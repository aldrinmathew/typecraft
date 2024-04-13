printf -v flutter_timestamp '%(%Y-%m-%d %H:%M:%S)T' -1 \
	&& flutter build web --release --base-href=/typecraft/ \
	&& git add . \
	&& git commit -m "New Build - ${flutter_timestamp}" \
	&& git push origin main \
	&& git push origin -d gh-pages \
	&& git subtree push --prefix build/web origin gh-pages