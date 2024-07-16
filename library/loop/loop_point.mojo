from .loop import Loop
from math import trunc, cos, sin, sqrt


@value
struct LoopPoint:
    var x: Float64
    var y: Float64
    var base_x: Float64
    var base_y: Float64
    var terminal_x: Float64
    var terminal_y: Float64
    var origin_x: Float64
    var origin_y: Float64

    fn cosine(inout self) -> Float64:
        return self.x - self.origin_x

    fn sine(inout self) -> Float64:
        return self.y - self.origin_y


@always_inline
fn __loop_point[
    layer_count: Int
](loop: Loop[layer_count], input_angle: Float64) -> LoopPoint:
    var point_result = LoopPoint(0, 0, 0, 0, 0, 0, 0, 0)
    for layer_index in range(layer_count).__reversed__():
        var loop_layer = loop.layers[layer_index]
        var sub_circle_depth = loop_layer.relative_sub_loop_depth * (
            1 - loop_layer.relative_sub_loop_radius
        )
        var sub_circle_x = sub_circle_depth * cos(loop_layer.sub_phase)
        var sub_circle_y = sub_circle_depth * sin(loop_layer.sub_phase)
        var sub_point_x: Float64
        var sub_point_y: Float64
        var terminal_point_x: Float64
        var terminal_point_y: Float64
        var origin_point_x: Float64
        var origin_point_y: Float64
        if layer_index == layer_count - 1:
            sub_point_x = (
                loop_layer.relative_sub_loop_radius * cos(input_angle)
                + sub_circle_x
            )
            sub_point_y = (
                loop_layer.relative_sub_loop_radius * sin(input_angle)
                + sub_circle_y
            )
            terminal_point_x = sub_point_x
            terminal_point_y = sub_point_y
            origin_point_x = sub_circle_x
            origin_point_y = sub_circle_y
        else:
            sub_point_x = (
                loop_layer.relative_sub_loop_radius * point_result.x
                + sub_circle_x
            )
            sub_point_y = (
                loop_layer.relative_sub_loop_radius * point_result.y
                + sub_circle_y
            )
            terminal_point_x = (
                loop_layer.relative_sub_loop_radius * point_result.terminal_x
                + sub_circle_x
            )
            terminal_point_y = (
                loop_layer.relative_sub_loop_radius * point_result.terminal_y
                + sub_circle_y
            )
            origin_point_x = (
                loop_layer.relative_sub_loop_radius * point_result.origin_x
                + sub_circle_x
            )
            origin_point_y = (
                loop_layer.relative_sub_loop_radius * point_result.origin_y
                + sub_circle_y
            )
        var delta_x = origin_point_x - sub_point_x
        var delta_y = origin_point_y - sub_point_y
        var squared_delta_added = delta_x * delta_x + delta_y * delta_y
        var expr_a = (
            origin_point_x * origin_point_x
            - origin_point_x * sub_point_x
            + origin_point_y * delta_y
        ) / squared_delta_added
        var expr_b = origin_point_y * sub_point_x - origin_point_x * sub_point_y
        var expr_c = sqrt(1 - (expr_b * expr_b) / squared_delta_added) / sqrt(
            squared_delta_added
        )
        var base_point_x = origin_point_x - delta_x * expr_a - delta_x * expr_c
        var base_point_y = origin_point_y - delta_x * expr_a - delta_y * expr_c
        var orientation_cos = cos(loop_layer.sub_orientation)
        var orientation_sin = sin(loop_layer.sub_orientation)
        point_result.x = (
            base_point_x * orientation_cos - sub_point_y * orientation_sin
        )
        point_result.y = (
            base_point_x * orientation_sin + sub_point_y * orientation_cos
        )
        point_result.base_x = (
            base_point_x * orientation_cos - base_point_y * orientation_sin
        )
        point_result.base_y = (
            base_point_x * orientation_sin + base_point_y * orientation_cos
        )
        point_result.terminal_x = (
            terminal_point_x * orientation_cos
            - terminal_point_y * orientation_sin
        )
        point_result.terminal_y = (
            terminal_point_x * orientation_sin
            + terminal_point_y * orientation_cos
        )
        point_result.origin_x = (
            origin_point_x * orientation_cos - origin_point_y * orientation_sin
        )
        point_result.origin_y = (
            origin_point_x * orientation_sin + origin_point_y * orientation_cos
        )
        var rotation_cos = cos(loop_layer.loop_rotation)
        var rotation_sin = sin(loop_layer.loop_rotation)
        var rotate_delta_x = point_result.x - point_result.origin_x
        var rotate_delta_y = point_result.y - point_result.origin_y
        point_result.x = (
            rotate_delta_x * rotation_cos
            - rotate_delta_y * rotation_sin
            + point_result.origin_x
        )
        point_result.y = (
            rotate_delta_x * rotation_sin
            + rotate_delta_y * rotation_cos
            + point_result.origin_y
        )
        rotate_delta_x = point_result.base_x - point_result.origin_x
        rotate_delta_y = point_result.base_y - point_result.origin_y
        point_result.base_x = (
            rotate_delta_x * rotation_cos
            - rotate_delta_y * rotation_sin
            + point_result.origin_x
        )
        point_result.base_y = (
            rotate_delta_x * rotation_sin
            + rotate_delta_y * rotation_cos
            + point_result.origin_y
        )
        rotate_delta_x = point_result.terminal_x - point_result.origin_x
        rotate_delta_y = point_result.terminal_y - point_result.origin_y
        point_result.terminal_x = (
            rotate_delta_x * rotation_cos
            - rotate_delta_y * rotation_sin
            + point_result.origin_x
        )
        point_result.terminal_y = (
            rotate_delta_x * rotation_sin
            + rotate_delta_y * rotation_cos
            + point_result.origin_y
        )
    return point_result
