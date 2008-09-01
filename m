From: "Michael Guyver" <michael.guyver@gmail.com>
Subject: Create software RAID from active partition
Date: Mon, 1 Sep 2008 13:32:20 +0100
Message-ID: <c8ce53500809010532h5444a8cckcb1d2cb57d3dc281@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,

I've got a question about creating a RAID-1 array on a remote server -
ie: if the operation fails, it's going to be very expensive. The
server has two 200 GB drives and during a hurried re-install of CentOS
5.2 the creation of software RAID partitions was omitted. This means
that the array would include the currently active partition on which
the kernel is installed. So my first question is as to the feasibility
of this operation, and its safety: any comments?

The following may give an insight into the current setup should you
need it to answer my question more accurately.

-------------------------------------------------------------
# fdisk -l
Disk /dev/sda: 203.9 GB, 203928109056 bytes
255 heads, 63 sectors/track, 24792 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          13      104391   83  Linux
/dev/sda2              14       24773   198884700   8e  Linux LVM

Disk /dev/sdb: 203.9 GB, 203928109056 bytes
255 heads, 63 sectors/track, 24792 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1          13      104391   83  Linux
/dev/sdb2              14       24773   198884700   8e  Linux LVM
-------------------------------------------------------------
# mount
/dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/sda1 on /boot type ext3 (rw)
tmpfs on /dev/shm type tmpfs (rw)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
-------------------------------------------------------------
# pvdisplay
  Found duplicate PV g7ZWtzNQcHx2PMQghP0NBHDXuYcaYqAt: using /dev/sdb2
not /dev/sda2
  --- Physical volume ---
  PV Name               /dev/sdb2
  VG Name               VolGroup00
  PV Size               189.67 GB / not usable 15.34 MB
  Allocatable           yes (but full)
  PE Size (KByte)       32768
  Total PE              6069
  Free PE               0
  Allocated PE          6069
  PV UUID               g7ZWtz-NQcH-x2PM-QghP-0NBH-DXuY-caYqAt
-------------------------------------------------------------
# lvdisplay
  Found duplicate PV g7ZWtzNQcHx2PMQghP0NBHDXuYcaYqAt: using /dev/sdb2
not /dev/sda2
  --- Logical volume ---
  LV Name                /dev/VolGroup00/LogVol00
  VG Name                VolGroup00
  LV UUID                rvPZJS-6Z7a-kXzk-aLcM-vv13-eRCK-kjg6I1
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                187.72 GB
  Current LE             6007
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

  --- Logical volume ---
  LV Name                /dev/VolGroup00/LogVol01
  VG Name                VolGroup00
  LV UUID                zvxDsa-MZXn-akSA-DlzC-49IX-65Fo-HPBuyJ
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                1.94 GB
  Current LE             62
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1

-------------------------------------------------------------

Judging from the "Found duplicate " messages produced by pvdisplay and
lvdisplay, as well as the mount output, it seems that the root
partition is being loaded from /dev/sdb2. What /dev/sda2 is doing
right now is, I guess, completely sweet FA.

Can anyone point me to the way of finding out a file's physical
location on disc so that I can verify this is the case? So, for
example, I would like to check that my latest edit to ~/somefile.txt
is in fact on /dev/sdb1 at location xyz and that can be verified by
using dd to copy those bytes to a file in /tmp.

Having started reading the docs related to creating a RAID device, it
seems likely that the order of the listed devices is significant when
the array is initialised. However, I haven't yet been able to confirm
that were I to write

mdadm -C /dev/md0 --level raid1 --raid-disks 2 /dev/sdb1 /dev/sda1

that it would start to copy data from sdb1 to sda1 - or have I
misunderstood the initialisation process?

These questions may not seem very well framed, but some initial
guidance while I'm still reading into the problem would be
appreciated.

Best wishes

Michael
