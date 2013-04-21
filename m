From: NeilBrown <neilb@suse.de>
Subject: Re: Reshape Shrink Hung Again
Date: Mon, 22 Apr 2013 07:24:14 +1000
Message-ID: <20130422072414.3e30882c@notabene.brown>
References: <96A49024-A8A7-4ED9-82B1-5AE430374EBE@bingner.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YNdQbFUX+aLCSLAWC0YphmE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <96A49024-A8A7-4ED9-82B1-5AE430374EBE@bingner.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Bingner <sam@bingner.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/YNdQbFUX+aLCSLAWC0YphmE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Apr 2013 08:29:37 +0000 Sam Bingner <sam@bingner.com> wrote:

> I'll start this off by saying that no data is in jeopardy, but I would li=
ke to track down the cause of this problem and fix it.  I originally though=
t it must have been due to the incorrect backup-file size with a raid array=
 shrunk to smaller than the final size when it happened to me last time but=
 this time this was not the case.
>=20
> I initiated a shrink from a 4-drive RAID5 to a 3-drive RAID5, this shrink=
 had no problems except that a drive failed right at the end of the reshape=
... then it hung at 99.9% and does not allow me to remove the failed drive =
from the array because it is "rebuilding".  I am not sure if the drive fail=
ed at the end, or if it was after it had gotten to 99.9% because I didn't s=
ee this until the next morning as it ran overnight.
>=20
> Sam
>=20
> root@fs:/var/log# uname -a
> Linux fs 2.6.32-5-686 #1 SMP Mon Jan 16 16:04:25 UTC 2012 i686 GNU/Linux
>=20
> Apr 17 22:37:41 fs kernel: [25860779.639762] md1: detected capacity chang=
e from 749122093056 to 499414728704
> Apr 17 22:38:40 fs kernel: [25860837.912441] md: reshape of RAID array md1
> Apr 17 22:38:40 fs kernel: [25860837.912447] md: minimum _guaranteed_  sp=
eed: 1000 KB/sec/disk.
> Apr 17 22:38:40 fs kernel: [25860837.912452] md: using maximum available =
idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
> Apr 17 22:38:40 fs kernel: [25860837.912459] md: using 128k window, over =
a total of 243854848 blocks.
> Apr 18 07:51:09 fs kernel: [25893987.273813] raid5: Disk failure on sda2,=
 disabling device.
> Apr 18 07:51:09 fs kernel: [25893987.273815] raid5: Operation continuing =
on 2 devices.
> Apr 18 07:51:09 fs kernel: [25893987.287168] md: super_written gets error=
=3D-5, uptodate=3D0
> Apr 18 07:51:10 fs kernel: [25893987.657039] md: md1: reshape done.
> Apr 18 07:51:10 fs kernel: [25893987.781599] md: reshape of RAID array md1
> Apr 18 07:51:10 fs kernel: [25893987.781607] md: minimum _guaranteed_  sp=
eed: 100 KB/sec/disk.
> Apr 18 07:51:10 fs kernel: [25893987.781613] md: using maximum available =
idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
> Apr 18 07:51:10 fs kernel: [25893987.781620] md: using 128k window, over =
a total of 243854848 blocks.
>=20
>=20
> md1 : active raid5 sdd2[3] sda2[0](F) sdc2[2] sdb2[4]
>       487709696 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2] [=
_UU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.]  resh=
ape =3D 99.9% (243853824/243854848) finish=3D343.6min speed=3D0K/sec
>=20

Looks like a bug - probably in mdadm.
mdadm needs to help the reshape over the last little bit, and md is probably
waiting for it to do that.  This will be the only time in the whole process
when the backup file is used.

I would try stopping the array and re-assembling it.  That might require a
reboot.  If that doesn't fix it, let me know and I'll prioritise this.
Otherwise - I've put it on my to-do list.  I'll try to reproduce and fix it
in due course.

Thanks for the report,
NeilBrown

--Sig_/YNdQbFUX+aLCSLAWC0YphmE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXRY/jnsnt1WYoG5AQJqBQ//cmmXBW68dkSQXMiaY2NBvoWjP7wGm2gT
bdYLzqUguA/sdvwAtBr94qx3kEpjreSsdL0PK66HunexAX782O+h1pqN4wxfoGav
BniTfjy68BgGUo3E/SOJeCrxhfsyM3FCa/IYCW0BkIAp/605L5Uc2OB6yXr/VtmK
Xsz+A2+buhkP4om6gDmv2EWyfWOsxORSjW283tFjAQIyMU3I0LUMXNpR9iUJOP/U
w8zURlRSg7sHsTSL5cFAnxzwoJURWS1aA+osv49SyYNT8l4Eog/lItcVcsvY98JV
auIR2oxhYQswIq7o0wNWcsaKLSrz6DI8DSeNA4avKHstTGpIB6zojsMqn56gBGEc
aFDiyBxxOf9VCBmdyddwZrN7jwLBdnRZLcVjBYUdT/3NrPkzxWiA8ZIokSBlFk+h
sKHL+hupLyTdUAbmRcV5QXZjAfG7+ngJySRhZAzA56RzV99mSA5xmrCZ5tMsHYNh
YUb5bGISAON8G3zMQYV1yPa2GvSZmFvybaOoX17VusHRqug7YPA4uNCsfB4lV1Zp
GvLyhOGdoYM+nZR+qG0/rD0+gWvnBEpxp38sj7iV7f8/cMA7Ha8nJqaELj65AX46
UTz/1/BOUEz2C0OH7DlK0cuYC6bGL3laia474EGarN2wA8n1KDRYpo+PGBDUNIsC
oFhalQAg/tQ=
=jodP
-----END PGP SIGNATURE-----

--Sig_/YNdQbFUX+aLCSLAWC0YphmE--
