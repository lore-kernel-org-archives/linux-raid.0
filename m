From: NeilBrown <neilb@suse.de>
Subject: Re: 3.12: raid-1 mismatch_cnt question
Date: Tue, 12 Nov 2013 08:58:25 +1100
Message-ID: <20131112085825.16ca8446@notabene.brown>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com>
	<527E8B74.70301@shiftmail.org>
	<008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com>
	<527F7FF5.3000002@shiftmail.org>
	<000301cedec0$1fa72d60$5ef58820$@lucidpixels.com>
	<5280BA1E.6060604@shiftmail.org>
	<CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nmnmDE8oM90mtg0FZsD4=Fc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: joystick <joystick@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/nmnmDE8oM90mtg0FZsD4=Fc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Nov 2013 13:52:23 -0500 Justin Piszcz <jpiszcz@lucidpixels.com>
wrote:


> > 4- Linux or SSD bug on trim, such as trimming wrong offsets killing live
> > data
> > 5- MD does not lock regions during check so returns erroneous mismatche=
s for
> > areas being written. This would be harmless but your mismatches number =
seems
> > to high to me for this.
> I wonder if this could be it.

I cannot promise that my code is bug free, but if it wasn't getting this
locking correct, that would be a very serious bug.  I think this possibility
is quite unlikely.

NeilBrown

--Sig_/nmnmDE8oM90mtg0FZsD4=Fc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoFTATnsnt1WYoG5AQLerxAAijpM3nN6QB+KZh8F+CxQLJaE9qB5UlMJ
zaOyGImqHNCQRs31lzSXWCkq22DJc3Jk6QOYKq0HNp9QOj5x8nKum+VPUJR27imS
so5PH+MNQpp7oP6ebKtLWQsw9IufClCkP4P8BPExuMHRd/Bm7cLASI3glxtYdCeA
oWP83S5rQfdNNlk//P7MJ2PPpQ2GlcotnW0x6kgcip+id8FoF1UXp80vTirPXNEQ
qa+BktuB1TcStuTy7D2so4d80xx426k7DOg3JbbdXsZhZ5pJdpXM5URjuLwEft3K
0knd6rQbx/cXLhNugKFPSrGzzohvCank0SkgUPA/Dzy6k6rpPdIKJPfrCJjC42wk
LQqYUoy7mwJ2kwG+pzN2a7FwdCZsHo4nI0mJe28aB1Yi6y9pVRi2DUbDWfIRWmuZ
2xbdxeYxLir6KnuLg7GgOMj3NoG67aBzJ1oXDUO8JAPWpGYTGd7b15oNi2EylAjf
iyZHlGSyDVpuvJB8fwsNg51Ed0H9ZUSg+d7mg4JMFF0/6U4UlJJbWKGvIsh36oH5
zZ1vF+C5fSKdoWNmr0MRbMd20XXp/3Bu5My1/ZZL9hNcN88WaGLJpvtp68l6Zsc1
MfHLp/2KK38252SM/ZheEykJEF60oqCY/iUJbJhTzi9iuhXT4e9Ji9u7AfZWlk/N
KGCvs0QXKcI=
=Uq07
-----END PGP SIGNATURE-----

--Sig_/nmnmDE8oM90mtg0FZsD4=Fc--
