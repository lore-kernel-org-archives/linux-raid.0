From: Norman Schmidt <norman.schmidt@ratnet.stw.uni-erlangen.de>
Subject: Re: ADD_NEW_DISK failed
Date: Sun, 23 Feb 2003 16:41:21 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E58EBA1.7010305@ratnet.stw.uni-erlangen.de>
References: <5.1.0.14.0.20030223085025.00b08b30@psimail.spindrift.on.ca>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Victor Geller <vgeller@spindrift.on.ca>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Victor!

Victor Geller schrieb:
> Hi,
>=20
> I have the following problem:
>=20
> [root@wti7 vic]# mdadm -Cv /dev/md0 -l1 -n2 /dev/hda1 /dev/hdc1
> mdadm: chunk size defaults to 64K
> mdadm: /dev/hda1 appears to contain an ext2fs file system
>     size=3D5630748K  mtime=3DSun Feb 23 08:52:48 2003
> mdadm: /dev/hdc1 appears to contain an ext2fs file system
>     size=3D5630748K  mtime=3DSun Feb 23 08:52:54 2003
> mdadm: size set to 5630656K
> Continue creating array? y
> mdadm: ADD_NEW_DISK for /dev/hda1 failed: Invalid argument
>=20
> [root@wti7 vic]# mount
> /dev/hda1 on / type ext3 (rw)
> /dev/hdc1 on /mnt/raid1_1 type ext3 (rw)
>=20
> I would appreciate your help
>=20
> Victor Geller , vgeller@spindrift.on.ca

That is easy:

You MUST unmount /dev/hda1 and /dev/hdc1 before using them as part of a=
=20
md device! Later, you will NEVER mount one of both but ONLY /dev/md0 on=
 /.
But this will not work with your current configuration, since you=20
actually cannot unmount the root fs while it is running.
Ask Neil or whoever how to use the failed disk way for circumventing th=
e=20
need to copy your rootfs twice to another place (forth and back) or=20
newly install the system (I am preparing a modified Debian Woody=20
bootable CD just for that).

By the way: This failed-disk approach is not so well documented for=20
mdadm, or did I overlook something? Any documentation anywhere?

Hth, Norman.

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
