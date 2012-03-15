package Slic3r;

# Copyright holder: Alessandro Ranellucci
# This application is licensed under the GNU Affero General Public License, version 3

use strict;
use warnings;
require v5.10;

our $VERSION = "0.7.2-dev";

our $debug = 0;
sub debugf {
    printf @_ if $debug;
}

use Slic3r::Config;
use Slic3r::ExPolygon;
use Slic3r::Extruder;
use Slic3r::ExtrusionLoop;
use Slic3r::ExtrusionPath;
use Slic3r::ExtrusionPath::Arc;
use Slic3r::ExtrusionPath::Collection;
use Slic3r::Fill;
use Slic3r::Format::AMF;
use Slic3r::Format::STL;
use Slic3r::Geometry qw(PI);
use Slic3r::Layer;
use Slic3r::Line;
use Slic3r::Perimeter;
use Slic3r::Point;
use Slic3r::Polygon;
use Slic3r::Polyline;
use Slic3r::Print;
use Slic3r::Skein;
use Slic3r::Surface;
use Slic3r::TriangleMesh;
use Slic3r::TriangleMesh::IntersectionLine;

our $threads            = 4;

# miscellaneous options
our $notes              = '';

# output options
our $output_filename_format = '[input_filename_base].gcode';
our $post_process       = [];

# printer options
our $nozzle_diameter    = 0.5;
our $print_center       = [100,100];  # object will be centered around this point
our $z_offset           = 0;
our $gcode_flavor       = 'reprap';
our $use_relative_e_distances = 0;
our $extrusion_axis     = 'E';
our $gcode_arcs         = 0;
our $g0                 = 0;
our $gcode_comments     = 0;

# filament options
our $filament_diameter  = 3;    # mm
our $extrusion_multiplier = 1;
our $temperature        = 200;
our $first_layer_temperature;
our $bed_temperature    = 0;
our $first_layer_bed_temperature;

# speed options
our $travel_speed           = 130;  # mm/s
our $perimeter_speed        = 30;   # mm/s
our $small_perimeter_speed  = 30;   # mm/s
our $infill_speed           = 60;   # mm/s
our $solid_infill_speed     = 60;   # mm/s
our $bridge_speed           = 60;   # mm/s
our $bottom_layer_speed_ratio   = 0.3;

# acceleration options
our $acceleration           = 0;
our $perimeter_acceleration = 25;   # mm/s^2
our $infill_acceleration    = 50;   # mm/s^2

# accuracy options
our $resolution             = 0.00000001;
our $small_perimeter_area   = ((6.5 / $resolution)**2)*PI;
our $layer_height           = 0.4;
our $first_layer_height_ratio = 1;
our $infill_every_layers    = 1;

# flow options
our $extrusion_width_ratio  = 0;
our $bridge_flow_ratio      = 1;
our $overlap_factor         = 0.5;
our $flow_width;
our $min_flow_spacing;
our $flow_spacing;

# print options
our $perimeters         = 3;
our $solid_layers       = 3;
our $fill_pattern       = 'rectilinear';
our $solid_fill_pattern = 'rectilinear';
our $fill_density       = 0.4;  # 1 = 100%
our $fill_angle         = 45;
our $support_material   = 0;
our $support_material_tool = 0;
our $start_gcode = "G28 ; home all axes";
our $end_gcode = <<"END";
M104 S0 ; turn off temperature
G28 X0  ; home X axis
M84     ; disable motors
END

# retraction options
our $retract_length         = 1;    # mm
our $retract_restart_extra  = 0;    # mm
our $retract_speed          = 30;   # mm/s
our $retract_before_travel  = 2;    # mm
our $retract_lift           = 0;    # mm

# cooling options
our $cooling                = 0;
our $min_fan_speed          = 35;
our $max_fan_speed          = 100;
our $bridge_fan_speed       = 100;
our $fan_below_layer_time   = 60;
our $slowdown_below_layer_time = 15;
our $min_print_speed        = 10;
our $disable_fan_first_layers = 1;
our $fan_always_on          = 0;

# skirt options
our $skirts             = 1;
our $skirt_distance     = 6;    # mm
our $skirt_height       = 1;    # layers

# transform options
our $scale              = 1;
our $rotate             = 0;
our $duplicate          = 1;
our $duplicate_x        = 1;
our $duplicate_y        = 1;
our $duplicate_distance = 6;    # mm

1;
