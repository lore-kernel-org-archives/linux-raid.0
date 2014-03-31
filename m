From: NeilBrown <neilb@suse.de>
Subject: Re: RAIS5 Rebuild Help - Possible Data Offset
Date: Mon, 31 Mar 2014 17:29:53 +1100
Message-ID: <20140331172953.3f37f6c2@notabene.brown>
References: <CAFth78x1SkCEUmETFt+F+79UpjUbhanNLUbZoWa7Hxi3EzsdMw@mail.gmail.com>
	<20140131102551.GA2425@cthulhu.home.robinhill.me.uk>
	<CAFth78xfsaBLzg9TC=UkEoQiafpg-oVJyoxbYgWyrVHCyAuHew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.Zt9H8pNlz4czBH2ip4mXE0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFth78xfsaBLzg9TC=UkEoQiafpg-oVJyoxbYgWyrVHCyAuHew@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yorik <yoriks13@westnet.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.Zt9H8pNlz4czBH2ip4mXE0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 1 Feb 2014 15:56:14 +0800 Yorik <yoriks13@westnet.com.au> wrote:

> Thank you for your help. Sorry for my omission, I thought I had put
> that in. It was one of the first things that I tried and have numerous
> times since.
>=20
> #mdadm -Af /dev/md0 /dev/sd[abc]1 /dev/sd[defgi]
> mdadm: /dev/md0 assembled from 5 drives - not enough to start the array.
>=20
> Then if I try the command again, I get the following
>=20
> # mdadm -Af /dev/md0 /dev/sd[abc]1 /dev/sd[defgi]
> mdadm: /dev/sda1 is busy - skipping
> mdadm: /dev/sdb1 is busy - skipping
> mdadm: /dev/sdc1 is busy - skipping
> mdadm: /dev/sdd is busy - skipping
> mdadm: /dev/sde is busy - skipping
> mdadm: /dev/sdf is busy - skipping
> mdadm: /dev/sdg is busy - skipping
> mdadm: /dev/sdi is busy - skipping
>=20
> And my /proc/mdstat looks like this, with all drives marked as spare.
>=20
> # cat /proc/mdstat
> Personalities :
> md0 : inactive sda1[0](S) sdf[7](S) sdg[8](S) sde[5](S) sdi[6](S)
> sdd[4](S) sdc1[2](S) sdb1[1](S)
>       23442114872 blocks super 1.1
>=20
> unused devices: <none>

If this is still a problem then please:
1/ get the latest mdadm:
     cd /tmp
     git clone git://neil.brown.name/mdadm
     cd mdadm
     make
2/ stop the array
     ./mdadm --stop /dev/md0
3/ force-assemble the array with --verbose:

     ./mdadm --assemble --force --verbose /dev/md0 /dev/sd[abc]1 /dev/sd[de=
fgi]

and report all the output of the last command.

NeilBrown


--Sig_/.Zt9H8pNlz4czBH2ip4mXE0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUzkLYTnsnt1WYoG5AQL5cA/7Bs3HUOtO44moj8AysrmcJisRQmjrsH/H
e27hRgHEnDr7GByurfRchSdi9Zb1sm5KfxHywmyVatKOz4e2CgC/qGTFp/IX5ZCK
9yiXN/oDImEUa16tFhHCrdyU9V9uCdVHwElojkpGfz4kYO7ZLMrY2ftNAVzeBRnI
AfgQmuQpAFEMhkZ+oee3gYrMK+XUWOwQMloZxwHqMvVrnwf1/ccMOUa8XDmKYm1c
Q7RyYuMoxkobu0IkdNCN6Y49MiHzKN5UsA64vO1hgA0bvZmoS6DqPtopOKgvFtdY
2XjfQbSeWf/lkC+pzoZbAJ0968F3/z74+UHTv2m2hFYxkr1oUR1hLMX2iecmrlPa
jFdR6mr4I7WK00D4YZvrpWTPedE47ZKvwyD1zF4gj3SMssHVQp7y4fG2jpUFn1e0
dlG1knsFKk5IBi9Dr3KQrcKSLzPO80Yx5Wu31V+e8SqAefVho2adObz8lz6CN4NX
4d6YE+REk1OkzskGKVS7wLPyq6PnqUz1OJH5g6WvFgv0eSLq9nRb4CSUu9/0H0J/
TkdDvWNv6DhKUVWMzYtsE9nLf+IBp+xqrdOC+Aq1yx8SuU5EgDCnyfQE0JEs6MEY
C3/hiiEecFJcAeiQW26G0cfpANxoZaAlDYj1VaQvIf1AMK9kZCSyyv3NX2/45xEb
pGJ8poveQ+c=
=l+Zd
-----END PGP SIGNATURE-----

--Sig_/.Zt9H8pNlz4czBH2ip4mXE0--
