From: NeilBrown <neilb@suse.de>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Thu, 8 Dec 2011 09:16:51 +1100
Message-ID: <20111208091651.2a56dd5b@notabene.brown>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu>
	<20111208075709.587ac227@notabene.brown>
	<654BF752-029F-444F-A4AB-68C3CEA7F8D5@ucsc.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CixsdJQAzKTPMHJr/5dE.wo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <654BF752-029F-444F-A4AB-68C3CEA7F8D5@ucsc.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Morris <ermorris@ucsc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CixsdJQAzKTPMHJr/5dE.wo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Dec 2011 14:00:00 -0800 Eli Morris <ermorris@ucsc.edu> wrote:

>=20
> On Dec 7, 2011, at 12:57 PM, NeilBrown wrote:
>=20
> > On Wed, 7 Dec 2011 12:42:26 -0800 Eli Morris <ermorris@ucsc.edu> wrote:
> >=20
> >> Hi All,
> >>=20
> >> I thought maybe someone could help me out. I have a 16 disk software R=
AID that we use for backup. This is at least the second time this happened-=
 all at once, four of the drives report as 'removed' when none of them actu=
ally were. These drives also disappeared from the 'lsscsi' list until I res=
tarted the disk expansion chassis where they live.=20
> >>=20
> >> These are the dreaded Caviar Green drives. We bought 16 of them as an =
upgrade for a hardware RAID originally, because the tech from that company =
said they would work fine. After running them for a while, four drives drop=
ped out of that array. So I put them in the software RAID expansion chassis=
 they are in now, thinking I might have better luck. In this configuration,=
 this happened once before. That time, the drives looked to all have signif=
icant numbers of bad sectors, so I got those ones replaced and thought that=
 that might have been the problem all along. Now it has happened again. So =
I have two fairly predictable questions and I'm hoping someone might be abl=
e to offer a suggestion:
> >>=20
> >> 1) Any ideas on how to get this array working again without starting f=
rom scratch? It's all backup data, so it's not do or die, but it is also 30=
 TB and I really don't want to rebuild the whole thing again from scratch.
> >=20
> > 1/ Stop the array
> >    mdadm -S /dev/md5
> >=20
> > 2/ Make sure you can read all of the devices
> >=20
> >    mdadm -E /dev/some-device
> >=20
> > 3/ When you are confident that the hardware is actually working, reasse=
mble
> >   the array with --force
> >=20
> >    mdadm -A /dev/md5 --force /dev/sd[a-o]1
> > (or whatever gets you a list of devices.)
> >=20
> >>=20
> >> I tried the re-add command and the error was something like 'not allow=
ed'
> >>=20
> >> 2) Any idea on how to stop this from happening again? I was thinking o=
f playing with the disk timeout in the OS (not the one on the drive firmwar=
e).=20
> >=20
> > Cannot help there, sorry - and you really should solve this issue befor=
e you
> > put the array back together or it'll just all happen again.
> >=20
> > NeilBrown
> >=20
> >>=20
> >> If anyway can help, I'd greatly appreciate it, because, at this point,=
 I have no idea what to do about this mess.=20
