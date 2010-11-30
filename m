From: Philip Hands <phil@hands.com>
Subject: Re: mdadm seems not be doing rewrites on unreadable blocks
Date: Tue, 30 Nov 2010 18:36:18 +0000
Message-ID: <8762vek6al.fsf@poker.hands.com>
References: <87oc98jgqb.fsf@poker.hands.com> <20101130115214.0b818e48@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101130115214.0b818e48@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Nov 2010 11:52:14 +1100, Neil Brown <neilb@suse.de> wrote:
> On Mon, 29 Nov 2010 15:23:56 +0000 Philip Hands <phil@hands.com> wrote:
>=20
...
> I assume you mean "RAID1" where you wrote "RAID0" ??

correct

...
> >   root#  dd bs=3D512 skip=3D19087681 seek=3D19087681 count=3D1 if=3D/de=
v/sdc of=3D/dev/sdb
> >   dd: writing `/dev/sdb': Input/output error
> >   1+0 records in
> >   0+0 records out
> >   0 bytes (0 B) copied, 11.3113 s, 0.0 kB/s
>=20
> You should probably had added oflag=3Ddirect.
>=20
> When you write 512 byte blocks to a block device, it will read a 4096 byte
> block, update the 512 bytes, and write the 4096 bytes back.

Ah, right -- I was wondering if something like that was going on.

That makes the behaviour much more understandable, thanks.

Looking further back into the logs, I've found quite a few instances of
"read error corrected (8 sectors at 167360736 on sdb4)" type messages,
so mostly md seems to be doing the right thing.

I'm still a little suspicious about the fact that I can make md read the
contents of the whole disk, while adding a third disk to the raid, and
unreadable blocks were being found, but not rewritten (the pending
sectors count ended up being 32)

Perhaps the disk's controller is just defective, but if that's not the
case it would seem that duff sectors were being found during the md
rebuild, but not all rewritten.

I've now added the disk back into the RAID1, and it's rebuilding, thus
overwriting the disk -- the pending sector count is dropping, so those
writes are at least pretending to work at present ... which is what
made me suspicious about the difference between just writing to the
disk, and letting md do it as a consequence of the read failing.

Is it likely that the disk is getting in such a strop that it first
refuses the read, and then ignores a write in a way that doesn't provoke
md into declaring the disk dead?

Still seems a bit odd to me, even if the disk is a bit broken.

Anyway, thanks for the insights.

Cheers, Phil.
=2D-=20
|)|  Philip Hands [+44 (0)20 8530 9560]    http://www.hands.com/
|-|  HANDS.COM Ltd.                    http://www.uk.debian.org/
|(|  10 Onslow Gardens, South Woodford, London  E18 1NE  ENGLAND

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJM9UQiAAoJENBLo6ABJdXA02oQAMaOiy/OnOlPCPyIUp22EqOD
Vqz3vDG12uQnOhypSo5kYdu21lwc/IpgLctElCKDzSeeXttD1DdvH6FZpMoHTH4S
XNNv/YTP+1UShTMRlMW2+G+vmcCcfadugXK0qA2ddN/vL5mxOqntcQzQUbYd2gZx
gIdppadcokQqppHM4Oj7/3kEelfzAzE0ii/KH+/BzmuUKl0VARMVsabC3sLYtfVR
KowJr+6Fzkig/Ewvxkim9zQfBQ0ABzmW3PPM/1si5Z27ey2RG+a/ZmGt3MXOS90m
cmQod2pcDKwaNnNUsNYvXy6WsJlPg75M7fVky7nwjxOcqtuuFPsuYGvS+pglcWqH
KR6qVq5q8lgiSNiN7y2IuPiakR+Jw+iJ8d1s26nnITo0PxBH+fCSPrXPm6oC8+U7
A4yJWmniLlGkVY1f44uaUzM0FwmViXSTfX0TjWh9sf8ofguBfU/h3H0bCMcFHmtW
vL+g7egfScw8QR3RNKLJnOP6903ZJWNBICWlLtz66yRnb8Ea+iJh1OeuwyCR+Oyl
ck0MO05wEuP0CbR4nID/E3CVOWLx9OxlGUPe3lln1SvV7yBJKTS31SCdgiSBDbzG
xBvC0F5EFYb4B3caEjBbN/HAagyKM6iL9n45PuB7nrU0HkGd7v3yVFvHU6dgNNz3
lDP6BnVQF+4GggFQI30J
=WWWG
-----END PGP SIGNATURE-----
--=-=-=--
