From: NeilBrown <neilb@suse.de>
Subject: Re: Recalculating the --size parameter when recovering a failed
 array
Date: Sun, 17 Jun 2012 18:03:41 +1000
Message-ID: <20120617180341.39e2d384@notabene.brown>
References: <F4D18266-EDAB-4D31-B3F1-A91894C7E455@ibink.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sFZt5VteI66K4bQajVBd1IL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F4D18266-EDAB-4D31-B3F1-A91894C7E455@ibink.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Nufire <linux-raid_tim@ibink.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/sFZt5VteI66K4bQajVBd1IL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 16 Jun 2012 06:09:47 -0700 Tim Nufire <linux-raid_tim@ibink.com>
wrote:

> Hello,
>=20
> An array that I created using a custom --size parameter has failed and ne=
eds to be recovered. I am very comfortable recovering arrays using --assume=
-clean but due to a typo at creation time I don't know the device size that=
 was originally used. I am hoping this value can be recalculate from data i=
n the superblocks but this calculation is not obvious to me.=20
>=20
> Here's what I know... I'm using metadata version 1.0 with an internal bit=
map on all my arrays. I ran some experiments in the lab with 3TB drives and=
 found that when I specified a device size of 2929687500 when creating an a=
rray, 'mdadm -D' reported a 'Used Dev Size' of 5859374976. The value specif=
ied on the command line is in kilobytes so I was expecting 3,000,000,000,00=
0 bytes to be used on each device. The value reported by mdadm is in sector=
s (512 bytes) so turning this into bytes I get 2,999,999,987,712 bytes. Thi=
s is off by 12,288 bytes (12kb) which I assume is used by the v1.0 superblo=
ck and/or the internal bitmap. I also tried creating an array with 2TB driv=
es (Requested Size: 1953125000, Used Dev Size: 3906249984) and got a differ=
ence of 8kb (2,000,000,000,000 vs 1,999,999,991,808 bytes) so clearly the a=
mount of extra space used depends on the size of the device in some way.
>=20
> The array that I'm trying to recover reports a 'Used Dev Size' of 5858574=
976. This is just 800,000 sectors less than I got when requesting an even 3=
 trillion bytes so I know the size to use on the command line is close to 2=
929687500. But I don't know how to calculate the exact size... Can someone =
help me?=20

The "Used Dev Size" of the array should be exactly the same as the value you
give to create with --size (metadata and bitmap are extra and not included =
in
these counts) *provided* that the number you give is a multiple of the chunk
size.  If it isn't the number is rounded down to a multiple of the chunk si=
ze.

So if you specify "-c 64 -z 2929287488", you should get the correct sized
array.

NeilBrown


