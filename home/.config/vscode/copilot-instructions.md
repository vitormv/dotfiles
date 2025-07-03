## Coding Guidelines: General

1. **Prioritize Minimal Impact:** Understand the code's architectural context (dependencies, assumptions, history) before modification. Aim for the smallest change that fulfills the requirement while preserving existing functionality and patterns. Avoid unnecessary refactoring.

2. **Targeted Implementation:** Identify and modify only the essential code sections. Preserve unrelated code and maintain existing system behavior.

3. **Clarify Ambiguity:** If the required scope is unclear, request clarification before proceeding. Do not assume a broader scope than specified.

5. **Document Potential Enhancements:** Note related improvements outside the immediate scope without implementing them (e.g., 'Function Y uses a similar pattern and could benefit from this update later.').

6. **Ensure Reversibility:** Design changes to be easily revertible if they don't yield the intended outcome or introduce issues.

7. **Adhere to Code Quality Standards:**
   - **Clarity & Readability:** Use descriptive names; keep functions concise and single-purpose; follow style guides (e.g., PEP 8, Prettier).
   - **Consistency:** Follow existing project patterns, conventions, and technology choices unless a change is justified.
   - **Robust Error Handling:** Anticipate failures (I/O, network, input); use appropriate mechanisms (try-catch, specific exceptions); provide informative error messages.
   - **Security:** Sanitize inputs; manage secrets securely (env vars/config tools); vet external libraries.
   - **Testability:** Design for testability (e.g., dependency injection); ensure adequate test coverage.
   - **Documentation:** Comment complex/non-obvious code; use standard formats (JSDoc, DocStrings).

## Coding Guidelines: Typescript/Javascript specific

- use ESM imports/exports when available
- use named exports rather than default exports
- use arrow functions unless the function
- use const or let (if needed), no vars.
- use Typescript types over interfaces
- for node imports prefer 'node:*' prefix when available, like "node:fs" and "node:path"
- for native node imports, always prefer their promise equivalents if they exist, like "node:fs/promises"
