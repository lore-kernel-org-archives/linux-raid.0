From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm/Monitor.c - never removes MD devices from statelist
Date: Wed, 21 Sep 2011 15:06:13 +1000
Message-ID: <20110921150613.74e044f0@notabene.brown>
References: <CAGRgLy4=mq_py=Qr+Mk8MOvXY1fbwgeEmEr1kAcmiwHQfCZweg@mail.gmail.com>
	<20110912053646.5eb0b55d@notabene.brown>
	<CAGRgLy4=dMRmqZW4_+Wv+0QZzanH_ZCX88xxL5QD2OK03GmYww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YPkB83MBwKqp2SoF_A4I9wC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4=dMRmqZW4_+Wv+0QZzanH_ZCX88xxL5QD2OK03GmYww@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YPkB83MBwKqp2SoF_A4I9wC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Sep 2011 11:32:23 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil,
> yes, I will try to produce a patch (although I am using git, I have
> never done patches yet).

If you are using git, then patches are easy:

 git show --format=3Demail


>=20
> But I don't understand why do you require 'err' to be set. I would say
> that when there is a "DeviceDisappeared" event plus --scan is set,
> then you should remove. (And also perhaps if this array does not
> appear in the device list provided by the user).

A DeviceDisappeared event sets ->err to 1.  So testing ->err is an easy way
to test if the device disappeated.

It doesn't matter if the device was listed by the user: if --scan is set we
will find it again anyway.

NeilBrown


>=20
> Alex.
>=20
>=20
> On Mon, Sep 12, 2011 at 6:36 AM, NeilBrown <neilb@suse.de> wrote:
> > On Sun, 11 Sep 2011 21:32:12 +0300 Alexander Lyakas <alex.bolshoy@gmail=
.com>
> > wrote:
> >
> >> Hi everybody,
> >> looking at the code of Monitor.c and doing some tests with it, I see
> >> that it is capable of detecting new arrays, when they appear in
> >> /proc/mdstat (if --scan is given). However, once array is added to
> >> 'statelist', it is never removed from there. Is this intentional?
> >> Perhaps only if --scan is given, and device disappears from
> >> /proc/mdstat, then it should be removed from monitoring, otherwise it
> >> could stick there forever, even though the array has been gone long
> >> time ago. And if it appears again, it will be picked up anyways.
> >>
> >
> > You are right - arrays are never removed.
> >
> > Is that a problem? =A0Probably not, though I guess you could probably c=
reate
> > a scenario where there were lots of inactive devices cluttering memory.
> >
> > Is it worth fixing? =A0I don't know - it depends on how intrusive the p=
atch is.
> > We would only want to remove arrays with ->err set if 'scan' was set, b=
ut
> > when it is, it possible makes sense.
> >
> > Want to try creating a patch?
> >
> > NeilBrown
> >


--Sig_/YPkB83MBwKqp2SoF_A4I9wC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeXDFG5fc6gV+Wb0RAplkAJ47YN4g+CbSLIlDriDjf/ZZUSg1uQCgwi5T
SvtHwoYcUQSoMszH7/ACvQo=
=zALK
-----END PGP SIGNATURE-----

--Sig_/YPkB83MBwKqp2SoF_A4I9wC--