>=20
> Once I know the size I will recreate the array using the following:
>=20
> size=3D???
> md11=3D'/dev/sdc /dev/sdf /dev/sdi /dev/sdl /dev/sdo /dev/sdr /dev/sdu /d=
ev/sdx missing missing /dev/sdag /dev/sdaj /dev/sdam /dev/sdap /dev/sdas'
> mdadm --create /dev/md11 --metadata=3D1.0 --size=3D$size --bitmap=3Dinter=
nal --auto=3Dyes -l 6 -n 15 --assume-clean $md11
>=20
> Just incase it helps, here's the full output from mdadm -D for the array =
I'm trying to recover and mdadm -E for the first device in that array:
>=20
> mdadm -E /dev/sdc
> /dev/sdc:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x1
>      Array UUID : 560bd0d9:a8d4758c:9849143c:a2ef5b8e
>            Name : sm345:11  (local to host sm345)
>   Creation Time : Sat Dec 17 07:22:56 2011
>      Raid Level : raid6
>    Raid Devices : 15
>=20
>  Avail Dev Size : 5860532896 (2794.52 GiB 3000.59 GB)
>      Array Size : 76161474688 (36316.62 GiB 38994.68 GB)
>   Used Dev Size : 5858574976 (2793.59 GiB 2999.59 GB)
>    Super Offset : 5860533152 sectors
>           State : clean
>     Device UUID : f3ad57be:c0835578:4f242111:fb465c0a
>=20
> Internal Bitmap : -176 sectors from superblock
>     Update Time : Sat Jun 16 05:45:17 2012
>        Checksum : 4936d9a7 - correct
>          Events : 187674
>=20
>      Chunk Size : 64K
>=20
>     Array Slot : 0 (empty, 1, 2, 3, 4, 5, 6, 7, failed, failed, 10, 11, 1=
2, 13, 14)
>    Array State : _uuuuuuu__uuuuu 2 failed
>=20
> mdadm -D /dev/md11
> /dev/md11:
>         Version : 01.00
>   Creation Time : Sat Dec 17 07:22:56 2011
>      Raid Level : raid6
>      Array Size : 38080737344 (36316.62 GiB 38994.68 GB)
>   Used Dev Size : 5858574976 (5587.17 GiB 5999.18 GB)
>    Raid Devices : 15
>   Total Devices : 15
> Preferred Minor : 11
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Sat Jun 16 05:45:17 2012
>           State : active, degraded
>  Active Devices : 12
> Working Devices : 15
>  Failed Devices : 0
>   Spare Devices : 3
>=20
>      Chunk Size : 64K
>=20
>            Name : sm345:11  (local to host sm345)
>            UUID : 560bd0d9:a8d4758c:9849143c:a2ef5b8e
>          Events : 187674
>=20
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1       8       80        1      active sync   /dev/sdf
>        2       8      128        2      active sync   /dev/sdi
>        3       8      176        3      active sync   /dev/sdl
>        4       8      224        4      active sync   /dev/sdo
>        5      65       16        5      active sync   /dev/sdr
>        6      65       64        6      active sync   /dev/sdu
>        7      65      112        7      active sync   /dev/sdx
>        8       0        0        8      removed
>        9       0        0        9      removed
>       10      66        0       10      active sync   /dev/sdag
>       11      66       48       11      active sync   /dev/sdaj
>       12      66       96       12      active sync   /dev/sdam
>       13      66      144       13      active sync   /dev/sdap
>       14      66      192       14      active sync   /dev/sdas
>=20
>        0       8       32        -      spare   /dev/sdc
>       15      65      160        -      spare   /dev/sdaa
>       16      65      208        -      spare   /dev/sdad
>=20
>=20
> Thanks,
> Tim
>=20
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/sFZt5VteI66K4bQajVBd1IL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT92PXTnsnt1WYoG5AQKwSQ//RCqVpt8Eir1JV/U7w0mKcmriF56RZlR1
SecvDsgw7DhxLO5emGOVLEGex2TJtEMlyfUZuSzTW70ZihhnfoL2BnD8yx8AtJHY
V07IVy+cWaoTpvvvD5NphfIaQ0qpdTSckmlMZJjlUuw7IgSi3WA/9up/aP7XF5qF
hD2P7hDt2DwDVrhoOnePIYlEzdJm767gljMiHB2j1Wa6e5srrZvQTOtz8P3hENkz
0+r1A2dqj/gqFijDRpHmf9zffjR4P2jqxtsJ5ckVymyoR9XDe+XKjhYdCyqO1kYt
9C+YcWMh/cTm4aaZDTWsdZt6jinEIA9mJTb6cjJlVXRu2i2irFEltkksIWA7GVf/
PFPOoIEIBBY73Ky6hP+90obV3l+VYlwUF+zdfQCQVROL4z9RXUWuzEyEP7wmZI0e
gjPbMPL3pl7Iw4E/ulPRchxFcXk2EoOVJqrSYJN0sr44yKR3WJVFpIbQc3VTgJEF
LuZxWqngxd2wjcF1BYo0G57UV2dPIwXolMp3PUqNknnjYAvS/hcDS1US3+aXO/sv
owIza+O/cTePPC9j57rHXR7JYhStCIP8S9GrBGURavstsbpSKHb9R9GIrx1+KmDC
GdbBSdyXWLxhOdpATPeS5XJi9uw8yM4Cilwpml7+kgKYail03GqOE3gwY4sReNxE
XiPbB+xYz8o=
=XdGd
-----END PGP SIGNATURE-----

--Sig_/sFZt5VteI66K4bQajVBd1IL--
