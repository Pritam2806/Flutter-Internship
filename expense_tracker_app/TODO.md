# Expense Tracker App - TODO

## Phase 1: Project Setup & Dependencies

- [ ] Update pubspec.yaml with required dependencies:
  - provider
  - sqflite
  - path_provider
  - intl (for date formatting)
  - fl_chart (for interactive charts)
- [ ] Run `flutter pub get`
- [ ] Verify Android/iOS build configurations

## Phase 2: Data Model & Database

- [ ] Create `lib/models/expense.dart`:
  - [ ] Define Expense class with id, title, amount, date
  - [ ] Add toMap() and fromMap() methods
  - [ ] Add copyWith() method
- [ ] Create `lib/database/database_helper.dart`:
  - [ ] Initialize SQLite database
  - [ ] Create expenses table schema
  - [ ] Implement addExpense() method
  - [ ] Implement getExpenses() method
  - [ ] Implement deleteExpense() method
  - [ ] Implement getExpensesByDate() method
  - [ ] Implement getExpensesByMonth() method

## Phase 3: State Management (Provider)

- [ ] Create `lib/providers/expense_provider.dart`:
  - [ ] Initialize DatabaseHelper
  - [ ] Implement loadExpenses() method
  - [ ] Implement addExpense() with database save
  - [ ] Implement deleteExpense() with database delete
  - [ ] Implement filterByMonth() method
  - [ ] Implement filterByDay() method
  - [ ] Implement toggle between monthly/yearly view
  - [ ] Add notifyListeners() calls for UI updates

## Phase 4: UI Widgets

- [ ] Create `lib/widgets/expense_chart.dart`:
  - [ ] Implement bar chart using fl_chart
  - [ ] Add Monthly View (1-31 dates)
  - [ ] Add Yearly View (12 months)
  - [ ] Make bars clickable/interactive
  - [ ] Update expense list on bar tap
  - [ ] Style chart with black bars on white background

- [ ] Create `lib/widgets/expense_tile.dart`:
  - [ ] Display expense date (leading)
  - [ ] Display expense title (title)
  - [ ] Display expense amount (subtitle)
  - [ ] Add delete icon button (trailing)
  - [ ] Sort expenses by date in ascending order

- [ ] Create `lib/widgets/add_expense_dialog.dart`:
  - [ ] Create TextField for expense title
  - [ ] Create number input for amount
  - [ ] Create date picker field
  - [ ] Add Cancel and Save buttons
  - [ ] Validate input before saving
  - [ ] Call provider.addExpense() on save

- [ ] Create `lib/widgets/toggle_button.dart` (or within chart):
  - [ ] Add toggle between "Current Month" and "Whole Year"
  - [ ] Update chart based on selection

## Phase 5: Main Screen & Layout

- [ ] Create `lib/screens/home_screen.dart`:
  - [ ] Set up AppBar
  - [ ] Implement top 50% - Chart Section:
    - [ ] Add toggle button above chart
    - [ ] Render ExpenseChart widget
  - [ ] Implement bottom 50% - Expense List:
    - [ ] Use ListView for expense list
    - [ ] Display ExpenseTile for each expense
    - [ ] Handle empty state
  - [ ] Add Floating Action Button (+):
    - [ ] Open AddExpenseDialog on tap
    - [ ] Refresh data after add/delete

- [ ] Create `lib/main.dart`:
  - [ ] Set up Provider
  - [ ] Configure Material App theme (White bg, Black text)
  - [ ] Route to HomeScreen
  - [ ] Set app title

## Phase 6: Delete Functionality

- [ ] Implement delete confirmation dialog:
  - [ ] Show alert: "Delete Expense?"
  - [ ] Show warning: "This action cannot be undone"
  - [ ] Add Cancel button (close dialog)
  - [ ] Add Delete button (confirm delete)
- [ ] Update ExpenseTile to show delete dialog on icon tap
- [ ] Call provider.deleteExpense() on confirm
- [ ] Verify chart and list update immediately

## Phase 7: Chart Interaction & Filtering

- [ ] Implement monthly mode chart interaction:
  - [ ] Tap on day bar → filter expenses for that day
  - [ ] Update list to show only that day's expenses
- [ ] Implement yearly mode chart interaction:
  - [ ] Tap on month bar → filter expenses for that month
  - [ ] Update list to show only that month's expenses

## Phase 8: UI/UX Polish

- [ ] Apply theme styling:
  - [ ] White background throughout
  - [ ] Black text
  - [ ] Black chart bars
  - [ ] Light grey borders on cards
  - [ ] Minimalistic design
- [ ] Responsive layout:
  - [ ] Test on different screen sizes
  - [ ] Ensure 50/50 split between chart and list
- [ ] Handle edge cases:
  - [ ] Empty expense list
  - [ ] No data for selected period
  - [ ] Invalid date inputs

## Phase 9: Testing

- [ ] Widget tests:
  - [ ] Test Expense model
  - [ ] Test DatabaseHelper CRUD
  - [ ] Test Provider state management
- [ ] Manual testing:
  - [ ] Add multiple expenses
  - [ ] Delete expenses
  - [ ] Filter by month
  - [ ] Filter by day
  - [ ] Verify persistence after app restart
  - [ ] Verify chart updates after operations
  - [ ] Verify list updates after operations

## Phase 10: Final Review & Deployment

- [ ] Code cleanup and formatting
- [ ] Fix any linting errors
- [ ] Documentation/comments
- [ ] Verify all success criteria met
- [ ] Test on physical device/emulator
- [ ] Build APK/IPA for distribution

---

## Dependencies to Add (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  sqflite: ^2.0.0
  path_provider: ^2.0.0
  intl: ^0.19.0
  fl_chart: ^0.63.0
```

## Key Success Criteria

✅ Expenses persist after app restart  
✅ Charts update instantly after CRUD  
✅ Can filter by month/day via chart interaction  
✅ Expense list sorted by date  
✅ Simple, clean, responsive UI
