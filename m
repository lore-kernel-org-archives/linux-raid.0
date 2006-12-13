From: Patrik Jonsson <patrik@ucolick.org>
Subject: Frequent SATA errors / port timeouts in 2.6.18.3?
Date: Wed, 13 Dec 2006 14:42:28 -0800
Message-ID: <458081D4.9060704@ucolick.org>
References: <4578F5D4.8080205@moniker.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD3C2CE5335F08A8A8C3327BC"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4578F5D4.8080205@moniker.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD3C2CE5335F08A8A8C3327BC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,
this may not be the best list for this question, but I figure that the
number of disks connected to users here should be pretty big...

I upgraded from 2.6.17-rc4 to 2.6.18.3 about a week ago, and I've since
had 3 drives kicked out of my 10-drive RAID5 array. Previously, I had no
kicks over almost a year. The kernel message is:

ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata7.00: (BMDMA stat 0x20)
ata7.00: tag 0 cmd 0xc8 Emask 0x1 stat 0x41 err 0x4 (device error)
ata7: EH complete
SCSI device sdc: 488397168 512-byte hdwr sectors (250059 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata7.00: (BMDMA stat 0x20)
ata7.00: tag 0 cmd 0xca Emask 0x4 stat 0x40 err 0x0 (timeout)
ata7: port is slow to respond, please be patient
ata7: port failed to respond (30 secs)
ata7: soft resetting port
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata7.00: failed to IDENTIFY (I/O error, err_mask=3D0x2)
ata7.00: revalidation failed (errno=3D-5)
ata7: failed to recover some devices, retrying in 5 secs
ata7: hard resetting port
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata7.00: failed to IDENTIFY (I/O error, err_mask=3D0x2)
ata7.00: revalidation failed (errno=3D-5)
ata7: failed to recover some devices, retrying in 5 secs
ata7: hard resetting port
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata7.00: failed to IDENTIFY (I/O error, err_mask=3D0x2)
ata7.00: revalidation failed (errno=3D-5)
ata7.00: disabled
ata7: EH complete


First I thought it was a cabling or card issue, because the same drive
got kicked twice. That drive was connected to a 2-port SIG sata_sil24
card. However, I just had another drive kicked that's connected to
sata_nv, which leads me to suspect that the upgraded kernel might have
something to do with it. A quick googling seems to indicate that others
are seeing this with 2.6.18, too, so I was wondering if anyone here
knows more.

I did at the same time also install an Areca ARC1260 controller and
connected a bunch of drives to it, so another idea I had was cable
interference or something (there are now 18 drives in the machine).

Any ideas or thought would be appreciated,

/Patrik


--------------enigD3C2CE5335F08A8A8C3327BC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFgIHZT+KvsdUW5p8RAp+1AJ9rvofKHD2o3mOMSOs3nv5UMznoHgCgrimQ
/UCU+QcKyyKOq4uVJLS4oZ4=
=KVkr
-----END PGP SIGNATURE-----

--------------enigD3C2CE5335F08A8A8C3327BC--
