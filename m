From: Doug Ledford <dledford@redhat.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Mon, 29 Oct 2007 11:21:56 -0400
Message-ID: <1193671316.10336.423.camel@firewall.xsintricity.com>
References: <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>
	 <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com>
	 <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com>
	 <1193294406.10336.76.camel@firewall.xsintricity.com>
	 <20071026091513.GB32550@percy.comedia.it>
	 <1193426793.10336.302.camel@firewall.xsintricity.com>
	 <4725278E.1050306@tmr.com> <20071029074139.GA15475@percy.comedia.it>
	 <4725DEAB.4050507@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ufQPEbpKECxASJAyTyxu"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4725DEAB.4050507@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-ufQPEbpKECxASJAyTyxu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-29 at 09:22 -0400, Bill Davidsen wrote:

> > consider a storage with 64 spt, an io size of 4k and partition starting
> > at sector 63.
> > first io request will require two ios from the storage (1 for sector 63=
,
> > and one for sectors 64 to 70)
> > the next 7 io (71-78,79-86,97-94,95-102,103-110,111-118,119-126) will b=
e
> > on the same track
> > the 8th will again require to be split, and so on.
> > this causes the storage to do 1 unnecessary io every 8. YMMV.
> No one makes drives with fixed spt any more. Your assumptions are a=20
> decade out of date.

Your missing the point, it's not about drive tracks, it's about array
tracks, aka chunks.  A 64k write, that should write to one and only one
chunk, ends up spanning two.  That increases the amount of writing the
array has to do and the number of disks it busies for a typical single
I/O operation.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-ufQPEbpKECxASJAyTyxu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJfqTTzP9PM7pjw8RAiJrAJwN/c96ahMziJ3CkF8Dh3D0vjxodQCePZGn
UhUR26Zt1jyTtQ3qh+IgO7Q=
=7Io+
-----END PGP SIGNATURE-----

--=-ufQPEbpKECxASJAyTyxu--

