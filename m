From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 01/10] md: allow a reshape operation to be reversed.
Date: Tue, 2 Oct 2012 12:41:03 +1000
Message-ID: <20121002124103.6d66e3f2@notabene.brown>
References: <20120403054656.19495.36380.stgit@notabene.brown>
	<20120403055301.19495.37242.stgit@notabene.brown>
	<20121001161554.2445f3e5@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rjNIUuUM6Gzghmcjm0AX3lF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121001161554.2445f3e5@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/rjNIUuUM6Gzghmcjm0AX3lF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Oct 2012 16:15:54 +0600 Roman Mamedov <rm@romanrm.ru> wrote:

> On Tue, 03 Apr 2012 15:53:01 +1000
> NeilBrown <neilb@suse.de> wrote:
>=20
> > To reverse a partial reshape which changes the number of devices
> > you can stop the array and re-assemble with the raid-disks numbers
> > reversed and it will undo.
>=20
> Unfortunately this does not seem to work:
>=20
> # mdadm --assemble --raid-disks=3D5 --backup-file=3D/mnt/scratch/backup-f=
ile /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sde1 /dev/sdd1 /dev/sdf1
> mdadm:option --raid-disks not valid in assemble mode
>=20

No, mdadm doesn't support this yet.  The patch you identified is part of
preparing the way for this functionality, but it isn't ready yet.

For now, you'll just need to let the reshape complete.

NeilBrown


--Sig_/rjNIUuUM6Gzghmcjm0AX3lF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGpUPznsnt1WYoG5AQLqIQ//VsQtq+Unb4gVaQM2cBBT0kmC+GTmtfd2
hYumDgxn8Lwbupo8+K32xQKziQMjxWOiStvClFGko8FaNSnbLHJJI/Yd173bjLra
GsdpwXR6Giqxai/FX6y5Ur31WwDWuN4sei7gna+x+Rqgk0pBQIBvStyZAI2mUiWP
tLFsqh3m7W+dykoqUUhbg9g21oHPbsYh1ECIB3ypK4iBkmBGtOHyNZTHsBkpwf4c
pfJ/pJI51lnAI3kaueIgiDiRQzObAfe+3acVhDbp6XTZylfARPJ1MRSNDbDHkj6k
JdlswGDeOeG3WZjdrEmhxq9RYPFoOfiT4sk6hyG5q6kzzSjlEvQt5ImVBI6kWpxW
TjbZls3vvXWKTxUq0gnrngw+CHcj2z6CeVsUnJMntdT9+YMWE/QWcbQSRvA+ZUov
6taCNpMNs6CusqfQo6KsdoEXQ1qiUK+FmqJqAyZrMwe2MkKzXpVFvFXUtbigBWXd
BZqErLZQt2tSwB5BMosxCfEKDYqOYq7VJQJ6KRs8507MZXAGZlHKvAX3w8jyRkJU
soE3JmzSEwkJbfbOM/GTNp/F+dcjEjZAigTFJ5FbQJbnCAJs96zrOFcXcRT2v4vI
Ie0+agBBsUgpwDJCKdciBFB26uxk+0UKSS8TJ/mnn7ZOWjAFa7HMcU8PHhJBnjMw
hpl2G0f+7ac=
=Wdy6
-----END PGP SIGNATURE-----

--Sig_/rjNIUuUM6Gzghmcjm0AX3lF--
