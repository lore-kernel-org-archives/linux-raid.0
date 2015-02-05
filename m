From: NeilBrown <neilb@suse.de>
Subject: Re: unsynchronized raid10 with different events count
Date: Thu, 5 Feb 2015 15:52:52 +1100
Message-ID: <20150205155252.053096e9@notabene.brown>
References: <2049102750.36641422714825909.JavaMail.root@shiva>
	<850189010.36671422720846038.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/xtiSFwY6bJBynDGtUApBxpR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <850189010.36671422720846038.JavaMail.root@shiva>
Sender: linux-raid-owner@vger.kernel.org
To: LuVar <luvar@plaintext.sk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/xtiSFwY6bJBynDGtUApBxpR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Jan 2015 17:14:06 +0100 (GMT+01:00) LuVar <luvar@plaintext.sk>
wrote:

> Hi,
> finally,
> I have run --re-add thing. It seems that it is what I wanted. My array is=
 now OK.
>=20
> So only one question remains. Is there any possibility to make improvemen=
ts and make array autoassemble if there are clear that in raid10, there is =
consistent highest events count for at least one drive for raid1 subparts? =
I have layout=3Dn3 for situations when one drive fails, to be able to corre=
ctly recover from others two same copies and to know that given data are pr=
obably ok if they are same.

It appears from the mdstat you posted:

Personalities : [raid10]=20
md3 : active raid10 sdj[9] sdl[13] sdm[6] sdi[3] sdb[10]
      937709952 blocks super 1.2 128K chunks 3 near-copies [9/5] [U_UU__UU_]
      bitmap: 4/7 pages [16KB], 65536KB chunk

unused devices: <none>


That it *did* autoassemble and provide you with a working array.  It just
didn't include all the devices - because some of them looked old and mdadm
couldn't be sure they were reliable.

You did the correct thing to --re-add them.  That is how you tell mdadm
"these devices are reliable, even though someone went wrong before and they
didn't get updated with the latest event count".

So it appears to me that everything is working correctly.

NeilBrown

--Sig_/xtiSFwY6bJBynDGtUApBxpR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNL3JTnsnt1WYoG5AQLhDA/+KLX70U7xsTw55PgR6I6DcTDJHp4o1JDB
3RapA14P+HqX+Sr1aKgwWhgell2UX1xvl/fWpj7jhurffnicqLwYJza52y4uOv/X
ews5Mn2VdGYwt8a5ULVVYTuxkUlA0gqyjrJea24VhBcu+zeGG2pd7ObkTkhJ901a
zsD0GqT2hbqThblx5WIMmTgZwtiEa8y0tpjrrUWRTviaJg+lbn4D1GxwbylNJcHh
+3SafIH98roirTzMpT52TulnscqqzBEFs+KW6QDo9oc1LSGJLC1Tc3gnNVKTFCvC
5GmLawgVQe9Uc4B8tg5paD60aNHpNArVXsuT4rXony+zGzIok0s6DmipYCGe2vh4
wS/oHmTR518ISN3jxHd/UqF/jrtCyca4SMsnbuid4MO5EeiTBqZWY87dkOLPAVxC
+c/nTV7sqtwnF0l4ee0PSMg9GSo+rzglsRbyAkkU9ibaoTpz9Ww/+nT9M8Gh4BLc
15YjI8AgtETHw1ywyo961MzQ3YZkzeM/9PFw9AUf0LXt4DaBepIUuXQu7BOi8EY0
iNvk7+ZoGOxeIyxyoBe8gWzCl+Ed9j/8fxY44pl1O5OUpdNWBgEPFnicdHburSbD
iYUYQaudE9TnycjywdaIL2D31JkHwxV+caI5ARsq7PlzFPq9GC3a6qLb6zmf7Gzi
dtOK/N1N4AE=
=BGoN
-----END PGP SIGNATURE-----

--Sig_/xtiSFwY6bJBynDGtUApBxpR--
