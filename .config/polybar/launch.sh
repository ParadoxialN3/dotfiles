#!/usr/bin/env bash

dir="$HOME/.config/polybar"
themes=(`ls --hide="launch.sh" $dir`)

launch_bar() {
	killall -q polybar
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

	if [[ "$style" == "hack" || "$style" == "cuts" ]]; then
		polybar -q top -c "$dir/$style/config.ini" &
		polybar -q bottom -c "$dir/$style/config.ini" &

	elif [[ "$style" == "pwidgets" ]]; then
		bash "$dir"/pwidgets/launch.sh --main

	else
		#👇 👉 launching multiple monitors --> make sure to add monitor = ${env:MONITOR:} in the config
		if type "xrandr"; then
		  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
		    MONITOR=$m polybar -q main -c "$dir/$style/config.ini" &
		  done
		else
		  polybar -q main -c "$dir/$style/config.ini" &
		fi
		#polybar -q main -c "$dir/$style/config.ini" &
	fi
}

if type "xrandr" > /dev/null; then
    while read F1 F2 _; do
        if [ "$F2" = 'connected' ]; then
            MONITOR=$F1 polybar --reload main -c ~/.config/polybar/config.ini &
        fi
    done <<< $( xrandr )
else
    polybar --reload main -c ~/.config/polybar/config.ini  &
fi

if [[ "$1" == "--material" ]]; then
	style="material"
	launch_bar

elif [[ "$1" == "--shades" ]]; then
	style="shades"
	launch_bar

elif [[ "$1" == "--hack" ]]; then
	style="hack"
	launch_bar

elif [[ "$1" == "--docky" ]]; then
	style="docky"
	launch_bar

elif [[ "$1" == "--cuts" ]]; then
	style="cuts"
	launch_bar

elif [[ "$1" == "--shapes" ]]; then
	style="shapes"
	launch_bar

elif [[ "$1" == "--grayblocks" ]]; then
	style="grayblocks"
	launch_bar

elif [[ "$1" == "--blocks" ]]; then
	style="blocks"
	launch_bar

elif [[ "$1" == "--colorblocks" ]]; then
	style="colorblocks"
	launch_bar

elif [[ "$1" == "--forest" ]]; then
	style="forest"
	launch_bar

elif [[ "$1" == "--pwidgets" ]]; then
	style="pwidgets"
	launch_bar

elif [[ "$1" == "--panels" ]]; then
	style="panels"
	launch_bar

else
	cat <<- EOF
	Usage : launch.sh --theme
		
	Available Themes :
	--blocks    --colorblocks    --cuts      --docky
	--forest    --grayblocks     --hack      --material
	--panels    --pwidgets       --shades    --shapes
	EOF
fi
