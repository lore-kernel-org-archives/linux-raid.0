From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v4 06/11] md/raid5: get rid of bio_fits_rdev()
Date: Wed, 27 May 2015 10:38:36 +1000
Message-ID: <20150527103836.1a41a7a8@notabene.brown>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-7-git-send-email-mlin@kernel.org>
	<20150525154829.4330f149@notabene.brown>
	<CAF1ivSY+ky5PD=m34KXU4z9gE_v4uztaFT=MuU4g69DtXD9vWA@mail.gmail.com>
	<20150525175414.6a1fc33d@notabene.brown>
	<20150525141708.GA26249@lst.de>
	<CAF1ivSajEe1ec_dCeUec=ER3keKVfhhNvv5pWiti_M++NRrBDQ@mail.gmail.com>
	<CAF1ivSYxfE+bZrPD7vpHPsU+XAD+S2Lkz=h84vA9yCy86h40ow@mail.gmail.com>
	<20150527090309.2cddf33b@notabene.brown>
	<CAF1ivSZee_aV4XOtgc9YOR4YG4Lsd0tJkE-F+i9jg-5Ep7_Afg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+aZaGrd4QbQt5kTbH7tuzmC"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSZee_aV4XOtgc9YOR4YG4Lsd0tJkE-F+i9jg-5Ep7_Afg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, lkml <linux-kernel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+aZaGrd4QbQt5kTbH7tuzmC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 May 2015 16:42:35 -0700 Ming Lin <mlin@kernel.org> wrote:

> On Tue, May 26, 2015 at 4:03 PM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 26 May 2015 15:32:38 -0700 Ming Lin <mlin@kernel.org> wrote:
> >
> >> On Tue, May 26, 2015 at 7:33 AM, Ming Lin <mlin@kernel.org> wrote:
> >> > On Mon, May 25, 2015 at 7:17 AM, Christoph Hellwig <hch@lst.de> wrot=
e:
> >> >> On Mon, May 25, 2015 at 05:54:14PM +1000, NeilBrown wrote:
> >> >>> Did I write that?  I guess I did :-(
> >> >>> I meant *after*.   Don't get rid of bio_fits_rdev until split_bio =
is in
> >> >>> chunk_aligned_read().
> >> >>
> >> >> I suspect the whole series could use some reordering.
> >> >
> >> > Nice reordering.
> >> > I'll do this.
> >>
> >> Here is the reordering.
> >> https://git.kernel.org/cgit/linux/kernel/git/mlin/linux.git/log/?h=3Db=
lock-generic-req
> >>
> >> I'll post it if you are OK.
> >>
> >> [PATCH 01/15] block: add blk_queue_split()
> >> [PATCH 02/15] md: remove ->merge_bvec_fn
> >> [PATCH 03/15] dm: remov merge functions
> >> [PATCH 04/15] drbd: remove ->merge_bvec_fn
> >> [PATCH 05/15] pktcdvd: remove ->merge_bvec_fn
> >> [PATCH 06/15] rbd: remove ->merge_bvec_fn
> >> [PATCH 07/15] bcache: remove driver private bio splitting code
> >> [PATCH 08/15] btrfs: remove bio splitting and merge_bvec_fn() calls
> >> [PATCH 09/15] block: call blk_queue_split() in make_request functions
> >> [PATCH 10/15] block: kill ->merge_bvec_fn and simplify bio_add_page
> >> [PATCH 11/15] block: remove split code in blkdev_issue_discard
> >> [PATCH 12/15] md/raid5: get rid of bio_fits_rdev()
> >> [PATCH 13/15] block: remove bio_get_nr_vecs()
> >> [PATCH 14/15] fs: use helper bio_add_page() instead of open coding on
> >> [PATCH 15/15] Documentation: update notes in biovecs about
> >
> > The changes to dm.c and dm.h should be in the "dm:" patch, not "md:".
>=20
> Will move it.
>=20
> >
> > But I don't think the sequence is right.
> >
> > You cannot remove ->merge_bvec_fn for *any* stacked device until *all* =
devices
> > make use of blk_queue_split() (or otherwise handle arbitrarily large bi=
os).
> >
> > I think it would be easiest to:
> >  - add blk_queue_split() and call it from common code before ->make_req=
uest_fn
> >    is called.  The ensure all devices can accept arbitrarily large bios.
>=20
> For "common code", do you mean "generic_make_request()"
>=20
> diff --git a/block/blk-core.c b/block/blk-core.c
> index fbbb337..bb6455b 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1942,6 +1942,7 @@ void generic_make_request(struct bio *bio)
>         do {
>                 struct request_queue *q =3D bdev_get_queue(bio->bi_bdev);
>=20
> +               blk_queue_split(q, &bio, q->bio_split);
>                 q->make_request_fn(q, bio);
>=20
>                 bio =3D bio_list_pop(current->bio_list);

Yes, that is what I mean (assuming that is the only place that calls
->make_request_fn).

Thanks,
NeilBrown



--Sig_/+aZaGrd4QbQt5kTbH7tuzmC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWUSDDnsnt1WYoG5AQIYqA//fJUCPbgb3pctJnSF6YzPct1kqvkagiZO
Qz9LH/k92tUyvAZaS527SDSz4Tps6lS3t5mq+kNWWZnlxNFGsflT63Q34/3K/QLb
gld3MuUvXTDPSm0yjCsexHEi1K2hZsjKwsQd8VNYU2rGBmRyaxgOHRKOivUWpItn
OLkVtEGpuXh8eVf7t2wk4OXMFl4Q8iMFptATOJJJjJoCZGEfAd4F6Y1PFoODxYSS
ooDSpK/+Mp40xPsZYRRp7/XxlWaPpnKXlK/Lw6EsqSgMBSJqM7A0nV5lbcFhzPPi
diq2Px9TkMfwt6OvicgqCXRjE5rVUMfMap4YxY6m1Hsl/nsF0wBWAbnOuKngA1bE
HpH2A5kIRTr8aAf6K8BcFF+UqrGtPkONuAroSRUXq8wQwFqmXi4tfOWc0mft6tRn
uHTKaR7A0mscF/ATwCKbIyE2yqp0X2KwapzNBksaUtCixPwRVaVR4OQHr3RcVZNE
yvgc/Xmac/9pmLycQnR12Waoq33925D0YNIMZEke+KxwjqwtroEjZ9CFMtxJR5la
J1AFAaO6390BvtegmSGhYdX+LxOIej11JTELNr0ue2FCiGml3PEvqFvCV/6gPCrl
HizzkqDQYNPNXf2t6sjth95jT3aHjVwhgAg/sFo2hcePp1ozVJ8T0rodVkJ86aOg
gC77U+0CgAk=
=GpNS
-----END PGP SIGNATURE-----

--Sig_/+aZaGrd4QbQt5kTbH7tuzmC--
