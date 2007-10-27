From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 27 Oct 2007 16:09:03 -0400
Message-ID: <1193515743.10336.324.camel@firewall.xsintricity.com>
References: <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
	 <1192813877.1666.79.camel@firewall.xsintricity.com>
	 <18200.63987.514073.184865@stoffel.org>
	 <20071019212303.GB2013@teal.hq.k1024.org>
	 <1192830129.1666.103.camel@firewall.xsintricity.com>
	 <20071020075349.GA17431@teal.hq.k1024.org>
	 <1192885917.1666.112.camel@firewall.xsintricity.com>
	 <20071026095417.GC32550@percy.comedia.it>
	 <1193424779.10336.287.camel@firewall.xsintricity.com>
	 <20071027080035.GC12053@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X/PjkgxRrt9HluuiHeMC"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071027080035.GC12053@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-X/PjkgxRrt9HluuiHeMC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-27 at 10:00 +0200, Luca Berra wrote:
> On Fri, Oct 26, 2007 at 02:52:59PM -0400, Doug Ledford wrote:
> >On Fri, 2007-10-26 at 11:54 +0200, Luca Berra wrote:
> >> On Sat, Oct 20, 2007 at 09:11:57AM -0400, Doug Ledford wrote:
> >> just apply some rules, so if you find a partition table _AND_ an md
> >> superblock at the end, read both and you can tell if it is an md on a
> >> partition or a partitioned md raid1 device.
> >
> >In fact, no you can't.  I know, because I've created a device that had
> >both but wasn't a raid device.  And it's matching partner still existed
> >too.  What you are talking about would have misrecognized this
> >situation, guaranteed.
> then just ignore the device and log a warning, instead of doing a random
> choice.
> L.

It also happened to be my OS drive pair.  Ignoring it would have
rendered the machine unusable.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-X/PjkgxRrt9HluuiHeMC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHI5rfTzP9PM7pjw8RAgzlAJ0QCGSRkHkKZFRKfNPZnqbzjdhLMwCeL3RQ
XXFATDO0zpjsX9mzGKke3XU=
=s2zS
-----END PGP SIGNATURE-----

--=-X/PjkgxRrt9HluuiHeMC--

