From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 22:10:37 +0000
Message-ID: <20091111221036.GA23061@cthulhu.home.robinhill.me.uk>
References: <20091111150155475.WWUI3390@cdptpa-omta03.mail.rr.com>
 <4AFB2026.2010001@redhat.com>
 <babafd2f0911111346y1dc42030g92a11f172bc32620@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <babafd2f0911111346y1dc42030g92a11f172bc32620@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Nov 11, 2009 at 01:46:50PM -0800, Ben DJ wrote:

> Hi,
>=20
> On Wed, Nov 11, 2009 at 12:35 PM, Doug Ledford <dledford@redhat.com> wrot=
e:
> > Yes, very incorrect. =A0You can use grow to add an internal bitmap late=
r,
>=20
> Is that true for RAID-10, as well?  I understood "--grow" with RAID-10
> wasn't fully capable -- yet.
>=20
It's true for RAID-10, yes.  You can't physically grow the array, but
you can definitely add/remove the bitmap.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkr7NlwACgkQShxCyD40xBIsvACfbBLlGxxXaEagqBKJmtF+/p/A
cCAAnjdyMensycQjPQANR+uAGZMoTazl
=f56B
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
