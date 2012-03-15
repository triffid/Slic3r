package Slic3r::Config;
use strict;
use warnings;
use utf8;

use constant PI => 4 * atan2(1, 1);

our $Options = {

    # miscellaneous options
    'notes' => {
        label   => 'Configuration notes',
        cli     => 'notes=s',
        type    => 's',
        multiline => 1,
        width   => 350,
        height  => 300,
        serialize   => sub { join '\n', split /\R/, $_[0] },
        deserialize => sub { join "\n", split /\\n/, $_[0] },
    },

    # output options
    'output_filename_format' => {
        label   => 'Output filename format',
        cli     => 'output-filename-format=s',
        type    => 's',
    },

    # printer options
    'nozzle_diameter' => {
        label   => 'Nozzle diameter (mm)',
        cli     => 'nozzle-diameter=f',
        type    => 'f',
        important => 1,
    },
    'print_center' => {
        label   => 'Print center (mm)',
        cli     => 'print-center=s',
        type    => 'point',
        serialize   => sub { join ',', @{$_[0]} },
        deserialize => sub { [ split /,/, $_[0] ] },
    },
    'gcode_flavor' => {
        label   => 'G-code flavor',
        cli     => 'gcode-flavor=s',
        type    => 'select',
        values  => [qw(reprap teacup makerbot mach3 no-extrusion)],
        labels  => ['RepRap (Marlin/Sprinter)', 'Teacup', 'MakerBot', 'Mach3/EMC', 'No extrusion'],
    },
    'use_relative_e_distances' => {
        label   => 'Use relative E distances',
        cli     => 'use-relative-e-distances',
        type    => 'bool',
    },
    'extrusion_axis' => {
        label   => 'Extrusion axis',
        cli     => 'extrusion-axis=s',
        type    => 's',
    },
    'z_offset' => {
        label   => 'Z offset (mm)',
        cli     => 'z-offset=f',
        type    => 'f',
    },
    'gcode_arcs' => {
        label   => 'Use native GCODE arcs',
        cli     => 'gcode-arcs',
        type    => 'bool',
    },
    'g0' => {
        label   => 'Use G0 for travel moves',
        cli     => 'g0',
        type    => 'bool',
    },
    'gcode_comments' => {
        label   => 'Verbose G-code',
        cli     => 'gcode-comments',
        type    => 'bool',
    },
    
    # filament options
    'filament_diameter' => {
        label   => 'Diameter (mm)',
        cli     => 'filament-diameter=f',
        type    => 'f',
        important => 1,
    },
    'extrusion_multiplier' => {
        label   => 'Extrusion multiplier',
        cli     => 'extrusion-multiplier=f',
        type    => 'f',
        aliases => [qw(filament_packing_density)],
    },
    'first_layer_temperature' => {
        label   => 'First layer temperature (°C)',
        cli     => 'first-layer-temperature=i',
        type    => 'i',
    },
    'first_layer_bed_temperature' => {
        label   => 'First layer bed temperature (°C)',
        cli     => 'first-layer-bed-temperature=i',
        type    => 'i',
    },
    'temperature' => {
        label   => 'Temperature (°C)',
        cli     => 'temperature=i',
        type    => 'i',
        important => 1,
    },
    'bed_temperature' => {
        label   => 'Bed Temperature (°C)',
        cli     => 'bed-temperature=i',
        type    => 'i',
    },
    
    # speed options
    'travel_speed' => {
        label   => 'Travel (mm/s)',
        cli     => 'travel-speed=i',
        type    => 'f',
        aliases => [qw(travel_feed_rate)],
    },
    'perimeter_speed' => {
        label   => 'Perimeters (mm/s)',
        cli     => 'perimeter-speed=i',
        type    => 'f',
        aliases => [qw(perimeter_feed_rate)],
    },
    'small_perimeter_speed' => {
        label   => 'Small perimeters (mm/s)',
        cli     => 'small-perimeter-speed=i',
        type    => 'f',
    },
    'infill_speed' => {
        label   => 'Infill (mm/s)',
        cli     => 'infill-speed=i',
        type    => 'f',
        aliases => [qw(print_feed_rate infill_feed_rate)],
    },
    'solid_infill_speed' => {
        label   => 'Solid infill (mm/s)',
        cli     => 'solid-infill-speed=i',
        type    => 'f',
        aliases => [qw(solid_infill_feed_rate)],
    },
    'bridge_speed' => {
        label   => 'Bridges (mm/s)',
        cli     => 'bridge-speed=i',
        type    => 'f',
        aliases => [qw(bridge_feed_rate)],
    },
    'bottom_layer_speed_ratio' => {
        label   => 'Bottom layer speed ratio',
        cli     => 'bottom-layer-speed-ratio=f',
        type    => 'f',
    },
    
    # acceleration options
    'acceleration' => {
        label   => 'Enable acceleration control',
        cli     => 'acceleration',
        type    => 'bool',
    },
    'perimeter_acceleration' => {
        label   => 'Perimeters (mm/s²)',
        cli     => 'perimeter-acceleration',
        type    => 'f',
    },
    'infill_acceleration' => {
        label   => 'Infill (mm/s²)',
        cli     => 'infill-acceleration',
        type    => 'f',
    },
    
    # accuracy options
    'layer_height' => {
        label   => 'Layer height (mm)',
        cli     => 'layer-height=f',
        type    => 'f',
    },
    'first_layer_height_ratio' => {
        label   => 'First layer height ratio',
        cli     => 'first-layer-height-ratio=f',
        type    => 'f',
    },
    'infill_every_layers' => {
        label   => 'Infill every N layers',
        cli     => 'infill-every-layers=i',
        type    => 'i',
    },
    
    # flow options
    'extrusion_width_ratio' => {
        label   => 'Extrusion width (ratio over layer height; leave zero to calculate automatically)',
        cli     => 'extrusion-width-ratio=f',
        type    => 'f',
    },
    'bridge_flow_ratio' => {
        label   => 'Bridge flow ratio',
        cli     => 'bridge-flow-ratio=f',
        type    => 'f',
    },
    
    # print options
    'perimeters' => {
        label   => 'Perimeters',
        cli     => 'perimeters=i',
        type    => 'i',
        aliases => [qw(perimeter_offsets)],
    },
    'solid_layers' => {
        label   => 'Solid layers',
        cli     => 'solid-layers=i',
        type    => 'i',
    },
    'fill_pattern' => {
        label   => 'Fill pattern',
        cli     => 'fill-pattern=s',
        type    => 'select',
        values  => [qw(rectilinear line concentric hilbertcurve archimedeanchords octagramspiral)],
        labels  => [qw(rectilinear line concentric), 'hilbertcurve (slow)', 'archimedeanchords (slow)', 'octagramspiral (slow)'],
    },
    'solid_fill_pattern' => {
        label   => 'Solid fill pattern',
        cli     => 'solid-fill-pattern=s',
        type    => 'select',
        values  => [qw(rectilinear concentric hilbertcurve archimedeanchords octagramspiral)],
        labels  => [qw(rectilinear concentric), 'hilbertcurve (slow)', 'archimedeanchords (slow)', 'octagramspiral (slow)'],
    },
    'fill_density' => {
        label   => 'Fill density',
        cli     => 'fill-density=f',
        type    => 'f',
    },
    'fill_angle' => {
        label   => 'Fill angle (°)',
        cli     => 'fill-angle=i',
        type    => 'i',
    },
    'support_material' => {
        label   => 'Generate support material',
        cli     => 'support-material',
        type    => 'bool',
    },
    'support_material_tool' => {
        label   => 'Tool used to extrude support material',
        cli     => 'support-material-tool=i',
        type    => 'select',
        values  => [0,1],
        labels  => [qw(Primary Secondary)],
    },
    'start_gcode' => {
        label   => 'Start GCODE',
        cli     => 'start-gcode=s',
        type    => 's',
        multiline => 1,
        width   => 350,
        height  => 150,
        serialize   => sub { join '\n', split /\R+/, $_[0] },
        deserialize => sub { join "\n", split /\\n/, $_[0] },
    },
    'end_gcode' => {
        label   => 'End GCODE',
        cli     => 'end-gcode=s',
        type    => 's',
        multiline => 1,
        width   => 350,
        height  => 150,
        serialize   => sub { join '\n', split /\R+/, $_[0] },
        deserialize => sub { join "\n", split /\\n/, $_[0] },
    },
    'post_process' => {
        label   => 'Post-processing scripts',
        cli     => 'post-process=s@',
        type    => 's@',
        multiline => 1,
        width   => 350,
        height  => 60,
        serialize   => sub { join '; ', @{$_[0]} },
        deserialize => sub { [ split /\s*;\s*/, $_[0] ] },
    },
    
    # retraction options
    'retract_length' => {
        label   => 'Length (mm)',
        cli     => 'retract-length=f',
        type    => 'f',
    },
    'retract_speed' => {
        label   => 'Speed (mm/s)',
        cli     => 'retract-speed=i',
        type    => 'i',
    },
    'retract_restart_extra' => {
        label   => 'Extra length on restart (mm)',
        cli     => 'retract-restart-extra=f',
        type    => 'f',
    },
    'retract_before_travel' => {
        label   => 'Minimum travel after retraction (mm)',
        cli     => 'retract-before-travel=f',
        type    => 'f',
    },
    'retract_lift' => {
        label   => 'Lift Z (mm)',
        cli     => 'retract-lift=f',
        type    => 'f',
    },
    
    # cooling options
    'cooling' => {
        label   => 'Enable cooling',
        cli     => 'cooling',
        type    => 'bool',
    },
    'min_fan_speed' => {
        label   => 'Min fan speed (%)',
        cli     => 'min-fan-speed=i',
        type    => 'i',
    },
    'max_fan_speed' => {
        label   => 'Max fan speed (%)',
        cli     => 'max-fan-speed=i',
        type    => 'i',
    },
    'bridge_fan_speed' => {
        label   => 'Bridge fan speed (%)',
        cli     => 'bridge-fan-speed=i',
        type    => 'i',
    },
    'fan_below_layer_time' => {
        label   => 'Enable fan if layer print time is below (approximate seconds)',
        cli     => 'fan-below-layer-time=i',
        type    => 'i',
    },
    'slowdown_below_layer_time' => {
        label   => 'Slow down if layer print time is below (approximate seconds)',
        cli     => 'slowdown-below-layer-time=i',
        type    => 'i',
    },
    'min_print_speed' => {
        label   => 'Min print speed (mm/s)',
        cli     => 'min-print-speed=i',
        type    => 'i',
    },
    'disable_fan_first_layers' => {
        label   => 'Disable fan for the first N layers',
        cli     => 'disable-fan-first-layers=i',
        type    => 'i',
    },
    'fan_always_on' => {
        label   => 'Keep fan always on',
        cli     => 'fan-always-on',
        type    => 'bool',
    },
    
    # skirt options
    'skirts' => {
        label   => 'Loops',
        cli     => 'skirts=i',
        type    => 'i',
    },
    'skirt_distance' => {
        label   => 'Distance from object (mm)',
        cli     => 'skirt-distance=i',
        type    => 'i',
    },
    'skirt_height' => {
        label   => 'Skirt height (layers)',
        cli     => 'skirt-height=i',
        type    => 'i',
    },
    
    # transform options
    'scale' => {
        label   => 'Scale',
        cli     => 'scale=f',
        type    => 'f',
    },
    'rotate' => {
        label   => 'Rotate (°)',
        cli     => 'rotate=i',
        type    => 'i',
    },
    'duplicate' => {
        label    => 'Copies (auto arrange)',
        cli        => 'duplicate=i',
        type    => 'i',
    },
    'duplicate_x' => {
        label   => 'Copies along X',
        cli     => 'duplicate-x=i',
        type    => 'i',
        aliases => [qw(multiply_x)],
    },
    'duplicate_y' => {
        label   => 'Copies along Y',
        cli     => 'duplicate-y=i',
        type    => 'i',
        aliases => [qw(multiply_y)],
    },
    'duplicate_distance' => {
        label   => 'Distance between copies',
        cli     => 'duplicate-distance=i',
        type    => 'i',
        aliases => [qw(multiply_distance)],
    },
};

