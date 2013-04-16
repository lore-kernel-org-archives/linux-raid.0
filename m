From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Question about resync in RAID5
Date: Tue, 16 Apr 2013 11:24:52 +0100
Message-ID: <20130416102452.GC25795@cthulhu.home.robinhill.me.uk>
References: <1366106560-12957-1-git-send-email-robin.k.dong@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1366106560-12957-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Apr 16, 2013 at 06:02:40PM +0800, Robin Dong wrote:

> Dear Raid experts,
>=20
> I have a soft RAID5 volume and after one disk failed I replaced it with
> a new hard-disk. Then the raid5 volume begin to resync with WHOLE new
> disk.
> There is only 1G data in the RAID5 volume so I think resync whole disk
> is not efficient.
> Take ZFS for example, when replacing with a new disk, it only resync the
> data which are written after the creation of the volume.
>=20
> Is there any method to just resync WRITTEN data to new-added-disk ? Or
> any developing plan to add this feature?

No, because md is a block device it has no knowledge of what data has
actually been written to the disk or where it is stored. This means it
has to rebuild the entire disk.

There are plans to improve this by keeping track of which stripes have
been written to, which should help (and will also mean no need for an
initial RAID sync). I don't know whether this has progressed beyond the
idea stage yet though.

The alternative is to use a filesystem which incorporates RAID, hence
knows what needs keeping in sync (ZFS, possibly btrfs - I don't know
where they're up to with that).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlFtJvQACgkQShxCyD40xBKUVQCgh04aTOJE7x1JwRU3GOHnm+ow
JbAAniDY+ZBPSWsw/GLZfN+PwCFFbB9s
=J9Vt
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
