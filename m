From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: sending ioctl 1261 to a partition!
Date: Tue, 6 Mar 2012 07:01:43 +1100
Message-ID: <20120306070143.4f8abc0e@notabene.brown>
References: <4F54B997.3060207@crc.id.au>
	<4F54D314.9060504@anonymous.org.uk>
	<4F550BA8.3010306@crc.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hfFVK071UPMgnYpb3dfgcHf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F550BA8.3010306@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hfFVK071UPMgnYpb3dfgcHf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 06 Mar 2012 05:53:28 +1100 Steven Haigh <netwiz@crc.id.au> wrote:

> On 6/03/2012 1:52 AM, John Robinson wrote:
> > On 05/03/2012 13:03, Steven Haigh wrote:
> >> I've noticed that recently I've managed to get a ton of messages like
> >> this at boot:
> >>
> >> mdadm: sending ioctl 1261 to a partition!
> >> mdadm: sending ioctl 800c0910 to a partition!
> >
> > It's probably harmless.
> >
> > http://lists.debian.org/debian-kernel/2012/01/msg01105.html says "This
> > warning was introduced as part of the fix for CVE-2011-4127"
> >
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D783955#c4 says "Actually,
> > the warning seems a false positive to me"
>=20
> I did see these - and I probably should have mentioned it in the=20
> original post. Naughty me for posting at times I should really be asleep.
>=20
> The general jist of it seemed to be "it always failed before, now we=20
> just know about it". What makes me wonder is that if it always failed=20
> before, why do we do it in the first place?
>=20

800c0910 is 'are you an md device'.  So failure is a valid response.

1261 is flush-bufs.  I hope that does still work on partitions....

NeilBrown

--Sig_/hfFVK071UPMgnYpb3dfgcHf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1Ubpznsnt1WYoG5AQJUHBAAvndKROYsFFrkUbqESOhd4ErUmYgrJz4T
jZp9m0pztNwE4BY2qOhE5zUkLPvtFmY7urrZSKaauc7braumnOkYRz0vCMRH8AdM
A1rRS3c5kWESwly/UfxvugwU/Uq3P7DXQZzrhfwJL7v0Fs5L6zoN0FDxdsKyOZIM
fBsQ9lQPMi/hCVQRw0XWaZmydkHvwWdMr/n0gMAk2N7ZOT4A0/cNBZjcaFM73icC
msGP+17CYPgiGKyA9HoTu1uKoqO0Zf4LyUFJ3XyFdH9em0ueIvtiJH9bQq8sAI2X
d2hA19FeOh/+uyy7R5JnQwk6iTyk8blV0+tl5av9cxctSvo+D8DlWCtCa575giDU
GgKEmygkvBoSjQ2bxXmV+CRtqwV3Z3BMBg8UlR8DBwI0HvNU7pJnIm2Qt8g+iO5D
pJzlcXS67MbMl6Id+WbtYJORp2N2zOK3BtpPkxY+mP1ggWqbp7qRkH37xU1ERnmw
EBWaSUCQ8vluNhONLhYfXixpFzzePSe+bSaxKWJ7NUDhZhifN6M/O7Dh8m4jrLLn
DS8aaPw4MHx41sZlJUxHOUzFGCxtiMvQVaH/8yfusmty1TWgNrdNdjf+J+elUmBM
yM7aJvisDYsJ0yVq9icAyD/hxVoxM7j+bnA/A2DvdTzoZozBVrYOkXdAPaYUJicD
g/7KaP7Qk5Y=
=8GOH
-----END PGP SIGNATURE-----

--Sig_/hfFVK071UPMgnYpb3dfgcHf--
