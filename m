From: NeilBrown <neilb@suse.de>
Subject: Re: On URE and RAID rebuild - again!
Date: Thu, 31 Jul 2014 07:31:21 +1000
Message-ID: <20140731073121.38cd1773@notabene.brown>
References: <53D8ACF0.1070202@assyoma.it>
	<alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se>
	<53D8ED99.90606@assyoma.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cuMABT_QhV4Q_3CtSfzeP=l"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53D8ED99.90606@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/cuMABT_QhV4Q_3CtSfzeP=l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Jul 2014 15:05:29 +0200 Gionatan Danti <g.danti@assyoma.it> wrot=
e:

> On 30/07/2014 13:13, Mikael Abrahamsson wrote:
> >
> > There has been much discussion about the URE figures. Some people
> > interpret it one way, others another way. There is nobody here that
> > knows for sure. Ask your HDD vendor, if they answer, do share here!
> >
> - Ouch! -
> I was hoping that HDD vendors were somewhat more open about their URE=20
> calculations... It's time for some lab test, I think!
>  >
> > When MD encounters an URE, it should calculate that block from parity
> > information and write it. I have personally had problems with this not
> > happening, seems it might be that if the URE doesn't happen repeatedly,
> > MD might not re-write. All parity raid levels should behave the same, so
> > this should work identically for RAID1, RAID10, RAID5 and RAID6.
> >
> What about _degraded_ array state? In other words, if a degraded RAID5=20
> experiences a URE during rebuild, what happens? I read that most=20
> hardware based RAID card both stop rebuilding _and_ kill the entire=20
> array. From my understanding, mdadm should stop rebuilding but the array=
=20
> can the restarted, mounted and backupped. Right?
>=20
> Regards.
>=20

Yes, you can usually get your data back with mdadm.

With latest code, a URE during recovery will cause a bad-block to be record=
ed
on the recovered device, and recovery will continue.  You end up with a
working array that has a few unreadable blocks on it.

NeilBrown

--Sig_/cuMABT_QhV4Q_3CtSfzeP=l
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU9lkKTnsnt1WYoG5AQKUZRAAtSdPPB4Dnsr8gyDjOrUrVyFQTGF35IuO
B0WCVWvCpwe8rAhoUrWcQ/iGN8tQsIeHGXt4+H6y+kjdBJbuo8pZ1y38NcsXIHYh
RgomLeoOWzFLudqWA320BpXVkYt1JyCiK26QGdna11uzWvVNAgc2labhrFp+Gsbg
fUoiPKOhGUj3tW1CkQD6Nwx1sOq6cxVqC39ImlYeeegcRLBoZ3atKeR2up1duENq
qi+aH5X4E4W1SnfXUZBCviXNqxqTjLbFLlcqyP39sUKV9xPyK7TuCWcdN1xG+0PU
sTOcq/K9A1GzqkuFbHK6NzsDm1n2a2WNc6ChzXaOuTvCYKqf/KK3+FFfHkOLqclG
73WZlNz8lkznJYrKPAIKN3dPkbKtb8msgqHMQs29jptfzoojra1hTyTGYgRUJ0+D
GwriKjZZ8vK18yvV3BA+xfj0ZpIMo8SEOc1LzenCRe9P3bv8Z+0uWAqa7WEc03nc
/4L5Ll2RiElq4TiR90m+eibL33OhI3l14F0F3xyiQKqV3/XgMLytHNhpvvBohIUw
lOLPusKFBS6n9YkCquhzS0GKOoEZ+6D4gWOzK3SCK7EMxbUxNjvwoB9j0aoXUxk9
2B5GzeeAXCdnoh7TP0B5fEsxhXRhwk7sMfynxN2YYBlE+lpz0JOiIyhirhIp1wdB
AudFb+EdIkA=
=WLMM
-----END PGP SIGNATURE-----

--Sig_/cuMABT_QhV4Q_3CtSfzeP=l--
