From: martin f krafft <madduck@madduck.net>
Subject: zeroing superblocks on running systems
Date: Sat, 8 Nov 2008 20:27:16 +0100
Message-ID: <20081108192716.GA16878@piper.oerlikon.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

I just pulled up a new machine and initially had /dev/sd[ab] as the
source of a giant md device to serve as physical volumne in an LVM2
volume group, but then grub2 didn't managed to obtain my trust and
I created /dev/sd[ab]1 as /boot and /dev/sd[ab]2 for the md device
instead.

Unfortunately, I forgot to zero the superblock on /dev/sd[ab], so
now when I call mdadm -Es, it tells me about three arrays, when
I really only have two.

But I also cannot zero the superblock while the machine is running:

  khyber:/boot# mdadm --zero-superblock /dev/sda
  mdadm: Couldn't open /dev/sda for write - not zeroing

I cannot take it down. Is there any other way in which I could
destroy the obsolete superblocks on /dev/sd[ab]?

Thanks,

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
review of a chemistry paper:
  "paper should be greatly reduced or completely oxidized."
                                                    -- frank vastola
=20
spamtraps: madduck.bogus@madduck.net

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkV6A0ACgkQIgvIgzMMSnWXnQCgvUnSuWTS30vNXIT3GZNWH1RC
UFQAoMi82yIQi3CKpTMBG4Za16X46GFY
=IJbZ
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
