const codeCopyIcons = {
    copy: '<svg viewBox="0 0 24 24" aria-hidden="true"><rect width="14" height="14" x="8" y="8" rx="2" ry="2"></rect><path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path></svg>',
    copied: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="m20 6-11 11-5-5"></path></svg>',
    failed: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M18 6 6 18"></path><path d="m6 6 12 12"></path></svg>'
};

function setCodeCopyState(button, state, label)
{
    button.innerHTML = codeCopyIcons[state];
    button.setAttribute("aria-label", label);
    button.title = label;
}

window.highlightMarkdown = (root) => {
    root.querySelectorAll("pre code").forEach((block) => {
        if(window.hljs && !block.classList.contains("hljs"))
        {
            window.hljs.highlightElement(block);
        }

        const container = block.parentElement;

        if(container.dataset.copyEnabled)
        {
            return;
        }

        const copy = document.createElement("button");
        copy.type = "button";
        copy.className = "code-copy";
        setCodeCopyState(copy, "copy", "Copy code to clipboard");

        copy.addEventListener("click", async () => {
            try
            {
                await navigator.clipboard.writeText(block.textContent);
                setCodeCopyState(copy, "copied", "Code copied");
            }
            catch(error)
            {
                setCodeCopyState(copy, "failed", "Unable to copy code");
            }

            window.setTimeout(() => setCodeCopyState(copy, "copy", "Copy code to clipboard"), 2000);
        });

        container.dataset.copyEnabled = "true";
        container.append(copy);
    });
};

document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".markdown").forEach((markdown) => window.highlightMarkdown(markdown));
});
