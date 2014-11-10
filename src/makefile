build-dir=../build
lib-dir=lib
build-js-dir=${build-dir}/js
build-www=/var/www/vlabs/ann

theme=blue-icon


all:  help-dir 

help-dir:

	(touch ${build-dir}/theme-${theme}; rsync -avC --exclude ${mathjax}.zip lab/* lib/* help themes/${theme}/* ${build-dir})

local:
	(touch ${build-www}/theme-${theme}; rsync -avC --exclude ${mathjax}.zip lab/* lib/* help themes/${theme}/* ${build-www};chown -R www-data.www-data ${build-www})



# don't remove the js directory, since copying it again with mathjax takes too long.
# http://superuser.com/questions/168130/unix-delete-files-and-folders-excluding-pattern
clean:
	(find ${build-dir} -mindepth 1 -maxdepth 1 ! -name js -print0 | xargs -0n1 rm -rf)









