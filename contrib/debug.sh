#!/bin/sh -e

gdb=${GDB:-arm-none-eabi-gdb}
openocd=${OPENOCD:-/usr/bin/openocd}
openocd_root=${OPENOCD_ROOT:-/usr/share/openocd}

usage=$(cat <<- EOM
	Usage: $0 [-g|--gdb /path/to/gdb] [--openocd-bin /path/to/openocd] [--openocd-root /path/to/openocd/share/dir] <binary to debug>

	    -g|--gdb <bin>: Use the gdb binary <bin> to debug the application. 
	        Uses by default 'arm-none-eabi-gdb'.
	    --openocd-bin <path>: Use the openocd binary located at <path> to
	        reset the hardware for proper debugging.
	        Uses by default '/usr/bin/openocd'.
	    --openocd-root <path>: The share directory of openocd.
	        Uses by default '/usr/share/openocd'.
EOM
)

while [ $# -ge 1 ]; do
    arg="$1"

    case $arg in
        -g|--gdb)       gdb="$2"; shift;;
        --openocd-bin)  openocd="$2"; shift;;
        --openocd-root) openocd_root="$2"; shift;;
        -*)
            echo "$usage"
            exit 3
            ;;
        *)
            bin=$arg;;
    esac
    shift
done

if [ -z "$bin" ]; then
    echo "$usage"
    exit 3
fi;

if [ ! -f "$bin" ]; then
    echo "File '$bin' does not exist."
    exit 3
fi;

tmp=$(mktemp)

cat > $tmp <<- EOM
	shell $openocd -f "$openocd_root/scripts/board/stm32f4discovery.cfg" -c "init" -c "reset halt" >/dev/null 2>&1 &
	shell rm -f $tmp
	target remote localhost:3333
	monitor reset halt
	monitor flash protect 0 0 11 off
	monitor flash write_image erase "$(realpath $bin)"
	monitor reset halt
	file $bin
	load
	break _ada_main
	tabset
	continue
EOM

exec $gdb "-command=$tmp"
