From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?=
	<phcoder@gmail.com>
Subject: Re: Bug#597563: grub-common: grub-probe segfaults scanning lvm devices
Date: Sun, 09 Jan 2011 00:34:36 +0100
Message-ID: <4D28F48C.1030806@gmail.com>
References: <20100920202854.27101.8288.reportbug@cheetah.fastcat.org> <4D274FF9.8010004@gmail.com> <alpine.DEB.2.00.1101072241560.25170@cheetah.fastcat.org> <4D285B79.9040100@gmail.com> <alpine.DEB.2.00.1101081739500.14736@cheetah.fastcat.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig4BB0777A03C9D191B18B8D12"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1101081739500.14736@cheetah.fastcat.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matthew Gabeler-Lee <cheetah@cheetah.fastcat.org>
Cc: 597563@bugs.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4BB0777A03C9D191B18B8D12
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/08/2011 11:53 PM, Matthew Gabeler-Lee wrote:
> On Sat, 8 Jan 2011, Vladimir '=CF=86-coder/phcoder' Serbinenko wrote:
>
>> As was recommended I forward the remaining part to linux-raid mailing
>> list.
>> In short: on his system mdraid, raid5, 4 devices, metadata (presumably=
)
>> 0.90, two devices have index 0.
>> If such situation is valid please advice me on how such situation shou=
ld
>> be handled.
>> @Matthew: could you supply mdadm -Q outputput and *last* 64K of every
>> disk?
>
Sorry, I've noticed that I've looked into the wrong place all the long.
md2 is fine. I suppose it's a problem with md0 (all mdraid are assembled
at the beginning). Since md0 is raid1, its misassembly wouldn't have any
influence (we don't write to devices). mdstat lists both md0 and md1 as
having no duplicate indices. I would need info on md0 for this (now
minor) remaining bug.
> $ sudo mdadm -QD /dev/md2
> /dev/md2:
>         Version : 0.90
>   Creation Time : Mon Mar 27 14:04:18 2006
>      Raid Level : raid5
>      Array Size : 2185667136 (2084.41 GiB 2238.12 GB)
>   Used Dev Size : 728555712 (694.80 GiB 746.04 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 2
>     Persistence : Superblock is persistent
>
>     Update Time : Sat Jan  8 17:40:20 2011
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>            UUID : 01e2f978:88d1f867:34e1e46c:f3c01470
>          Events : 0.32040050
>
>     Number   Major   Minor   RaidDevice State
>        0       8       35        0      active sync   /dev/sdc3
>        1       8       19        1      active sync   /dev/sdb3
>        2       8        3        2      active sync   /dev/sda3
>        3       8       51        3      active sync   /dev/sdd3
>
> The actual last 64k of all the partitions in the array is all zeros.
> So is the 64k up to the end of the "Used Dev Size".  What has some
> data in it is the 64k after that.  I hope that has the superblock data
> I presume you're looking for.  I.e.  dd if=3D/dev/sdX3 bs=3D1024
> skip=3D728555712 count=3D64.
>


--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko



--------------enig4BB0777A03C9D191B18B8D12
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk0o9IwACgkQNak7dOguQgnH5wEAmJY4L9OSFOL6A93ufvZHK6B7
iV6lo8smLTvwuOrfnXsA/jq+wIyet9K6r/0ZKzrVnJjEKC7KceEFsTeIRmqlcfYO
=lcJ7
-----END PGP SIGNATURE-----

--------------enig4BB0777A03C9D191B18B8D12--
