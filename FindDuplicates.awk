BEGIN {
    # perform an ls command
    cmd="ls";
    for (; (cmd|getline inp)>0 ;) {
        # file is in inp
        # do a shasum
        cmd2="shasum " inp;
        for (; (cmd2|getline inp2)>0 ;) {
            split(inp2,array);
            checksum=array[1];
            print checksum;
            # did we already see this file
            if ( CHK[checksum]==1) {
                # yes we did
                cmd3="mv " inp " DUPLICATE." inp;
                print cmd3;
            } else {
                # no we did not
                CHK[checksum]=1;
            }
        }
        close(cmd2);
    }
    close(cmd);
}