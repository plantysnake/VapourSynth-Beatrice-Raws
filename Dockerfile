# syntax=docker/dockerfile:1.5
FROM fr3akyphantom/vapoursynth-av1an-rt:latest

SHELL ["/bin/bash", "-c"]

USER app

WORKDIR /tmp

RUN <<-'EOL'
    set -ex  
	sudo pacman -Sy --noconfirm 2>/dev/null
	sudo pacman -S --noconfirm meson 2>/dev/null
	mkdir -p /home/app/.cache/paru/clone 2>/dev/null
	export PARU_OPTS="--skipreview --noprovides --removemake --cleanafter --useask --combinedupgrade --batchinstall --nokeepsrc" 
	echo -e "[+] Custom x265 install Starts Here" 
	cd /tmp 
	sudo pacman -Rdd x265-git --noconfirm 
	git clone https://github.com/plantysnake/x265-aMod.git 
	cd x265-aMod 
	paru -Ui --noconfirm --needed ${PARU_OPTS} --mflags="--force" --rebuild && cd .. 
	echo -e "[+] vapoursynth additional Plugins Installation Block Starts Here" 
	cd /tmp && yes | CFLAGS+=' -Wno-unused-parameter -Wno-deprecated-declarations -Wno-unknown-pragmas -Wno-implicit-fallthrough' CXXFLAGS+=' -Wno-unused-parameter -Wno-deprecated-declarations -Wno-unknown-pragmas -Wno-implicit-fallthrough' paru -S --needed ${PARU_OPTS} vapoursynth-plugin-d2vsource-git vapoursynth-plugin-damb-git vapoursynth-plugin-dctfilter-git vapoursynth-plugin-fftspectrum-git vapoursynth-plugin-fieldhint-git vapoursynth-plugin-fixtelecinedfades-git vapoursynth-plugin-histogram-git vapoursynth-plugin-imwri-git vapoursynth-plugin-motionmask-git vapoursynth-plugin-nnedi3-git vapoursynth-plugin-nnedi3cl-git vapoursynth-plugin-nnedi3_weights_bin vapoursynth-plugin-vsrawsource-git vapoursynth-plugin-scxvid-git vapoursynth-plugin-smoothuv-git vapoursynth-plugin-tcolormask-git vapoursynth-plugin-tonemap-git vapoursynth-plugin-vmaf-git vapoursynth-plugin-awarpsharp2-git vapoursynth-plugin-znedi3-git vapoursynth-plugin-vivtc-git vapoursynth-plugin-removegrain-git vapoursynth-plugin-vine-git vapoursynth-plugin-subtext-git vapoursynth-plugin-subtext-git vapoursynth-plugin-tdeintmod-git vapoursynth-plugin-edgefixer-git 
	echo -e "[+] TMaskCleaner.git install" 
	mkdir -p /home/app/TMaskCleaner 
	cd /home/app/TMaskCleaner 
	git clone https://github.com/Beatrice-Raws/VapourSynth-TMaskCleaner
	cd VapourSynth-TMaskCleaner 
	meson build 
	ninja -C build 
	sudo ninja -C build install 
	echo -e "[i] Plugins configuration" 
	sudo libtool --finish /usr/lib/vapoursynth &>/dev/null 
	sudo ldconfig 2>/dev/null 
	echo -e "[i] Home directory Investigation" 
	sudo du -sh ~/\.[a-z]* 2>/dev/null 
	echo -e "[<] Cleanup" 
	find "$(python -c "import os;print(os.path.dirname(os.__file__))")" -depth -type d -name __pycache__ -exec sudo rm -rf '{}' + 2>/dev/null 
	( sudo pacman -Rdd cmake ninja clang nasm yasm rust cargo-c compiler-rt llvm-libs --noconfirm 2>/dev/null || true ) 
	sudo rm -rf /tmp/* /var/cache/pacman/pkg/* /home/app/.cache/yay/* /home/app/.cache/paru/* /home/app/.cargo/* 2>/dev/null
EOL

VOLUME ["/videos"]
WORKDIR /videos

ENTRYPOINT [ "/usr/bin/bash" ]
