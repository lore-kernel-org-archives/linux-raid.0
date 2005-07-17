From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: Raid5 Failure
Date: Sun, 17 Jul 2005 11:44:19 -0400
Message-ID: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH>
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

-(root@abyss)-(/)- # mdadm --manage --add /dev/md0 /dev/sdaa
mdadm: hot add failed for /dev/sdaa: Invalid argument

Jul 17 11:42:38 abyss kernel: md0: HOT_ADD may only be used with version-0 
superblocks.

What, if anything, can I do since I'm using a version 1.0 superblock?

-- David M. Strang

----- Original Message ----- 
From: David M. Strang
To: Neil Brown
Cc: linux-raid@vger.kernel.org
Sent: Friday, July 15, 2005 4:25 PM
Subject: Re: Raid5 Failure


Okay, the array rebuilt - but I had 2 failed devices this morning.

/dev/sdj & /dev/sdaa were marked faulty.

Jul 15 01:47:53 abyss kernel: qla2200 0000:00:0d.0: LOOP DOWN detected.
Jul 15 01:47:53 abyss kernel: qla2200 0000:00:0d.0: LIP occured (f7f7).
Jul 15 01:47:53 abyss kernel: qla2200 0000:00:0d.0: LOOP UP detected (1
Gbps).
Jul 15 01:52:12 abyss kernel: qla2200 0000:00:0d.0: LIP reset occured
(f7c3).
Jul 15 01:52:12 abyss kernel: qla2200 0000:00:0d.0: LIP occured (f7c3).
Jul 15 01:52:12 abyss kernel: qla2200 0000:00:0d.0: LIP reset occured
(f775).
Jul 15 01:52:12 abyss kernel: qla2200 0000:00:0d.0: LIP occured (f775).
Jul 15 01:59:50 abyss kernel: qla2200 0000:00:0d.0: LIP reset occured
(f7c3).
Jul 15 01:59:50 abyss kernel: qla2200 0000:00:0d.0: LIP occured (f7c3).
Jul 15 02:00:42 abyss kernel: qla2200 0000:00:0d.0: LIP reset occured
(f776).
Jul 15 02:00:42 abyss kernel: qla2200 0000:00:0d.0: LIP occured (f776).
Jul 15 02:01:17 abyss kernel:  rport-2:0-9: blocked FC remote port time out:
removing target
Jul 15 02:01:17 abyss kernel:  rport-2:0-26: blocked FC remote port time
out: removing target
Jul 15 02:01:17 abyss kernel: SCSI error : <2 0 9 0> return code = 0x10000
Jul 15 02:01:17 abyss kernel: end_request: I/O error, dev sdj, sector
53238272
Jul 15 02:01:17 abyss kernel: raid5: Disk failure on sdj, disabling device.
Operation continuing on 27 devices
Jul 15 02:01:17 abyss kernel: scsi2 (9:0): rejecting I/O to dead device
Jul 15 02:01:17 abyss kernel: SCSI error : <2 0 9 0> return code = 0x10000
Jul 15 02:01:17 abyss kernel: end_request: I/O error, dev sdj, sector
53239552
Jul 15 02:01:17 abyss kernel: scsi2 (9:0): rejecting I/O to dead device
Jul 15 02:01:17 abyss kernel: SCSI error : <2 0 9 0> return code = 0x10000
Jul 15 02:01:17 abyss kernel: end_request: I/O error, dev sdj, sector
53239296
Jul 15 02:01:17 abyss kernel: scsi2 (9:0): rejecting I/O to dead device
Jul 15 02:01:17 abyss kernel: SCSI error : <2 0 9 0> return code = 0x10000
Jul 15 02:01:17 abyss kernel: end_request: I/O error, dev sdj, sector
53239040
Jul 15 02:01:17 abyss kernel: scsi2 (9:0): rejecting I/O to dead device
Jul 15 02:01:17 abyss kernel: SCSI error : <2 0 9 0> return code = 0x10000
Jul 15 02:01:17 abyss kernel: end_request: I/O error, dev sdj, sector
53238784
Jul 15 02:01:17 abyss kernel: scsi2 (9:0): rejecting I/O to dead device
Jul 15 02:01:17 abyss kernel: SCSI error : <2 0 9 0> return code = 0x10000
Jul 15 02:01:17 abyss kernel: end_request: I/O error, dev sdj, sector
53238528
Jul 15 02:01:17 abyss kernel: scsi2 (9:0): rejecting I/O to dead device
Jul 15 02:01:17 abyss kernel: SCSI error : <2 0 26 0> return code = 0x10000
Jul 15 02:01:17 abyss kernel: end_request: I/O error, dev sdaa, sector
53238016
Jul 15 02:01:17 abyss kernel: raid5: Disk failure on sdaa, disabling device.
Operation continuing on 26 devices

