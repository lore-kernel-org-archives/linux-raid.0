From: NeilBrown <neilb@suse.de>
Subject: Re: Yet another corrupt raid5
Date: Wed, 9 May 2012 06:40:01 +1000
Message-ID: <20120509064001.5c937942@notabene.brown>
References: <4FA52031.2040608@philippwendler.de>
	<20120506160044.5b3a50c2@notabene.brown>
	<4FA6428B.802@philippwendler.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nYDJqi7l1MrP.outVk4SiYZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FA6428B.802@philippwendler.de>
Sender: linux-raid-owner@vger.kernel.org
To: Philipp Wendler <ml@philippwendler.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/nYDJqi7l1MrP.outVk4SiYZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 06 May 2012 11:21:15 +0200 Philipp Wendler <ml@philippwendler.de>
wrote:

> So I did it, and it worked out fine on the first try.
> Luks could successfully decrypt it, fsck did not complain, mounting
> worked and data is also fine. So hurrayy and big thanks ;-)
> Now I am running the resync.

Good news!  thanks for letting us know.

>=20
> >> Thank you very much in advance for your help.
> >=20
> > Good luck, and please accept my apologies for the bug that resulted in =
this
> > unfortunate situation.
>=20
> Hey, you don't need to apologize. I am a software developer as well, and
> I know that such things might happen. And it didn't crash my data, so
> everything is fine.
>=20
> On the contrary, I want to thank all the developers here that you do all
> this work I can use for free (in both senses) and now when there was a
> problem, I could ask on this list and get such a extensive and helpful
> answer, although I am this "yet another guy" that asks something for the
> x-th time.

I find "Do unto other what you would have others do to you" to be a very go=
od
idea.

And the more I can encourage people to test my development code and report
bugs, the more bugs I can fix before they get to paying customers - and that
is certainly a good thing :-)

Thanks,
NeilBrown

--Sig_/nYDJqi7l1MrP.outVk4SiYZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6mEoTnsnt1WYoG5AQIquhAAmrWpfKp/r4oMKGPp45iQYT6AjGxtNH3+
25nA/DURAjnT527U5r25mUNFkVjXxE6YKv3adL+D4kMnYrIt/GObfIFB/Fo0jUGp
ldNJPZc+awr75tijVpg5np0wNrmMZN4/xULSH2fzHYTAKy2G+kjJHMOm2hSkxhM3
u3lXSXt808U/HyftHOSr49Chs2uciYCNWNOeIx3OovUmVh4V0J8SiBDOOQp3fpkJ
qYumJN7WmdCJGfqgUkdmGh2hcYiKU+9w8OThopT2se7fnjMUu+g7m0Xv7KXJ2tkd
DYzDCW5Er9uNOI49Xos4QuF/TaVGTWv4Po5lEZrPzpr5bKHcyNsRSYOs0rSHxdl1
UN9m3w0x0Pvvjv6TBNP+veWSmFoe7qjAOF8pbRRPeMqJzXHo0UNgW44geOWMyVrw
3ROdHw4yC6Ae+d0YeKQvd8o2+YeOTs41HsQJH1UJibiGDxlkZnVkzxiKSW9FUbYj
P4+qkTponbIQky6ww5U7OXD2rQbB73n73Lgxm/cYftSbsREyfAGpMgMxVlgt/v/i
Igybcfu80tq12/OYCSogWWnE5+7Ce/8CXrn/gud/ridLOGOTTegnU23BRoTbb3RA
i/u0lf9VXBtfJSJ6gjEss91GOqgsv1XkXqLc1WQvtGhBU/NAVr14TxSXkYCXDFVO
/l/SYCODGaA=
=cfdY
-----END PGP SIGNATURE-----

--Sig_/nYDJqi7l1MrP.outVk4SiYZ--
