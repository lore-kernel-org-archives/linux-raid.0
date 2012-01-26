From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: add another disk to existing raid 0, ie grow raid 0 possible?
Date: Thu, 26 Jan 2012 10:47:14 +0000
Message-ID: <CADNH=7GXJ0DW7K5DqSgoYYsa2eSWzE9P46R=Qrehu1pFXqnpyQ@mail.gmail.com>
References: <4F212A59.1070008@oldum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F212A59.1070008@oldum.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nikolay Kichukov <hijacker@oldum.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26 January 2012 10:26, Nikolay Kichukov <hijacker@oldum.net> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi all,
>
> I tried to expand md block device raid level 0 ( /dev/md2 ) by adding=
 another partition to it.
>
> Here are the steps:
>
> mdadm --assemble /dev/md2
> mdadm: /dev/md2 has been started with 2 drives.
> hanna64:~# mdadm --grow /dev/md2 --raid-devices=3D3 --add /dev/sdc2
> mdadm: level of /dev/md2 changed to raid4
> mdadm: added /dev/sdc2
> mdadm: Need to backup 3072K of critical section..
>
>
> Now fdisk -l cannot complete, just goes to D state.
>
> Disks layout before the grow attempt:
>
> ARRAY /dev/md2 metadata=3D1.2 name=3Dhanna64:2 UUID=3D4840f7f0:71b5f4=
a0:c4d8a42c:0b43b5fb
>
> /dev/sda2: UUID=3D"4840f7f0-71b5-f4a0-c4d8-a42c0b43b5fb" TYPE=3D"linu=
x_raid_member" LABEL=3D"hanna64:2"
> UUID_SUB=3D"cf97412f-269a-f3e8-fde2-8ca3bf42a349"
> /dev/sdb2: UUID=3D"4840f7f0-71b5-f4a0-c4d8-a42c0b43b5fb" TYPE=3D"linu=
x_raid_member" LABEL=3D"hanna64:2"
> UUID_SUB=3D"9aee2d4c-6deb-911a-d790-cbd12f6c671c"
>
> md2 : active raid0 sda2[0] sdb2[1]
> =C2=A0 =C2=A0 =C2=A015628288 blocks super 1.2 512k chunks
>
>
> Disk /dev/md2: 16.0 GB, 16003366912 bytes
> 2 heads, 4 sectors/track, 3907072 cylinders, total 31256576 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 524288 bytes / 1048576 bytes
> Disk identifier: 0x7b88c100
>
> Disk /dev/md2 doesn't contain a valid partition table
>
>
> This array was used as swap, so no valuable information is stored the=
re anyways. Let me know what has gone wrong and
> what I typed wrong assuming the grow command will just add /dev/sdc2 =
to the existing array and make it larger with the
> size of /dev/sdc2.
>
> Thank you,
> - -Nikolay Kichukov
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.11 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
>
> iQEcBAEBAgAGBQJPISpZAAoJEDFLYVOGGjgXS4IIAIDdhB1lInCO9jpb9eQRyj8x
> QQYl7B+t0pud/mBuML5T2eTou/qtLhp4Mdv0ZoiwJ7NIuouXuR1wOAbe7/LDkKwB
> ku1iLjLpnqLtQZnctYV598cjH3q2mzb8zi7bOoD3FTGRN/DmyNik0WflsLA04TBc
> 0ohR4KoQIA/j95CvhNrMhZ2tyUis8VmhN+aBzdCnm90gNE8fLJKpUsB1hKahocit
> wSUg9ab/C2wDHTBp5mq1AJModgClCKMCUgf7Z4A1f2zP6NPy1xmoP88emGLUSo/b
> NEMwNTqKjzKcxo67kl0xUGnp8kxVfCLGfjDQHUUFwMT1F9g/PWkgBD0CXmfBSbk=3D
> =3Dg/v/
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml


AFAIK growing raid0 is not possible.

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
