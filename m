From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Formatting Raid5 device as NTFS
Date: Thu, 17 Sep 2009 21:02:29 +0100
Message-ID: <20090917200229.GA19611@cthulhu.home.robinhill.me.uk>
References: <f5d1f90a0909171223h684e5f65k405fa319ab6be8d9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f5d1f90a0909171223h684e5f65k405fa319ab6be8d9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Sep 17, 2009 at 12:23:22PM -0700, Linux Raid Study wrote:

> Hello:
>=20
> I have to bundle 4 disks as a Raid5 device, export it to iSCSI
> initiators and format it as NTFS.
>=20
> What is better:
> - Format individual disks as NTFS and then bundle them as Raid5 device
> and export to initiator PCs
> - Or bundle the disks first as Raid5 dev, export them and then format
> the /dev/md0 device as NTFS
>=20
> I get "write-protected" errors when I do the second option. Does it
> mean formatting of raid5 device is not allowed?
> Does Raid5 inherit the NTFS properties of individual disks (first option)?
>=20
I don't see your first option working at all.  When you bundle the
drives together, the resulting device will have totally scrambled the
underlying NTFS filesystems.

The second option is how md RAID is supposed to work - you bundle
together the disks into a single array, then format that.  Where are you
getting the "write-protected" errors?  Are you trying to format the
exported iSCSI device from a remote system?  Certainly the RAID device
can be formatted directly, but I've no idea how the iSCSI affects
things.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqyldUACgkQShxCyD40xBIHRACfeE+GfSAsKxs2dAad0Vpi03Yu
phQAoMWn04AW0b64Wlb7L9/9RIfkF0GM
=/58P
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
