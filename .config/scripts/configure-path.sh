for file in ./add-to-path/*; do
	if [ -d "$file" ]; then
		echo "skipping directory $file..."
		continue
	fi

	cp "$file" "/usr/bin/"
done
