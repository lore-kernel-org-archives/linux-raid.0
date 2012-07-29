From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: problem hot-adding spare / internal bitmap problem?
Date: Sun, 29 Jul 2012 06:08:28 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207290601000.27169@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I'm having trouble hot-adding a spare to my raid6, this is on an ubuntu 12.04 
amd64 box:

swmike@ub:~$ uname -a
Linux ub 3.2.0-27-generic #43-Ubuntu SMP Fri Jul 6 14:25:57 UTC 2012 x86_64 
x86_64 x86_64 GNU/Linux
swmike@ub:~$ mdadm -V
mdadm - v3.2.3 - 23rd December 2011

swmike@ub:~$ sudo mdadm --zero-superblock /dev/sdj
swmike@ub:~$ sudo mdadm --verbose --manage /dev/md0 --add /dev/sdj
swmike@ub:~$ sudo mdadm --verbose --manage /dev/md0 --fail /dev/sdj
mdadm: set device faulty failed for /dev/sdj:  No such device
swmike@ub:~$ sudo mdadm --examine /dev/sdj
/dev/sdj:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 7eda4927:254c1b6e:f3c3144a:9f4159d2
           Name : swmike-htpc2:0
  Creation Time : Thu Mar 19 16:32:38 2009
     Raid Level : raid6
   Raid Devices : 9

Avail Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
     Array Size : 27349202048 (13041.12 GiB 14002.79 GB)
    Data Offset : 304 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 755bac53:47bd845d:88c649aa:28a6596b

Internal Bitmap : 2 sectors from superblock
    Update Time : Sat Jul 28 15:22:04 2012
       Checksum : eec07f07 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : spare
   Array State : AAAAAAAAA ('A' == active, '.' == missing)
swmike@ub:~$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10]
md0 : active raid6 sdk[13] sdg[11] sdh[14] sdi[10] sde[12] sdd[9] sdc[2] sdb[6] sdf[7]
      13674601024 blocks super 1.2 level 6, 64k chunk, algorithm 2 [9/9] [UUUUUUUUU]
      bitmap: 0/8 pages [0KB], 131072KB chunk

unused devices: <none>

If I run strace:

sudo strace mdadm --verbose --manage /dev/md0 --add /dev/sdj

the last lines of the output is:

open("/dev/urandom", O_RDONLY)          = 5
read(5, "\257\222w=\340\364\24\365\5+2O\230a\330\324", 16) = 16
close(5)                                = 0
fstat(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 144), ...}) = 0
ioctl(4, BLKGETSIZE64, 0x7fff8c93c760)  = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
lseek(4, 4096, SEEK_SET)                = 4096
ioctl(4, BLKSSZGET, 0x7fff8c93c75c)     = 0
read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 1024) = 1024
fstat(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 144), ...}) = 0
ioctl(4, BLKGETSIZE64, 0x7fff8c93c830)  = 0
fstat(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 144), ...}) = 0
ioctl(4, BLKGETSIZE64, 0x7fff8c93c7f0)  = 0
lseek(4, 4096, SEEK_SET)                = 4096
ioctl(4, BLKSSZGET, 0x7fff8c93c7ec)     = 0
write(4, "\374N+\251\1\0\0\0\1\0\0\0\0\0\0\0~\332I'%L\33n\363\303\24J\237AY\322"..., 1024) = 1024
lseek(4, 5120, SEEK_SET)                = 5120
ioctl(4, BLKSSZGET, 0x7fff8c93c7ec)     = 0
read(4, "bitm\4\0\0\0~\332I'%L\33n\363\303\24J\237AY\322\267\252J\0\0\0\0\0"..., 512) = 512
lseek(4, -512, SEEK_CUR)                = 5120
write(4, "bitm\4\0\0\0~\332I'%L\33n\363\303\24J\237AY\322\267\252J\0\0\0\0\0"..., 512) = 512
lseek(4, -256, SEEK_CUR)                = 5376
fsync(4)                                = 0
lseek(4, 5120, SEEK_SET)                = 5120
ioctl(4, BLKSSZGET, 0x7fff8c93b7ec)     = 0
write(4, "bitm\4\0\0\0~\332I'%L\33n\363\303\24J\237AY\322\267\252J\0\0\0\0\0"..., 2560) = -1 EINVAL (Invalid argument)
fsync(4)                                = 0
close(4)                                = 0
close(4)                                = -1 EBADF (Bad file descriptor)
exit_group(1)                           = ?

