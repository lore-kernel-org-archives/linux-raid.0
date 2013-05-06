From: NeilBrown <neilb@suse.de>
Subject: Re: Simultaneous assembly on multiple hosts
Date: Mon, 6 May 2013 16:32:03 +1000
Message-ID: <20130506163203.7a65786b@notabene.brown>
References: <20130504020146.GD31411@chc-5.metaname.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uaF.Hn+A7j.G6s+tKNQTsjp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130504020146.GD31411@chc-5.metaname.net>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Matai <neil@matai.kiwi.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/uaF.Hn+A7j.G6s+tKNQTsjp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 4 May 2013 14:01:46 +1200 Neil Matai <neil@matai.kiwi.nz> wrote:

> Hi all,
>=20
> Is it dangerous have an array assembled on two hosts at the same time?
> Say I have servers A and B exporting devices a and b via ATA over
> Ethernet or similar to hosts C and D.  If a and b are components of an
> array then both C and D automatically assemble the array as soon as
> the components a and b are exported but is this safe (on the proviso
> that only one of C or D is ever writing to the array at any time and
> that there is no write-behind caching above the array device)?
>=20

Yes, it is dangerous.
Both hosts will try to update the metadata and will trip over each other.

NeilBrown

--Sig_/uaF.Hn+A7j.G6s+tKNQTsjp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYdOYznsnt1WYoG5AQJ/rA/9E/H1dawxxttVLp3cRdWm7hhEH+HpzL9G
oYsY5jim7navAz+DafDf4OVIFjFml2/44ZVwsh7/4QqEpYQCeubNHpOlG3WA6uGl
76cfaRQKTh1LpkeWwJZwzOAiV9NriEw7ow8LQnpfPP7NHj7/T4gMDIFKkfWQGe/E
ZVymKrzziFJUU+AjpkM+JQ4jMiONSKhSTO7GQToAacjcEChTeKMp4837D98SFUL4
/97rhZrgzzUeWbXIWfh2Cdzqepe7e9n3C3BtfxQ639cl14ZIADzspxbD5WKImEu1
O056X/SXmE2cn/E3ws5RTAZ7Yy7SCb0irNw2ygILgJfzhj2LlDIHyRABsJX+yiMd
rGVFv815VBNb3GyzwNFzZVtOXDuhbTs9xPteU3Pjxe+JjSFjse/vyz38DzR2ly3r
RYZknhmaaGLetxHtcy2709rf2zgcqCmLPkFYlEMsdujxsA4B1p03C1sNcDK8KyCv
ZdgzYlUe5mfGmjs1cBHOtNrS604MBHOEvmLQIdBmDXIl4tJOX4R5gL4h1sEYMB8q
L74ScDVBaZdekVF4bqhJVUPHuBgNmWf8+d/I315daGaBXm7Wg+65VTYM45JOunuC
BhhDzbLZXNUBI4WpfL2QkNmKHrQbwgpQvo7+6fm7qTdI/8wwrMVJ5TWoW1Is7s0J
4Z7sMN/SNP0=
=J8A1
-----END PGP SIGNATURE-----

--Sig_/uaF.Hn+A7j.G6s+tKNQTsjp--
