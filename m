From: NeilBrown <neilb@suse.de>
Subject: Re: grub-probe: "found two disks with the index 3 for RAID md2"
 after changing superblock 0.9 to 1.0
Date: Thu, 18 Sep 2014 16:49:00 +1000
Message-ID: <20140918164900.3d526d69@notabene.brown>
References: <20140915064741.GH11855@bitfolk.com>
	<20140915170037.16f93daa@notabene.brown>
	<20140915171252.GI11855@bitfolk.com>
	<20140916075458.155ca17a@notabene.brown>
	<20140916040023.GG27492@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/N7CVdfg13Xkwy6zjHl03VXe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140916040023.GG27492@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/N7CVdfg13Xkwy6zjHl03VXe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Sep 2014 04:00:24 +0000 Andy Smith <andy@strugglers.net> wrote:

> Hi Neil,
>=20
> On Tue, Sep 16, 2014 at 07:54:58AM +1000, NeilBrown wrote:
> > On Mon, 15 Sep 2014 17:12:52 +0000 Andy Smith <andy@strugglers.net> wro=
te:
> > > On Mon, Sep 15, 2014 at 05:00:37PM +1000, NeilBrown wrote:
> > > >   mdadm --zero-super --metadata=3D0.90 /dev/sda3
> > > >=20
> > > > will remove any 0.90 metadata.
> > >=20
> > > Trying that whole the array is running:
> > >=20
> > > mdadm: Couldn't open /dev/sda3 for write - not zeroing
> > >=20
> > > This needs to be done with the array stopped, presumably?
> >=20
> > It's preferred, but if you are really confident (and I think you are), =
then
> > adding --force is justified and should make it work.
>=20
> Yep, that worked, thank you! No more complaints from grub-probe.
>=20
> Do you consider it a bug that mdadm does not zero the old metadata
> when upgrading it to a new version?

No, but it might be excessive caution.  I think it was a deliberate decision
to make it (relatively) easy to revert if anything when wrong.

mdadm always prefers the more recent metadata, so the old metadata is
effectively invisible to mdadm.  Not to grub though.

>=20
> Or do you consider it a documentation issue to explain that it may
> be necessary to manually do it?

Maybe.  Though I really don't want to impose that sort of burden on users.
Things should  "just work".  Maybe I should  bite the bullet and just erase
the old metadata.... if I do it *after* the array is assembled it should be
safe.
The code might be a bit clumsy but that isn't the end of the world...

I've made a not on my to-do list :-)

Thanks,
NeilBrown


>=20
> I think I would've liked grub-probe at least in verbose mode to say
> which version of metadata it was reading from where. That would've
> been immediately enlightening, so I'll see if they would accept a
> patch for that=E2=80=A6
>=20
> Cheers,
> Andy


--Sig_/N7CVdfg13Xkwy6zjHl03VXe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBqAXDnsnt1WYoG5AQJcqw//YOF/wkYjX2641yVhw0uStwY83kQNDdW8
8EtT/PF1QpCtQScfEV3HXrNx1pnM+uCSS1YYistFidTX+osrmhqAUgv+B68PW6mv
y1p48s5yCGQJhQiJy5EGmBeYjPa0vUJrs73621b8pbxNKtOpzGrhTC6bJyy2p+lp
NfQmIIse1oF8LR7uczuGXm05ko8b+pb+UTJzn2NX8s4MJidEcZOHadH+qlSuS17x
hBOJHo7XS7wJt1u2hZRKRjLNG+oL17ATQ7podwRbCzoegTum1rGwVF4DuP62KVej
H2TQifipzuJyKrbVpeCwLRESiYU2Br3ozopCb2oLHOmXJjqr+ia27KTrLKtGIRQc
Edaai3yHRe3D8pubM1Yv6aoQnr0XV8ZulGtC3JA4TfQMWHbPUPsdjz5Su2jHPa7u
1mCShXsKcfBsPK5tsrjefMsAYzhc/+T+7KSi5P1MDHGVtuKfSf5yhw7q6e0hr9in
XPnW6xxcemvSBT+BOlcO2CTJUU3NV6vlr/FyDN/wJ/j1wu7X5Qu2FcSavUDkKthK
Z28/sQIeoxyc5YDrAiH251x7Y3wgomDbVWnU61+OsYt5tuUf+TrDzVIY4E4z2bt9
RBAtgxB6i38xoEb6K8bjlNcBMlvor6/gz/QF5D08Ph7bOCYM6AV+X7Im/jblAU9a
RQcHh/sqCWU=
=yNLW
-----END PGP SIGNATURE-----

--Sig_/N7CVdfg13Xkwy6zjHl03VXe--