Any idea what might be going on? I can create a filesystem directly on the 
drive and write files to it and read it back, so it doesn't seem to be a 
drive error.

In dmesg I only see:

[  390.017751] md: export_rdev(sdj)
[ 3032.233917] md: export_rdev(sdj)
[ 3107.694528] md: export_rdev(sdj)
[ 3120.065697] md: export_rdev(sdj)
[ 3196.654406] md: export_rdev(sdj)
[ 3281.629939] md: export_rdev(sdj)

(one per attempt)

On a hunch I removed the internal bitmap and added the drive, but couldn't 
then enable the internal bitmap again. So the below output is from when I 
disabled the internal bitmap, added the drive (which became a spare), and 
then removed it again.

swmike@ub:~$ sudo mdadm --zero-superblock /dev/sdj
swmike@ub:~$ sudo mdadm --verbose --manage /dev/md0 --add /dev/sdj
mdadm: added /dev/sdj
swmike@ub:~$ sudo mdadm --grow /dev/md0 --bitmap=internal
mdadm: failed to set internal bitmap.
swmike@ub:~$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] 
[raid10]
md0 : active raid6 sdj[15](S) sdk[13] sdg[11] sdh[14] sdi[10] sde[12] sdd[9] 
sdc[2] sdb[6] sdf[7]
       13674601024 blocks super 1.2 level 6, 64k chunk, algorithm 2 [9/9] [UUUUUUUUU]

unused devices: <none>
swmike@ub:~$ sudo mdadm --verbose --manage /dev/md0 --remove /dev/sdj
mdadm: hot removed /dev/sdj from /dev/md0
swmike@ub:~$ sudo mdadm --grow /dev/md0 --bitmap=internal
mdadm: failed to set internal bitmap.

Seems every attempt to enable the bitmap write stuff in dmesg:

[ 5016.315578] md/raid:md0: Disk failure on sdj, disabling device.
[ 5016.315579] md/raid:md0: Operation continuing on 9 devices.
[ 5022.121373] md: unbind<sdj>
[ 5022.148324] md: export_rdev(sdj)
[ 5032.774506] md: bind<sdj>
[ 5037.831802] md0: invalid bitmap file superblock: bad magic
[ 5037.831808] md0: bitmap file superblock:
[ 5037.831811]          magic: 00000000
[ 5037.831814]        version: 0
[ 5037.831816]           uuid: 00000000.00000000.00000000.00000000
[ 5037.831827]         events: 0
[ 5037.831829] events cleared: 0
[ 5037.831831]          state: 00000000
[ 5037.831834]      chunksize: 0 B
[ 5037.831836]   daemon sleep: 0s
[ 5037.831838]      sync size: 0 KB
[ 5037.831840] max write behind: 0
[ 5055.038413] md: unbind<sdj>
[ 5055.117254] md: export_rdev(sdj)
[ 5068.187109] md0: invalid bitmap file superblock: bad magic
[ 5068.187116] md0: bitmap file superblock:
[ 5068.187120]          magic: 00000000
[ 5068.187123]        version: 0
[ 5068.187127]           uuid: 00000000.00000000.00000000.00000000
[ 5068.187131]         events: 0
[ 5068.187134] events cleared: 0
[ 5068.187136]          state: 00000000
[ 5068.187140]      chunksize: 0 B
[ 5068.187143]   daemon sleep: 0s
[ 5068.187145]      sync size: 0 KB
[ 5068.187148] max write behind: 0
[ 5560.762625] md0: invalid bitmap file superblock: bad magic
[ 5560.762632] md0: bitmap file superblock:
[ 5560.762636]          magic: 00000000
[ 5560.762640]        version: 0
[ 5560.762644]           uuid: 00000000.00000000.00000000.00000000
[ 5560.762649]         events: 0
[ 5560.762652] events cleared: 0
[ 5560.762655]          state: 00000000
[ 5560.762658]      chunksize: 0 B
[ 5560.762661]   daemon sleep: 0s
[ 5560.762664]      sync size: 0 KB
[ 5560.762667] max write behind: 0

I can successfully add a bitmap file to the array so that seems to work, 
it seems to be an internal bitmap problem.

Any idea what might be going wrong here?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
