local styles = data.raw["gui-style"].default

-- Generic

styles["si_titlebar_flow"] = {
    type = "horizontal_flow_style",
    horizontal_spacing = 8
}

styles["si_titlebar_drag_handle"] = {
    type = "empty_widget_style",
    parent = "draggable_space",
    left_margin = 4,
    right_margin = 4,
    height = 24,
    horizontally_stretchable = "on"
}
