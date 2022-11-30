BEGIN {
    # perform the shasum command
    cmd="shasum --algorithm 512256 --UNIVERSAL *";
    for (; (cmd|getline inp)>0 ;) {
		split(inp,WorkArray,FS);
		Checksum=WorkArray[1];
		Filename=substr(WorkArray[2],2);
		if ( FileArray[Checksum]=="" ) {
			FileArray[Checksum]=Filename
		} else {
			print "DUPLICATE",Filename,FileArray[Checksum]
			cmd2="mv " Filename " DUPLICATE." Filename
			system(cmd2);
			close(cmd2);
		}
    }
    close(cmd);
}
