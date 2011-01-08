From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?=
	<phcoder@gmail.com>
Subject: Re: Bug#597563: grub-common: grub-probe segfaults scanning lvm devices
Date: Sun, 09 Jan 2011 00:55:11 +0100
Message-ID: <4D28F95F.4090509@gmail.com>
References: <20100920202854.27101.8288.reportbug@cheetah.fastcat.org> <4D274FF9.8010004@gmail.com> <alpine.DEB.2.00.1101072241560.25170@cheetah.fastcat.org> <4D285B79.9040100@gmail.com> <alpine.DEB.2.00.1101081739500.14736@cheetah.fastcat.org> <4D28F48C.1030806@gmail.com> <4D28F58F.7000401@fastcat.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig62A84A63D98987118FE2EF6F"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D28F58F.7000401@fastcat.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matthew Gabeler-Lee <cheetah@fastcat.org>
Cc: 597563@bugs.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig62A84A63D98987118FE2EF6F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/09/2011 12:38 AM, Matthew Gabeler-Lee wrote:
> On 1/8/2011 18:34, Vladimir '=CF=86-coder/phcoder' Serbinenko wrote:
>> Sorry, I've noticed that I've looked into the wrong place all the long=
=2E
>> md2 is fine. I suppose it's a problem with md0 (all mdraid are assembl=
ed
>> at the beginning). Since md0 is raid1, its misassembly wouldn't have a=
ny
>> influence (we don't write to devices). mdstat lists both md0 and md1 a=
s
>> having no duplicate indices. I would need info on md0 for this (now
>> minor) remaining bug.
I have a hypothesis. Does last partition on any device span, s.t. it
leaves less than 64K after it until the end of device? If so then GRUB
sees the same metadata sector as the one at the end of device and as at
the end of partition. With 1.x metadata sector contains its own location
on the device. With 0.90 I can see no such field. Is there a way to
check for such condition with 0.90?

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko



--------------enig62A84A63D98987118FE2EF6F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk0o+WAACgkQNak7dOguQgnLqgD/WDmjE7uCa4ouxMkxvroMYEtE
nftIyRbBws+K4RZHNCYBAIHsBdlyqVJcalcsTGliG1eevoh2RdTcKdYbm/NDrRa8
=jBf8
-----END PGP SIGNATURE-----

--------------enig62A84A63D98987118FE2EF6F--
