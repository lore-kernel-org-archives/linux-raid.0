From: Doug Ledford <dledford@redhat.com>
Subject: Re: bitmap chunk size
Date: Tue, 10 Nov 2009 13:01:54 -0500
Message-ID: <4AF9AA92.7030604@redhat.com>
References: <alpine.DEB.1.00.0911100933160.10087@darius>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDF0E77F8E1BC78B2DB9DCA40"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0911100933160.10087@darius>
Sender: linux-raid-owner@vger.kernel.org
To: "Darius S. Naqvi" <dnaqvi@datagardens.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDF0E77F8E1BC78B2DB9DCA40
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/10/2009 11:39 AM, Darius S. Naqvi wrote:
> Is there any possibility of having a bitmap chunk size of 512 bytes?
> I know that mdadm rejects anything under 4k.  I fear that the
> assumption of the 4k minimum is embedded fairly strongly in the code.
> Can my fear be alleviated?
>=20

If you're putting any normal filesystem (with a block size of 4k) on
this, then it makes absolutely no sense to have a bitmap size less than
4k as any given filesystem block is either dirty or clean, sub-block
semantics make no sense in this scenario.  That said, unless you have a
specific need for this level of granularity, it is a really bad idea
(performance wise and space wise) to go with anything even close to
resembling the granularity you are requesting.  I usually go with
--bitmap-chunk=3D32768 (which since that's expressed in k means
32Megabytes).  I would actually suspect that if you have a truly
pressing need for a 512byte bitmap chunk, then you probably don't need a
bare raid, you need some sort of database underlying your data or
something else.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigDF0E77F8E1BC78B2DB9DCA40
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr5qpIACgkQg6WylM+/8ZS3zACfXbdD8GPfy8XqHGSYDJViOepn
1tAAoIpcd8kHeJR26MaBwqJAaw42d7ND
=1imn
-----END PGP SIGNATURE-----

--------------enigDF0E77F8E1BC78B2DB9DCA40--
