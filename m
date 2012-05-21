From: NeilBrown <neilb@suse.de>
Subject: Re: Check / Automatic repair
Date: Mon, 21 May 2012 20:15:38 +1000
Message-ID: <20120521201538.1fbac51b@notabene.brown>
References: <CAFYuN7qTy5Apj265N6PiyvbU5QmS7=ry+ofi=vHjzDfsf7uh5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=91uH51SUP73.t2kTwdyD0G"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFYuN7qTy5Apj265N6PiyvbU5QmS7=ry+ofi=vHjzDfsf7uh5g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Fabien Bourigault <dradge@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=91uH51SUP73.t2kTwdyD0G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 May 2012 12:09:47 +0200 Fabien Bourigault <dradge@gmail.com> wro=
te:

> Hi,
>=20
> I was reading the kernel md.txt documentation and found that couple of
> sentences about sync_action :
>=20
> 496        check         - A full check of redundancy was requested and is
> 497                        happening.  This reads all block and checks
> 498                        them. A repair may also happen for some raid
> 499                        levels.
>=20
>=20
> What levels/configurations are affected by the "A repair may also
> happen for some raid levels." sentence ?

Someone really should find time to fix up that file....

I don't remember the details of what it meant at the time, but with current
code 'check' means a check is happening for all raid levels, and 'repair'
means a repair is happening.

NeilBrown

--Sig_/=91uH51SUP73.t2kTwdyD0G
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7oVyjnsnt1WYoG5AQIhPg//axrECs0jCUfP92OdDYESEFvJvpBCYU1d
unIia1JJgbczvUCu6zHKb2/i10yPHZ8d7IRe5slEk2pKNzF7/b9bIXuB2nQJunyZ
MjSBizFy9/EMoEfOA1zqXYJqerUo5HLU+DexskO6r/u2nAfohOMbeIf941hyV0gr
laGswY+4T6t8ISK1ybHoXuhOntr42wdLiM7aabtgsW02wuhVoHre2AumXbe7NJs0
FH1mirXUjU6FrLE1ysm2GWWHvPAO9NCgJnlaw/wibmXoXH2linYruPQDVSAIRRHs
BDu1/ICkUmqNMmVMsfOLMO50zJbhRy80fofp+M0axonHvd90poQyySHw+kz4XNWd
/UxJeA8V7woFC16VufKetxH1LlKuk6BFraVQpnOgX6t0/jlkNgV7QzXgvlG++9zC
6NDNTtTgES/2PDyYQHi4Z8RJW1mOqQZnngBrx6ctgjaqS9TUKEScQjePtLemo6Ds
ttKJ0R0ShRt9wH3JN4RGbIZIHol0+1qFB/4vohO+CV6BX6wxsVge1z3I3DZZiepz
NvQaD+DPMjj+IFSDyL28JLTqJSvPV32uhcDrL+8B/Fh/mXWpoCAP9Hnbyrd7z6YZ
5emZUcgfWiyQDY8BmCKnGpiIFXEjtB6hvSksbnsRjIM2B/CQ5oxVYRQysMX/utvn
sdojGHgCy80=
=i1vT
-----END PGP SIGNATURE-----

--Sig_/=91uH51SUP73.t2kTwdyD0G--
