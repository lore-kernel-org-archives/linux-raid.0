From: Andre Noll <maan@systemlinux.org>
Subject: Re: raid6 rebuild
Date: Thu, 5 Apr 2007 12:13:03 +0200
Message-ID: <20070405101303.GY4252@skl-net.de>
References: <20070404194638.GB3712@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sx3M3By4KbPIrykT"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070404194638.GB3712@xi.wantstofly.org>
Sender: linux-raid-owner@vger.kernel.org
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: mingo@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Sx3M3By4KbPIrykT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21:46, Lennert Buytenhek wrote:

> While my RAID6 array was rebuilding after one disk had failed (which
> I replaced), a second disk failed[*], and this caused the rebuild
> process to start over from the beginning.
>=20
> Why would the rebuild need to start over from the beginning in this
> case?  Why couldn't it just continue from where it was?

I think this is because an easier algorithm may be used to rebuild from
a one disk failure than what is needed in case of a two disk failure.
In case of a one disk failure you can simply do the following:

rebuild P or Q: Just recompute it from the data disks
rebuild data: xor remaining data and P as in raid5 (in fact, the raid5
code is used in this case)

It's only the rebuild from a two disk failure that requires deeper
and more expensive math.

So if a second disk dies during the rebuild, the raid6 code must
switch from the easy algorithm to the "difficult" algorithm to finish
rebuilding the first failed disk. Theoretically this could be done
on the fly, but I think the current code doesn't do this now.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Sx3M3By4KbPIrykT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGFMuvWto1QDEAkw8RAtLFAJ9kXM8CziFQyElybMOdsKJOLniIWACfSGn2
KNQCxbez5uT++vbxKvTIO8E=
=MTix
-----END PGP SIGNATURE-----

--Sx3M3By4KbPIrykT--
