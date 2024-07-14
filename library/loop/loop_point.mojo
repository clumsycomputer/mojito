from .loop import Loop

@value
struct LoopPoint:
    var x: Float64
    var y: Float64
    var baseX: Float64
    var baseY: Float64
    var terminalX: Float64
    var terminalY: Float64
    var originX: Float64
    var originY: Float64

fn __loop_point(loop: Loop, inputAngle: Float64) -> LoopPoint:
    var pointResult = LoopPoint(0, 0, 0, 0, 0, 0, 0, 0)
    return pointResult