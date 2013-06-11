From: Richard Laager <rlaager@wiktel.com>
Subject: Prevent Autodetection
Date: Tue, 11 Jun 2013 04:36:22 -0500
Message-ID: <1370943382.26636.39.camel@watermelon.coderich.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-cZfiYNgI42P8IWRYvjqI"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-cZfiYNgI42P8IWRYvjqI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have a virtualization host running on an MD root filesystem. I also
have two whole disks allocated to a virtualized guest which is doing an
MD RAID1. The host is seeing the array (i.e. it shows up
in /proc/mdstat). I'd like to prevent this, if for no other reason than
if there's a problem with that array, it prevents (or at least delays)
booting the host.

I've tried setting "AUTO +1.x homehost -all" "AUTO homehost -all" and
even "AUTO -all" in /etc/mdadm/mdadm.conf. I'm updating the initrd and
rebooting after each change. I've tried "msdos" as well as GPT labels on
the disks used by the guest. In every case I've tried, it's still
imported.

I'm running Ubuntu 12.04 "Precise" on both the host and the guest.

$ uname -a
Linux HOSTNAME 3.2.0-45-generic #70-Ubuntu SMP Wed May 29 20:12:06 UTC
2013 x86_64 x86_64 x86_64 GNU/Linux

$ mdadm --version
mdadm - v3.2.5 - 18th May 2012

Does this suggest the initrd scripts are broken on Ubuntu, am I doing
something wrong, or is it just not possible to prevent this
autodetection?

Thanks for any insight you can provide!

--=20
Richard

--=-cZfiYNgI42P8IWRYvjqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlG275YACgkQbfU6uV4fG85jlgCdG1LLdWcu9DJchbhyaUz3c2cB
sM8AnRwJKomxyG8Y0V91nt0ho8lLy6ky
=qO9q
-----END PGP SIGNATURE-----

--=-cZfiYNgI42P8IWRYvjqI--

