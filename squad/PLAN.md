# REABILITA_OMBRO_PRODUCTION

## SYSTEM_STATE
- **Phase**: Draft analysis and production
- **Active_Agent**: @ask

## EXECUTION_QUEUE

### [1] DISCOVERY & ANALYSIS
- [ ] [1.1] @ask: Analyze `./squad/assets/reabilita_ombro_client_mockup` contents, stating the main flow of the application and convert it to `CLIENT_MOCKUP.md` in `./squad/assets/`.
- [ ] [1.2] @ask: Analyze `./squad/assets/componentes_padrao` contents, these will be our default components. Read `./squad/assets/componentes_padrao/README.md` for more information.
- [ ] [1.3] @plan: Cross [1.1] output (`./squad/assets/CLIENT_MOCKUP.md`) with [1.2] output (components analysis) and specifications in `./squad/assets/SPECS.md` and propose a new structure for the application in `./squad/assets/ARCHITECTURE.md` for production with @code. Unify screens if necessary.

### [2] STRUCTURAL DESIGN
- [ ] [2.1] @plan: Based on ARCHITECTURE.md [1.3], design an improved layout for the application, maintaining the patterns and templates used in ./squad/assets/componentes_padrao. Map the new component hierarchy using a #mermaid diagram and specify the layout strategies in LAYOUT.md.
- [ ] [2.2] @plan: Based on the 10 Nielsen Heuristics, run a user experience analysis of LAYOUT.md, identify basic inconsistencies, and refine the structural design to output the final LAYOUT.md. (Note: Merging the old 2.2 and 2.3 saves a redundant back-and-forth step).

### [3] PRODUCTION
- [ ] [3.1] @code: Build the improved application with the `LAYOUT.md` mapped in [2.3]. Follow the instructions in `./squad/assets/componentes_padrao/README.md` to reuse components. Create the necessary Flutter components using DART.