From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Wed, 18 Mar 2009 14:26:53 +0000
Message-ID: <20090318142653.GA15321@cthulhu.home.robinhill.me.uk>
References: <87ljr4hsk9.fsf@frosties.localdomain> <20090318121825.GL32416@skl-net.de> <49C0EA5F.9070901@vshift.com> <20090318123525.GK17185@skl-net.de> <87wsam53ev.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87wsam53ev.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Mar 18, 2009 at 03:08:56PM +0100, Goswin von Brederlow wrote:

> Andre Noll <maan@systemlinux.org> writes:
>=20
> > On 08:34, Ruslan Sivak wrote:
> >
> >> I would guess the reason is that it doesn't make sense.  As mentioned,=
 if
> >> you are going to create a 3 disk raid 6, it's essentially a raid1 over=
 3
> >> disks, at which point you are better off with the raid-1.  I don't thi=
nk
> >> there's a raid controller that would let you set something like this u=
p, I
> >> don't see why the softraid should.
> >
> > Well, Goswin mentioned some pretty good reasons I think.
> >
>=20
> Raid6 is the only level that requires such "sanity".
>=20
> Here is another scenario: Say you have a 2 disk raid1 and now want to
> switch to 5 disk raid6. No problem, add 3 new disks, set up 1+2 disk
> raid6, pvmove the data (don't you love LVM?), stop the raid1, grow the
> raid6 to 5 disks.
>=20
> It is clear that 1+2 disk raid6 only makes sense as a transitory step
> but one that is usefull.
>=20
You could do this via the new RAID5-RAID6 migration. Either:
    - recreate the two disk RAID1 as RAID5 (assume clean)
    - add 2 disks and grow the array
    - add the fifth disk and convert to RAID6
or
    - create a new 3-disk RAID5 array
    - copy/pvmove the data
    - add a fourth disk and grow the array
    - add the fifth disk and convert to RAID6
or even (not 100% sure this'll work until the RAID6 restriping work is
done):
    - create a new 3-disk RAID5 array
    - copy/pvmove the data
    - add a fourth disk and convert to RAID6
    - add the fifth disk and grow the array

So the 3-disk RAID6 isn't essential, though if there's no particular
reason to prohibit it then it might as well be allowed as an option.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAknBBK0ACgkQShxCyD40xBLvgQCgidPAPn+7pTTYtFGdiuFhci6/
Z2MAnA+erzNtQ8n+d2JnQNrJp6ux+RWI
=f2M6
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