I have switched out the QLA2200 controller for a different one; and used:

mdadm -A /dev/md0 /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
/dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn
/dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt /dev/sdu /dev/sdv
/dev/sdw /dev/sdx /dev/sdy /dev/sdz /dev/sdaa /dev/sdab -f

to start the array; it is now running.

Jul 15 08:55:51 abyss kernel: md: bind<sdb>
Jul 15 08:55:51 abyss kernel: md: bind<sdc>
Jul 15 08:55:51 abyss kernel: md: bind<sdd>
Jul 15 08:55:51 abyss kernel: md: bind<sde>
Jul 15 08:55:51 abyss kernel: md: bind<sdf>
Jul 15 08:55:51 abyss kernel: md: bind<sdg>
Jul 15 08:55:51 abyss kernel: md: bind<sdh>
Jul 15 08:55:51 abyss kernel: md: bind<sdi>
Jul 15 08:55:51 abyss kernel: md: bind<sdj>
Jul 15 08:55:51 abyss kernel: md: bind<sdk>
Jul 15 08:55:51 abyss kernel: md: bind<sdl>
Jul 15 08:55:51 abyss kernel: md: bind<sdm>
Jul 15 08:55:51 abyss kernel: md: bind<sdn>
Jul 15 08:55:51 abyss kernel: md: bind<sdo>
Jul 15 08:55:51 abyss kernel: md: bind<sdp>
Jul 15 08:55:51 abyss kernel: md: bind<sdq>
Jul 15 08:55:51 abyss kernel: md: bind<sdr>
Jul 15 08:55:51 abyss kernel: md: bind<sds>
Jul 15 08:55:51 abyss kernel: md: bind<sdt>
Jul 15 08:55:51 abyss kernel: md: bind<sdu>
Jul 15 08:55:51 abyss kernel: md: bind<sdv>
Jul 15 08:55:51 abyss kernel: md: bind<sdw>
Jul 15 08:55:51 abyss kernel: md: bind<sdx>
Jul 15 08:55:51 abyss kernel: md: bind<sdy>
Jul 15 08:55:51 abyss kernel: md: bind<sdz>
Jul 15 08:55:51 abyss kernel: md: bind<sdaa>
Jul 15 08:55:51 abyss kernel: md: bind<sdab>
Jul 15 08:55:51 abyss kernel: md: bind<sda>
Jul 15 08:55:51 abyss kernel: md: kicking non-fresh sdaa from array!
Jul 15 08:55:51 abyss kernel: md: unbind<sdaa>
Jul 15 08:55:51 abyss kernel: md: export_rdev(sdaa)
Jul 15 08:55:51 abyss kernel: raid5: device sda operational as raid disk 0
Jul 15 08:55:51 abyss kernel: raid5: device sdab operational as raid disk 27
Jul 15 08:55:51 abyss kernel: raid5: device sdz operational as raid disk 25
Jul 15 08:55:51 abyss kernel: raid5: device sdy operational as raid disk 24
Jul 15 08:55:51 abyss kernel: raid5: device sdx operational as raid disk 23
Jul 15 08:55:51 abyss kernel: raid5: device sdw operational as raid disk 22
Jul 15 08:55:51 abyss kernel: raid5: device sdv operational as raid disk 21
Jul 15 08:55:51 abyss kernel: raid5: device sdu operational as raid disk 20
Jul 15 08:55:51 abyss kernel: raid5: device sdt operational as raid disk 19
Jul 15 08:55:51 abyss kernel: raid5: device sds operational as raid disk 18
Jul 15 08:55:51 abyss kernel: raid5: device sdr operational as raid disk 17
Jul 15 08:55:51 abyss kernel: raid5: device sdq operational as raid disk 16
Jul 15 08:55:51 abyss kernel: raid5: device sdp operational as raid disk 15
Jul 15 08:55:51 abyss kernel: raid5: device sdo operational as raid disk 14
Jul 15 08:55:51 abyss kernel: raid5: device sdn operational as raid disk 13
Jul 15 08:55:51 abyss kernel: raid5: device sdm operational as raid disk 12
Jul 15 08:55:51 abyss kernel: raid5: device sdl operational as raid disk 11
Jul 15 08:55:51 abyss kernel: raid5: device sdk operational as raid disk 10
Jul 15 08:55:51 abyss kernel: raid5: device sdj operational as raid disk 9
Jul 15 08:55:51 abyss kernel: raid5: device sdi operational as raid disk 8
Jul 15 08:55:51 abyss kernel: raid5: device sdh operational as raid disk 7
Jul 15 08:55:51 abyss kernel: raid5: device sdg operational as raid disk 6
Jul 15 08:55:51 abyss kernel: raid5: device sdf operational as raid disk 5
Jul 15 08:55:51 abyss kernel: raid5: device sde operational as raid disk 4
Jul 15 08:55:51 abyss kernel: raid5: device sdd operational as raid disk 3
Jul 15 08:55:51 abyss kernel: raid5: device sdc operational as raid disk 2
Jul 15 08:55:51 abyss kernel: raid5: device sdb operational as raid disk 1
Jul 15 08:55:51 abyss kernel: raid5: allocated 29215kB for md0
Jul 15 08:55:51 abyss kernel: raid5: raid level 5 set md0 active with 27 out
of 28 devices, algorithm 0
Jul 15 08:55:51 abyss kernel: RAID5 conf printout:
Jul 15 08:55:51 abyss kernel:  --- rd:28 wd:27 fd:1
Jul 15 08:55:51 abyss kernel:  disk 0, o:1, dev:sda
Jul 15 08:55:51 abyss kernel:  disk 1, o:1, dev:sdb
Jul 15 08:55:51 abyss kernel:  disk 2, o:1, dev:sdc
Jul 15 08:55:51 abyss kernel:  disk 3, o:1, dev:sdd
Jul 15 08:55:51 abyss kernel:  disk 4, o:1, dev:sde
Jul 15 08:55:51 abyss kernel:  disk 5, o:1, dev:sdf
Jul 15 08:55:51 abyss kernel:  disk 6, o:1, dev:sdg
Jul 15 08:55:51 abyss kernel:  disk 7, o:1, dev:sdh
Jul 15 08:55:51 abyss kernel:  disk 8, o:1, dev:sdi
Jul 15 08:55:51 abyss kernel:  disk 9, o:1, dev:sdj
Jul 15 08:55:51 abyss kernel:  disk 10, o:1, dev:sdk
Jul 15 08:55:51 abyss kernel:  disk 11, o:1, dev:sdl
Jul 15 08:55:51 abyss kernel:  disk 12, o:1, dev:sdm
Jul 15 08:55:51 abyss kernel:  disk 13, o:1, dev:sdn
Jul 15 08:55:51 abyss kernel:  disk 14, o:1, dev:sdo
Jul 15 08:55:51 abyss kernel:  disk 15, o:1, dev:sdp
Jul 15 08:55:51 abyss kernel:  disk 16, o:1, dev:sdq
Jul 15 08:55:51 abyss kernel:  disk 17, o:1, dev:sdr
Jul 15 08:55:51 abyss kernel:  disk 18, o:1, dev:sds
Jul 15 08:55:51 abyss kernel:  disk 19, o:1, dev:sdt
Jul 15 08:55:51 abyss kernel:  disk 20, o:1, dev:sdu
Jul 15 08:55:51 abyss kernel:  disk 21, o:1, dev:sdv
Jul 15 08:55:51 abyss kernel:  disk 22, o:1, dev:sdw
Jul 15 08:55:51 abyss kernel:  disk 23, o:1, dev:sdx
Jul 15 08:55:51 abyss kernel:  disk 24, o:1, dev:sdy
Jul 15 08:55:51 abyss kernel:  disk 25, o:1, dev:sdz
Jul 15 08:55:51 abyss kernel:  disk 27, o:1, dev:sdab
Jul 15 08:56:22 abyss kernel: ReiserFS: md0: found reiserfs format "3.6"
with standard journal
Jul 15 08:56:26 abyss kernel: ReiserFS: md0: using ordered data mode
Jul 15 08:56:26 abyss kernel: ReiserFS: md0: journal params: device md0,
size 8192, journal first block 18, max trans len 1024, max batch 900, max
commit age 30, max trans age 30
Jul 15 08:56:26 abyss kernel: ReiserFS: md0: checking transaction log (md0)
Jul 15 08:56:26 abyss kernel: ReiserFS: md0: replayed 1 transactions in 0
seconds
Jul 15 08:56:27 abyss kernel: ReiserFS: md0: Using r5 hash to sort names

