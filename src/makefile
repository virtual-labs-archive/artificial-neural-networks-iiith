build-dir=../build
theme=green-icon

all:patch-analytics ${theme}

green-icon:
	mkdir ${build-dir};rsync -avC --progress lab/* themes/${theme}/* ${build-dir}
clean:
	rm -rf ${build-dir}

patch-analytics:
	git clone https://github.com/virtual-labs/vlabs-analytics.git
	cp vlabs-analytics/gtm-patcher.py ../scripts/.
	cp vlabs-analytics/patch-analytics.sh ../scripts/.
	chmod +x ../scripts/patch-analytics.sh 
	../scripts/patch-analytics.sh
	rm -rf vlabs-analytics
	rm -rf ../scripts/patch-analytics.sh
	rm -rf ../scripts/gtm-patcher.py
