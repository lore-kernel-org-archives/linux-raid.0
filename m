From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Cancelling not pausing array check
Date: Mon, 6 Oct 2014 14:53:14 +0100
Message-ID: <20141006135314.GB1928@cthulhu.home.robinhill.me.uk>
References: <CAAOsTSnYjW-r7VoOL0SiNhsdv5kn9DunrfD3izuLDzaHaBb56Q@mail.gmail.com>
 <20141006133641.GA1928@cthulhu.home.robinhill.me.uk>
 <CAAOsTSny1MUvQktS=nSLLGdvdWd3Ud4M7pPxgWKvHCamem8V4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAOsTSny1MUvQktS=nSLLGdvdWd3Ud4M7pPxgWKvHCamem8V4Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Horn=EDk?= <patrik@dsl.sk>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Oct 06, 2014 at 03:39:12PM +0200, Patrik Horn=EDk wrote:

> 2014-10-06 15:36 GMT+02:00 Robin Hill <robin@robinhill.me.uk>:
> > On Mon Oct 06, 2014 at 03:29:13PM +0200, Patrik Horn=EDk wrote:
> >
> >> Hello,
> >>
> >> is it possible to cancel RAID 6 array check? echo check >
> >> /sys/block/mdX/md/sync_action apparently only pauses it and next check
> >> continuing from saved position. (I guess /sys/block/mdX/md/sync_min)
> >>
> >> I want to achieve two things:
> >>
> >> - Start check from the start of the array.
> >>
> >> - Be sure I can shutdown array without any ill effect because check
> >> was interrupted.
> >>
> >> I guess that position will be cleared when array is stopped and
> >> started again, but I dont want to guess and experiment... :)
> >>
> >
> > You'd echo idle to the sync_action to pause/stop the check. If you want
> > to restart from the beginning next time, just echo 0 to sync_min
> > (similarly, if you just want to check/repair a specific range then set
> > sync_min and sync_max before the check/repair).
> >
> OK, thanks. So that should be fully working and correct way to do it
> and I cant harm my array by this in any way?
>=20
A check is always safe (well, excepting physical disk issues or issues
with overloading the I/O subsystem, but those are issues not limited to
check) as it's read-only.

The sync_min and sync_max values need to be multiples of the chunk size
(it throws an error otherwise), which ensures a whole stripe is being
checked/repaired (otherwise you could have issues).

The kernel documentation describes setting sync_min/sync_max, so it's an
expected operation. Whether there's another way of doing the same thing
I don't know - I've not heard of one though.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlQynskACgkQShxCyD40xBJI3QCeO4J8IJv4rUZLv09q15RCdMDH
5UIAn32NZNTwD9J0ps19n0UM57Qv4A7e
=bzgq
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
