From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 lockups post ca64cae96037de16e4af92678814f5d4bf0c1c65
Date: Wed, 20 Mar 2013 11:54:48 +1100
Message-ID: <20130320115448.30340ab6@notabene.brown>
References: <wrfj1ubvi88x.fsf@redhat.com>
	<20130305080010.6285b435@notabene.brown>
	<wrfjlia2fd6h.fsf@redhat.com>
	<20130306131804.0b39752a@notabene.brown>
	<wrfj4ngog9h0.fsf@redhat.com>
	<20130312093231.72c54735@notabene.brown>
	<20130312123224.62018981@notabene.brown>
	<513F0DAE.4060801@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/a+sav4CDJfDh8wZT94JFK3z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <513F0DAE.4060801@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: joystick <joystick@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/a+sav4CDJfDh8wZT94JFK3z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Mar 2013 12:12:46 +0100 joystick <joystick@shiftmail.org> wrote:

> On 03/12/13 02:32, NeilBrown wrote:
> > Subject: [PATCH] md/raid5: ensure sync and recovery don't happen at the=
 same
> >   time.
>=20
> Watch out for probable mistake

I assume you mean that it isn't 'sync and recovery' but rather 'sync and
DISCARD' ?

Thanks for noticing that - fixed.

NeilBrown

--Sig_/a+sav4CDJfDh8wZT94JFK3z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUUkI2Dnsnt1WYoG5AQJZAA//XKfxeyhwT4WKet9kb5eq8Qgr4K2lHtqq
ZX4UYRC6jfjtrm0y67t8ReRpoSpgRUm2yD1WOv/FgiOwWnzRtqvZhTUBwZwqvlMg
+u3bp5k7yMbQ6y4SGqSBv2IVqNEf0aYxva4L9vj0UJZPg/cSpUs3g9eo7QSPsXaM
wjinQe4CpLhtND9EYF4wIPRtS834SCV/JDURTSFIwtBjTEqyDp5Dtf4thkPqTzRs
fZ++EPvKJ88abxKKO1SI7Kjl4kKGYZxOlsqk4p0AaqhgxcTkReIwIc7xB8+eaXbk
jmNMqzO4QUYdYGqVLGM2XjHpqemq4vJGJJtK6sSFttZRW/3yg1EVBib5yfgqb/O8
qn6M9M14FN+zRDtlaIL2pmaeBUvVfLZTq0/KNIzwl3GIouFaqMQoSVVWrKimReUn
JCjIr1Hpjnn8nGGYbth0QrUW5bQNAorxFjk1SbuuTkYDkNat2JxjCb03iXmwZ+r0
YZrQjF/pNqUlfylYac0AJWVaQ2Hwd1/iy5yHPeev6bfca8lGSRbvNCe8IEP+4i8y
qGD9EOevtWjpyUdaiOJNpUbisdIBLEKVdxocHWHIAXc0u7sez7QBYMh1Pg81084d
kGZj/L4yq8DZuC+fS2y7k/OIYePoHYsFIL6VSphPEn0Rpe/ANXXJVY/ZoHqSXyuw
YtFMFxUqtDg=
=cG9k
-----END PGP SIGNATURE-----

--Sig_/a+sav4CDJfDh8wZT94JFK3z--
