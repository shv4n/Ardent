# Ardent

> Personal development tracker, architecture notes, and roadmap.

---

# Progress

## 1. StateManager (Hybrid)

### Overall
- [x] Implemented
- [ ] Fully tested

### Functions

- [x] Register
- [ ] Register tested

- [x] Unregister
- [ ] Unregister tested

- [x] SetState
- [ ] SetState tested

- [x] GetState
- [ ] GetState tested

- [x] Trigger
- [ ] Trigger tested

- [x] PushState
- [ ] PushState tested

- [x] PopState
- [ ] PopState tested

- [x] GetAllInState
- [ ] GetAllInState tested

---

## 2. State Definitions

### Overall
- [x] Implemented
- [ ] Fully tested

### SharedFunctions

- [x] SharedFunctions
- [ ] SharedFunctions tested

### States

- [x] Idle
- [ ] Idle tested

- [x] Attacking
- [ ] Attacking tested

- [x] Blocking
- [ ] Blocking tested

- [x] Stunned
- [ ] Stunned tested

---

## 3. EntityManager (DOD)

### Overall
- [x] Implemented
- [ ] Fully tested

### Functions

- [x] CreateEntity
- [ ] CreateEntity tested

- [x] DestroyEntity
- [ ] DestroyEntity tested

- [x] GetEntity
- [ ] GetEntity tested

- [x] GetEntityByCharacter
- [ ] GetEntityByCharacter tested

- [x] EntityExists
- [ ] EntityExists tested

- [x] ChangeState
- [ ] ChangeState tested

- [x] ForceState
- [ ] ForceState tested

- [x] SwapStateModule
- [ ] SwapStateModule tested

---

## 4. DataManager

### Overall
- [x] Implemented
- [ ] Fully tested

### Functions

- [x] PlayerAdded
- [ ] PlayerAdded tested

- [x] PlayerRemoved
- [ ] PlayerRemoved tested

- [x] GetClientData
- [ ] GetClientData tested

- [x] GetStateModule
- [ ] GetStateModule tested

- [x] SetStateModule
- [ ] SetStateModule tested

- [x] AddCrowns
- [ ] AddCrowns tested

- [x] AddEXP
- [ ] AddEXP tested

---

## 5. DamageService

### Overall
- [x] Implemented
- [ ] Fully tested

### Functions

- [x] ApplyDamage
- [ ] ApplyDamage tested

- [x] CalculateDamage
- [ ] CalculateDamage tested

---

## 6. CombatService

### Overall
- [ ] Implemented
- [ ] Fully tested

### Functions

- [ ] OnAttackInput
- [ ] OnAttackInput tested

- [ ] OnHitboxTouched
- [ ] OnHitboxTouched tested

- [ ] AdvanceCombo
- [ ] AdvanceCombo tested

---

## 7. MovementService

### Overall
- [ ] Implemented
- [ ] Fully tested

### Functions

- [ ] OnDashInput
- [ ] OnDashInput tested

- [ ] CanSprint
- [ ] CanSprint tested

---

## 8. SkillService

### Overall
- [ ] Implemented
- [ ] Fully tested

### Functions

- [ ] CastSkill
- [ ] CastSkill tested

- [ ] IsOnCooldown
- [ ] IsOnCooldown tested

---

## 9. Throne

### Overall
- [ ] Implemented
- [ ] Fully tested

### Functions

- [ ] IsThrone
- [ ] IsThrone tested

- [ ] GetRank
- [ ] GetRank tested

- [ ] GetTitle
- [ ] GetTitle tested

---

## 10. AI Service

### Overall
- [ ] Started
- [ ] Fully tested

---

# Architecture

| Module | Paradigm |
|---------|----------|
| StateManager | Hybrid (OOP Interface / DOD Storage) |
| EntityManager | DOD |
| DataManager | OOP Wrapper |
| DamageService | Stateless |
| CombatService | OOP |
| MovementService | OOP |
| SkillService | Hybrid |
| Throne | DOD |
| AI Service | DOD (Planned) |

---

# Future Ideas

- [ ] Inventory
- [ ] Equipment
- [ ] NPC AI
- [ ] Utility AI
- [ ] Quests
- [ ] Bosses
- [ ] Guilds
- [ ] Trading
- [ ] Crafting

---

# Notes

- StateManager owns state.
- EntityManager owns entities.
- DataManager owns persistence.
- Services perform actions.
- Managers own data.
- Avoid circular dependencies.
- Keep modules as independent as possible.