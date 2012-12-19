From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: how to proceed with possible corruption
Date: Wed, 19 Dec 2012 22:30:09 +0000
Message-ID: <20121219223009.GA12347@cthulhu.home.robinhill.me.uk>
References: <1355951195.12402.33.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1355951195.12402.33.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Dec 19, 2012 at 01:06:35PM -0800, Ross Boylan wrote:

> Short version: I suspect some of my array components may be corrupt, and
> wonder what the best way is to  check for it and fix it.
>=20
> I have a VM  configued similarly to my real machine for testing.
> When I brought it up there were some complaints about the arrays and
> needing to resync them.  While the sync appeared to complete
> successfully, the VM was quite unstable afterwards, as it had not been
> before.
>=20
> The VM was most likely shut down abruptly when the real machine had a
> power failure.  Also, I had added a 3rd disk to my RAID-1 arrays since I
> last booted the VM, but my mdadm.conf had -num-devices=3D2 (which we have
> already established is a recipe for trouble).
>=20
> I installed a new kernel in the VM, and have not had problems since.  So
> I wonder if some of the kernel files got corrupted, and more generally
> if the virtual disks are trustworthy.
>=20
> Does this /proc/mdstat offer any clues about which disks might be a
> problem?
>=20
> Personalities : [raid1]
> md0 : active raid1 sda1[0] sdc1[2] sdb1[1]
>       96256 blocks [3/3] [UUU]
>=20
> md1 : active raid1 sdb3[0] sdc3[2] sda3[1]
>       8187712 blocks [3/3] [UUU]
>=20
> unused devices: <none>
>=20
> It seems odd the disks are out of order, that is not sda, sdb, sdc.
>=20
> I know I could fail some components and add them back to assure
> consistency, but this wouldn't tell me if they were inconsistent before
> that.  There's also the possibility they are  consisstent but corrupt.
>=20
The arrays are RAID1, so the order of the disks is irrelevant - they
data should be identical on all disks.

You can check whether the disks are all in sync by doing:
    echo check > /sys/block/mdX/md/sync_action

Once the check is complete (you can see the progress via /proc/mdstat)
then /sys/block/mdX/md/mismatch_cnt will indicate whether or not there
are any mismatches. If so, use "repair" instead of "check" in the above
command to resync the drives.

Otherwise, the issue could be filesystem corruption. A "fsck -f" on the
array should detect that.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlDSP/AACgkQShxCyD40xBL0JACfWgtxGwYt0hjnsRC3GaPqrp3i
97UAoKVt0SxKw7o4G4EKodUmiMtH2zsJ
=dQL4
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
