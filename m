From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 26 Oct 2007 14:52:59 -0400
Message-ID: <1193424779.10336.287.camel@firewall.xsintricity.com>
References: <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
	 <1192813877.1666.79.camel@firewall.xsintricity.com>
	 <18200.63987.514073.184865@stoffel.org>
	 <20071019212303.GB2013@teal.hq.k1024.org>
	 <1192830129.1666.103.camel@firewall.xsintricity.com>
	 <20071020075349.GA17431@teal.hq.k1024.org>
	 <1192885917.1666.112.camel@firewall.xsintricity.com>
	 <20071026095417.GC32550@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OujkJfqo+oLqHpemN2wc"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071026095417.GC32550@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-OujkJfqo+oLqHpemN2wc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-26 at 11:54 +0200, Luca Berra wrote:
> On Sat, Oct 20, 2007 at 09:11:57AM -0400, Doug Ledford wrote:
> just apply some rules, so if you find a partition table _AND_ an md
> superblock at the end, read both and you can tell if it is an md on a
> partition or a partitioned md raid1 device.

In fact, no you can't.  I know, because I've created a device that had
both but wasn't a raid device.  And it's matching partner still existed
too.  What you are talking about would have misrecognized this
situation, guaranteed.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-OujkJfqo+oLqHpemN2wc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHIjeLTzP9PM7pjw8RAumfAJwPd1KEY2T1i/ElVIpZ2LihTeOcgwCfRV0i
Qx4IXj7uRsfQmviU6PdfX6E=
=8wtA
-----END PGP SIGNATURE-----

--=-OujkJfqo+oLqHpemN2wc--

