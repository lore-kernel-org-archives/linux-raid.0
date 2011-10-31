From: NeilBrown <neilb@suse.de>
Subject: Re: PULL REQUEST - serious md/RAID10 bug in 3.1 when activating a
 hot-spare.
Date: Mon, 31 Oct 2011 16:49:54 +1100
Message-ID: <20111031164954.274dda14@notabene.brown>
References: <20111031130859.121d5620@notabene.brown>
	<4EAE2C62.3030506@fnarfbargle.com>
	<4EAE3352.8090409@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/b5wzpTW1V=iP0WIFMoGjYYu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EAE3352.8090409@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/b5wzpTW1V=iP0WIFMoGjYYu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Oct 2011 13:34:10 +0800 Brad Campbell <lists2009@fnarfbargle.com>
wrote:

> On 31/10/11 13:04, Brad Campbell wrote:
> > On 31/10/11 10:08, NeilBrown wrote:
> >>
> >> Hi Linus et al,
> >>
> >> I just discovered a fairly serious flaw that I introduced into 3.1 -
> >> details
> >> below.
> >>
> >> Anyone running RAID10 with 3.1 is advised to either apply this patch or
> >> revert an earlier kernel as soon as possible. In the mean time, remove
> >> any
> >> hot spares from an RAID10 array.
> >>
> >
> > G'day Neil,
> >
> > Is that the issue I bumped up against here?
> >
> > http://permalink.gmane.org/gmane.linux.raid/35805
>=20
> After looking closer I can confirm that making the indicated change=20
> resolves this problem.

Yes, definitely the same problem.
It's a shame I didn't pay proper attention to that report at the time - I
think that was the day that the uSD in my phone died and I was somewhat
distracted trying to figure out how to rebuild the install from scratch :-(

NeilBrown


--Sig_/b5wzpTW1V=iP0WIFMoGjYYu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTq43Dznsnt1WYoG5AQLymg/+Jm095/0MmPYKDhamJbB2ytj0BA1l1Ix+
y+AXqDct1l2Gn6lgjHbS08ZVSfImKruwuEA6/fZNzMNZDopDUz5wrgMMCdpPHdi2
We5UahKKzCakMOCcroNiWcuTnPGnPJGqz9eTyRHCpMI0GEyM+bn2zqDu2N6v6SFw
MyyUI3jkUDFdjRWlIgfhgDQ6/2yjYjLESEDXssDGxHHwd7RoikYPmhBnDQgVs/9D
0atYQjEbC5sin1MS3OyuESoDCGOppP8Mv4i2h69ypnwdz38bmXyk+dw37Wz8Fagd
bJAXMO6zv3aXOjlLUbY8VjHcFaBsqimL+4UweJDX2tDXUiSNwbH2OlmlHcQ7/O5Z
wJVNufHIrxIdPVApa1oR3TzJSVvOxLsfidk9ptYGV5m84MGERybbI4yfST5/v85E
WzEeZ0kufBjQZcrmAnfmBfS6JdnyWE5zpCyCqq6epKkXubx4cv5qYDlUaF72PxqV
YusBwwvFAxLvhPmWtf3jDhuzbCw4BU4Up/tocFlDM9akic7F0+jGtQoAg943yGTr
y8LBw53SvCwMkzgn9KW9H2CyTZjuw2k1Ls/69oyIn3EhkSCFFg9WiZakvEZ67tS8
K67/g8FCZEblrt+6geVCazHbmNKaiE0aev/lXl9/6hpDJn0lRxSrZ1MjwJgnvwJ9
row05cOJNRI=
=uuw4
-----END PGP SIGNATURE-----

--Sig_/b5wzpTW1V=iP0WIFMoGjYYu--
