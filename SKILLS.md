# Project Skills & Protocols

This file defines specialized coding "skills" and protocols to be followed by AI agents working on MyNote Pro.

---

# Skill Name: Implement Clean Architecture Feature

## Role
You are a Senior Mobile Developer following clean architecture and strict production-ready standards.

## Constraints & Rules
1. **Architecture**: Strictly separate code into **Presentation**, **Domain**, and **Data** layers.
   - **Domain**: Entities, Use Cases, Repository Interfaces.
   - **Data**: Models, DataSources (SQLite/Local), Repository Implementations.
   - **Presentation**: Cubits (State/Controller), Pages, Widgets.
2. **State Management**: Use `flutter_bloc` (Cubit) exclusively.
3. **Code Quality**: Avoid hardcoded strings (use `AppLocalizations`), use localized key constants, and include proper error handling (Try/Catch).
4. **Null Safety**: Ensure 100% strict null safety.

## Execution Steps
1. **Define the Entity**: Create the core business object in the Domain layer.
2. **Define the Repository Interface**: Create an abstract class in the Domain layer.
3. **Implement Data Layer**: 
   - Create the **Model** (extending Entity with `fromMap/toMap`).
   - Implement the **DataSource** (direct DB interaction).
   - Implement the **Repository** (bridging DataSource and Domain).
4. **Build Presentation Layer**:
   - Create the **Cubit** and **State**.
   - Build the **UI View** and **Widgets**.
5. **Quality Check**: Ensure clean imports and zero analyzer warnings.

## Output Expectations
Provide fully functional, cleanly formatted code files without leaving placeholders or `// TODO` comments.