> >>=20
> >> Thanks!
> >>=20
> >> Eli
> >>=20
> >>=20
> >> [root@stratus ~]# mdadm --detail /dev/md5
> >> /dev/md5:
> >>        Version : 1.2
> >>  Creation Time : Wed Oct 12 16:32:41 2011
> >>     Raid Level : raid5
> >>  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
> >>   Raid Devices : 16
> >>  Total Devices : 13
> >>    Persistence : Superblock is persistent
> >>=20
> >>    Update Time : Mon Dec  5 12:52:46 2011
> >>          State : active, FAILED, Not Started
> >> Active Devices : 12
> >> Working Devices : 13
> >> Failed Devices : 0
> >>  Spare Devices : 1
> >>=20
> >>         Layout : left-symmetric
> >>     Chunk Size : 512K
> >>=20
> >>           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.uc=
sc.edu)
> >>           UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
> >>         Events : 32
> >>=20
> >>    Number   Major   Minor   RaidDevice State
> >>       0       8        1        0      active sync   /dev/sda1
> >>       1       0        0        1      removed
> >>       2       8       33        2      active sync   /dev/sdc1
> >>       3       8       49        3      active sync   /dev/sdd1
> >>       4       8       65        4      active sync   /dev/sde1
> >>       5       8       81        5      active sync   /dev/sdf1
> >>       6       8       97        6      active sync   /dev/sdg1
> >>       7       8      113        7      active sync   /dev/sdh1
> >>       8       0        0        8      removed
> >>       9       8      145        9      active sync   /dev/sdj1
> >>      10       8      161       10      active sync   /dev/sdk1
> >>      11       8      177       11      active sync   /dev/sdl1
> >>      12       8      193       12      active sync   /dev/sdm1
> >>      13       8      209       13      active sync   /dev/sdn1
> >>      14       0        0       14      removed
> >>      15       0        0       15      removed
> >>=20
> >>      16       8      225        -      spare   /dev/sdo1
> >> [root@stratus ~]#=20
> >>=20
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
>=20
> Hi Neil,
>=20
> Thanks. I gave it a try and I think I got close to getting it back. Maybe=
. Here is the output from one of the drives that showed up as 'removed' bel=
ow. It looks OK to me, but I'm not really sure what trouble signs to look f=
or. After stopping the array, I tried to reconstruct it, and here is what I=
 got below. I don't know why the drives would be busy. Short of rebooting, =
which I can't do at the moment, is there a way to check why they are busy a=
nd force them to stop? I don't have them mounted or anything. Or do you thi=
nk that means the hardware is not responding properly?
>=20
> Thanks,
>=20
> Eli
>=20
> mdadm -A /dev/md5 --force /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sd=
e1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /d=
ev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1
> mdadm: failed to add /dev/sdo1 to /dev/md5: Device or resource busy
> mdadm: failed to add /dev/sdp1 to /dev/md5: Device or resource busy
> mdadm: /dev/md5 assembled from 12 drives and 2 spares - not enough to sta=
rt the array.

This means that the device is busy....
Maybe it got attach to another md array.  What is in /proc/mdstat.  Maybe y=
ou
have to stop something else.

NeilBrown

--Sig_/CixsdJQAzKTPMHJr/5dE.wo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt/l6Tnsnt1WYoG5AQILjhAAj3iQD+FSTuGcHiDfKcoqGU/r08pzt/6D
smuwi84/vbNoD32sLf/QuXx9QfjejXlz2xpZ/KqY7w6lFNk15UZ5Jp+gFzTyHNEz
/hYsrj9Dji0fCHlWkifMO1YgQjz1wM1vwF5OmWB6EjyYxJn75YcXGWvobKcbhseh
g4WbQM7SHYshmd9R0z/4v3CcUb+SermOgRsPblKb9gbDddls5BfkJTnxtAZcvsam
A4zxRWRUTJVm0SgAUnVVlfaU0EathmENa29Ji5Fb8iz8r5bWstloths1N3mL4PgX
tMB7z2EWcO4W91OJe+spo0D5p2+R5Zk5+PE4DxfBEo+OLiZMm27bamx4hX8Pbgco
L7WRCmVjcz1YWFoXeQfizHA2cVCBkPFbSSBCWwPKQLQFa5UsFHCtQwlYV6Hs3FA3
aEcY5E7WrIB5rs8LXDhfFF5o83c7R2MItutEuU3bg7pUhifSSmj4NlzmuVTQHiJf
wVaDc+eWQReUf8Qnu/ctM3xogl4ZCjrCp+H60NhUjSmmFEEZbkC8uhgACpYVTplm
tqelppe5Kv56Dv5R8YFFEXruEXUT7EfY2DYEDGyIeghlrVIIyCNDuV/S39zIVY6v
inHzxGZUiFzST3BU+yysxu95gO4n6vSIhXTJb+7VKlALFP+k2zMdNh7VuQ+4tFsJ
WGr0N6u2XzU=
=aWMr
-----END PGP SIGNATURE-----

--Sig_/CixsdJQAzKTPMHJr/5dE.wo--
