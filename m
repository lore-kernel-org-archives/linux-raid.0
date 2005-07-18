From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: Raid5 Failure
Date: Sun, 17 Jul 2005 21:46:45 -0400
Message-ID: <004b01c58b3a$8e26f910$c200a8c0@NCNF5131FTH>
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH><17114.54800.132155.142544@cse.unsw.edu.au><00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH><17114.62108.319878.983091@cse.unsw.edu.au><010701c58b32$ee423830$c200a8c0@NCNF5131FTH><17115.149.130115.176372@cse.unsw.edu.au><001601c58b37$620c69d0$c200a8c0@NCNF5131FTH> <17115.1749.370942.838069@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil --

That worked, the device has been added to the array. Now, I think the next 
problem is my own ignorance.

-(root@abyss)-(/)- # mdadm --detail /dev/md0
/dev/md0:
        Version : 01.00.01
  Creation Time : Wed Dec 31 19:00:00 1969
     Raid Level : raid5
     Array Size : 1935556992 (1845.89 GiB 1982.01 GB)
    Device Size : 71687296 (68.37 GiB 73.41 GB)
   Raid Devices : 28
  Total Devices : 28
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Jul 17 17:32:12 2005
          State : clean, degraded
 Active Devices : 27
Working Devices : 28
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-asymmetric
     Chunk Size : 128K

           UUID : 4e2b6b0a8e:92e91c0c:018a4bf0:9bb74d
         Events : 176939

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/evms/.nodes/sda
       1       8       16        1      active sync   /dev/evms/.nodes/sdb
       2       8       32        2      active sync   /dev/evms/.nodes/sdc
       3       8       48        3      active sync   /dev/evms/.nodes/sdd
       4       8       64        4      active sync   /dev/evms/.nodes/sde
       5       8       80        5      active sync   /dev/evms/.nodes/sdf
       6       8       96        6      active sync   /dev/evms/.nodes/sdg
       7       8      112        7      active sync   /dev/evms/.nodes/sdh
       8       8      128        8      active sync   /dev/evms/.nodes/sdi
       9       8      144        9      active sync   /dev/evms/.nodes/sdj
      10       8      160       10      active sync   /dev/evms/.nodes/sdk
      11       8      176       11      active sync   /dev/evms/.nodes/sdl
      12       8      192       12      active sync   /dev/evms/.nodes/sdm
      13       8      208       13      active sync   /dev/evms/.nodes/sdn
      14       8      224       14      active sync   /dev/evms/.nodes/sdo
      15       8      240       15      active sync   /dev/evms/.nodes/sdp
      16      65        0       16      active sync   /dev/evms/.nodes/sdq
      17      65       16       17      active sync   /dev/evms/.nodes/sdr
      18      65       32       18      active sync   /dev/evms/.nodes/sds
      19      65       48       19      active sync   /dev/evms/.nodes/sdt
      20      65       64       20      active sync   /dev/evms/.nodes/sdu
      21      65       80       21      active sync   /dev/evms/.nodes/sdv
      22      65       96       22      active sync   /dev/evms/.nodes/sdw
      23      65      112       23      active sync   /dev/evms/.nodes/sdx
      24      65      128       24      active sync   /dev/evms/.nodes/sdy
      25      65      144       25      active sync   /dev/evms/.nodes/sdz
      26       0        0        -      removed
      27      65      176       27      active sync   /dev/evms/.nodes/sdab

      28      65      160        -      spare   /dev/evms/.nodes/sdaa


I've got 28 devices, 1 spare, 27 active. I'm still running as clean, 
degraded.

What do I do next? What I wanted to do was to put /dev/sdaa back in as 
device 26, but now it's device 28 - and flagged as spare. How do I make it 
active in the array again?

-- David M. Strang


----- Original Message ----- 
From: Neil Brown
To: David M. Strang
Cc: linux-raid@vger.kernel.org
Sent: Sunday, July 17, 2005 9:33 PM
Subject: Re: Raid5 Failure

Ahhhh...  I cannot read my own code, that is the problem!!

This patch should fix it.

Thanks for persisting.

NeilBrown

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./Manage.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff ./Manage.c~current~ ./Manage.c
--- ./Manage.c~current~ 2005-07-07 09:19:53.000000000 +1000
+++ ./Manage.c 2005-07-18 11:31:57.000000000 +1000
@@ -204,11 +204,8 @@ int Manage_subdevs(char *devname, int fd
  return 1;
  }
  close(tfd);
-#if 0
- if (array.major_version == 0) {
-#else
- if (md_get_version(fd)%100 < 2) {
-#endif
+ if (array.major_version == 0 &&
+     md_get_version(fd)%100 < 2) {
  if (ioctl(fd, HOT_ADD_DISK,
    (unsigned long)stb.st_rdev)==0) {
  fprintf(stderr, Name ": hot added %s\n",
- 

