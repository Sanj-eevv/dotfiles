;; Optimized Laravel Blade injections.scm for Neovim + nvim-treesitter
;; Based on EmranMR/tree-sitter-blade official recommendations

;; PHP code in regular Blade content (primary injection)
((text) @injection.content
    (#not-has-ancestor? @injection.content "envoy")
    (#set! injection.combined)
    (#set! injection.language php))

;; Bash/Shell commands in Laravel Envoy tasks
((text) @injection.content
    (#has-ancestor? @injection.content "envoy")
    (#set! injection.combined)
    (#set! injection.language bash))

;; PHP-only content blocks
((php_only) @injection.content
    (#set! injection.language php_only))

;; Blade directive parameters with include-children for complex expressions
((parameter) @injection.content
    (#set! injection.include-children)
    (#set! injection.language php_only))

;; Comments injection (if tree-sitter-comment is available)
((comment) @injection.content
    (#set! injection.language comment))