sub get {
    my $class = @_ == 2 ? shift : undef;
    my ($opt_key) = @_;
    no strict 'refs';
    return ${"Slic3r::$opt_key"};
}

sub set {
    my $class = @_ == 3 ? shift : undef;
    my ($opt_key, $value) = @_;
    no strict 'refs';
    ${"Slic3r::$opt_key"} = $value;
}

sub serialize {
    my $class = @_ == 2 ? shift : undef;
    my ($opt_key) = @_;
    return $Options->{$opt_key}{serialize}
        ? $Options->{$opt_key}{serialize}->(get($opt_key))
        : get($opt_key);
}

sub deserialize {
    my $class = @_ == 3 ? shift : undef;
    my ($opt_key, $value) = @_;
    return $Options->{$opt_key}{deserialize}
        ? set($opt_key, $Options->{$opt_key}{deserialize}->($value))
        : set($opt_key, $value);
}

sub save {
    my $class = shift;
    my ($file) = @_;
    
    open my $fh, '>', $file;
    binmode $fh, ':utf8';
    foreach my $opt (sort keys %$Options) {
        my $value = get($opt);
        $value = $Options->{$opt}{serialize}->($value) if $Options->{$opt}{serialize};
        printf $fh "%s = %s\n", $opt, $value;
    }
    close $fh;
}

