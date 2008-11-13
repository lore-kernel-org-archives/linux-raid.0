From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Superblock limits / conversion
Date: Thu, 13 Nov 2008 15:12:06 +0000
Message-ID: <20081113151206.GB25751@cthulhu.home.robinhill.me.uk>
References: <7d86ddb90811130646k440676aakecc62defc8d42b7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7d86ddb90811130646k440676aakecc62defc8d42b7a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Nov 13, 2008 at 09:46:23AM -0500, Ryan Wagoner wrote:

> I have a RAID 5 array with 3 TB drives. When reading through the list
> I realized that the v0.90 superblock doesn't support arrays over 2TB.
> This means I can never grow this array to 4 drives?
>=20
That's my understanding, yes.

> Is there a way to convert to the v1.0 superblock? I realize I can't
> convert to the v1.1 or v1.2 without recreating the array. Is there any
> advantages over the v1.1 or v1.2 formats with their placement of the
> metadata not at the start of the device?
>=20
There's no way to convert superblocks as such.  With both the 0.90 and
1.0 superblocks being at the  end of the disk, you could probably
recreate the array without losing data though - you may need to shrink
the filesystem in case the 1.0 superblock uses more space than the 0.90
(and I'd definitely test this with loopback devices first).

> I read that the kernel autodetect will not work with v1 superblocks. I
> have my mdadm.conf correctly configured. When booting this should be
> all I need for the array to be assembled? Out of curiosity can v1
> superblocks work on the /boot or / array? I would assume not because
> it would need to be auto configured before the mdadm.conf could be
> read.
>=20
If this is not the / array then the init scripts should assemble it from
the mdadm.conf file.  You can use 1.x superblocks for /boot anyway (as
that's not accessed during boot outside of the bootloader, and that
needs to access the raw disks anyway), and for / if you're using an
initrd (which will contain the mdadm.conf and assemble the array before
switching root).

> Also "v1 supports restarting driver recovery that was interrupted by a
> clean shutdown.". Does this mean that a initial resync or recovery
> will continue and not restart when rebooting?
>=20
Not sure on this one, I though all versions would continue (if using a
bitmap).

HTH,
    Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkcQ8UACgkQShxCyD40xBJeLgCgqh6XmCqLiQSkY7SpkUZu2og3
4NwAoKRxwnu7aoV741liFvYF3IU4rdkR
=e4ua
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
