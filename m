From: Lucas Barbuto <lucas@qk.com.au>
Subject: Problems mounting root file system with software RAID-1
Date: Tue, 28 Jan 2003 12:30:36 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030128013036.GA22180@qk.com.au>
Reply-To: Lucas Barbuto <lucas@qk.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All,

I'm having trouble mouting my root file system as part of a software
RAID-1.  First my setup.

OS:     Debian Woody with kernel 2.4.20-XFS (all required fs and RAID
        support compiled in, not as modules)

HDDS:   Two 40GB drives connected to a Promise PDC 20276 (recognised by
        the system as two seperate drives hde and hdg), 1 80GB drive
        connected as secondary slave (hdd).

Originally I installed the OS onto hdd, when I boot off it, the system
looks like this:

--
jupter:~# cat /etc/mtab
/dev/hdd2       /                       ext2    rw,errors=remount-ro 0 0
proc            /proc                   proc    rw                   0 0
devpts          /dev/pts                devpts  rw,gid=5,mode=620    0 0
/dev/md2        /mnt/new-root           ext3    rw                   0 0
/dev/md1        /mnt/new-root/boot      ext3    rw                   0 0
/dev/md5        /mnt/new-root/home      xfs     rw                   0 0
/dev/md6        /mnt/new-root/tmp       xfs     rw                   0 0
/dev/md7        /mnt/new-root/usr       xfs     rw                   0 0
/dev/md8        /mnt/new-root/var       xfs     rw                   0 0
--

The software RAID is working, the md devices will sync and mount and I
have created the file systems on them and copied the whole OS over to
the RAID partitions.

I added the following lines to /mnt/new-root/etc/lilo.conf:

--
boot=/dev/md1
raid-extra-boot="/dev/hde, /hdev/hdg"
root=/dev/md2
--

And run the following command:

--
jupiter:~# chroot /mnt/new-root/ /sbin/lilo
Warning: using BIOS device code 0x80 for RAID boot blocks
Added Linux *
Added LinuxOLD
The boot record of /dev/md1 has been updated.
The boot record of /dev/hde has been updated.
The boot record of /dev/hdg has been updated.
--

Which all looks good... but when I reboot, I get this:

--
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
EXT3-fs: unable to read superblock
EXT2-fs: unable to read superblock
iofs_read_super: bread failed, dev=09:01, iso_blknum=16, block=32
XFS: bad magic number
XFS: SB validate failed
Kernel panic: VFS: Unable to mount root fs on 09:01
--

When trying to mount the root file system.

I don't get it.  I can mount the RAID partitions under /mnt no problems,
I can boot off the RAID device /dev/md1, I just can't mount /dev/md2 as
my root file system.  Can anyone shed some light on this for me?  What
do I need to do?  I have experimented with the LiLo setup and found that
the system will boot up as expected with /dev/hde2 (or /dev/hdg2) as the
root file system... why doesn't it like /dev/md2?  Thanks in advance.

Regards,

Lucas