sub load {
    my $class = shift;
    my ($file) = @_;
    
    local $/ = "\n";
    open my $fh, '<', $file;
    binmode $fh, ':utf8';
    while (<$fh>) {
        s/\R+$//;
        next if /^\s+/;
        next if /^$/;
        next if /^\s*#/;
        /^(\w+) = (.*)/ or die "Unreadable configuration file (invalid data at line $.)\n";
        my $key = $1;
        if (!exists $Options->{$key}) {
            $key = +(grep { $Options->{$_}{aliases} && grep $_ eq $key, @{$Options->{$_}{aliases}} }
                keys %$Options)[0] or warn "Unknown option $1 at line $.\n";
        }
        next unless $key;
        my $opt = $Options->{$key};
        set($key, $opt->{deserialize} ? $opt->{deserialize}->($2) : $2);
    }
    close $fh;
}

sub validate_cli {
    my $class = shift;
    my ($opt) = @_;
    
    for (qw(start end)) {
        if (defined $opt->{$_."_gcode"}) {
            if ($opt->{$_."_gcode"} eq "") {
                set($_."_gcode", "");
            } else {
                die "Invalid value for --${_}-gcode: file does not exist"
                    if !-e $opt->{$_."_gcode"};
                open my $fh, "<", $opt->{$_."_gcode"};
                $opt->{$_."_gcode"} = do { local $/; <$fh> };
                close $fh;
            }
        }
    }
}

