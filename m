From: Norman Schmidt <norman.schmidt@ratnet.stw.uni-erlangen.de>
Subject: Re: Problems mounting root file system with software RAID-1
Date: Tue, 28 Jan 2003 09:12:11 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E363B5B.5000105@ratnet.stw.uni-erlangen.de>
References: <20030128013036.GA22180@qk.com.au>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Lucas Barbuto <lucas@qk.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Lucas!

Lucas Barbuto schrieb:

> NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
> EXT3-fs: unable to read superblock
> EXT2-fs: unable to read superblock
> iofs_read_super: bread failed, dev=3D09:01, iso_blknum=3D16, block=3D=
32
> XFS: bad magic number
> XFS: SB validate failed
> Kernel panic: VFS: Unable to mount root fs on 09:01
> --
>=20
> When trying to mount the root file system.
>=20
> I don't get it.  I can mount the RAID partitions under /mnt no proble=
ms,
> I can boot off the RAID device /dev/md1, I just can't mount /dev/md2 =
as
> my root file system.  Can anyone shed some light on this for me?  Wha=
t
> do I need to do?  I have experimented with the LiLo setup and found t=
hat
> the system will boot up as expected with /dev/hde2 (or /dev/hdg2) as =
the
> root file system... why doesn't it like /dev/md2?  Thanks in advance.

I think your problem is the following:

The kernel booting from a /boot md device doesn=B4t really boot off=20
/dev/md1 but off one of the bootblocks of /dev/hde and /dev/hdg (which=20
is perfectly good). The kernel doesn=B4t need /dev/md1 (=3D/boot) to bo=
ot,=20
but only one of the bootblocks to find the kernel image, which is=20
possible on both hde and hdg. The kernel panic occurs as soon as the=20
kernel wants to mount the / filesystem the first time. The reason for=20
this is that at that point, the raid devices (i.e. at least /dev/md2,=20
the others can be assembled later) are not assembled yet.

You have two options: The older one is to make the underlying partition=
s=20
of /dev/md1 (you didn=B4t give their name) autodetectable (change=20
partition type to fd).
The newer option is to tell the kernel at boot time how to assemble the=
=20
needed devices, which you do by inserting the following into the "image=
"=20
section of your booting kernel in /etc/lilo.conf:
append =3D "md=3D2,/dev/hde3,/dev/hdg3"
Change the partitions to those that build up /dev/md2.
The kernel then can assemble its raid, since you compiled at least raid=
1=20
into it. You migth be able to use raid in a module at boot time if you=20
load the module through an initial ramdisk (initrd), something Debian=20
usually does not, but SuSE seems to (if yet very badly documented).

By the way: The most importatnt thing missing in your mail is=20
/etc/raidtab or /etc/mdadm/mdadm.conf.

HTH, Norman Schmidt.
--=20
--

Norman Schmidt          Institut f=FCr Physikal. u. Theoret. Chemie
cand. chem.             Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
