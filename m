From: NeilBrown <neilb@suse.de>
Subject: Re: Recalculating the --size parameter when recovering a failed
 array
Date: Mon, 25 Jun 2012 16:15:54 +1000
Message-ID: <20120625161554.1bef3fb9@notabene.brown>
References: <F4D18266-EDAB-4D31-B3F1-A91894C7E455@ibink.com>
	<20120617180341.39e2d384@notabene.brown>
	<D7A190C6-B05F-4423-B569-D88D34FD076A@ibink.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/s63pt6jquCZysHNv98.Fg6x"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D7A190C6-B05F-4423-B569-D88D34FD076A@ibink.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Nufire <linux-raid_tim@ibink.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/s63pt6jquCZysHNv98.Fg6x
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Jun 2012 13:33:37 -0700 Tim Nufire <linux-raid_tim@ibink.com>
wrote:

> Neil,
>=20
> Thanks for your prompt response. I used the information below and was abl=
e to recover the array easily :-)

Good news.

>=20
> Has anyone written a tool/script to crunch all the metadata info and reco=
mmend the right mdadm --create parameters and drive order? I understand tha=
t figuring out which drives to mark as missing requires an understanding of=
 the history of the array but it seems  the basic command would be easy to =
generate.

My idea it to have a variation of --create which extract information from t=
he
devices, fills in any details that weren't explicitly given on the command
line, and verifying any details that were given.  If something - such as dr=
ive
order - were clearly wrong, mdadm would suggest what the value should be.

