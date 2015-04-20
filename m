From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5: don't do chunk aligned read on degraded
 array.
Date: Mon, 20 Apr 2015 16:20:38 +1000
Message-ID: <20150420162038.72af8591@notabene.brown>
References: <550A60FF.3050902@gmail.com>
	<20150319170215.7d6dfd60@notabene.brown>
	<550B265C.7070907@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/j3/6q=feI9Z3SphPqLSlI6M"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <550B265C.7070907@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Mei <meijia@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/j3/6q=feI9Z3SphPqLSlI6M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Mar 2015 13:41:16 -0600 Eric Mei <meijia@gmail.com> wrote:

> On 2015-03-19 12:02 AM, NeilBrown wrote:
> > On Wed, 18 Mar 2015 23:39:11 -0600 Eric Mei <meijia@gmail.com> wrote:
> >
> >> From: Eric Mei <eric.mei@seagate.com>
> >>
> >> When array is degraded, read data landed on failed drives will result =
in
> >> reading rest of data in a stripe. So a single sequential read would
> >> result in same data being read twice.
> >>
> >> This patch is to avoid chunk aligned read for degraded array. The
> >> downside is to involve stripe cache which means associated CPU overhead
> >> and extra memory copy.
> >>
> >> Signed-off-by: Eric Mei <eric.mei@seagate.com>
> >> ---
> >>    drivers/md/raid5.c |   15 ++++++++++++---
> >>    1 files changed, 12 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index cd2f96b..763c64a 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -4180,8 +4180,12 @@ static int raid5_mergeable_bvec(struct mddev *m=
ddev,
> >>           unsigned int chunk_sectors =3D mddev->chunk_sectors;
> >>           unsigned int bio_sectors =3D bvm->bi_size >> 9;
> >>
> >> -       if ((bvm->bi_rw & 1) =3D=3D WRITE)
> >> -               return biovec->bv_len; /* always allow writes to be
> >> mergeable */
> >> +       /*
> >> +        * always allow writes to be mergeable, read as well if array
> >> +        * is degraded as we'll go through stripe cache anyway.
> >> +        */
> >> +       if ((bvm->bi_rw & 1) =3D=3D WRITE || mddev->degraded)
> >> +               return biovec->bv_len;
> >>
> >>           if (mddev->new_chunk_sectors < mddev->chunk_sectors)
> >>                   chunk_sectors =3D mddev->new_chunk_sectors;
> >> @@ -4656,7 +4660,12 @@ static void make_request(struct mddev *mddev,
> >> struct bio * bi)
> >>
> >>           md_write_start(mddev, bi);
> >>
> >> -       if (rw =3D=3D READ &&
> >> +       /*
> >> +        * If array is degraded, better not do chunk aligned read beca=
use
> >> +        * later we might have to read it again in order to reconstruct
> >> +        * data on failed drives.
> >> +        */
> >> +       if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> >>                mddev->reshape_position =3D=3D MaxSector &&
> >>                chunk_aligned_read(mddev,bi))
> >>                   return;
> >
> > Thanks for the patch.
> >
> > However this sort of patch really needs to come with some concrete
> > performance numbers.  Preferably both sequential reads and random reads.
> >
> > I agree that sequential reads are likely to be faster, but how much fas=
ter
> > are they?
> > I imagine that this might make random reads a little slower.   Does it?=
  By
> > how much?
> >
> > Thanks,
> > NeilBrown
> >
>=20
> Hi Neil,
>=20
> Sorry I should have done the test in first place.
>=20
> Following test are done on a enterprise storage node with Seagate 6T SAS=
=20
> drives and Xeon E5-2648L CPU (10 cores, 1.9Ghz), 10 disks MD RAID6 8+2,=20
> chunk size 128 KiB.
>=20
> I use FIO, using direct-io with various bs size, enough queue depth,=20
> tested sequential and 100% random read against 3 array config: 1)=20
> optimal, as baseline; 2) degraded; 3) degraded with this patch. Kernel=20
> version is 4.0-rc3.
>=20
> Each individual test I only did once so there might be some variations,=20
> but we just focus on big trend.
>=20
> Sequential Read:
>   bs=3D(KiB)  optimal(MiB/s)  degraded(MiB/s)  degraded-with-patch (MiB/s)
>    1024       1608            656              995
>     512       1624            710              956
>     256       1635            728              980
>     128       1636            771              983
>      64       1612           1119             1000
>      32       1580           1420             1004
>      16       1368            688              986
>       8        768            647              953
>       4        411            413              850
>=20
> Random Read:
>   bs=3D(KiB)  optimal(IOPS)  degraded(IOPS)  degraded-with-patch (IOPS)
>    1024        163            160              156
>     512        274            273              272
>     256        426            428              424
>     128        576            592              591
>      64        726            724              726
>      32        849            848              837
>      16        900            970              971
>       8        927            940              929
>       4        948            940              955
>=20
> Some notes:
>   * In sequential + optimal, as bs size getting smaller, the FIO thread=20
> become CPU bound.
>   * In sequential + degraded, there's big increase when bs is 64K and=20
> 32K, I don't have explanation.
>   * In sequential + degraded-with-patch, the MD thread mostly become CPU=
=20
> bound.
>=20
> If you want to we can discuss specific data point in those data. But in=20
> general it seems with this patch, we have more predictable and in most=20
> cases significant better sequential read performance when array is=20
> degraded, and almost no noticeable impact on random read.
>=20
> Performance is a complicated thing, the patch works well for this=20
> particular configuration, but may not be universal. For example I=20
> imagine testing on all SSD array may have very different result. But I=20
> personally think in most cases IO bandwidth is more scarce resource than=
=20
> CPU.
>=20
> Eric

