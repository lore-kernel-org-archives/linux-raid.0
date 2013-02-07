From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: some raid questions
Date: Thu, 7 Feb 2013 14:18:18 +0000
Message-ID: <20130207141818.GA16690@cthulhu.home.robinhill.me.uk>
References: <CAANkY-n1ZhcU+A2zf1X9mJJURoEoj8=n9S4Kct5Y+iQA1zZ=dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAANkY-n1ZhcU+A2zf1X9mJJURoEoj8=n9S4Kct5Y+iQA1zZ=dw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ionut Cadariu <ionut.cadariu@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Feb 07, 2013 at 03:49:18PM +0200, Ionut Cadariu wrote:

> Hello,
>=20
> I have some problems understanding the following situation (it's a
> real situation that occurred  one of my friends had this but couldn't
> explain me) so if anyone can point me to the documentation or explain
> me will be great:
>=20
> Let's say md3 with members: sda6 and sdb6
>=20
> - if there are some file system errors on array md3, and I'll create a
> degraded array with only sda6 then run fsck ..what happens if I'll add
> sdb6 to the array ...first i don't understand from what member will
> sync begin ...sda6 or sdb6...then if sync will be from sdb6 errors
> remain
>=20
If you add sdb6 back into the array then the sync will be from sda6 to
sdb6. If you have a bitmap on the array then only the modified chunks
will be synced, otherwise the entire of sdb6 will get rewritten.

If (OTOH) you just fscked sda6 without having created a degraded array
then, when the array gets reassembled from both members, the errors
will remain on sdb6 (and any data read could come from either sda6 or
sdb6, so may or may not be the fscked data) until you force an array
repair (in which case you'll end up with either the fscked or un-fscked
data - I'm not sure how the decision is made on this).

> - if the sync will be done from sda6 ...will errors on sdb6 get fixed
> without fsck
> - if the sync will be done from sdb6 ....i think will get synced with
> errors ...so sda6 will have errors
>=20
Yes, depending on which the sync ends up being from, either you'll end
up with both disks having the fscked data or both having the un-fscked
data.

> If i'm wrong or you can help me please reply...
> My friend that had this situation started to sync data to another
> disks so he can't help me with this.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlETt6kACgkQShxCyD40xBI5hgCgpmGC2Q9a0UCYsNicVtp3LLch
2LYAoLxY/rVGHXfweb/2Nry+DQ3nsAnd
=HjRX
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
