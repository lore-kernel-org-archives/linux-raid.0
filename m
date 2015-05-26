From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v4 06/11] md/raid5: get rid of bio_fits_rdev()
Date: Wed, 27 May 2015 09:03:09 +1000
Message-ID: <20150527090309.2cddf33b@notabene.brown>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-7-git-send-email-mlin@kernel.org>
	<20150525154829.4330f149@notabene.brown>
	<CAF1ivSY+ky5PD=m34KXU4z9gE_v4uztaFT=MuU4g69DtXD9vWA@mail.gmail.com>
	<20150525175414.6a1fc33d@notabene.brown>
	<20150525141708.GA26249@lst.de>
	<CAF1ivSajEe1ec_dCeUec=ER3keKVfhhNvv5pWiti_M++NRrBDQ@mail.gmail.com>
	<CAF1ivSYxfE+bZrPD7vpHPsU+XAD+S2Lkz=h84vA9yCy86h40ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/8MMpc4P+nLG6sfy3WjHJiEp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSYxfE+bZrPD7vpHPsU+XAD+S2Lkz=h84vA9yCy86h40ow@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, lkml <linux-kernel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/8MMpc4P+nLG6sfy3WjHJiEp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 May 2015 15:32:38 -0700 Ming Lin <mlin@kernel.org> wrote:

> On Tue, May 26, 2015 at 7:33 AM, Ming Lin <mlin@kernel.org> wrote:
> > On Mon, May 25, 2015 at 7:17 AM, Christoph Hellwig <hch@lst.de> wrote:
> >> On Mon, May 25, 2015 at 05:54:14PM +1000, NeilBrown wrote:
> >>> Did I write that?  I guess I did :-(
> >>> I meant *after*.   Don't get rid of bio_fits_rdev until split_bio is =
in
> >>> chunk_aligned_read().
> >>
> >> I suspect the whole series could use some reordering.
> >
> > Nice reordering.
> > I'll do this.
>=20
> Here is the reordering.
> https://git.kernel.org/cgit/linux/kernel/git/mlin/linux.git/log/?h=3Dbloc=
k-generic-req
>=20
> I'll post it if you are OK.
>=20
> [PATCH 01/15] block: add blk_queue_split()
> [PATCH 02/15] md: remove ->merge_bvec_fn
> [PATCH 03/15] dm: remov merge functions
> [PATCH 04/15] drbd: remove ->merge_bvec_fn
> [PATCH 05/15] pktcdvd: remove ->merge_bvec_fn
> [PATCH 06/15] rbd: remove ->merge_bvec_fn
> [PATCH 07/15] bcache: remove driver private bio splitting code
> [PATCH 08/15] btrfs: remove bio splitting and merge_bvec_fn() calls
> [PATCH 09/15] block: call blk_queue_split() in make_request functions
> [PATCH 10/15] block: kill ->merge_bvec_fn and simplify bio_add_page
> [PATCH 11/15] block: remove split code in blkdev_issue_discard
> [PATCH 12/15] md/raid5: get rid of bio_fits_rdev()
> [PATCH 13/15] block: remove bio_get_nr_vecs()
> [PATCH 14/15] fs: use helper bio_add_page() instead of open coding on
> [PATCH 15/15] Documentation: update notes in biovecs about

The changes to dm.c and dm.h should be in the "dm:" patch, not "md:".

But I don't think the sequence is right.

You cannot remove ->merge_bvec_fn for *any* stacked device until *all* devi=
ces
make use of blk_queue_split() (or otherwise handle arbitrarily large bios).

I think it would be easiest to:
 - add blk_queue_split() and call it from common code before ->make_request=
_fn
   is called.  The ensure all devices can accept arbitrarily large bios.
 - driver-by-driver remove merge_bvec_fn and make sure the the driver can c=
ope
   with arbitrary bios themselve, calling blk_queue_split in the make_reque=
st
   function only if needed
 - finally remove the call to blk_queue_split from the common code.

Does that make sense to others?

Thanks,
NeilBrown

>=20
> >
> > Thanks.
> >
> >>
> >> patch 1:
> >>
> >>  add ->bio_split and blk_queue_split
> >>
> >> patch 2..n:
> >>
> >>  one for each non-trivial driver that implements ->merge_bvec_fn to
> >>  remove it and instead split bios in ->make_request.  The md patch
> >>  to do the right thing in chunk_aligned_read goes into the general
> >>  md patch here.  The bcache patch also goes into this series.
> >>
> >> patch n+1:
> >>
> >>  - add blk_queue_split calls for remaining trivial drivers
> >>
> >> patch n+2:
> >>
> >>  - remove ->merge_bvec_fn and checking of max_sectors a for all
> >>    drivers, simplify bio_add_page
> >>
> >> patch n+2:
> >>
> >>  - remove splitting in blkdev_issue_discard
> >>
> >> patch n+3
> >>
> >>  - remove bio_fits_rdev
> >>
> >> patch n+4
> >>
> >>  - remove bio_get_nr_vecs
> >>
> >> patch n+4
> >>
> >>  - use bio_add_page
> >>
> >> patch n+5
> >>
> >>  - update documentation


--Sig_/8MMpc4P+nLG6sfy3WjHJiEp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWT7rTnsnt1WYoG5AQJKSxAAs6GGlr3ZzmKBAVFRz+Ojk9LE12C4i2vq
6FM+4lkcBBB+i+O6ppiJpwvOz2dn936mz2r+jb8h1c3j4IxTmNDoaIMv+R/+r5s5
r0otXtDQf7y6P8gXLzHhicuVcf9elwh+QitQ6oS7od6rVOaSJnJinTpDl9StWtq8
AeSp/WQruLUrG8r3C19E4Ye1FJ21KXx3SL8LwKSCh4jCq7Fzdta1OhDsfJr5Z5pt
4J9EM06FbKFKrc3/sVa0/yE0cBz14v0CeVJal/bVVTzEungcJyj/TezYym5sstzM
caWY23o2H9GGxEtV7laQoRUGfrnMI8jBuaG+Qp5EpW5D5zclOnR12Qbz+3sKXxll
vR6sI4qgy10CvBZqGBMjPume3dcPTcpV+H8fcxZTzlxqEUSINK/2nPAe2cPvm0nV
00AoOAIvKtblf/XXJY6VRuSPlDTB0yvRbbLWJWHYkDec96/F5orY0eYtAK9I5vWI
52vVYrzgcVmEpDRjhb+Hx5ThCO1X60f59AVBLEyM08tKqHlnXqPX1CptyrHuJdkA
u8g7+Qd66tmYB9kicvMOqWsJhIvH1lVXeuLJpT69aiXupMO0jC8S07ino9/Tzk0e
J/4E+ZqL5NmrbdzabeKTUIkj4zfiig+FCVn3uw7N3wat9aCtGCHgbXM8JSfNT3Hf
sW2l5hLbImk=
=Tau2
-----END PGP SIGNATURE-----

--Sig_/8MMpc4P+nLG6sfy3WjHJiEp--
