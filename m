From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Sat, 8 Jan 2005 20:01:09 +0100
Message-ID: <200501082001.09317.maarten@ultratux.net>
References: <crmt7e$8d6$1@sea.gmane.org> <20050108145228.GB26475@janus> <200501081749.32816.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501081749.32816.maarten@ultratux.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 08 January 2005 17:49, maarten wrote:
> On Saturday 08 January 2005 15:52, Frank van Maarseveen wrote:
> > On Fri, Jan 07, 2005 at 04:57:35PM -0500, Guy wrote:
> > > His plan is to split the disks into 6 partitions.
> > > Each of his six RAID5 arrays will only use 1 partition of each physical
> > > disk.
> > > If he were to lose a disk, all 6 RAID5 arrays would only see 1 failed
> > > disk. If he gets 2 read errors, on different disks, at the same time,
> > > he has a 1/6 chance they would be in the same array (which would be
> > > bad). His plan is to combine the 6 arrays with LVM or a linear array.
> >
> > Intriguing setup. Do you think this actually improves the reliability
> > with respect to disk failure compared to creating just one large RAID5
> > array?

As the system is now online again, busy copying, I can show the exact config:

dozer:~ # fdisk -l /dev/hde

Disk /dev/hde: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hde1             1       268   2152678+  fd  Linux raid autodetect
/dev/hde2           269       331    506047+  fd  Linux raid autodetect
/dev/hde3           332       575   1959930   fd  Linux raid autodetect
/dev/hde4           576     30401 239577345    5  Extended
/dev/hde5           576      5439  39070048+  fd  Linux raid autodetect
/dev/hde6          5440     10303  39070048+  fd  Linux raid autodetect
/dev/hde7         10304     15167  39070048+  fd  Linux raid autodetect
/dev/hde8         15168     20031  39070048+  fd  Linux raid autodetect
/dev/hde9         20032     24895  39070048+  fd  Linux raid autodetect
/dev/hde10        24896     29759  39070048+  fd  Linux raid autodetect
/dev/hde11        29760     30401   5156833+  83  Linux

dozer:~ # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [multipath]
read_ahead 1024 sectors
md1 : active raid1 hdg2[1] hde2[0]
      505920 blocks [2/2] [UU]

md0 : active raid1 hdg1[1] hde1[0]
      2152576 blocks [4/2] [UU__]

md2 : active raid1 sdb2[0] sda2[1]
      505920 blocks [2/2] [UU]

md3 : active raid5 sdb5[2] sda5[3] hdg5[1] hde5[0]
      117209856 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md4 : active raid5 sdb6[2] sda6[3] hdg6[1] hde6[0]
      117209856 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md5 : active raid5 sdb7[2] sda7[3] hdg7[1] hde7[0]
      117209856 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md6 : active raid5 sdb8[2] sda8[3] hdg8[1] hde8[0]
      117209856 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md7 : active raid5 sdb9[2] sda9[3] hdg9[1] hde9[0]
      117209856 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md8 : active raid5 sdb10[2] sda10[3] hdg10[1] hde10[0]
      117209856 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

# Where md0 is "/" (temporary degraded), and md1 and md2 are swap.  
# The md3 through md8 are the big arrays that are part of LVM.

dozer:~ # pvscan
pvscan -- reading all physical volumes (this may take a while...)
pvscan -- ACTIVE   PV "/dev/md3" of VG "lvm_video" [111.72 GB / 0 free]
pvscan -- ACTIVE   PV "/dev/md4" of VG "lvm_video" [111.72 GB / 0 free]
pvscan -- ACTIVE   PV "/dev/md5" of VG "lvm_video" [111.72 GB / 0 free]
pvscan -- ACTIVE   PV "/dev/md6" of VG "lvm_video" [111.72 GB / 0 free]
pvscan -- ACTIVE   PV "/dev/md7" of VG "lvm_video" [111.72 GB / 0 free]
pvscan -- ACTIVE   PV "/dev/md8" of VG "lvm_video" [111.72 GB / 0 free]
pvscan -- total: 6 [670.68 GB] / in use: 6 [670.68 GB] / in no VG: 0 [0]

dozer:~ # vgdisplay
--- Volume group ---
VG Name               lvm_video
VG Access             read/write
VG Status             available/resizable
VG #                  0
MAX LV                256
Cur LV                1
Open LV               1
MAX LV Size           2 TB
Max PV                256
Cur PV                6
Act PV                6
VG Size               670.31 GB
PE Size               32 MB
Total PE              21450
Alloc PE / Size       21450 / 670.31 GB
Free  PE / Size       0 / 0
VG UUID               F0EF61-uu4P-cnCq-6oQ6-CO5n-NE9g-5xjdTE

dozer:~ # df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md0               1953344   1877604     75740  97% /
/dev/lvm_video/mythtv
                     702742528  42549352 660193176   7% /mnt/store

# As of yet there are no spares.  This is a todo, the most important thing is 
to get the app back in working state now.  I'll probably make a /usr md 
device in future from hdX3, as "/" is completely full. This was because of 
legacy constraints, migrating drives...

Maarten

