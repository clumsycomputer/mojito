from .loop import Loop
from .loop_constants import LoopLookup
from math import trunc


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


@always_inline 
fn __loop_point[
    layer_count: Int
](loop: Loop[layer_count], input_angle: Float64) -> LoopPoint:
    var pointResult = LoopPoint(0, 0, 0, 0, 0, 0, 0, 0)

    @parameter
    for layer_index in range(layer_count).__reversed__():
        var loop_layer = loop.layers[layer_index]
        var sub_circle_depth = loop_layer.relative_sub_loop_depth * (
            1 - loop_layer.relative_sub_loop_radius
        )
        var sub_circle_lookup_index = (
            input_angle * loop_lookup.INDEX_SCALAR
        ).__int__()
        var sub_circle_x = sub_circle_depth * loop_lookup.cosine_table[
            sub_circle_lookup_index
        ]
        var sub_circle_y = sub_circle_depth * loop_lookup.sine_table[
            sub_circle_lookup_index
        ]
        print(sub_circle_lookup_index)
        print(sub_circle_x)
        print(sub_circle_y)
    return pointResult
