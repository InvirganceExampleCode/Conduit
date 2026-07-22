document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll("[data-markdown-editor]").forEach((editor) => {
        const form = editor.closest("form");
        const writeTab = editor.querySelector("[data-markdown-write]");
        const previewTab = editor.querySelector("[data-markdown-preview]");
        const textarea = editor.querySelector("[data-markdown-body]");
        const writePanel = editor.querySelector("#markdown-write");
        const previewPanel = editor.querySelector("[data-markdown-output]");
        const status = editor.querySelector("[data-markdown-status]");
        let renderedMarkdown = null;

        function selectTab(tab, panel)
        {
            writeTab.classList.toggle("active", tab === writeTab);
            previewTab.classList.toggle("active", tab === previewTab);
            writeTab.setAttribute("aria-selected", tab === writeTab);
            previewTab.setAttribute("aria-selected", tab === previewTab);
            writePanel.hidden = panel !== writePanel;
            previewPanel.hidden = panel !== previewPanel;
        }

        writeTab.addEventListener("click", () => {
            selectTab(writeTab, writePanel);
            status.textContent = "";
            textarea.focus();
        });

        previewTab.addEventListener("click", async () => {
            selectTab(previewTab, previewPanel);

            if(renderedMarkdown === textarea.value) return;

            status.textContent = "Rendering preview…";
            previewTab.disabled = true;

            try
            {
                const parameters = new URLSearchParams();
                parameters.set("body", textarea.value);
                parameters.set("csrf", form.elements.csrf.value);

                const response = await fetch(editor.dataset.previewUrl, {
                    method: "POST",
                    credentials: "same-origin",
                    headers: {"Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"},
                    body: parameters
                });

                if(!response.ok) throw new Error(`Preview failed with status ${response.status}`);

                const records = await response.json();
                previewPanel.innerHTML = records[0]?.bodyHtml || "";

                if(window.highlightMarkdown)
                {
                    window.highlightMarkdown(previewPanel);
                }

                if(!previewPanel.hasChildNodes())
                {
                    const empty = document.createElement("p");
                    empty.className = "markdown-preview-empty";
                    empty.textContent = "Nothing to preview yet.";
                    previewPanel.append(empty);
                }

                renderedMarkdown = textarea.value;
                status.textContent = "Preview updated.";
            }
            catch(error)
            {
                previewPanel.replaceChildren();

                const message = document.createElement("p");
                message.className = "form-error";
                message.textContent = "The preview could not be rendered. Your Markdown is still safe in the editor.";
                previewPanel.append(message);
                status.textContent = "Preview unavailable.";
            }
            finally
            {
                previewTab.disabled = false;
            }
        });
    });
});
