From: "Dambacher, Ulf" <Ulf.Dambacher@mach.uni-karlsruhe.de>
Subject: AW: Problems mounting root file system with software RAID-1
Date: Tue, 28 Jan 2003 08:15:31 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6F5F11DC834C7F47958471A2B71DEB9F2E9894@wbke2k.wbk.uni-karlsruhe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Lucas Barbuto <lucas@qk.com.au>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Lucas

your boot configuration seems ok for me.
So your root fs does not want to mount at boot time...
It seems like it can't find a proper superblock on the device /dev/md1 =
and tries
all filesystems it has availiable.

first, is the promise driver compiled in?
- not in /proc/modules?
- gives message at boot time about partititions and drives?

second, do you use raid autostart on md1?=20
- partitition id is set to hex(fd)?
- autostart support compiled in?
- kernel searches for autostart devices at boot time?
- kernel finds any autostart devices?

if all this is ok, please send the complete bootup messages (dmesg) for=
 more
information

bye
	Ulf

-----Urspr=FCngliche Nachricht-----
Von: Lucas Barbuto [mailto:lucas@qk.com.au]
Gesendet: Dienstag, 28. Januar 2003 02:31
An: Linux RAID Mailing List
Betreff: Problems mounting root file system with software RAID-1


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
/dev/hdd2       /                       ext2    rw,errors=3Dremount-ro =
0 0
proc            /proc                   proc    rw                   0 =
0
devpts          /dev/pts                devpts  rw,gid=3D5,mode=3D620  =
  0 0
/dev/md2        /mnt/new-root           ext3    rw                   0 =
0
/dev/md1        /mnt/new-root/boot      ext3    rw                   0 =
0
/dev/md5        /mnt/new-root/home      xfs     rw                   0 =
0
/dev/md6        /mnt/new-root/tmp       xfs     rw                   0 =
0
/dev/md7        /mnt/new-root/usr       xfs     rw                   0 =
0
/dev/md8        /mnt/new-root/var       xfs     rw                   0 =
0
--

The software RAID is working, the md devices will sync and mount and I
have created the file systems on them and copied the whole OS over to
the RAID partitions.

I added the following lines to /mnt/new-root/etc/lilo.conf:

--
boot=3D/dev/md1
raid-extra-boot=3D"/dev/hde, /hdev/hdg"
root=3D/dev/md2
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
iofs_read_super: bread failed, dev=3D09:01, iso_blknum=3D16, block=3D32
XFS: bad magic number
XFS: SB validate failed
Kernel panic: VFS: Unable to mount root fs on 09:01
--

When trying to mount the root file system.

I don't get it.  I can mount the RAID partitions under /mnt no problems=
,
I can boot off the RAID device /dev/md1, I just can't mount /dev/md2 as
my root file system.  Can anyone shed some light on this for me?  What
do I need to do?  I have experimented with the LiLo setup and found tha=
t
the system will boot up as expected with /dev/hde2 (or /dev/hdg2) as th=
e
root file system... why doesn't it like /dev/md2?  Thanks in advance.

Regards,

Lucas
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
