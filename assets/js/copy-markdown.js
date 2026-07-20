"use strict";

function copyMarkdownFallback(markdown) {
  const textarea = document.createElement("textarea");
  textarea.value = markdown;
  textarea.setAttribute("readonly", "");
  textarea.style.position = "fixed";
  textarea.style.opacity = "0";
  document.body.appendChild(textarea);
  textarea.select();
  const copied = document.execCommand("copy");
  textarea.remove();

  if (!copied) {
    throw new Error("Copy command failed");
  }
}

async function copyMarkdown(markdown) {
  if (navigator.clipboard && window.isSecureContext) {
    await navigator.clipboard.writeText(markdown);
    return;
  }

  copyMarkdownFallback(markdown);
}

function initializeCopyMarkdownButton(button) {
  const label = button.querySelector(".copy-markdown-label");
  const source = document.getElementById(button.dataset.copyMarkdownTarget);

  if (!label || !source) {
    return;
  }

  const defaultLabel = label.textContent;
  button.addEventListener("click", async () => {
    button.disabled = true;

    try {
      await copyMarkdown(JSON.parse(source.textContent));
      label.textContent = "Copied!";
    } catch (_error) {
      label.textContent = "Copy failed";
    }

    button.disabled = false;
    button.focus();
    window.setTimeout(() => {
      label.textContent = defaultLabel;
    }, 2000);
  });
}

function initializeCopyMarkdownButtons() {
  document.querySelectorAll(".copy-markdown-button").forEach(initializeCopyMarkdownButton);
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initializeCopyMarkdownButtons);
} else {
  initializeCopyMarkdownButtons();
}
