From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Best way to re-format RAID1 disks
Date: Thu, 26 Mar 2009 18:23:00 +0000
Message-ID: <20090326182300.GA18434@cthulhu.home.robinhill.me.uk>
References: <26c008d70903260410y22c8af1ocf00138a1ff6a2b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <26c008d70903260410y22c8af1ocf00138a1ff6a2b6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Mar 26, 2009 at 12:10:35PM +0100, Federico wrote:

> Hi all,
> I've two disks in RAID1 formatted with reiserfs which, in my system,
> has  amazingly poor performance... I want to switch to ext3 and in a
> couple of kernel releases to upgrade to ext4.
> This is my plan:
>=20
> 1 - Remove one disk from the array
> 2 - Format the removed disk with ext3 filesystem
> 3 - Copy all the data from the degradeted RAID to the newly ext3-formatte=
d disk
> 4 - Create a new degradeted RAID1 with the ext3 disk
> 5 - Modify grub and reconfigure mdadm to boot in the ext3 RAID1 disk.
> 6 - Reboot.
> 7 - Reformat the reiserfs disk
> 8 - Add the formatted disk to the ext3 RAID and start to syncing.
>=20
> Is there a more easy and failproof method?
> I'm a bit scared to lose same (or all) of my data during the process...
> Thank you for your help :P
>=20
You've got a lot of steps in the wrong order here.  It also sounds like
the array is your root/boot partition?  If so, you'll have to do this
all offline, as the copy won't get everything on a running system.

My suggestion would be to firstly make sure you have a working bootable
CD you can do the migration from (and so you can attempt some recovery
if needed) - my choice would be GRML, but pretty much any live CD will
do.

I'd recommend also booting from CD and running some (read-only) disk
checks (badblocks, SMART tests, dd) first to try to reduce the risk of
later disk failure and data loss.  If the array _is_ your root device
(or can't be mounted read-only when you're running normally) then you'll
need to do the whole process from the live CD.

Your process is going to be:

1 - Mount the array in read-only mode.
2 - Remove one disk (disk B) from the array (leaving disk A in the
    array).
3 - Erase the superblock on disk B.
4 - Create a new (degraded) array containing only disk B.
5 - Format the array as ext3.
6 - Mount the new array in read-write mode.
7 - Copy all the data from the old array to the new one.
8 - Verify the data (i generally use MD5).
9 - Unmount the old array.
10 - Stop the old array.
11 - Erase the superblock on disk A.
12 - Add disk A into the new array.
13 - Update /etc/fstab and /etc/mdadm.conf
14 - Once the sync is complete, update grub (you'll need to rerun the
     setup, not just update the menu) and reboot.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAknLyAQACgkQShxCyD40xBKYYgCgikFCyI7XEUNP47hWUr4ihLtI
tSEAnRchWykwh7F4Xjelx00Uru7BMPX6
=vVnW
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
