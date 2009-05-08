From: CoolCold <coolthecold@gmail.com>
Subject: Re: Problem with auto-assembling raid1 on system start
Date: Fri, 8 May 2009 22:36:22 +0400
Message-ID: <f19d625d0905081136p6af2249bk16efeaf9a71faadb@mail.gmail.com>
References: <4A043D78.8020104@qumido.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A043D78.8020104@qumido.de>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias Gunkel <tobias.gunkel@qumido.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Does mdadm.conf in initrd image contains valid uuids/array names? (you
can ungzip && extract cpio archive to check this)

On Fri, May 8, 2009 at 6:11 PM, Tobias Gunkel <tobias.gunkel@qumido.de>=
 wrote:
> Hello everyone!
>
> After rebooting one of our Debian servers yesterday (under normal
> conditions), mdadm was not able to assemble /dev/md0 automaticly any =
more.
> System: Debian Lenny, mdmadm v2.5.6, Kernel 2.6.26-preemptive-cpuset =
(from
> Debian testing sources)
>
> This is what I get during boot:
>
> =A0[...]
> =A0Begin: Mounting root file system... ...
> =A0Begin: Running /scripts/local-top ...
> =A0Begin: Loading MD modules ...
> =A0md: raid1 personality registered for level 1
> =A0Success: loaded module raid1.
> =A0Done.
> =A0Begin: Assembling all MD arrays ...
> =A0[...]
> =A0md: md0 stopped.
> =A0mdadm: no devices found for /dev/md0
> =A0Failure: failed to assemble all arrays.
> =A0[...]
>
> Then the system falls back to BusyBox shell from initramfs, because t=
he root
> fs =A0- which is located on /dev/md0 - could not be mounted.
> But from the initramfs shell, it is possible to cleanly assemble and =
mount
> the md0 array:
>
> =A0(initramfs) mdadm -A /dev/md0 /dev/sda2 /dev/sdb2
> =A0md: md0 stopped.
> =A0md: bind<sdb2>
> =A0md: bind<sda2>
> =A0raid1: raid set md0 active with 2 out of 2 mirrors
> =A0mdadm: /dev/md0 has been started with 2 drives.
>
> =A0(initramfs) mount /dev/md0 root
> =A0kjournald starting. Commit interval 5 seconds
> =A0EXT3 FS on md0, internal journal
> =A0EXT3-fs: mounted filesystem with ordered data mode.
>
> After leaving the initramfs shell with 'exit', the system continues t=
o boot
> normally.
>
> Strange: /dev/md1 (swap) which is the first array in assembling order=
, gets
> assembled and started correctly.
> I also played around with ROOTDELAY=3D60, but this did not changed an=
ything.
>
> I'm grateful for any help.
> Best regards, Tobias
>
>
> PS: Maybe some helpful output (after starting the system the way desc=
ribed
> above):
>
> $ cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sda2[0] sdb2[1]
> =A0 =A0 487331648 blocks [2/2] [UU]
>
> md1 : active raid1 sda1[0] sdb1[1]
> =A0 =A0 1052160 blocks [2/2] [UU]
>
> unused devices: <none>
>
>
> $ mdadm --detail --scan
> ARRAY /dev/md1 level=3Draid1 num-devices=3D2
> UUID=3Dc3838888:50dbed72:15a9bffb:d0e83d23
> ARRAY /dev/md0 level=3Draid1 num-devices=3D2
> UUID=3D0d0a0c79:70adae03:f802952b:2b58c14d
>
>
> $ grep -v ^# /etc/mdadm/mdadm.conf
>
> DEVICE /dev/sd*[0-9] /dev/sd*[0-9]
>
> CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
>
> HOMEHOST <system>
>
> MAILADDR root
>
> ARRAY /dev/md1 level=3Draid1 num-devices=3D2
> UUID=3Dc3838888:50dbed72:15a9bffb:d0e83d23
> ARRAY /dev/md0 level=3Draid1 num-devices=3D2
> UUID=3D0d0a0c79:70adae03:f802952b:2b58c14d
>
>
> $ mdadm --detail /dev/md0
> /dev/md0:
> =A0 =A0 =A0 Version : 00.90.03
> =A0Creation Time : Thu Dec 11 14:18:44 2008
> =A0 =A0Raid Level : raid1
> =A0 =A0Array Size : 487331648 (464.76 GiB 499.03 GB)
> =A0 Device Size : 487331648 (464.76 GiB 499.03 GB)
> =A0Raid Devices : 2
> =A0Total Devices : 2
> Preferred Minor : 0
> =A0 Persistence : Superblock is persistent
>
> =A0 Update Time : Fri May =A08 15:45:32 2009
> =A0 =A0 =A0 =A0 State : clean
> Active Devices : 2
> Working Devices : 2
> Failed Devices : 0
> =A0Spare Devices : 0
>
> =A0 =A0 =A0 =A0 =A0UUID : 0d0a0c79:70adae03:f802952b:2b58c14d
> =A0 =A0 =A0 =A0Events : 0.900
>
> =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
> =A0 =A0 =A00 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0 =
=A0active sync =A0 /dev/sda2
> =A0 =A0 =A01 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
