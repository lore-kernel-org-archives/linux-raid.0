From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: Big Endian RAID discovery problem (metadata 1!)
Date: Wed, 28 Jun 2017 22:14:21 +0200
Message-ID: <10863311.m9o1njCPed@daneel.sf-tec.de>
References: <3667530.kn15F7ggIU@daneel.sf-tec.de> <AE3DE84B-9DF9-40DD-8DE2-1DD3D3CE3650@athompso.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5298997.4tV2lZqvNQ"; micalg="pgp-"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AE3DE84B-9DF9-40DD-8DE2-1DD3D3CE3650@athompso.net>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Thompson <athompso@athompso.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--nextPart5298997.4tV2lZqvNQ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Mittwoch, 28. Juni 2017, 13:55:09 schrieb Adam Thompson:
> If you search the archives, I had a very similar problem a few months ago.
> There is already an option to mdadm to update a v1 superblock in the wrong
> byte order.  It just wasn't obvious when looking at the mdadm man page.
> Going from memory, search for "byte order" instead of "endian" to find the
> option. -Adam

If you refer to --update=byteorder, the documentation says it is only for 
v0.90 metadata. Also it's only the super_offset field so far, other fields like 
magic are correct.

Greetings,

Eike
--nextPart5298997.4tV2lZqvNQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAllUDh0ACgkQXKSJPmm5/E6ZigCeIaW9yKp52PSgqEIHSnY4+8fc
FN0An3IVjdiElxYCtcTD6VkepqlKtwB1
=sGOv
-----END PGP SIGNATURE-----

--nextPart5298997.4tV2lZqvNQ--

