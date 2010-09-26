From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Accidental grow before add
Date: Sun, 26 Sep 2010 11:38:18 +0100
Message-ID: <20100926103818.GA5719@cthulhu.home.robinhill.me.uk>
References: <AANLkTi=PydpqTR1x=KTfW16en3U3+KxoLV85iWpWtRC9@mail.gmail.com>
 <AANLkTi=3MEirXZs_Qv7nO7fvAKxvErnkvAiEe8fdxQA=@mail.gmail.com>
 <AANLkTimPPD6TfoX7GVbaNgQo1CPpjc7LLG-nWDz7=En=@mail.gmail.com>
 <alpine.DEB.1.10.1009261159120.28005@uplift.swm.pp.se>
 <AANLkTikOr3LdZ_uy5Vnj=wu0k7Ag8A+LXRYwxf69YNOv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikOr3LdZ_uy5Vnj=wu0k7Ag8A+LXRYwxf69YNOv@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Sep 26, 2010 at 06:18:09AM -0400, Mike Hartman wrote:

> > You need to start looking in dmesg / other logs to see what has happene=
d and
> > why things have failed. Without that information it's impossible to tell
> > what's going on.
> >
> I've uploaded the dmesg output starting with the reshape to
> www.hartmanipulation.com/raid/dmesg_6.txt. It looks like /dev/sdd is
> having some kind of intermittent read issues (which wasn't happening
> before the reshape started) but I still don't understand why it
> wouldn't be marked as failed in the md2 section of mdstat, since md0
> is accessing it via md2.
>=20
I think this is because it's a RAID0 array.  It can't fail the device
without (irrecoverably) failing the array, so it's left to the normal
block device error reporting/handling process.

> At any rate, that doesn't help me with my most immediate issue: does a
> drive failing during a reshape corrupt the array? Or am I safe to
> resume the reshape? Is there any way to restore my safety net a bit
> before resuming the reshape, or will I just have to hope nothing else
> goes wrong between now and the time the new hot spare is finally
> incorporated?
>=20
Failure of a device during the reshape certainly shouldn't corrupt the
array (I don't see how it would anyway, unless there's a screw-up in the
code).  I don't think there's any way to "restore your safety net"
though (short of imaging all the drives as backups), but it's probably
worth while doing a read test of all member devices before you continue.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAkyfIpkACgkQShxCyD40xBJ2bgCbBV2IrE/N4i0uTkxs9Grt6uS2
bcgAnjI+Kc4B3WSutbWB+jPdQm3z+JTE
=aIqD
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
