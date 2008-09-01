From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: Create software RAID from active partition
Date: Mon, 01 Sep 2008 14:14:54 +0100
Message-ID: <48BBEACE.6070407@tuffmail.co.uk>
References: <c8ce53500809010532h5444a8cckcb1d2cb57d3dc281@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c8ce53500809010532h5444a8cckcb1d2cb57d3dc281@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Guyver <michael.guyver@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Guyver wrote:
> Hi there,
>
> I've got a question about creating a RAID-1 array on a remote server -
> ie: if the operation fails, it's going to be very expensive. The
> server has two 200 GB drives and during a hurried re-install of CentOS
> 5.2 the creation of software RAID partitions was omitted. This means
> that the array would include the currently active partition on which
> the kernel is installed. So my first question is as to the feasibility
> of this operation, and its safety: any comments?
>
> The following may give an insight into the current setup should you
> need it to answer my question more accurately.
>
> -------------------------------------------------------------
> # fdisk -l
> Disk /dev/sda: 203.9 GB, 203928109056 bytes
> 255 heads, 63 sectors/track, 24792 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1   *           1          13      104391   83  Linux
> /dev/sda2              14       24773   198884700   8e  Linux LVM
>
> Disk /dev/sdb: 203.9 GB, 203928109056 bytes
> 255 heads, 63 sectors/track, 24792 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1   *           1          13      104391   83  Linux
> /dev/sdb2              14       24773   198884700   8e  Linux LVM
> -------------------------------------------------------------
> # mount
> /dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
> proc on /proc type proc (rw)
> sysfs on /sys type sysfs (rw)
> devpts on /dev/pts type devpts (rw,gid=5,mode=620)
> /dev/sda1 on /boot type ext3 (rw)
> tmpfs on /dev/shm type tmpfs (rw)
> none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
> sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
> -------------------------------------------------------------
> # pvdisplay
>   Found duplicate PV g7ZWtzNQcHx2PMQghP0NBHDXuYcaYqAt: using /dev/sdb2
> not /dev/sda2
>   --- Physical volume ---
>   PV Name               /dev/sdb2
>   VG Name               VolGroup00
>   PV Size               189.67 GB / not usable 15.34 MB
>   Allocatable           yes (but full)
>   PE Size (KByte)       32768
>   Total PE              6069
>   Free PE               0
>   Allocated PE          6069
>   PV UUID               g7ZWtz-NQcH-x2PM-QghP-0NBH-DXuY-caYqAt
> -------------------------------------------------------------
> # lvdisplay
>   Found duplicate PV g7ZWtzNQcHx2PMQghP0NBHDXuYcaYqAt: using /dev/sdb2
> not /dev/sda2
>   --- Logical volume ---
>   LV Name                /dev/VolGroup00/LogVol00
>   VG Name                VolGroup00
>   LV UUID                rvPZJS-6Z7a-kXzk-aLcM-vv13-eRCK-kjg6I1
>   LV Write Access        read/write
>   LV Status              available
>   # open                 1
>   LV Size                187.72 GB
>   Current LE             6007
>   Segments               1
>   Allocation             inherit
>   Read ahead sectors     auto
>   - currently set to     256
>   Block device           253:0
>
>   --- Logical volume ---
>   LV Name                /dev/VolGroup00/LogVol01
>   VG Name                VolGroup00
>   LV UUID                zvxDsa-MZXn-akSA-DlzC-49IX-65Fo-HPBuyJ
>   LV Write Access        read/write
>   LV Status              available
>   # open                 1
>   LV Size                1.94 GB
>   Current LE             62
>   Segments               1
>   Allocation             inherit
>   Read ahead sectors     auto
>   - currently set to     256
>   Block device           253:1
>
> -------------------------------------------------------------
>
> Judging from the "Found duplicate " messages produced by pvdisplay and
> lvdisplay, as well as the mount output, it seems that the root
> partition is being loaded from /dev/sdb2. What /dev/sda2 is doing
> right now is, I guess, completely sweet FA.
>   

Hmm.  It looks like it was set up as some sort of RAID1, hence the
duplicate PVs, but it is no longer using it.

> Can anyone point me to the way of finding out a file's physical
> location on disc so that I can verify this is the case? So, for
> example, I would like to check that my latest edit to ~/somefile.txt
> is in fact on /dev/sdb1 at location xyz and that can be verified by
> using dd to copy those bytes to a file in /tmp.
>
>   

swap_offset program from the uswsusp package?  I'd trust pvdisplay that
you're only using sdb2 though, and not sda2.

> Having started reading the docs related to creating a RAID device, it
> seems likely that the order of the listed devices is significant when
> the array is initialised. However, I haven't yet been able to confirm
> that were I to write
>
> mdadm -C /dev/md0 --level raid1 --raid-disks 2 /dev/sdb1 /dev/sda1
>
> that it would start to copy data from sdb1 to sda1 - or have I
> misunderstood the initialisation process?
>
> These questions may not seem very well framed, but some initial
> guidance while I'm still reading into the problem would be
> appreciated.
>
> Best wishes
>
> Michael
>   
a) For safety, the trick would be to do it in stages.  I've done this
locally to add RAID to my existing desktop.

Create a 1-device RAID1 (you can do this, though you have to force it)
on the *unused* drive.  Copy your data into the RAID device (e.g. using
dd).  Get it to the point where it's bootable on it's own.  Boot into it
and check it works (Use the BIOS boot drive selection.  You do have
remote BIOS access, right?).  Then grow the RAID device by adding the
other disk - overwriting the old contents.

That's one more copy than strictly needed, but it's worth it for peace
of mind.

b) Also, it sounds like you're missing a piece of knowledge.  (Sane)
software RAID requires a RAID superblock at the end of the device for
identification.  That means you can't take a non-RAID disk and turn it
into a RAID disk while leaving the drive unchanged.  You would have to
shrink the LVM physical volume.  With the stepwise approach you may be
able to avoid shrinking in-place - which could be risky.  E.g. shrink
the  boot partition slightly instead before copying.

c) Thinking of the boot partition, you also need to make that RAID1 in
the same way.  Unlike LVM, RAID1 is transparent to GRUB (because GRUB
doesn't write to the filesystem).  But it's recommended you do the
individual partitions separately, and don't try to do whole-disk RAID.

Don't forget you've got /boot on sda1 - that's going to be a confusing
problem whatever you do.



Alan
