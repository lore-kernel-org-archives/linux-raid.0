From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Backups using RAID1
Date: Thu, 20 Nov 2008 09:08:26 +0000
Message-ID: <20081120090826.GA28736@cthulhu.home.robinhill.me.uk>
References: <c268e4660811170713y64b2a707p2d0fcfbca0b0d1c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c268e4660811170713y64b2a707p2d0fcfbca0b0d1c6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Nov 17, 2008 at 07:13:07AM -0800, Drew wrote:

> Hi there,
>=20
> In recent months I've been exploring low cost solutions for backing up
> the data on my home media server. I already run three raid-1 arrays on
> this rig to protect against drive failures and a fellow linux user
> suggested I consider using the existing raid, just yank the 'backup'
> disks as needed, and drop in fresh disks to replace the yanked unit.
>=20
> I realize I'm treading on unsupported ground here but what suggestions
> can people give me to minimize the risk of data loss?
>=20
Firstly, a disclaimer - I've not tried this myself, so there's no
personal experience behind these suggestions.

Ideally you should unmount the array before failing & removing the
drive.  If this is not possible then pick a time when the IO is likely
to be low - there's always going be a risk of corruption (especially
with something like a database), but modern journalling filesystems
usually cope with this okay.

As has been said elsewhere, you can have more than 2 disks in a RAID-1
array so don't leave yourself at risk by having a single disk in the
array.  Whenever you want to do a backup, add in the new disk and, once
it's been fully synced, fail & remove it (or leave 3 disks in the array
& just pull one when you want the backup, replacing it with another).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkklKQoACgkQShxCyD40xBLJMgCdHQ3g1dufcRUFiiTABxu9/4V5
OP8AnR47gdr8y24VOuAqIOhWC+68AtLm
=YhKm
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
