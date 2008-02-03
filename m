From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID needs more to survive a power hit, different /boot layout
	for example (was Re: draft howto on making raids for surviving a
	disk crash)
Date: Sun, 3 Feb 2008 20:01:50 +0000
Message-ID: <20080203200150.GB22004@cthulhu.home.robinhill.me.uk>
References: <47A612BE.5050707@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47A612BE.5050707@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Feb 03, 2008 at 01:15:10PM -0600, Moshe Yudkowsky wrote:

> I've been reading the draft and checking it against my experience. Becaus=
e=20
> of local power fluctuations, I've just accidentally checked my system:  M=
y=20
> system does *not* survive a power hit. This has happened twice already=20
> today.
>
> I've got /boot and a few other pieces in a 4-disk RAID 1 (three running,=
=20
> one spare). This partition is on /dev/sd[abcd]1.
>
> I've used grub to install grub on all three running disks:
>
> grub --no-floppy <<EOF
> root (hd0,1)
> setup (hd0)
> root (hd1,1)
> setup (hd1)
> root (hd2,1)
> setup (hd2)
> EOF
>
> (To those reading this thread to find out how to recover: According to=20
> grub's "map" option, /dev/sda1 maps to hd0,1.)
>
This is wrong - the disk you boot from will always be hd0 (no matter
what the map file says - that's only used after the system's booted).
You need to remap the hd0 device for each disk:

grub --no-floppy <<EOF
root (hd0,1)
setup (hd0)
device (hd0) /dev/sdb
root (hd0,1)
setup (hd0)
device (hd0) /dev/sdc
root (hd0,1)
setup (hd0)
device (hd0) /dev/sdd
root (hd0,1)
setup (hd0)
EOF

>
> After the power hit, I get:
>
> > Error 16
> > Inconsistent filesystem mounted
>
> I then tried to boot up on hda1,1, hdd2,1 -- none of them worked.
>
> The culprit, in my opinion, is the reiserfs file system. During the power=
=20
> hit, the reiserfs file system of /boot was left in an inconsistent state;=
=20
> this meant I had up to three bad copies of /boot.
>
Could well be - I always use ext2 for the /boot filesystem and don't
have it automounted.  I only mount the partition to install a new
kernel, then unmount it again.

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHph2tShxCyD40xBIRAsLzAJ93c/0vnygJIel6s0KGrLT2+NLkiQCeLzif
u5VAnQEwpARNZYN9RYRgQJk=
=fKVr
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
