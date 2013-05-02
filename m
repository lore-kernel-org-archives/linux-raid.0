From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Anything left to try?
Date: Thu, 2 May 2013 16:09:32 +0100
Message-ID: <20130502150932.GA13438@cthulhu.home.robinhill.me.uk>
References: <CAPSPcXjFQ9zDP9ZK8X3uZXHNKot5hS=0iwj04E_FrNa2Z8n++A@mail.gmail.com>
 <C480F6221151144EA453A5C89300815601403A74@MBOX1.ds.sbdhi.com>
 <CAPSPcXhS2O8ASH8Gsz8KE=oJp6y1K6VTi7Jf-=39uzNzG3SnJQ@mail.gmail.com>
 <20130502145829.GB18405@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130502145829.GB18405@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu May 02, 2013 at 03:58:29PM +0100, Robin Hill wrote:

> On Thu May 02, 2013 at 09:26:55AM -0500, Barrett Lewis wrote:
>=20
> > That is a really good idea.  At minimum I will ddrescue the failed driv=
es.
> > But even if I do that, is there a way to reassemble the array (even with
> > new drives) now that those components are marked failed?
> >=20
> Yes, "mdadm -Af /dev/mdX" should reassemble the array, making use of the
> best set of drives available to get the array running - i.e. all the
> working drives plus the most-recently failed drive(s). It'll still be in
> a degraded state, but hopefully you can then get the other disk added
> (though you'll still have to keep your fingers crossed that there's no
> read error of any kind during the several days required to rebuild a 4T
> drive).
>=20
Sorry, got you mixed up with someone else there. Anyway, the command
should reassemble the array and allow you to get the rest of the data
off. You might want/need to also specify the disks/partitions it should
be using for the assembly.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlGCgawACgkQShxCyD40xBLmEQCeIQmxGWE6S2a+LfUh4lfC3Bnm
UosAn1HFvhh1LjStg3bLS6Ofmcn2ipGs
=wrg4
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
