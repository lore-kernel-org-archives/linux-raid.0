From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: mdadm dropped disk, won't re-add
Date: Wed, 15 Feb 2012 14:45:36 +0000
Message-ID: <20120215144536.GC18336@cthulhu.home.robinhill.me.uk>
References: <1329314322.3574.16.camel@z6>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1329314322.3574.16.camel@z6>
Sender: linux-raid-owner@vger.kernel.org
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Feb 15, 2012 at 02:58:42PM +0100, John Paul Adrian Glaubitz wrote:

> Hello,
>=20
> I have a rather big problem with my Linux software RAID5.
>=20
> It consists of 4 SATA disks each 1 TB in size, resulting in a 3 TB RAID5
> volume (/dev/md0 assembled from /dev/sd{b,c,d,e}1.
>=20
> Today, mdadm kicked disk sde1 from the RAID since the cable seemed to
> make problems. I shutdown the machine, replaced the cable and tried
> re-adding the disk, however, mdadm refused to add the drive.
>=20
> So I re-partioned sde1 and added it as a new devices, mdadm instantly
> started rebuilding the raid. Unfortunately, during the rebuild, mdadm
> decided to kick sdc1 and I have now ended up with two drives failing.
>=20
> I have tried re-adding sdc1 with the --re-add command, but mdadm again
> refuses to re-add the drive.
>=20
That's a safety measure. If it can't actually re-add the drive then it
fails, rather than changing to do an --add instead (as older mdadm
versions did), potentially losing data.

> I haven't changed anything since as I don't know what to do further. I
> don't want to make any further damage to the raid and hope that someone
> knows how to restore it.
>=20
> My primary question is whether mdadm actually deletes any important data
> on the remaining disks (sd{b,c,d}1) while rebuilding or whether it just
> writes data to the newly added disk sde1.
>=20
It just writes data/checksums to the newly added disk. The only writes
to the remaining disks will be if other applications are writing to the
array during the rebuild process.

> mdadm is version 3.2.3, kernel is Linux 3.2.0 on Debian Wheezy.
>=20
> Can anyone give further advise?
>=20
What errors does dmesg give about why sdc1 was failed? You'll need to
fix that before you try recovering the array. If it's a drive error then
using ddrescue to clone it (or as much of it as possible) to sde1 would
probably be your best bet, then get a replacement drive.

Once you've fixed that issue then you should be able to force assemble
the array (mdadm -S /dev/md0; mdadm -Af /dev/md0) and continue/restart
the recovery process. I'd recommend doing a fsck on the filesystem
afterwards as well, especially if you've replaced sdc.

If the force assembly fails then try it with added verbosity (mdadm -S
/dev/md0; mdadm -Afvvv /dev/md0) and post the output from that (and from
dmesg) and hopefully someone will be able to figure out what's going
wrong.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk87xQ8ACgkQShxCyD40xBKKwwCgr6f9s8KBq/vobAz1omzHFbeY
3zgAnjy/QQ2vTXpgU3aPYys+0pfttTIx
=jUv2
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
