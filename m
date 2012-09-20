From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/2]MD: raid5 trim support
Date: Thu, 20 Sep 2012 11:47:40 +1000
Message-ID: <20120920114740.7e2c2d1f@notabene.brown>
References: <20120918082511.GA6298@kernel.org>
	<20120920111517.54d05380@notabene.brown>
	<20120920013642.GA6798@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FzpVVqtDHL+CieGaZW6F6Qz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120920013642.GA6798@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/FzpVVqtDHL+CieGaZW6F6Qz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Sep 2012 09:36:42 +0800 Shaohua Li <shli@kernel.org> wrote:

> On Thu, Sep 20, 2012 at 11:15:17AM +1000, NeilBrown wrote:
> > On Tue, 18 Sep 2012 16:25:11 +0800 Shaohua Li <shli@kernel.org> wrote:
> >=20
> > > Discard for raid4/5/6 has limitation. If discard request size is smal=
l, we do
> > > discard for one disk, but we need calculate parity and write parity d=
isk.  To
> > > correctly calculate parity, zero_after_discard must be guaranteed. Ev=
en it's
> > > true, we need do discard for one disk but write another disks, which =
makes the
> > > parity disks wear out fast. This doesn't make sense. So an efficient =
discard
> > > for raid4/5/6 should discard all data disks and parity disks, which r=
equires
> > > the write pattern to be (A, A+chunk_size, A+chunk_size*2...). If A's =
size is
> > > smaller than chunk_size, such pattern is almost impossible in practic=
e. So in
> > > this patch, I only handle the case that A's size equals to chunk_size=
. That is
> > > discard request should be aligned to stripe size and its size is mult=
iple of
> > > stripe size.
> > >=20
> > > Since we can only handle request with specific alignment and size (or=
 part of
> > > the request fitting stripes), we can't guarantee zero_after_discard e=
ven
> > > zero_after_discard is true in low level drives.
> > >=20
> > > The block layer doesn't send down correctly aligned requests even cor=
rect
> > > discard alignment is set, so I must filter out.
> > >=20
> > > For raid4/5/6 parity calculation, if data is 0, parity is 0. So if
> > > zero_after_discard is true for all disks, data is consistent after di=
scard.
> > > Otherwise, data might be lost. Let's consider a scenario: discard a s=
tripe,
> > > write data to one disk and write parity disk. The stripe could be sti=
ll
> > > inconsistent till then depending on using data from other data disks =
or parity
> > > disks to calculate new parity. If the disk is broken, we can't restor=
e it. So
> > > in this patch, we only enable discard support if all disks have
> > > zero_after_discard.
> > >=20
> > > If discard fails in one disk, we face the similar inconsistent issue =
above. The
> > > patch will make discard follow the same path as normal write request.=
 If
> > > discard fails, a resync will be scheduled to make the data consistent=
. This
> > > isn't good to have extra writes, but data consistency is important.
> > >=20
> > > If a subsequent read/write request hits raid5 cache of a discarded st=
ripe, the
> > > discarded dev page should have zero filled, so the data is consistent=
. This
> > > patch will always zero dev page for discarded request stripe. This is=
n't
> > > optimal because discard request doesn't need such payload. Next patch=
 will
