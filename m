From: Nikolay Kichukov <hijacker@oldum.net>
Subject: Re: add another disk to existing raid 0, ie grow raid 0 possible?
Date: Thu, 26 Jan 2012 13:30:53 +0200
Message-ID: <4F21396D.7030308@oldum.net>
References: <4F212A59.1070008@oldum.net>	<CADNH=7GXJ0DW7K5DqSgoYYsa2eSWzE9P46R=Qrehu1pFXqnpyQ@mail.gmail.com> <20120126215713.0c24db62@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120126215713.0c24db62@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello Neil,

Here goes the details. Once again, no valuable data, just curious what =
has gone wrong in that case:

dmesg output, first I stopped md2, then assembled it again to perform t=
he grow.
http://pastebin.com/HkPVEKad

mdadm -E output:
http://pastebin.com/pJCjvrJE

The system runs GNU/Debian testing with latest updates from security-te=
sting applied.
Kernel: 3.1.0-1-amd64
mdadm:  3.2.2-1

Let me know should you need any further information.

Cheers,
- -Nik

On 01/26/2012 12:57 PM, NeilBrown wrote:
> On Thu, 26 Jan 2012 10:47:14 +0000 Mathias Bur=C3=A9n <mathias.buren@=
gmail.com>
> wrote:
>=20
>> On 26 January 2012 10:26, Nikolay Kichukov <hijacker@oldum.net> wrot=
e:
> Hi all,
>=20
> I tried to expand md block device raid level 0 ( /dev/md2 ) by adding=
 another partition to it.
>=20
> Here are the steps:
>=20
> mdadm --assemble /dev/md2
> mdadm: /dev/md2 has been started with 2 drives.
> hanna64:~# mdadm --grow /dev/md2 --raid-devices=3D3 --add /dev/sdc2
> mdadm: level of /dev/md2 changed to raid4
> mdadm: added /dev/sdc2
> mdadm: Need to backup 3072K of critical section..
>=20
>=20
> Now fdisk -l cannot complete, just goes to D state.
>=20
> Disks layout before the grow attempt:
>=20
> ARRAY /dev/md2 metadata=3D1.2 name=3Dhanna64:2 UUID=3D4840f7f0:71b5f4=
a0:c4d8a42c:0b43b5fb
>=20
> /dev/sda2: UUID=3D"4840f7f0-71b5-f4a0-c4d8-a42c0b43b5fb" TYPE=3D"linu=
x_raid_member" LABEL=3D"hanna64:2"
> UUID_SUB=3D"cf97412f-269a-f3e8-fde2-8ca3bf42a349"
> /dev/sdb2: UUID=3D"4840f7f0-71b5-f4a0-c4d8-a42c0b43b5fb" TYPE=3D"linu=
x_raid_member" LABEL=3D"hanna64:2"
> UUID_SUB=3D"9aee2d4c-6deb-911a-d790-cbd12f6c671c"
>=20
> md2 : active raid0 sda2[0] sdb2[1]
>      15628288 blocks super 1.2 512k chunks
>=20
>=20
> Disk /dev/md2: 16.0 GB, 16003366912 bytes
> 2 heads, 4 sectors/track, 3907072 cylinders, total 31256576 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 524288 bytes / 1048576 bytes
> Disk identifier: 0x7b88c100
>=20
> Disk /dev/md2 doesn't contain a valid partition table
>=20
>=20
> This array was used as swap, so no valuable information is stored the=
re anyways. Let me know what has gone wrong and
> what I typed wrong assuming the grow command will just add /dev/sdc2 =
to the existing array and make it larger with the
> size of /dev/sdc2.
>=20
> Thank you,
> -Nikolay Kichukov
>=20
- --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>> AFAIK growing raid0 is not possible.

> Seems an odd thing to say, given that when OP demonstrated that mdadm
> didn't complain, but went as far as converting the array to RAID4 so =
it could
> perform a reshape.....

> It wasn't possible once, but times change.

> To know what went wrong I would need lots more details.
> Start with the output of 'dmesg' - or equivalent from logs
> (e.g. /var/log/kern.log or /var/log/messages).

> Then "mdadm -E" output of each device in the array.

> NeilBrown
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPITltAAoJEDFLYVOGGjgXfQ0IAIEDBtmBNZHirPSc2UBsQi6a
LK3NQf0R7afVFyRqbcb6sizGy9i89vTUwfXKeq/lite2wafrxJUyjmql/9TBv5by
aaYS7Z9aq0qU2fE6JW2RF1Owi/jLABQn3RJc+9oI+NJL9OYK/lkeyWaNhF7t96FY
itb7TCL38vc0JIlNNUom1IqCUna6kNo4Bunz6FepyXQEjzHhgXwFynrbdTicO4rN
LK/bPt47QEU/GkRigALjZBgpVoMFdVPgxc+jphRiOH+gmqSOI/Co3jeCbwvDBzk6
ZVzTyehWZgPKfYqNCpiDfWEJyArqx0/maXpnu4lMT4Qnkp7mnVdTSQ7uE+wJafY=3D
=3DrqI+
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