But that is still on my to-do list, and not near the top :-(

NeilBrown



>=20
> Cheers,
> Tim
>=20
> On Jun 17, 2012, at 1:03 AM, NeilBrown wrote:
>=20
> > On Sat, 16 Jun 2012 06:09:47 -0700 Tim Nufire <linux-raid_tim@ibink.com>
> > wrote:
> >=20
> >> Hello,
> >>=20
> >> An array that I created using a custom --size parameter has failed and=
 needs to be recovered. I am very comfortable recovering arrays using --ass=
ume-clean but due to a typo at creation time I don't know the device size t=
hat was originally used. I am hoping this value can be recalculate from dat=
a in the superblocks but this calculation is not obvious to me.=20
> >>=20
> >> Here's what I know... I'm using metadata version 1.0 with an internal =
bitmap on all my arrays. I ran some experiments in the lab with 3TB drives =
and found that when I specified a device size of 2929687500 when creating a=
n array, 'mdadm -D' reported a 'Used Dev Size' of 5859374976. The value spe=
cified on the command line is in kilobytes so I was expecting 3,000,000,000=
,000 bytes to be used on each device. The value reported by mdadm is in sec=
tors (512 bytes) so turning this into bytes I get 2,999,999,987,712 bytes. =
This is off by 12,288 bytes (12kb) which I assume is used by the v1.0 super=
block and/or the internal bitmap. I also tried creating an array with 2TB d=
rives (Requested Size: 1953125000, Used Dev Size: 3906249984) and got a dif=
ference of 8kb (2,000,000,000,000 vs 1,999,999,991,808 bytes) so clearly th=
e amount of extra space used depends on the size of the device in some way.
> >>=20
> >> The array that I'm trying to recover reports a 'Used Dev Size' of 5858=
574976. This is just 800,000 sectors less than I got when requesting an eve=
n 3 trillion bytes so I know the size to use on the command line is close t=
o 2929687500. But I don't know how to calculate the exact size... Can someo=
ne help me?=20
> >=20
> > The "Used Dev Size" of the array should be exactly the same as the valu=
e you
> > give to create with --size (metadata and bitmap are extra and not inclu=
ded in
> > these counts) *provided* that the number you give is a multiple of the =
chunk
> > size.  If it isn't the number is rounded down to a multiple of the chun=
k size.
> >=20
> > So if you specify "-c 64 -z 2929287488", you should get the correct siz=
ed
> > array.
> >=20
> > NeilBrown
> >=20
> >=20
> >>=20
> >> Once I know the size I will recreate the array using the following:
> >>=20
> >> size=3D???
> >> md11=3D'/dev/sdc /dev/sdf /dev/sdi /dev/sdl /dev/sdo /dev/sdr /dev/sdu=
 /dev/sdx missing missing /dev/sdag /dev/sdaj /dev/sdam /dev/sdap /dev/sdas'
> >> mdadm --create /dev/md11 --metadata=3D1.0 --size=3D$size --bitmap=3Din=
ternal --auto=3Dyes -l 6 -n 15 --assume-clean $md11
> >>=20
> >> Just incase it helps, here's the full output from mdadm -D for the arr=
ay I'm trying to recover and mdadm -E for the first device in that array:
> >>=20
> >> mdadm -E /dev/sdc
> >> /dev/sdc:
> >>          Magic : a92b4efc
> >>        Version : 1.0
> >>    Feature Map : 0x1
> >>     Array UUID : 560bd0d9:a8d4758c:9849143c:a2ef5b8e
> >>           Name : sm345:11  (local to host sm345)
> >>  Creation Time : Sat Dec 17 07:22:56 2011
> >>     Raid Level : raid6
> >>   Raid Devices : 15
> >>=20
> >> Avail Dev Size : 5860532896 (2794.52 GiB 3000.59 GB)
> >>     Array Size : 76161474688 (36316.62 GiB 38994.68 GB)
> >>  Used Dev Size : 5858574976 (2793.59 GiB 2999.59 GB)
> >>   Super Offset : 5860533152 sectors
> >>          State : clean
> >>    Device UUID : f3ad57be:c0835578:4f242111:fb465c0a
> >>=20
> >> Internal Bitmap : -176 sectors from superblock
> >>    Update Time : Sat Jun 16 05:45:17 2012
> >>       Checksum : 4936d9a7 - correct
> >>         Events : 187674
> >>=20
> >>     Chunk Size : 64K
> >>=20
> >>    Array Slot : 0 (empty, 1, 2, 3, 4, 5, 6, 7, failed, failed, 10, 11,=
 12, 13, 14)
> >>   Array State : _uuuuuuu__uuuuu 2 failed
> >>=20
> >> mdadm -D /dev/md11
> >> /dev/md11:
> >>        Version : 01.00
> >>  Creation Time : Sat Dec 17 07:22:56 2011
> >>     Raid Level : raid6
> >>     Array Size : 38080737344 (36316.62 GiB 38994.68 GB)
> >>  Used Dev Size : 5858574976 (5587.17 GiB 5999.18 GB)
> >>   Raid Devices : 15
> >>  Total Devices : 15
> >> Preferred Minor : 11
> >>    Persistence : Superblock is persistent
> >>=20
> >>  Intent Bitmap : Internal
> >>=20
> >>    Update Time : Sat Jun 16 05:45:17 2012
> >>          State : active, degraded
> >> Active Devices : 12
> >> Working Devices : 15
> >> Failed Devices : 0
> >>  Spare Devices : 3
> >>=20
> >>     Chunk Size : 64K
> >>=20
> >>           Name : sm345:11  (local to host sm345)
> >>           UUID : 560bd0d9:a8d4758c:9849143c:a2ef5b8e
> >>         Events : 187674
> >>=20
> >>    Number   Major   Minor   RaidDevice State
> >>       0       0        0        0      removed
> >>       1       8       80        1      active sync   /dev/sdf
> >>       2       8      128        2      active sync   /dev/sdi
> >>       3       8      176        3      active sync   /dev/sdl
> >>       4       8      224        4      active sync   /dev/sdo
> >>       5      65       16        5      active sync   /dev/sdr
> >>       6      65       64        6      active sync   /dev/sdu
> >>       7      65      112        7      active sync   /dev/sdx
> >>       8       0        0        8      removed
> >>       9       0        0        9      removed
> >>      10      66        0       10      active sync   /dev/sdag
> >>      11      66       48       11      active sync   /dev/sdaj
> >>      12      66       96       12      active sync   /dev/sdam
> >>      13      66      144       13      active sync   /dev/sdap
> >>      14      66      192       14      active sync   /dev/sdas
> >>=20
> >>       0       8       32        -      spare   /dev/sdc
> >>      15      65      160        -      spare   /dev/sdaa
> >>      16      65      208        -      spare   /dev/sdad
> >>=20
> >>=20
> >> Thanks,
> >> Tim
> >>=20
> >>=20
> >>=20
> >>=20
> >>=20
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20


--Sig_/s63pt6jquCZysHNv98.Fg6x
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+gCGznsnt1WYoG5AQKGiA//YYNW5gEb6/dVLmsJTb81Oy+Faiuql543
Vtgg7byhN/K7KkKChDQyUT40uawP7fb5BGH4V9Su53//4IPweWD8Iyc/neQ3909u
Ic1J2Uhb7NBRWV+yz7Vv005NuJes4loiaiZDkoVhBdnqf8qsuMqvGvIy5aRPhKE+
o/XTA6fMNo8O99uJ/LUOA5RL5fexW28PpCesy4EShe9oLekqMpdzeS+c9lfdggc3
e5U6pTSkia2fN6jg3eWDRvsiiNYk2to8DZRKGC6mnFDRgYd9uMpSRXwhxpoaqR2z
tHjMXe+QrIF4mipwRPVHvMXE0O/R0j/EOacgCcLs6uy/aP/j71cg3hkooHuwNl1i
jqHNsj4Yz/dd4gz0f4FnBlngVq+pQB+UY4ZEWi8M+KY0UnMdwdcFWQN2LzwXDbJd
OyK+UmkwUQREVajXsIbPCxJCXea/8s1gghg6D9E8RrJ5fn/SAbKC5R+2wIYiOv8z
5FYkm/TcVGxK+iHxmZ6nJdc12BXG7aV/AEF5+9elQpeznCsXmFkhmDlMoFtHX2Gr
vcHzjo+dGxggqZxUDmxs9fDaTp34AmxE8p2H3m2HMYesSpanCBmo9ZoAhWCbFtF9
NFA/4V0nY2RQdCgrjyVJkxTIOfDLuTy+Xa+oAYXmyf5+BiT760lwU+Vgh7tVoSoL
up9uCtImbVU=
=4u53
-----END PGP SIGNATURE-----

--Sig_/s63pt6jquCZysHNv98.Fg6x--