sub validate {
    my $class = shift;

    # --layer-height
    die "Invalid value for --layer-height\n"
        if $Slic3r::layer_height <= 0;
    die "--layer-height must be a multiple of print resolution\n"
        if $Slic3r::layer_height / $Slic3r::resolution % 1 != 0;
    
    # --first-layer-height-ratio
    die "Invalid value for --first-layer-height-ratio\n"
        if $Slic3r::first_layer_height_ratio < 0;
    
    # --filament-diameter
    die "Invalid value for --filament-diameter\n"
        if $Slic3r::filament_diameter < 1;
    
    # --nozzle-diameter
    die "Invalid value for --nozzle-diameter\n"
        if $Slic3r::nozzle_diameter < 0;
    die "--layer-height can't be greater than --nozzle-diameter\n"
        if $Slic3r::layer_height > $Slic3r::nozzle_diameter;
    die "First layer height can't be greater than --nozzle-diameter\n"
        if ($Slic3r::layer_height * $Slic3r::first_layer_height_ratio) > $Slic3r::nozzle_diameter;
    die "First layer height can't be zero or negative\n"
        if ($Slic3r::layer_height * $Slic3r::first_layer_height_ratio) <= 0;
    
    if ($Slic3r::extrusion_width_ratio) {
        $Slic3r::flow_width = $Slic3r::layer_height * $Slic3r::extrusion_width_ratio;
    } else {
        # here we calculate a sane default by matching the flow speed (at the nozzle)
        # and the feed rate
        my $volume = ($Slic3r::nozzle_diameter**2) * PI/4;
        my $shape_threshold = $Slic3r::nozzle_diameter * $Slic3r::layer_height
            + ($Slic3r::layer_height**2) * PI/4;
        if ($volume >= $shape_threshold) {
            # rectangle with semicircles at the ends
            $Slic3r::flow_width = (($Slic3r::nozzle_diameter**2) * PI + ($Slic3r::layer_height**2) * (4 - PI)) / (4 * $Slic3r::layer_height);
        } else {
            # rectangle with squished semicircles at the ends
            $Slic3r::flow_width = $Slic3r::nozzle_diameter * ($Slic3r::nozzle_diameter/$Slic3r::layer_height - 4/PI + 1);
        }
        
        my $min_flow_width = $Slic3r::nozzle_diameter * 1.05;
        my $max_flow_width = $Slic3r::nozzle_diameter * 1.4;
        $Slic3r::flow_width = $max_flow_width if $Slic3r::flow_width > $max_flow_width;
        $Slic3r::flow_width = $min_flow_width if $Slic3r::flow_width < $min_flow_width;
    }
    
    if ($Slic3r::flow_width >= ($Slic3r::nozzle_diameter + $Slic3r::layer_height)) {
        # rectangle with semicircles at the ends
        $Slic3r::min_flow_spacing = $Slic3r::flow_width - $Slic3r::layer_height * (1 - PI/4);
    } else {
        # rectangle with shrunk semicircles at the ends
        $Slic3r::min_flow_spacing = $Slic3r::flow_width * (1 - PI/4) + $Slic3r::nozzle_diameter * PI/4;
    }
    $Slic3r::flow_spacing = $Slic3r::flow_width - $Slic3r::overlap_factor * ($Slic3r::flow_width - $Slic3r::min_flow_spacing);
    
    Slic3r::debugf "Flow width = $Slic3r::flow_width\n";
    Slic3r::debugf "Flow spacing = $Slic3r::flow_spacing\n";
    Slic3r::debugf "Min flow spacing = $Slic3r::min_flow_spacing\n";
    
    # --perimeters
    die "Invalid value for --perimeters\n"
        if $Slic3r::perimeters < 1;
    
    # --solid-layers
    die "Invalid value for --solid-layers\n"
        if $Slic3r::solid_layers < 0;
    
    # --print-center
    die "Invalid value for --print-center\n"
        if !ref $Slic3r::print_center 
            && (!$Slic3r::print_center || $Slic3r::print_center !~ /^\d+,\d+$/);
    $Slic3r::print_center = [ split /,/, $Slic3r::print_center ]
        if !ref $Slic3r::print_center;
    
    # --fill-pattern
    die "Invalid value for --fill-pattern\n"
        if !exists $Slic3r::Fill::FillTypes{$Slic3r::fill_pattern};
    
    # --solid-fill-pattern
    die "Invalid value for --solid-fill-pattern\n"
        if !exists $Slic3r::Fill::FillTypes{$Slic3r::solid_fill_pattern};
    
    # --fill-density
    die "Invalid value for --fill-density\n"
        if $Slic3r::fill_density < 0 || $Slic3r::fill_density > 1;
    
    # --infill-every-layers
    die "Invalid value for --infill-every-layers\n"
        if $Slic3r::infill_every_layers !~ /^\d+$/ || $Slic3r::infill_every_layers < 1;
    die "Maximum infill thickness can't exceed nozzle diameter\n"
        if $Slic3r::infill_every_layers * $Slic3r::layer_height > $Slic3r::nozzle_diameter;
    
    # --scale
    die "Invalid value for --scale\n"
        if $Slic3r::scale <= 0;
    
    # --duplicate
    die "Invalid value for --duplicate\n"
        if $Slic3r::duplicate < 1;

    # --duplicate-x
    die "Invalid value for --duplicate-x\n"
        if $Slic3r::duplicate_x < 1;
    
    # --duplicate-y
    die "Invalid value for --duplicate-y\n"
        if $Slic3r::duplicate_y < 1;

    # reflect actual quantity in 'duplicate' setting for use with output-filename-format, ie both --duplicate 15 and --duplicate-x 3 --duplicate-y 5 will make an appropriate filename
    if ($Slic3r::duplicate == 1 && (($Slic3r::duplicate_x > 1) || ($Slic3r::duplicate_y > 1))) {
        $Slic3r::duplicate = $Slic3r::duplicate_x * $Slic3r::duplicate_y;
    }
    
    # --duplicate-distance
    die "Invalid value for --duplicate-distance\n"
        if $Slic3r::duplicate_distance < 1;
    
    # --skirt-height
    die "Invalid value for --skirt-height\n"
        if $Slic3r::skirt_height < 0;
    
    # --bridge-flow-ratio
    die "Invalid value for --bridge-flow-ratio\n"
        if $Slic3r::bridge_flow_ratio <= 0;

	$Slic3r::first_layer_temperature //= $Slic3r::temperature;          #/
	$Slic3r::first_layer_bed_temperature //= $Slic3r::bed_temperature;  #/
    
    # G-code flavors
    $Slic3r::extrusion_axis = 'A' if $Slic3r::gcode_flavor eq 'mach3';
    
    # legacy with existing config files
    $Slic3r::small_perimeter_speed ||= $Slic3r::perimeter_speed;
    $Slic3r::bridge_speed ||= $Slic3r::infill_speed;
    $Slic3r::solid_infill_speed ||= $Slic3r::infill_speed;
}

sub replace_options {
    my $class = shift;
    my ($string, $more_variables) = @_;
    
    if ($more_variables) {
        my $variables = join '|', keys %$more_variables;
        $string =~ s/\[($variables)\]/$more_variables->{$1}/eg;
    }
    
    # build a regexp to match the available options
    my $options = join '|',
        grep !$Slic3r::Config::Options->{$_}{multiline},
        keys %$Slic3r::Config::Options;
    
    # use that regexp to search and replace option names with option values
    $string =~ s/\[($options)\]/Slic3r::Config->serialize($1)/eg;
    return $string;
}

1;
