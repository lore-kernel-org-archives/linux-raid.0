From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 03/10] Create n bitmaps for clustered mode
Date: Thu, 30 Apr 2015 12:53:46 +1000
Message-ID: <20150430125346.0a7f4d38@notabene.brown>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
	<1429860641-5839-4-git-send-email-gqjiang@suse.com>
	<20150429114115.2265643f@notabene.brown>
	<55419707.9050302@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/h6f94ywyNalCetwIFbMAFGL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55419707.9050302@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqJiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

--Sig_/h6f94ywyNalCetwIFbMAFGL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Apr 2015 10:44:23 +0800 Guoqing Jiang <gqJiang@suse.com> wrote:

> NeilBrown wrote:
> > On Fri, 24 Apr 2015 15:30:34 +0800 gqjiang@suse.com wrote:
> >
> >  =20
> >> From: Guoqing Jiang <gqjiang@suse.com>
> >>
> >> For a clustered MD, create bitmaps equal to number of nodes so
> >> each node has an independent bitmap.
> >>
> >> Only the first bitmap is has the bits set so that the first node
> >> that assembles the device also performs the sync.
> >>
> >> The bitmaps are aligned to 4k boundaries.
> >>
> >> On-disk format:
> >>
> >> 0                    4k                     8k                    12k
> >> -------------------------------------------------------------------
> >> | idle                | md super            | bm super [0] + bits |
> >> | bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]   |
> >> | bm super[2] + bits  | bm bits [2, contd]  | bm super[3] + bits  |
> >> | bm bits [3, contd]  |                     |                     |
> >>
> >> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> >> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> >> ---
> >>  Create.c   |  3 ++-
> >>  bitmap.h   |  7 +++++--
> >>  mdadm.8.in |  7 ++++++-
> >>  mdadm.c    | 17 ++++++++++++++++-
> >>  super1.c   | 59 +++++++++++++++++++++++++++++++++++++++++------------=
------
> >>  5 files changed, 70 insertions(+), 23 deletions(-)
> >>
> >> diff --git a/Create.c b/Create.c
> >> index cd5485b..9663dc4 100644
> >> --- a/Create.c
> >> +++ b/Create.c
> >> @@ -752,7 +752,8 @@ int Create(struct supertype *st, char *mddev,
> >>  #endif
> >>  	}
> >> =20
> >> -	if (s->bitmap_file && strcmp(s->bitmap_file, "internal")=3D=3D0) {
> >> +	if (s->bitmap_file && (strcmp(s->bitmap_file, "internal")=3D=3D0
> >> +			|| strcmp(s->bitmap_file, "clustered")=3D=3D0)) {
> >>  		if ((vers%100) < 2) {
> >>  			pr_err("internal bitmaps not supported by this kernel.\n");
> >>  			goto abort_locked;
> >> diff --git a/bitmap.h b/bitmap.h
> >> index c8725a3..adbf0b4 100644
> >> --- a/bitmap.h
> >> +++ b/bitmap.h
> >> @@ -154,8 +154,11 @@ typedef struct bitmap_super_s {
> >>  	__u32 chunksize;    /* 52  the bitmap chunk size in bytes */
> >>  	__u32 daemon_sleep; /* 56  seconds between disk flushes */
> >>  	__u32 write_behind; /* 60  number of outstanding write-behind writes=
 */
> >> -
> >> -	__u8  pad[256 - 64]; /* set to zero */
> >> +	__u32 sectors_reserved; /* 64 number of 512-byte sectors that are
> >> +				 * reserved for the bitmap. */
> >> +	__u32 nodes;        /* 68 the maximum number of nodes in cluster. */
> >> +	__u8 cluster_name[64]; /* 72 cluster name to which this md belongs */
> >> +	__u8  pad[256 - 136]; /* set to zero */
> >>  } bitmap_super_t;
> >>    =20
> >
> > I missed this the first time, but these fields that you have added need=
 to be
> > added to sb_le_to_cpu().
> >
> >  =20
> I guess only nodes need to be added as follows:
>     sb->nodes =3D __le32_to_cpu(sb->nodes);

Why not "sectors_reserved".  It may not be used, but best to be consistent.

>=20
> Does the cluster_name need to be addressed too? Like.
>     for (i =3D 0; i < 64; i++)
>        sb->cluster_name[i] =3D (unsigned
> char)__le16_to_cpu(sb->cluster_name[i]);

No, cluster_name is __u8, and they aren't affected by CPU endian-ness.

Thanks,
NeilBrown


>=20
> Thanks,
> Guoqing
> > NeilBrown
> >  =20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/h6f94ywyNalCetwIFbMAFGL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUGZOjnsnt1WYoG5AQLxvBAAkLoGPzBF0S17g9IYS6wqAVsOd2e4ihy4
QUuCqq+BJrYpLmN84CGlM0JmKgvdD3l4qHTLAgSusrt3uPc98XYGc4NGE+RQdFM0
HcqpETgdgCLnOb5yCC/25Y4w3gmEsfYLhOEU9BswwVSHzTCgN8jseKGaD2sSfFCf
EfLx3qRwGpm+W+IzX+JorQklWQofXgeKMpVt7H+hbvG2FiEvUqrWfw2EFtnsHHcJ
xcuMB3Z4KGHaQGNnO6rxWH1rRg1CMnBY/6yzAqdcJkqg4EN8i5G++Z2SoCsaAmb2
9WZ+UAqDhx3FDQFXfZ3XDplIhlp41h/hQifqMhPz/0Jj+uwUSLTAcMY47GT27X0V
tQUxGxvPYV4hkACZ3JwBnegeXRlOFimxSI1f4j7WXLY0GfzcCXQvBeBnVBp+J372
ihFqdp5Gjydb6hXTlPxCF8kjGjXkkV/dR+Ry7ZTjJ11IrhBiwzW2/EGoFAch9vUt
8wW4rU17f3LcQzilAfCSWSJuivxKew+MjnzsNeicY+WtLGWm+lxZ/Lkm/YC1f42B
5jufB2lVur35w06oEFVWRvKcSWCB1rd38HrW0875XLjFJX/vymo+hfAsuu5o7d1T
1yi30fwnX+M2RtwmXtmcml9jhxBrS9tdj+5keXc8xhH5lxkq2NZXg+IqWc8lb1e8
8vahnEMfxF4=
=vqzi
-----END PGP SIGNATURE-----

--Sig_/h6f94ywyNalCetwIFbMAFGL--