> > > avoid it.
> > >=20
> > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > > ---
> > >  drivers/md/raid5.c |  176 ++++++++++++++++++++++++++++++++++++++++++=
++++++++++-
> > >  drivers/md/raid5.h |    1=20
> > >  2 files changed, 174 insertions(+), 3 deletions(-)
> > >=20
> > > Index: linux/drivers/md/raid5.c
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > --- linux.orig/drivers/md/raid5.c	2012-09-18 16:15:51.219353357 +0800
> > > +++ linux/drivers/md/raid5.c	2012-09-18 16:15:55.471299904 +0800
> > > @@ -547,6 +547,8 @@ static void ops_run_io(struct stripe_hea
> > >  				rw =3D WRITE_FUA;
> > >  			else
> > >  				rw =3D WRITE;
> > > +			if (test_and_clear_bit(R5_Discard, &sh->dev[i].flags))
> > > +				rw |=3D REQ_DISCARD;
> > >  		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
> > >  			rw =3D READ;
> > >  		else if (test_and_clear_bit(R5_WantReplace,
> > > @@ -1170,8 +1172,13 @@ ops_run_biodrain(struct stripe_head *sh,
> > >  					set_bit(R5_WantFUA, &dev->flags);
> > >  				if (wbi->bi_rw & REQ_SYNC)
> > >  					set_bit(R5_SyncIO, &dev->flags);
> > > -				tx =3D async_copy_data(1, wbi, dev->page,
> > > -					dev->sector, tx);
> > > +				if (wbi->bi_rw & REQ_DISCARD) {
> > > +					memset(page_address(dev->page), 0,
> > > +						STRIPE_SECTORS << 9);
> > > +					set_bit(R5_Discard, &dev->flags);
> > > +				} else
> > > +					tx =3D async_copy_data(1, wbi, dev->page,
> > > +						dev->sector, tx);
> > >  				wbi =3D r5_next_bio(wbi, dev->sector);
> > >  			}
> > >  		}
> > > @@ -1237,6 +1244,20 @@ ops_run_reconstruct5(struct stripe_head
> > >  	pr_debug("%s: stripe %llu\n", __func__,
> > >  		(unsigned long long)sh->sector);
> > > =20
> > > +	for (i =3D 0; i < sh->disks; i++) {
> > > +		if (pd_idx =3D=3D i)
> > > +			continue;
> > > +		if (!test_bit(R5_Discard, &sh->dev[i].flags))
> > > +			break;
> > > +	}
> > > +	if (i >=3D sh->disks) {
> > > +		atomic_inc(&sh->count);
> > > +		memset(page_address(sh->dev[pd_idx].page), 0,
> > > +			STRIPE_SECTORS << 9);
> > > +		set_bit(R5_Discard, &sh->dev[pd_idx].flags);
> > > +		ops_complete_reconstruct(sh);
> > > +		return;
> > > +	}
> > >  	/* check if prexor is active which means only process blocks
> > >  	 * that are part of a read-modify-write (written)
> > >  	 */
> > > @@ -1281,10 +1302,28 @@ ops_run_reconstruct6(struct stripe_head
> > >  {
> > >  	struct async_submit_ctl submit;
> > >  	struct page **blocks =3D percpu->scribble;
> > > -	int count;
> > > +	int count, i;
> > > =20
> > >  	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sec=
tor);
> > > =20
> > > +	for (i =3D 0; i < sh->disks; i++) {
> > > +		if (sh->pd_idx =3D=3D i || sh->qd_idx =3D=3D i)
> > > +			continue;
> > > +		if (!test_bit(R5_Discard, &sh->dev[i].flags))
> > > +			break;
> > > +	}
> > > +	if (i >=3D sh->disks) {
> > > +		atomic_inc(&sh->count);
> > > +		memset(page_address(sh->dev[sh->pd_idx].page), 0,
> > > +			STRIPE_SECTORS << 9);
> > > +		memset(page_address(sh->dev[sh->qd_idx].page), 0,
> > > +			STRIPE_SECTORS << 9);
> > > +		set_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
> > > +		set_bit(R5_Discard, &sh->dev[sh->qd_idx].flags);
> > > +		ops_complete_reconstruct(sh);
> > > +		return;
> > > +	}
> > > +
> > >  	count =3D set_syndrome_sources(blocks, sh);
> > > =20
> > >  	atomic_inc(&sh->count);
> > > @@ -4067,6 +4106,96 @@ static void release_stripe_plug(struct m
> > >  		release_stripe(sh);
> > >  }
> > > =20
> > > +static void make_discard_request(struct mddev *mddev, struct bio *bi)
> > > +{
> > > +	struct r5conf *conf =3D mddev->private;
> > > +	sector_t logical_sector, last_sector;
> > > +	struct stripe_head *sh;
> > > +	int remaining;
> > > +	int stripe_sectors;
> > > +
> > > +	if (mddev->reshape_position !=3D MaxSector)
> > > +		/* Skip discard while reshape is happening */
> > > +		return;
> > > +
> > > +	logical_sector =3D bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
> > > +	last_sector =3D bi->bi_sector + (bi->bi_size>>9);
> > > +
> > > +	bi->bi_next =3D NULL;
> > > +	bi->bi_phys_segments =3D 1; /* over-loaded to count active stripes =
*/
> > > +
> > > +	stripe_sectors =3D conf->chunk_sectors *
> > > +		(conf->raid_disks - conf->max_degraded);
> > > +	logical_sector =3D DIV_ROUND_UP_SECTOR_T(logical_sector,
> > > +			stripe_sectors);
> > > +	sector_div(last_sector, stripe_sectors);
> > > +
> > > +	logical_sector *=3D stripe_sectors;
> > > +	last_sector *=3D stripe_sectors;
> > > +
> > > +	for (;logical_sector < last_sector;
> > > +					logical_sector +=3D STRIPE_SECTORS) {
> > > +		DEFINE_WAIT(w);
> > > +		sector_t new_sector;
> > > +		int d;
> > > +
> > > +		new_sector =3D raid5_compute_sector(conf, logical_sector,
> > > +						  0, &d, NULL);
> >=20
> > This is pointless.  Look at the patch I posted again.  You don't need t=
o call
> > raid5_compute_sector().  It essentially just divides logical_sector by
> > stripe_sectors.  It is cleaner not to do the multiple in the first plac=
e.
>=20
> in my test, without it, wrong sectors are trimmed.

Which tells me that the code you tested was wrong.
However the code you posted was wrong too.

Maybe if you post the code you tested and which looked more like mine, and
explain which wrong sectors were trimmed....

NeilBrown

--Sig_/FzpVVqtDHL+CieGaZW6F6Qz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFp1vDnsnt1WYoG5AQLbIA/6A6yaY3T721b59c45WKH7FFZp9QOYtEB1
Fi6Y3Ex+Y0SH8QGCW4ycpCU7Fh3l6UbNrDHt4cylXA4nBA/f2UXlT0Ul1TDBlFJ9
YoJUx8uM2vywHmbKuWgrZ72GSAi69opUrwTnfS2ntfqLzwmlPQMLXgu79daX/gG7
lAfhA8dWXvH4xpgbmpLiVBavv+VyU/vo+mIKbOi6kiHEPRw52vLGXl9DCq0TXIoC
QNidO/kM2FS/R1GGaPv0E1W6gStyVkgQ9cEgJ51npzwVj5j+rwkeMtzKH4xnjumS
XDrT9QmGRmP+zHRkMcNGZ4IDTk/YXIHcPwGCHdmCRR+NnsMEdd/aC1K4Y48FwJI4
SbsQXewmur/kUWdSUlqceZI0Im6lzhWtpR+b18mx8dQ8DOYFGnW5oUXMR0P0XTQO
kIAdORkJ3VeQiTwDJEfZI3magKkCTcTppngY38o4cyDD6xI90B7KnJcHKjPUPvpd
XCPQepiU9LxNdbsgbAbuBsV9PV6GJ9PlYCci9MeJAst1RbgxWd+kiIfZ1uOIEVG/
OMjzR8bLjpE45O+c2KdlUs+4IK0UWBPxmOS3gV+N/Q4Ety1r+BY5wyorLU+TncBb
mweTC9yc3O8bKgdaxWnroqFk7iFG3kmsYl8sLV4Hm8l8aB5ywg1V9qjzV5YkXF5Y
DXxz2POW6Lc=
=fARR
-----END PGP SIGNATURE-----

--Sig_/FzpVVqtDHL+CieGaZW6F6Qz--
