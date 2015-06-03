From: NeilBrown <neilb@suse.de>
Subject: Re: 4.1-rc6 radi5 OOPS
Date: Thu, 4 Jun 2015 08:15:57 +1000
Message-ID: <20150604081557.55435f13@notabene.brown>
References: <wrfjlhg0mtmi.fsf@jes.lga.redhat.com>
	<20150604064048.0cb2d7c9@notabene.brown>
	<wrfjzj4glajs.fsf@jes.lga.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/w+No.3ZnP6RTC1Iz71gS9nF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjzj4glajs.fsf@jes.lga.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
List-Id: linux-raid.ids

--Sig_/w+No.3ZnP6RTC1Iz71gS9nF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 03 Jun 2015 17:57:43 -0400 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> NeilBrown <neilb@suse.de> writes:
> > On Wed, 03 Jun 2015 16:20:21 -0400 Jes Sorensen <Jes.Sorensen@redhat.co=
m>
> > wrote:
> >
> >> Neil,
> >>=20
> >> I was running testing on the current 4.1-rc6 tree (Linus' top of trunk
> >> 8cd9234c64c584432f6992fe944ca9e46ca8ea76) and I am seeing the following
> >> OOPS which is reproducible.
> >>=20
> >> It shows up when running the mdadm test suite, 07changelevelintr to be
> >> specific.
> >>=20
> >> Is this something you have seen?
> >>=20
> >> Cheers,
> >> Jes
> >>=20
> >> ------------[ cut here ]------------
> >> kernel BUG at drivers/md/raid5.c:5391!
> >
> > No, I haven't seen that.  And I've been running the test suite quite a =
bit
> > lately.
> >
> > Can you get it to print out the relevant numbers?  Include
> > readpos/writepos/safepos too.
>=20
> This enough? Let me know if you need more.
>=20
> I suspect this started happening with the changes that went in between
> 4.1-rc5 and 4.1-rc6. I will try to bisect it tomorrow.
>=20
> Cheers,
> Jes
>=20
> mddev->dev_sectors: 0x9800, reshape_sectors: 0x0200 stripe_addr: ffffffff=
fffffdff, sector_nr 0, readpos 511, writepos -513, safepos 512

Those negative numbers look VERY suspicious.
I'm actually on leave this week so I won't be looking at it any more, but
I'll see what I can find on Monday.
Thanks,
NeilBrown

--Sig_/w+No.3ZnP6RTC1Iz71gS9nF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVW98njnsnt1WYoG5AQL8PQ/+PzqJLJ2r8PtSpBpWr8JQx7EaBanm0gDC
s4FnL+Z7ltfRDE3GvWkjCdqx2PJebl7T35S+AMOueicYrynBYGEW69hVhw/4JUO2
nQ5/6+6CuWd9k00WxdzwABDjIcEWxbPXnwinSNbJ1HqtEgE4XW3ayZqrsddpy5AG
7mde3NTQ26N/iCTlPGuYSyuSB8ClEUAiOFVt0nmdQ4jRniX/0Rpr0tHfrSCcLbHg
yI9HWSuT+XpRJv3XGey80k5QMj1hnaegTsz1lCtN6lP4ojCxgshBq99jNvFxdlFU
KCn1D1GQwLl1w0HIgkYCDKrhB6S61w6Fn3TCPHLiYkj/7ntFJbcTevdNOc9p5AIc
jvFVY7bSPQQdQH4RnXiAuTq/L7QdiCiHFNHKkBemwlaSNYne6X4EicU2PHDwEmWW
r8oRj7viDuKs8o/gmyOKzapxxzkjVgcrdyfN9PxpuKpbx8D2jPy/ambBD+NZzMD2
FtyXJhZMwkCD0Nkq8pCnpojokSVr6FRVYVZMiWvE2aICHSsl6DmX8S3Mq36Jf4wv
Agy0HlGYScKBYEuM5U2IEkSKhpqpxHJjaFsN0wxPKgJ7ESq0RtBk/L665+LPHMEJ
kdhmJTAgS5EWIrSFt5a7wXvvcRqT3fTCSFbwXEB7LMc7a9caAFP/CJpskF3b22h1
/niYdTqdd9Y=
=zjQ7
-----END PGP SIGNATURE-----

--Sig_/w+No.3ZnP6RTC1Iz71gS9nF--
