From: Frank Wittig <fw@weisshuhn.de>
Subject: Re: RAID design decisions
Date: Sun, 18 Dec 2005 13:43:29 +0100
Message-ID: <43A55971.9070206@weisshuhn.de>
References: <17315.27096.325885.788363@smtp.charter.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6F8BA2DD59EE928A34A0647C"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17315.27096.325885.788363@smtp.charter.net>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6F8BA2DD59EE928A34A0647C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi John,

you described exactly my favourite disk setup as I prefer since I tested
several different setups with and without LVM2.

John Stoffel wrote:

> 2. mirror my /, swap and /boot partitions for reliability
> 	- requires mkinitrd to work well and easily for new kernels.
> 	- requires I don't screw up my current setup when I try this.

I use Fedora rather than Debian but I think there're only marginal
differences in RAID/LVM-Setup.

My preferred disk setup for server systems is this:
- all disks which are part of the system raid contain a first partition
of 256MB size - these partitions build up a RAID1 which holds /boot.
- on all disks with a boot-partition a Grub is installed into MBR so
each of this disks can replace the first in case of failure
- the rest of the system disk space goes into on large LVM2 vg which
holds all system partitions and swap
- if I need extra disks for e.g. postgresql database space I set up a
second volume group which contains data partitions
- I use XFS or JFS for all partitions since these are growable without
unmounting them (i resized both partition types during high disk load
without any problems)

Greetings,
Frank

--------------enig6F8BA2DD59EE928A34A0647C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFDpVl1x6tzaD9P7mkRAvT/AJ9w8FEdfNcckMulgT7ku4aXLbzBWwCcDWvO
y7BOiXXEWXeipDJSqyQQ3zk=
=XYM2
-----END PGP SIGNATURE-----

--------------enig6F8BA2DD59EE928A34A0647C--
