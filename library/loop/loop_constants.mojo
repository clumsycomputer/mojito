from math import cos, sin

alias LOOP_ONE = 0.999999999999

alias LOOP_ZERO = 0.000000000001

alias LOOP_PI = 3.141592653589793

alias LOOP_LOOKUP = LoopLookup[table_resolution=4096]

@value
struct LoopLookup[table_resolution: Int]:
    alias INDEX_SCALAR: Float64 = table_resolution / (2 * LOOP_PI)
    alias SAMPLE_ANGLE_STEP: Float64 = 2 * LOOP_PI / table_resolution

    @staticmethod
    fn sine_table(table_index: Int) -> Float64:
        var sine_table_result = InlineArray[Float64, table_resolution]()
        @parameter
        for table_index in range(table_resolution):
            var sample_angle = table_index * Self.SAMPLE_ANGLE_STEP
            sine_table_result[table_index] = sin(sample_angle)
        return sine_table_result[table_index]


    @parameter
    fn __init__(inout self):
        var cosine_table_result = InlineArray[Float64, table_resolution]()
        var sine_table_result = InlineArray[Float64, table_resolution]()
        var sample_angle_step = 2 * LOOP_PI / table_resolution
        @parameter
        for table_index in range(table_resolution):
            var sample_angle = table_index * sample_angle_step
            cosine_table_result[table_index] = cos(sample_angle)
            sine_table_result[table_index] = sin(sample_angle)
        self.sine_table = sine_table_result^
        self.cosine_table = cosine_table_result^
