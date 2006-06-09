From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: Failed Hard Disk... help!
Date: Fri, 09 Jun 2006 16:44:22 -0700
Message-ID: <448A07D6.70103@ucolick.org>
References: <002801c68c1d$905a6020$7e0c10ac@enterprise.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig37D181E399543A356CBF8FB4"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002801c68c1d$905a6020$7e0c10ac@enterprise.local>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig37D181E399543A356CBF8FB4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

David M. Strang wrote:
> What options do I have to retreive the serial number without driving ou=
t
> to the datacenter and looking at the drive? Do I need to be afraid of
> upgrading my kernel and mdadm and having my superblock go poof?

pretty sure "smartctl -d ata -a /dev/sdwhatever" will tell you the
serial number. (Hopefully the kernel is new enough that it supports
SATA/smart, otherwise you need a kernel patch which won't be any better..=
=2E)

cheers,

/Patrik


--------------enig37D181E399543A356CBF8FB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEigfWT+KvsdUW5p8RAkfVAJ0Y7uoMSRZWXyT1mkzNQFclNuoQUQCeK+WM
E+xvPObXrlV6Sb4K34RBxec=
=uLRv
-----END PGP SIGNATURE-----

--------------enig37D181E399543A356CBF8FB4--