/dev/md0:
        Version : 01.00.01
  Creation Time : Wed Dec 31 19:00:00 1969
     Raid Level : raid5
     Array Size : 1935556992 (1845.89 GiB 1982.01 GB)
    Device Size : 71687296 (68.37 GiB 73.41 GB)
   Raid Devices : 28
  Total Devices : 27
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Jul 15 16:11:05 2005
          State : clean, degraded
 Active Devices : 27
Working Devices : 27
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-asymmetric
     Chunk Size : 128K

           UUID : 4e2b6b0a8e:92e91c0c:018a4bf0:9bb74d
         Events : 173177

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

It's been running most of the day - with no problems, just in a degraded
state. How do I get /dev/sdaa back into the array?

-- David M. Strang

----- Original Message ----- 
From: David M. Strang
To: Neil Brown
Cc: linux-raid@vger.kernel.org
Sent: Thursday, July 14, 2005 10:16 PM
Subject: Re: Raid5 Failure


Neil -

You are the man; the array went w/o force - and is rebuilding now!

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

    Update Time : Thu Jul 14 22:07:18 2005
          State : active, resyncing
 Active Devices : 28
Working Devices : 28
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-asymmetric
     Chunk Size : 128K

 Rebuild Status : 0% complete

           UUID : 4e2b6b0a8e:92e91c0c:018a4bf0:9bb74d
         Events : 172760

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
      26      65      160       26      active sync   /dev/evms/.nodes/sdaa
      27      65      176       27      active sync   /dev/evms/.nodes/sdab


