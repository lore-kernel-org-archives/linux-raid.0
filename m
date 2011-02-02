From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID 5 - One drive dropped while replacing another
Date: Wed, 2 Feb 2011 14:47:26 +0000
Message-ID: <20110202144726.GB18517@cthulhu.home.robinhill.me.uk>
References: <AANLkTinXTYds442gPrs9a9vKtWTo4OcDHDEzvO0njvyv@mail.gmail.com>
 <AANLkTikSjLhoUM5f2ibqCUmo8XF-tsrhxZ7oieg08dtD@mail.gmail.com>
 <20110202043605.593f0c5c@natsu>
 <AANLkTimJC_e8=BmGj7Th_LLc=wnoNj8tRovAgTR=mmQ7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimJC_e8=BmGj7Th_LLc=wnoNj8tRovAgTR=mmQ7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Feb 02, 2011 at 09:21:20PM +0700, hansbkk@gmail.com wrote:

> On Wed, Feb 2, 2011 at 6:36 AM, Roman Mamedov <rm@romanrm.ru> wrote:
> >
> >> I have a RAID5 setup with 15 drives.
> >
> > Looks like you got the problem you were so desperately asking for, with=
 this
> > crazy setup. :(
>=20
> Please give some more details as to what's so crazy about this.
>=20
Just the number of drives in a single RAID5 array I think.  I'd be
looking at RAID6 well before I got to 10 drives.

> I would think RAID6 would have made more sense, possibly with an
> additional spare if these are large drives (over a few hundred GB?)
>=20
With 15, RAID6 + spare would probably be what I'd go with (depending on
drive size of course, and whether you have cold spares handy).  For very
large drives, multiple arrays would be safer.

> Or is there an upper limit as to the number of drives that's advisable
> for any array?
>=20
I'm sure there's advice out there on this one - probably a recommended
minimum percentage of capacity used for redundancy.  I've not looked
though - I tend to go with gut feeling & err on the side of caution.

> If so, then what do people reckon a reasonable limit should be for a
> RAID6 made up of 2TB drives?
>
As the drive capacities go up, you need to be thinking more carefully
about redundancy - with a 2TB drive, your rebuild time is probably over
a day.  Rebuild also tends to put more load on drives than normal, so is
more likely to cause a secondary (or even tertiary) failure.  I'd be
looking at RAID6 regardless, and throwing in a hot spare if there's more
than 5 data drives.  If there's more than 10 then I'd be going with
multiple arrays.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk1Jbn4ACgkQShxCyD40xBLqQACgxv6KMt9FOokoyYR9RY+6dlvc
gnMAn1p1umIQ+SjJ5rn49Y2hOfnkSrbn
=IsUO
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
