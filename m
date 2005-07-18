From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid5 Failure
Date: Mon, 18 Jul 2005 11:33:09 +1000
Message-ID: <17115.1749.370942.838069@cse.unsw.edu.au>
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH>
	<17114.54800.132155.142544@cse.unsw.edu.au>
	<00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH>
	<17114.62108.319878.983091@cse.unsw.edu.au>
	<010701c58b32$ee423830$c200a8c0@NCNF5131FTH>
	<17115.149.130115.176372@cse.unsw.edu.au>
	<001601c58b37$620c69d0$c200a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David M. Strang on Sunday July 17
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 17, dstrang@shellpower.net wrote:
> -(root@abyss)-(~)- # gdb mdadm
> GNU gdb 6.2
> Copyright 2004 Free Software Foundation, Inc.
> GDB is free software, covered by the GNU General Public License, and you are
> welcome to change it and/or distribute copies of it under certain conditions.
> Type "show copying" to see the conditions.
> There is absolutely no warranty for GDB.  Type "show warranty" for details.
> This GDB was configured as "i686-pc-linux-gnu"...Using host libthread_db library "/lib/libthread_db.so.1".
> 
> (gdb) b 'Manage_subdevs'
> Breakpoint 1 at 0x804fcb6: file Manage.c, line 174.
> (gdb) run --manage --add /dev/md0 /dev/sdaa
> Starting program: /sbin/mdadm --manage --add /dev/md0 /dev/sdaa
> warning: Unable to find dynamic linker breakpoint function.
> GDB will be unable to debug shared library initializers
> and track explicitly loaded dynamic code.
> 
> Breakpoint 1, Manage_subdevs (devname=0xbfe0de75 "/dev/md0", fd=7, devlist=0x8067018) at Manage.c:174
> 174             void *dsuper = NULL;
> (gdb) n
> 176             if (ioctl(fd, GET_ARRAY_INFO, &array)) {
> (gdb) n
> 181             for (dv = devlist ; dv; dv=dv->next) {
> (gdb) n
> 182                     if (stat(dv->devname, &stb)) {
> (gdb) n
> 187                     if ((stb.st_mode & S_IFMT) != S_IFBLK) {
> (gdb) n
> 192                     switch(dv->disposition){
> (gdb) n
> 200                             tfd = open(dv->devname, O_RDONLY|O_EXCL);
> (gdb) n
> 201                             if (tfd < 0) {
> (gdb) n
> 206                             close(tfd);
> (gdb) n
> 210                                     if (md_get_version(fd)%100 <
> 2) {

Ahhhh...  I cannot read my own code, that is the problem!!

This patch should fix it.

Thanks for persisting.

NeilBrown

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./Manage.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff ./Manage.c~current~ ./Manage.c
--- ./Manage.c~current~	2005-07-07 09:19:53.000000000 +1000
+++ ./Manage.c	2005-07-18 11:31:57.000000000 +1000
@@ -204,11 +204,8 @@ int Manage_subdevs(char *devname, int fd
 				return 1;
 			}
 			close(tfd);
-#if 0
-			if (array.major_version == 0) {
-#else
-				if (md_get_version(fd)%100 < 2) {
-#endif
+			if (array.major_version == 0 &&
+			    md_get_version(fd)%100 < 2) {
 				if (ioctl(fd, HOT_ADD_DISK,
 					  (unsigned long)stb.st_rdev)==0) {
 					fprintf(stderr, Name ": hot added %s\n",
