From: NeilBrown <neilb@suse.de>
Subject: Re: not enough operational mirrors
Date: Mon, 22 Sep 2014 15:47:17 +1000
Message-ID: <20140922154717.6cd3cab2@notabene.brown>
References: <CANs+QMzWWqh-5MemOrbguaq7fNzJPDaYUH66K0rgGrnaXY7FNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/rpiHfABrRb6/3I1mMI2TaDz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANs+QMzWWqh-5MemOrbguaq7fNzJPDaYUH66K0rgGrnaXY7FNA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Young <ian@duffrecords.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/rpiHfABrRb6/3I1mMI2TaDz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 21 Sep 2014 22:32:19 -0700 Ian Young <ian@duffrecords.com> wrote:

> My 6-drive software RAID 10 array failed.  The individual drives
> failed one at a time over the past few months but it's been an
> extremely busy summer and I didn't have the free time to RMA the
> drives and rebuild the array.  Now I'm wishing I had acted sooner
> because three of the drives are marked as removed and the array
> doesn't have enough mirrors to start.  I followed the recovery
> instructions at raid.wiki.kernel.org and, before making things any
> worse, saved the status using mdadm --examine and consulted this
> mailing list.  Here's the status:
>=20
> http://pastebin.com/KkV8e8Gq
>=20
> I can see that the event counts on sdd2 and sdf2 are significantly far
> behind, so we can consider that data too old.  sdc2 is only behind by
> two events, so any data loss there should be minimal.  If I can make
> the array start with sd[abce]2 I think that will be enough to mount
> the filesystem, back up my data, and start replacing drives.  How do I
> do that?

Use the "--force" option with "--assemble".

NeilBrown

--Sig_/rpiHfABrRb6/3I1mMI2TaDz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVB+35Tnsnt1WYoG5AQLntg/8CEfNSaqpCpaeAx/GVHRwWWG3gU7VjHCL
OiwoCmKcwLdMg3YJm/o+ijv8AtOcxyQHJ5HLbMuMdr9dS2Ni1Xw0JWiuyh7YxwXm
Y9pI+aIbCAedsU2+ZfB3b9aS0Qgqo9waclb9w2Kz3AvqcM+EaEFG3Y5eg3Oy1bGt
tA9R9tP/meNAT5O72BTZmjH6iHKph3GAB9DQnjL5DOBGKsB5Mvwq11c0o1/TtX2q
mAJviFJqKRTfNmKZ1rd9uHeheE6kr1g8uBCMuhSk+vNzfm+yja9mfj7m3MXNIeAL
Ri9tmQ4rC1u+a/HtvQCPX8XaN14zjC+irfp8VRCnZEWLDxCdG9xWl2y+19Zn3AUw
iElf+EpW78yzbl/K9dy9yaIlwGYbd0uzLoEj3i2nT2uzGi/2+N1kPRHwDPogNlSe
3Trd6LgnOh2u1SKyGEDRELzOz84STHDBl6D9f5enCNGxzHaZrALxYUnqXh8UR//f
Vsp+eAS8tgjCYIV+qkR6Y5fGIU4li4bV6lRy5GwMvJTEZyDipgNxSRMyPFHJKG7a
4BduzsiK+rYsX/fzrp1hTWAfe6HPTqJeOmfK470lfqrl4Zj8YS4pWp1A2QtaYpOi
TEgHFfykSHeuExQ7uHVLNSjD7dZoeKsXmcgiT/WY+qyU9dRPC1w8wP0aKjygJCQG
MHSln5rY8p0=
=G2gd
-----END PGP SIGNATURE-----

--Sig_/rpiHfABrRb6/3I1mMI2TaDz--