Thanks.
That is reasonably convincing.

I've added that text to the commit message, fixed up all the white-space
damage in the patch (tabs were converted to spaces etc ... if you are going
to be sending more patches, please find a way to convince your mailer that
spaces are important), and applied it.

It should be included in my pull request for 4.1

Thanks,
NeilBrown

--Sig_/j3/6q=feI9Z3SphPqLSlI6M
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVTSatjnsnt1WYoG5AQJPfA/7BZHP5k9mO3nec4g3e4f6U7fZ4JQxkbQX
LhNRHyIEDecR1EL2aJR+FV0IbsEaOdDN1m13NqlcCSvd0sBrbeS3xMvrv5H05UKB
+TW4d8e0nRf5sBHwUyv0hIgCNSDh8RJqS7I4tGjHuAp5rv9bfaTnqhmIBP4bUSbT
UDfJ9e53SBUh7o6G5qr/YT3ialiUOFoq4nLKgv5gdHHtiHt5VetwSJbj+Z5gAwED
GVBSNtzUaTiGJRN8joqSSnznXCPnvpjOS69q9FzsNUeHRuGjBIdKO0u5234HelAU
Dc+AB7OfaVWORjf/lne9XCUtATQijP6hY/9mu4+P9/GLcSkKW7t6Q72WnzPzesBu
HMXlst3LeZtxRi1ry1jR6UGKTG+UPY04UAjDeshz+Gj9k6xiBQ7U3k9fJ7r/rz6W
Gh3XMknxDUMeo53265x2bc62CP47tmTM0nxWGCtVw8sY0+dR9LjEyMLE4GIG6Kcv
jCWU778ZuQroKv5MalA1rCE99QQD9hOB6Ncxx+YR9GPyyzh75IEnY05fBIvg2tD2
h5ceGhhYDwygkCPgjuVLvQeNCwoi4AgxQ9R7YCUBwaYfgk/7T3iko9YhWbP4ksOm
tWSsLfEdd0oSgEoSnZFMzE2yea9FbvT5pgwAPVFTcn5aOknDpZOQs0IDr4MF6ibU
8x/0zwi3SZo=
=4GI2
-----END PGP SIGNATURE-----

--Sig_/j3/6q=feI9Z3SphPqLSlI6M--
