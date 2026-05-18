# COMPONENTS MAP: REABILITA OMBRO

This document maps all existing UI components from the `componentes_padrao` library. Use these components to maintain visual consistency and avoid rebuilding existing logic.

---

## 1. Style Foundations

### Colors (`AppColors`)
- **Main**: `MY_BLUE` (#2E3B76), `MY_WHITE` (#F2F2F2), `MY_BLACK` (#231F20).
- **Secondary**: `MY_GREY` (#818181), `MY_LIGHT_GREY` (#D9D9D9).

### Typography (`AppTypography`)
- **Font**: Mulish (Google Fonts).
- **Styles**: `H1()`, `H2()`, `BODY()`, `DETAILS()`, `APP_BAR()`.

---

## 2. Buttons

| Component | Usage | Parameters |
| :--- | :--- | :--- |
| **`SimpleButton`** | Standard action button (Primary) | `dark` (bool), `title` (String), `onTap`, `width` |
| **`HomeButton`** | Menu option with image background | `title`, `imagePath`, `onTap`, `width`, `height` |
| **`ButtonContainer`** | Category list item with image | `title`, `imagePath`, `onTap`, `width`, `height` |
| **`CustomTextButton`**| Secondary text-only action | `dark` (bool), `title`, `onTap` |
| **`LabeledRadio`** | Selection input with label | `label`, `groupValue`, `value`, `onChanged`, `dark` |

---

## 3. Text Fields

| Component | Features | Parameters |
| :--- | :--- | :--- |
| **`SimpleTextField`** | Text input with CPF/Email logic | `dark`, `label`, `hintText`, `controller`, `errorMessage`, `isCPF`, `isEmail` |
| **`ObscureTextField`**| Password or sensitive data | `dark`, `label`, `hintText`, `controller`, `isPassword` |
| **`DatePickerTextField`**| Interactive date selection | `dark`, `label`, `hintText`, `dateController`, `startDate`, `endDate` |
| **`TimePickerTextField`**| Interactive time selection | `dark`, `label`, `hintText`, `timeController` |

---

## 4. List Tiles & Cards

| Component | Usage | Parameters |
| :--- | :--- | :--- |
| **`ListContainerTile`** | Rich list item with top/bottom info | `title`, `topInfo` (List), `bottomInfo` (List), `imagePath`, `onTap` |
| **`SimpleListContainerTile`**| List item with title and top info | `title`, `topInfo` (List), `imagePath`, `onTap` |
| **`CustomExpasionTile`**| Expandable content drawer | `title`, `children` (List<Widget>) |

---

## 5. UI Layout Elements

- **App Bar**: Standard `AppBar` with `MY_BLUE` background, elevation `0.0`, and centered title. Use `APP_BAR()` text style.
- **Background**: `MY_WHITE` for Scaffold background.
- **Shadows**: Use `MY_BOXSHADOW` for containers to maintain elevation consistency.
- **Grid**: Follow the 8-point grid system (Spacing/Padding in multiples of 8, e.g., 25.0 as seen in examples).
