From: Andre Noll <maan@systemlinux.org>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Wed, 18 Mar 2009 13:35:25 +0100
Message-ID: <20090318123525.GK17185@skl-net.de>
References: <87ljr4hsk9.fsf@frosties.localdomain> <20090318121825.GL32416@skl-net.de> <49C0EA5F.9070901@vshift.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V2Kn1ZfDiPlyQ6Qk"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49C0EA5F.9070901@vshift.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ruslan Sivak <russ@vshift.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--V2Kn1ZfDiPlyQ6Qk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08:34, Ruslan Sivak wrote:

> I would guess the reason is that it doesn't make sense.  As mentioned, if
> you are going to create a 3 disk raid 6, it's essentially a raid1 over 3
> disks, at which point you are better off with the raid-1.  I don't think
> there's a raid controller that would let you set something like this up, I
> don't see why the softraid should.

Well, Goswin mentioned some pretty good reasons I think.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--V2Kn1ZfDiPlyQ6Qk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJwOqNWto1QDEAkw8RAugoAJ9QAaEo80QvEpf7RqtO4yVCME6DxwCeIm5p
yzc5V+jRkg+5ouMXRRjfwjY=
=s9Uu
-----END PGP SIGNATURE-----

--V2Kn1ZfDiPlyQ6Qk--
