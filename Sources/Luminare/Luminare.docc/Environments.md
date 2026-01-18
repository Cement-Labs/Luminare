# Environments

``Luminare`` uses environment values to unify styles such as corner radius, padding and tint. Here is a list of available environment values for you to toggle the appearance of ``Luminare``.

## Overview

You can find all environment values in the file [`EnvironmentValues+Extensions`](https://github.com/MrKai77/Luminare/blob/main/Sources/Luminare/Utilities/Extensions/EnvironmentValues+Extensions.swift).

### Common Values

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminareTintColor` | `Color` | The tint color used in ``Luminare`` components. | `.accentColor` |
| `luminareAnimation` | `Animation` | The animation that is typically elegant and general-purposed. | `.smooth(duration: 0.2)` |
| `luminareAnimationFast` | `Animation` | The animation that is swifter and chunkier. | `.easeInOut(duration: 0.1)` |

### Modal Interaction

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminareModalStyle` | ``LuminareModalStyle`` | The way modals appear and react to interactions. | `.sheet` |
| `luminareModalContentWrapper` | `(AnyView) -> AnyView` | A wrapper to customize modal contents. | *closure* |

#### Sheet Modal

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminareSheetCornerRadii` | `RectangleCornerRadii` | The corner radii of sheet panels. | `12` for all corners |
| `luminareSheetPresentation` | ``LuminareSheetPresentation`` | The presentation of sheets. | `.windowCenter` |
| `luminareSheetIsMovableByWindowBackground` | `Bool` | Whether sheets are movable by dragging their backgrounds. | `false` |
| `luminareSheetClosesOnDefocus` | `Bool` | Whether sheets close on defocus (e.g., mouse clicked elsewhere). | `false` |

#### Popup Modal

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminarePopupCornerRadii` | `RectangleCornerRadii` | The corner radii of popup panels. | `16` for all corners |
| `luminarePopupPadding` | `CGFloat` | The padding around popup contents. | `4` |

#### Color Picker Modal

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminareColorPickerHasCancel` | `Bool` | Whether color picker modals have **cancel** buttons. | `false` |
| `luminareColorPickerHasDone` | Whether color picker modals have **done** buttons. | `false` |

### Generic Values for Views

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminareCornerRadii` | `RectangleCornerRadii` | The corner radii of views. | `12` for all corners |
| `luminareMinHeight` | `CGFloat` | The minimum height constraint for components. | `30` |
| `luminareBorderCondition` | ``LuminareBorderCondition`` | The condition of displaying borders. | `.all` |
| `luminareFillCondition` | ``LuminareFillCondition`` | The condition of displaying fills. | `.all` |
| `luminareHasDividers` | `Bool` | Whether to use dividers in list components. | `true` |
| `luminareContentMarginsTop` | `CGFloat` | The content margin of the top edge. | `0` |
| `luminareContentMarginsLeading` | `CGFloat` | The content margin of the leading edge. | `0` |
| `luminareContentMarginsBottom` | `CGFloat` | The content margin of the bottom edge. | `0` |
| `luminareContentMarginsTrailing` | `CGFloat` | The content margin of the trailing edge. | `0` |

#### Generic Values for Forms

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminareFormSpacing` | `CGFloat` | The spacing between form elements. | `15` |

#### Generic Values for Panes

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminarePaneLayout` | ``LuminarePaneLayout`` | The layout for panes. | `.stacked` |
| `luminareTitleBarHeight` | `CGFloat` | The height of title bars on top of the panes. | `50` |

#### Generic Values for Sections

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminareSectionLayout` | ``LuminareSectionLayout`` | The layout for ``LuminareSection``s. | `.stacked` |
| `luminareSectionHorizontalPadding` | `CGFloat` | The horizontal padding around section contents. | `8` |
| `luminareIsInsideSection` | `Bool` | Whether a component should be treated as *inside a section.* This decides various layout details across components, and is automatically set for components inside ``LuminareSection``s. | `false` |
| `luminareTopLeadingRounded` | `Bool` | | `true` |
| `luminareTopTrailingRounded` | `Bool` | | `true` |
| `luminareBottomLeadingRounded` | `Bool` | | `true` |
| `luminareBottomTrailingRounded` | `Bool` | | `true` |
| `luminareSectionMaxWidth` | `CGFloat?` | The max width of sections. If set to `0`, then the width of the section would be fixed. | `.infinity` |

#### Generic Values for Composes

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminareComposeControlSize` | ``LuminareComposeControlSize`` | The control size inside ``LuminareCompose``s. | `.automatic` |

#### Generic Values for Popovers

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminarePopoverTrigger` | ``LuminarePopoverTrigger`` | The way popovers are triggered. | `.hover` |
| `luminarePopoverShade` | ``LuminarePopoverShade`` | The style of popover trigger areas. | `.styled` |

#### Generic Values for Steppers

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminareStepperAlignment` | ``LuminareStepperAlignment`` | The alignment of stepper bars. | `trailing` |
| `luminareStepperDirection` | ``LuminareStepperDirection`` | The direction to place ``LuminareStepper``s. | `.horizontal` |

#### Generic Values for Compact Pickers

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminareCompactPickerStyle` | ``LuminareCompactPickerStyle`` | The style of ``LuminareCompactPicker``s. | `.menu` |

#### Generic Values for Lists

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminareListItemCornerRadii` | `RectangleCornerRadii` | The corner radii of items inside ``LuminareList``s. | `2` for all corners |
| `luminareListItemHeight` | `CGFloat` | The height of list items. | `50` |
| `luminareItemHighlightOnHover` | `Bool` | Whether list items are highlighted on hover. | `true` |
| `luminareItemBeingHovered` | `Bool` | | `false` |
| `luminareListFixedHeightUntil` | `CGFloat?` | | `nil` |

#### Generic Values for Sidebars

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminareSidebarOverflow` | `CGFloat` | The vertical overflow of ``LuminareSidebar``s to fade contents instead of clipping them. | `50` |

#### Generic Values for Sliders

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminareSliderLayout` | ``LuminareSliderLayout`` | The layout for ``LuminareSlider``s. | `.regular` |

#### Generic Values for Slider Pickers

| Name | Type | Description | Default Value |
|------|------|-------------|---------------|
| `luminareSliderPickerLayout` | ``LuminareSliderPickerLayout`` | The layout for ``LuminareSliderPicker``s. | `.regular` |
