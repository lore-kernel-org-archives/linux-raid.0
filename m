From: NeilBrown <neilb@suse.de>
Subject: Re: [patch]raid5: make release_stripe lockless
Date: Thu, 28 Mar 2013 13:28:42 +1100
Message-ID: <20130328132842.388ba4b3@notabene.brown>
References: <20130318043146.GA7016@kernel.org>
	<CAA9_cmeNpXtR91z8Ni=WBAZmiERvRTJre9Px47S-mzTOoNYucg@mail.gmail.com>
	<20130320005548.GA1343@kernel.org>
	<20130322063617.GA22668@kernel.org>
	<20130328114546.207e1d74@notabene.brown>
	<20130328020004.GB17351@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bCxXLMHxs0hAWa1oOTTU5C0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130328020004.GB17351@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Dan Williams <djbw@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/bCxXLMHxs0hAWa1oOTTU5C0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Mar 2013 10:00:04 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, Mar 28, 2013 at 11:45:46AM +1100, NeilBrown wrote:
> > On Fri, 22 Mar 2013 14:36:17 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > >=20
> > > Subject: raid5: make release_stripe lockless
> > >=20
> > > release_stripe still has big lock contention. We just add the stripe =
to a llist
> > > without taking device_lock. We let the raid5d thread to do the real s=
tripe
> > > release, which must hold device_lock anyway. In this way, release_str=
ipe
> > > doesn't hold any locks.
> > >=20
> > > The side effect is the released stripes order is changed. But sounds =
not a big
> > > deal, stripes are never handled in order. And I thought block layer c=
an already
> > > do nice request merge, which means order isn't that important.
> > >=20
> > > I kept the unplug release batch, which is unnecessary with this patch=
 from lock
> > > contention avoid point of view, and actually if we delete it, the str=
ipe_head
> > > release_list and lru can share storage. But the unplug release batch =
is also
> > > helpful for request merge. We probably can delay wakeup raid5d till u=
nplug, but
> > > I'm still afraid of the case which raid5d is running.
> >=20
> > Looks good, thanks.
> >=20
> > One comment:
> >=20
> >=20
> > > +/* should hold conf->device_lock already */
> > > +static int release_stripe_list(struct r5conf *conf)
> > > +{
> > > +	struct stripe_head *sh;
> > > +	struct llist_node *node;
> > > +	int count =3D 0;
> > > +
> > > +	while (1) {
> > > +		node =3D llist_del_first(&conf->released_stripes);
> > > +		if (!node)
> > > +			break;
> >=20
> > Why not:
> >  llist_for_each_entry(sh, llist_delete_all(&conf->released_stripes), re=
lease_list) {
> >       clear_bit()
> >       __release_stripe(conf, sh);
> >       count++;
> >  }
>=20
> This absolutly is ok too. I didn't clearly remember why I do it in my way,
> maybe because new entry can be added. If you prefer llist_for_each_entry(=
), I
> can change it.

I already changed it :-)
http://git.neil.brown.name/git?p=3Dmd.git;a=3Dcommitdiff;h=3D023a4ef1fc49d0=
60ab6f5e69146e56ef885375dc

Thanks,
NeilBrown

--Sig_/bCxXLMHxs0hAWa1oOTTU5C0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUVOq5Dnsnt1WYoG5AQLkBhAAsmuQZPcltaedjl29DoYAm5h+LtRS622B
JPPdjRgJFlVyb/XCurhNBH7/z3dKg4WgT/8wRwJP2VabsOG7QajyKPjuS9+b58Nh
K29QYXiU/aim1FzjP4L5u5VoMirvMc287LfQx3brbjaps9gDCiDfX23zs7kFbTJn
o5c7df9PiPsv5f11UXVLxP7ltCPCxJ8yfWOYcSDqa8Usjzw3wVeOv09Hi8BYd3jI
M1Fc2dFt5eoSjmFdn7dPKZ9fkY6LWBoLiQBaooJ2BcI6kznWtiGQLUmqwBUN4V0x
duMB4bVLIlADBipg34zbohd6C2qdlOivryHXEgXnM3MRwaVxlqiJwHisP/qixEib
1HC4ppfgSaBrDW++kiWD4AbZ+v87/cLZ4cxR2JPGHuJuJH3fBQG7Iiu66xvjQ9hT
VQK/ILhumlUgWvXMmjpuOp2jI/tIGvsG7fM5frDRj/0QTA/ZB2td28uuYqk7mbaO
9WxTXDMv6hy3e6T+r8ZlfpqvH4hTWLJaL7VPAb60Hzwv8H6vixNfvCEKfw8iEQBU
H3z4f1otM41T8laDCPX+zWOTsvhShex9D5rELzXTEwqc74Frw1tygKcY3n31nzKD
/JL79cmcc8ODo8Mi044fDLWwjz840C8pxgnHDt/KXjpsurdBB8QDCc5k8HzlTW03
tbi6/yf0iKY=
=FETD
-----END PGP SIGNATURE-----

--Sig_/bCxXLMHxs0hAWa1oOTTU5C0--
