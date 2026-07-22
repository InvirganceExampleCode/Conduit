document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll("[data-tag-editor]").forEach((editor) => {
        const form = editor.closest("form");
        const list = editor.querySelector("[data-tag-list]");
        const entry = editor.querySelector("[data-tag-entry]");
        const add = editor.querySelector("[data-tag-add]");

        function values()
        {
            return new Set(Array.from(list.querySelectorAll("[data-tag-value]"), (chip) => chip.dataset.tagValue));
        }

        function createTag(value)
        {
            const chip = document.createElement("span");
            const label = document.createElement("span");
            const remove = document.createElement("button");
            const input = document.createElement("input");

            chip.className = "tag-chip";
            chip.dataset.tagValue = value;
            label.textContent = value;
            remove.type = "button";
            remove.className = "tag-remove";
            remove.dataset.tagRemove = "";
            remove.setAttribute("aria-label", `Remove ${value}`);
            remove.textContent = "\u00d7";
            input.type = "hidden";
            input.name = "tagName";
            input.value = value;
            chip.append(label, remove, input);

            return chip;
        }

        function addTags()
        {
            const existing = values();
            const submitted = entry.value.split(",").map((tag) => tag.trim().toLowerCase()).filter(Boolean);
            const invalid = submitted.find((tag) => tag.length > 64);

            if(invalid)
            {
                entry.setCustomValidity(`Tags must be 64 characters or fewer: ${invalid}`);
                entry.reportValidity();
                return false;
            }

            entry.setCustomValidity("");

            submitted.forEach((tag) => {
                if(existing.has(tag))
                {
                    return;
                }

                list.append(createTag(tag));
                existing.add(tag);
            });

            entry.value = "";
            entry.focus();

            return true;
        }

        add.addEventListener("click", addTags);
        entry.addEventListener("input", () => entry.setCustomValidity(""));
        entry.addEventListener("keydown", (event) => {
            if(event.key !== "Enter")
            {
                return;
            }

            event.preventDefault();
            addTags();
        });
        list.addEventListener("click", (event) => {
            const remove = event.target.closest("[data-tag-remove]");

            if(!remove)
            {
                return;
            }

            const chip = remove.closest("[data-tag-value]");
            chip.remove();
            entry.focus();
        });
        form.addEventListener("submit", (event) => {
            if(!entry.value.trim())
            {
                return;
            }

            if(!addTags())
            {
                event.preventDefault();
            }
        });
    });
});
