From: NeilBrown <neilb@suse.de>
Subject: Re: Is (non-failed) disk replace possible without loosing
 redundancy ?
Date: Fri, 12 Apr 2013 20:21:30 +1000
Message-ID: <20130412202130.631011d7@notabene.brown>
References: <F5FBA8C0111F5C458B9E1BC24A3F4BDD01F43AAFA5@exchange2.ad.tlogica.com>
	<5166D3C5.5000407@websitemanagers.com.au>
	<runj3axnnb.ln2@goaway.wombat.san-francisco.ca.us>
	<20130412160124.3439ad7d@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dya7mYKaCUz7SSed_gnN=rT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130412160124.3439ad7d@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Keith Keller <kkeller@wombat.san-francisco.ca.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dya7mYKaCUz7SSed_gnN=rT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Apr 2013 16:01:24 +0600 Roman Mamedov <rm@romanrm.ru> wrote:

> On Thu, 11 Apr 2013 14:52:59 -0700
> Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
>=20
> > Is there any way to accomplish the same sort of
> > thing in a RAID5 or 6?
>=20
> There is the "want_replacement" mechanism. It exists, it works perfectly,=
 but
> from this thread it looks like no one knows about it. Actually I am not s=
ure
> where it is documented, try searching the mail list archives.
>=20
>=20

Checkout the devel mdadm from git://neil.brown.name/mdadm/

 make man
 less mdadm.man

and search for "--replace"

Requires linux-3.3 or later.

NeilBrown

--Sig_/dya7mYKaCUz7SSed_gnN=rT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUWfgKjnsnt1WYoG5AQK8QA/6AilYQjaxz6BMKAwLVKGUr+sl+0LbPXpZ
c0+I2KTmT23cRI/mpXWf6Kp7rwSSJuokMOo3vL1x2Q7oOvOE/o9Qkz4HDexrtNYa
QqRqFCDW7/7RK+98Q7MQJX7qfAS/JlpqL2avwJfFk/SbIZWjz70LEshaShv7aP4o
HLos8JkdQm7rdnyItVbZZ85WHSo23OAGAPta/8sLS9UaXIhmr408RLHfVtJ+G7AR
UVL2akhZoIFWpGJPTXLsQicMZ0YLFz6AAEuCTiWp5soqlmxtBk6YU9N2m+PLUxcy
/RKcn2Ppbu1KahHowtU9O31ZkTxwbe1Rwu/em7WY9MXa+qLkOl9zvZv2CXNBVunt
m6HLBx5jm5T4y4fkpOh4mbo3e3fJ66oHc30wBgotfH6hIYAJlZokmdiuiUsUTAXP
rZkTGtu5g/uFulZjO4qQapmmG+lewYcdvsBtOBrgcIZ+X+CQVsUzRf8NBxQwf1Pi
+NTbx4zIlcvUkZtvG7ue68409EliK8XPeFj1IG9ODK1kKVJ8+dXkFCv7GPTcwK0f
4HQdo6d9yFPySvDjYPS4/v2YX2abZCCXIWAEfEY2V9WAfkZzp9aVddeoOz9szORY
WYPwvWRvKPnxOgTLJJt32GpBFAnJv+3zWwgVp34NoaUpax1vXJqRQSYfVECj0ikg
5lcQ5aotV5Q=
=7W/a
-----END PGP SIGNATURE-----

--Sig_/dya7mYKaCUz7SSed_gnN=rT--
