From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/2] Fix sign extension of bitmap_offset in super1.c
Date: Thu, 26 Apr 2012 11:35:51 -0400
Message-ID: <4F996B57.2050309@redhat.com>
References: <1335453177-8515-1-git-send-email-Jes.Sorensen@redhat.com> <1335453177-8515-2-git-send-email-Jes.Sorensen@redhat.com> <4F99674B.7070900@redhat.com> <4F996800.2050603@redhat.com> <4F9968F0.30805@redhat.com> <4F996A94.3060509@twiddle.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC154C0C50905C162CC35A697"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F996A94.3060509@twiddle.net>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Henderson <rth@twiddle.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, neilb@suse.de, joe.lawrence@stratus.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC154C0C50905C162CC35A697
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/26/2012 11:32 AM, Richard Henderson wrote:
> On 04/26/12 08:25, Jes Sorensen wrote:
>> Just checking mdadm.h and bswap32() is defined like this:
>>
>> #define bswap_32(x) (((x) & 0x000000ffU) << 24 | \
>>                      ((x) & 0xff000000U) >> 24 | \
>>                      ((x) & 0x0000ff00U) << 8  | \
>>                      ((x) & 0x00ff0000U) >> 8)
>>
>> so I am not 100% sure just swapping to an s32 in the struct will work =
on
>> big endian systems? Will the 0x000000ffU not force the conversion back=

>> to unsigned or what happens in this case?
>=20
> This is actually semi-complicated.  c89 or c99 rules?  X already of a
> type larger than unsigned int?
>=20
> But if X is signed int, this entire expression will always be unsigned.=

>=20
> You're certainly better off with a cast as we discussed on irc.

Answering this question is beyond my bitfield/bigendian/littleendian
foo.  So nice to have Richard around ;-)


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enigC154C0C50905C162CC35A697
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPmWtXAAoJELgmozMOVy/d9JAP/iD1Nl6kVvRe7vCEOkgMW6Lv
kwMhnNomi7IKQzm3VozSeawtHeIRpF1CPXakH5/tN0eRLZomOzlqbqrXwQY4AZbZ
nyu79n5ESYJlbzineZ3lHA9gyMRz41U7F7gzFT6yQRL7b0D/17/9njaNWaZ141/9
hss3NFNVBtiMxUl2BPBmF5kex373ofV377hP6y3PlvGuga/A2mOScamAFLMiferF
LwJmOAsikRESjGA/UuT2rqTK2f3LkA2Nst01kQqcbVXA6oJH06dTQPQgFSfJj+I+
/PSMq92svnKRWmoARZyBcvnXkOC8FIxjarMORfAOJMy2Q4ejkoM9jzDYpdafjp6/
7N1XYtSCPb1PnbZYxgeqdtSgiQrb8KD8ZxoOIn5vI0SUE4hdQkFTy7OnhOfVEu3D
BBe+gDwowA8vOMBSj8iozUBpwPoJCNk/UImst8Hq48xBRlRTgCzTcdGdg67+3Lyz
/JYDz+j2r8zzUnywe5MNIvELknwJZu6Bv34+TvItp1ZRfXi7p/A+jvVhYA4H9Z9f
ZeRiPcRqbK2BYenz5lBg3oS8pi0BlEbNgZ5FXFc1QeOgdQfUCTYcE/Mpu6cleBdi
savAIIf7XJh3O9rZ2HFBn+Ye+AR+vg7n8nKKf2F31Io/rAfR14Ppvy/BBLIZexn9
ZUwbKeg6k0w1bOvFOQY9
=MGdW
-----END PGP SIGNATURE-----

--------------enigC154C0C50905C162CC35A697--
