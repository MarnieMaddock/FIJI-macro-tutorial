title = getTitle(); // Get the title of the current image
run("Split Channels");
run("Merge Channels...", "c1=[C1-" + title + "] c2=[C2-" + title + "] c3=[C3-" + title + "] create");
