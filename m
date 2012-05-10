From: NeilBrown <neilb@suse.de>
Subject: Re: Superblock backup
Date: Fri, 11 May 2012 08:50:57 +1000
Message-ID: <20120511085057.27790c1a@notabene.brown>
References: <20120510174431.GA3019@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kLWb2EMdFnvEJmFDzSLPJf="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120510174431.GA3019@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/kLWb2EMdFnvEJmFDzSLPJf=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 May 2012 19:44:31 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi,
>=20
> again, following the RAID-5 story, I was wondering
> if could make sense to have a new superblock type,
> let's say 2.x, having backup copies (of persistent
> or quasi persistent data) in different areas of the
> drive components.
> This would be similar to filesystem or gpt.
>=20
> Is there anything planned for this?

This is one of the idea that has floated around in my head for a while,
possibly a v1.3 metadata.

However my thought there was always to protect against a bad block on the
device.  Protecting against data corruption due to bugs or sys-admin mistak=
es
is always best handled by backups.
e.g. take a 'dump' (either binary or textual) of the metadata every day, or
every reboot or something. (And store it on a different host).

Both are probably useful, but for the recently problem, a regular backup
would be the most useful.

>=20
> In any case, it would be still interesting to have
> a "backup" capability at hand, like a "dd" of the
> superblock to some secure file.

"mdadm -E" would probably be enough - just write a cron job :-)

NeilBrown


>=20
> Any idea or suggestions?
>=20
> Thanks,
>=20
> bye,
>=20


--Sig_/kLWb2EMdFnvEJmFDzSLPJf=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6xGUTnsnt1WYoG5AQIScA//dTbkAugvU+KFlvUIZXNI+JqyOlV5n/Q9
AyXx7TWU8vOcB5V+jTV828/iun8KXfWTeMYU7Px5QNmAhIpobQqRh47JdwJDajxr
XXDMScIcI6OFTB1oUa9ycqV7P2mXNyIzAO3966oTTs/08qVQIYrpBAzjM5vX7M0O
U85O30iR1k34dk63OXak7rIPpc/HJevOD4bwEiIQxYi5R5hrVDR3AsdgevuZ2coj
9sChIoiHlJ9gSC81FYizqI4hc1nP8BGOofyyzBhvNSFTzQCIeKQEFXXCf5rL8O0T
jcKie+7JS/N28ZlFXH+Hrb5RW9gNGOfA4qKc6NfIoC7yvB9Fa3BHeTaPvnJZ3pIc
jp5hNDDv5XT+XHQno3VqH0s//Y6PLPieoVtd841+dGBoryU1VGwoKuM0CHMiGNcB
M18a0Ls7wLtX6rgSUlsKz93ptQW+mO7xQDkBaJWWK85VGucxW9NftopOByuJwKlH
447uaqVt3FMO0yUxYFn647JTy1hdN+StsvgHRbhCCWWWz0J5ptz9ZfT9j9iiiPfE
gR70N5qXSK168BgAmFtJxqjeen02OadnWm791BFQFNhXiEJGCKCh44eZox3r/Y77
E/4UDidShPUh7vVJltHoNTQMNKcHppPOxTLR2PzghPC8bR7rEzceKLVtQbL5hNrd
cbIFF/SZsy8=
=9LDd
-----END PGP SIGNATURE-----

--Sig_/kLWb2EMdFnvEJmFDzSLPJf=--
