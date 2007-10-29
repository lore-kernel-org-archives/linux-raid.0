From: Doug Ledford <dledford@redhat.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Mon, 29 Oct 2007 19:15:01 -0400
Message-ID: <1193699701.10336.508.camel@firewall.xsintricity.com>
References: <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>
	 <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com>
	 <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com>
	 <1193294406.10336.76.camel@firewall.xsintricity.com>
	 <472576A5.3030603@amfes.com> <20071029081802.GB15475@percy.comedia.it>
	 <1193672839.10336.443.camel@firewall.xsintricity.com>
	 <20071029212927.GA24635@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Js8dleZy8cT03LnV6KSK"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071029212927.GA24635@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-Js8dleZy8cT03LnV6KSK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-29 at 22:29 +0100, Luca Berra wrote:
> At which point he found that
> >the udev scripts in ubuntu are being stupid, and from the looks of it
> >are the cause of the problem.  So, I've considered the initial issue
> >root caused for a bit now.
> It seems i made an idiot of myself by missing half of the thread, and i
> even knew ubuntu was braindead in their use of udev at startup, since a
> similar discussion came up on the lvm or the dm-devel mailing list (that
> time iirc it was about lvm over multipath)

Nah.  Even if we had concluded that udev was to blame here, I'm not
entirely certain that we hadn't left Daniel with the impression that we
suspected it versus blamed it, so reiterating it doesn't hurt.  And I'm
sure no one has given him a fix for the problem (although Neil did
request a change that will give debug output, but not solve the
problem), so not dropping it entirely would seem appropriate as well.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-Js8dleZy8cT03LnV6KSK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJml1TzP9PM7pjw8RAgNnAJ43C1vhmw5uGXjaeSFV4p2sglmUewCdFQu8
XuxzXncBc0W1khZ5lyakg6Y=
=Eor4
-----END PGP SIGNATURE-----

--=-Js8dleZy8cT03LnV6KSK--

