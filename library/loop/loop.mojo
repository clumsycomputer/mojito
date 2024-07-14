from .loop_point import LoopPoint, __loop_point

@value
struct Loop[size: Int]:
    var layers: InlineArray[LoopLayer, size]

    fn pointAt(self: Self, inputAngle: Float64) -> LoopPoint:
        return __loop_point(self, inputAngle)


@value
struct LoopLayer:
    var relativeSubLoopRadius: Float64
    var relativeSubLoopDepth: Float64
    var subPhase: Float64
    var subOrientation: Float64
    var loopRotation: Float64


fn thing():
    var foo = Loop(
        InlineArray[LoopLayer, 1](
            LoopLayer(
                relativeSubLoopRadius=0,
                relativeSubLoopDepth=0,
                subPhase=0,
                subOrientation=0,
                loopRotation=0,
            )
        )
    )
    var bazPoint = foo.pointAt(0.5)
