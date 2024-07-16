from .loop_point import LoopPoint, __loop_point


@value
struct Loop[layer_count: Int]:
    var layers: InlineArray[LoopLayer, layer_count]

    fn pointAt(self: Self, input_angle: Float64) -> LoopPoint:
        return __loop_point(loop=self, input_angle=input_angle)


@value
struct LoopLayer:
    var relative_sub_loop_radius: Float64
    var relative_sub_loop_depth: Float64
    var sub_phase: Float64
    var sub_orientation: Float64
    var loop_rotation: Float64
