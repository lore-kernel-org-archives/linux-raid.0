From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: Raid5 Failure
Date: Sun, 17 Jul 2005 21:31:52 -0400
Message-ID: <003a01c58b38$79eb9980$c200a8c0@NCNF5131FTH>
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH><17114.54800.132155.142544@cse.unsw.edu.au><00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH><17114.62108.319878.983091@cse.unsw.edu.au><010701c58b32$ee423830$c200a8c0@NCNF5131FTH> <17115.149.130115.176372@cse.unsw.edu.au> <002901c58b37$ace88970$c200a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oops -

forgot this part:

(gdb) print array
$1 = {major_version = -1208614704, minor_version = 134596176, patch_version 
= -1079477788, ctime = -1209047397, level = 5, size = -1079477052, nr_disks 
= 134623392, raid_disks = 134623456,
  md_minor = -1079477212, not_persistent = 0, utime = -1208577344, state 
= -1208582100, active_disks = -1208448832, working_disks = -1079477752, 
failed_disks = -1209047199, spare_disks = 5,
  layout = -1079477052, chunk_size = 134623392}

-- David M. Strang
----- Original Message ----- 
From: David M. Strang
To: unlisted-recipients: ; no To-header on input
Cc: linux-raid@vger.kernel.org
Sent: Sunday, July 17, 2005 9:26 PM
Subject: Re: Raid5 Failure


-(root@abyss)-(~)- # gdb mdadm
GNU gdb 6.2
Copyright 2004 Free Software Foundation, Inc.
GDB is free software, covered by the GNU General Public License, and you are
welcome to change it and/or distribute copies of it under certain
conditions.
Type "show copying" to see the conditions.
There is absolutely no warranty for GDB.  Type "show warranty" for details.
This GDB was configured as "i686-pc-linux-gnu"...Using host libthread_db
library "/lib/libthread_db.so.1".

(gdb) b 'Manage_subdevs'
Breakpoint 1 at 0x804fcb6: file Manage.c, line 174.
(gdb) run --manage --add /dev/md0 /dev/sdaa
Starting program: /sbin/mdadm --manage --add /dev/md0 /dev/sdaa
warning: Unable to find dynamic linker breakpoint function.
GDB will be unable to debug shared library initializers
and track explicitly loaded dynamic code.

Breakpoint 1, Manage_subdevs (devname=0xbfe0de75 "/dev/md0", fd=7,
devlist=0x8067018) at Manage.c:174
174             void *dsuper = NULL;
(gdb) n
176             if (ioctl(fd, GET_ARRAY_INFO, &array)) {
(gdb) n
181             for (dv = devlist ; dv; dv=dv->next) {
(gdb) n
182                     if (stat(dv->devname, &stb)) {
(gdb) n
187                     if ((stb.st_mode & S_IFMT) != S_IFBLK) {
(gdb) n
192                     switch(dv->disposition){
(gdb) n
200                             tfd = open(dv->devname, O_RDONLY|O_EXCL);
(gdb) n
201                             if (tfd < 0) {
(gdb) n
206                             close(tfd);
(gdb) n
210                                     if (md_get_version(fd)%100 < 2) {
(gdb) n
212                                     if (ioctl(fd, HOT_ADD_DISK,
(gdb) n
219                                     fprintf(stderr, Name ": hot add
failed for %s: %s\n",
(gdb) n
mdadm: hot add failed for /dev/sdaa: Invalid argument
221                                     return 1;
(gdb) n
307     }
(gdb) n
main (argc=5, argv=0xbfe0cb14) at mdadm.c:810
810                     if (!rv && readonly < 0)
(gdb) n
812                     if (!rv && runstop)
(gdb) n
1072            exit(rv);
(gdb) n

Program exited with code 01.

-- David M. Strang
----- Original Message ----- 
From: Neil Brown
To: David M. Strang
Cc: linux-raid@vger.kernel.org
Sent: Sunday, July 17, 2005 9:06 PM
Subject: Re: Raid5 Failure


On Sunday July 17, dstrang@shellpower.net wrote:
> I'm not real good with GDB... but I'm giving it a shot.
>
> (gdb) run -a /dev/md0 /dev/sdaa
> Starting program: /sbin/mdadm -a /dev/md0 /dev/sdaa
> warning: Unable to find dynamic linker breakpoint function.
> GDB will be unable to debug shared library initializers
> and track explicitly loaded dynamic code.
>
> Breakpoint 1, Manage_subdevs (devname=0xbfe75e5f "/dev/md0", fd=7,
> devlist=0x8067018) at Manage.c:174
> 174             void *dsuper = NULL;
> (gdb) c

At this point you need to use 'n' for 'next', to step through the code
one statement at a time.
When you see:
 176            if (ioctl(fd, GET_ARRAY_INFO, &array)) {
enter 'n' again, to execute that, then
  print array
to print the 'array' structure.
Then continue with 'n' repeatedly.

NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html 