-- David M. Strang

----- Original Message ----- 
From: Neil Brown
To: David M. Strang
Cc: linux-raid@vger.kernel.org
Sent: Thursday, July 14, 2005 9:43 PM
Subject: Re: Raid5 Failure


On Thursday July 14, dstrang@shellpower.net wrote:
>
> It looks like the first 'segment of discs' sda->sdm are all marked clean;
> while sdn->sdab are marked active.
>
> What can I do to resolve this issue? Any assistance would be greatly
> appreciated.


Apply the following patch to mdadm-2.0-devel2 (it fixes a few bugs and
particularly make --assemble work) then try:

mdadm -A /dev/md0 /dev/sd[a-z] /dev/sd....

Just list all 28 SCSI devices, I'm not sure what their names are.

This will quite probably fail.
If it does, try again with
   --force

NeilBrown



Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./Assemble.c |   13 ++++++++++++-
 ./Query.c    |   33 +++++++++++++++++++--------------
 ./mdadm.h    |    2 +-
 ./super0.c   |    1 +
 ./super1.c   |    4 ++--
 5 files changed, 35 insertions(+), 18 deletions(-)

diff ./Assemble.c~current~ ./Assemble.c
--- ./Assemble.c~current~ 2005-07-15 10:13:04.000000000 +1000
+++ ./Assemble.c 2005-07-15 10:37:59.000000000 +1000
@@ -473,6 +473,7 @@ int Assemble(struct supertype *st, char
  if (!devices[j].uptodate)
  continue;
  info.disk.number = i;
+ info.disk.raid_disk = i;
  info.disk.state = desired_state;

  if (devices[j].uptodate &&
@@ -526,7 +527,17 @@ int Assemble(struct supertype *st, char

  /* Almost ready to actually *do* something */
  if (!old_linux) {
- if (ioctl(mdfd, SET_ARRAY_INFO, NULL) != 0) {
+ int rv;
+ if ((vers % 100) >= 1) { /* can use different versions */
+ mdu_array_info_t inf;
+ memset(&inf, 0, sizeof(inf));
+ inf.major_version = st->ss->major;
+ inf.minor_version = st->minor_version;
+ rv = ioctl(mdfd, SET_ARRAY_INFO, &inf);
+ } else
+ rv = ioctl(mdfd, SET_ARRAY_INFO, NULL);
+
+ if (rv) {
  fprintf(stderr, Name ": SET_ARRAY_INFO failed for %s: %s\n",
  mddev, strerror(errno));
  return 1;

diff ./Query.c~current~ ./Query.c
--- ./Query.c~current~ 2005-07-07 09:19:53.000000000 +1000
+++ ./Query.c 2005-07-15 11:38:18.000000000 +1000
@@ -105,26 +105,31 @@ int Query(char *dev)
  if (superror == 0) {
  /* array might be active... */
  st->ss->getinfo_super(&info, super);
- mddev = get_md_name(info.array.md_minor);
- disc.number = info.disk.number;
- activity = "undetected";
- if (mddev && (fd = open(mddev, O_RDONLY))>=0) {
- if (md_get_version(fd) >= 9000 &&
-     ioctl(fd, GET_ARRAY_INFO, &array)>= 0) {
- if (ioctl(fd, GET_DISK_INFO, &disc) >= 0 &&
-     makedev((unsigned)disc.major,(unsigned)disc.minor) == stb.st_rdev)
- activity = "active";
- else
- activity = "mismatch";
+ if (st->ss->major == 0) {
+ mddev = get_md_name(info.array.md_minor);
+ disc.number = info.disk.number;
+ activity = "undetected";
+ if (mddev && (fd = open(mddev, O_RDONLY))>=0) {
+ if (md_get_version(fd) >= 9000 &&
+     ioctl(fd, GET_ARRAY_INFO, &array)>= 0) {
+ if (ioctl(fd, GET_DISK_INFO, &disc) >= 0 &&
+     makedev((unsigned)disc.major,(unsigned)disc.minor) == stb.st_rdev)
+ activity = "active";
+ else
+ activity = "mismatch";
+ }
+ close(fd);
  }
- close(fd);
+ } else {
+ activity = "unknown";
+ mddev = "array";
  }
- printf("%s: device %d in %d device %s %s md%d.  Use mdadm --examine for
more detail.\n",
+ printf("%s: device %d in %d device %s %s %s.  Use mdadm --examine for more
detail.\n",
         dev,
         info.disk.number, info.array.raid_disks,
         activity,
         map_num(pers, info.array.level),
-        info.array.md_minor);
+        mddev);
  }
  return 0;
 }

diff ./mdadm.h~current~ ./mdadm.h
--- ./mdadm.h~current~ 2005-07-07 09:19:53.000000000 +1000
+++ ./mdadm.h 2005-07-15 10:15:51.000000000 +1000
@@ -73,7 +73,7 @@ struct mdinfo {
  mdu_array_info_t array;
  mdu_disk_info_t disk;
  __u64 events;
- unsigned int uuid[4];
+ int uuid[4];
 };

 #define Name "mdadm"

diff ./super0.c~current~ ./super0.c
--- ./super0.c~current~ 2005-07-07 09:19:53.000000000 +1000
+++ ./super0.c 2005-07-15 11:27:12.000000000 +1000
@@ -205,6 +205,7 @@ static void getinfo_super0(struct mdinfo
  info->disk.major = sb->this_disk.major;
  info->disk.minor = sb->this_disk.minor;
  info->disk.raid_disk = sb->this_disk.raid_disk;
+ info->disk.number = sb->this_disk.number;

  info->events = md_event(sb);


diff ./super1.c~current~ ./super1.c
--- ./super1.c~current~ 2005-07-07 09:19:53.000000000 +1000
+++ ./super1.c 2005-07-15 11:25:04.000000000 +1000
@@ -278,7 +278,7 @@ static void getinfo_super1(struct mdinfo

  info->disk.major = 0;
  info->disk.minor = 0;
-
+ info->disk.number = __le32_to_cpu(sb->dev_number);
  if (__le32_to_cpu(sb->dev_number) >= __le32_to_cpu(sb->max_dev) ||
      __le32_to_cpu(sb->max_dev) > 512)
  role = 0xfffe;
@@ -303,7 +303,7 @@ static void getinfo_super1(struct mdinfo

  for (i=0; i< __le32_to_cpu(sb->max_dev); i++) {
  role = __le16_to_cpu(sb->dev_roles[i]);
- if (role == 0xFFFF || role < info->array.raid_disks)
+ if (/*role == 0xFFFF || */role < info->array.raid_disks)
  working++;
  }

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html 

