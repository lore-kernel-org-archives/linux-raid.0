From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V3 00/11] mdadm tool: add the support for cluster-md
Date: Mon, 25 May 2015 15:03:15 +1000
Message-ID: <20150525150315.2ccf8333@notabene.brown>
References: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/GzmnBYZ//giITgrxXVXKH8W"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

--Sig_/GzmnBYZ//giITgrxXVXKH8W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 May 2015 11:20:32 +0800 Guoqing Jiang <gqjiang@suse.com> wrote:

> V3 changes:
> 1. re-orgnize some codes to ensure mdadm compiles after each patch is app=
lied
> 2. change the code for super1.c for first patch since it has side effect =
for
> non-cluster condition
>=20
> V2 changes:
> 1. re-arrange the squence of patches
> 2. add some memembers into sb_le_to_cpu
> 3. handle some logic change and comments from Neil
>=20
> Basic background for Cluster MD: Cluster MD is a shared-device RAID for a
> cluster, currently, the implementation is limited to RAID1 but with furth=
er
> work (and some positive feedback), it could be extend to other RAID level=
s.
>=20
> The kernel part code of cluster-md has been sent to maillist several month
> ago by Goldywyn, and to make cluster-md works, the mdadm tools also need =
to
> do some changes accordingly.
>=20
> This patch set extends mdadm tool to aware cluster MD scenario, and handle
> related cluster-md scenario.
>=20
> 1. the first part (0001-0007) comes from Goldwyn, which add initial
> support for cluster-md, those changes included make mdadm awares nodes,
> home-cluster and n bitmaps for clustered mode, also let mdadm can=20
> confirm disk which is added by another node.
>=20
>=20
> 2. the second part is for support change cluster-name and node nums under
> assemble mode. Which extend write-bitmap to handle above cases, and also
> use the extended write_bitmap for update uuid. [PATCH V2 10/10] is just c=
ompiled
> test only.
>=20
> BTW: this series is based on commit "72a457 IMSM: Count arrays per orom".
>=20
> Some reltated links:
> [1] http://marc.info/?l=3Dlinux-raid&m=3D141891941330336&w=3D2
> [2] http://marc.info/?l=3Dlinux-raid&m=3D141935561418770&w=3D2
>=20
> Guoqing Jiang (11):
>   Create n bitmaps for clustered mode
>   Add nodes option while creating md
>   home-cluster while creating an array
>   Show all bitmaps while examining bitmap
>   Add a new clustered disk
>   Convert a bitmap=3Dnone device to clustered
>   Skip clustered devices in incremental
>   mdadm: add the ability to change cluster name
>   mdadm: change the num of cluster node
>   Reuse calc_bitmap_size to reduce code size
>   Reuse the write_bitmap for update uuid
>=20
>  Assemble.c    |  14 ++++--
>  Create.c      |   5 +-
>  Grow.c        |  22 +++++++--
>  Incremental.c |   5 ++
>  Makefile      |   1 +
>  Manage.c      |  33 +++++++++++--
>  ReadMe.c      |   3 ++
>  bitmap.c      |  94 ++++++++++++++++++++++---------------
>  bitmap.h      |   7 ++-
>  config.c      |  27 ++++++++++-
>  md_p.h        |   7 +++
>  md_u.h        |   1 +
>  mdadm.8.in    |  28 +++++++++++-
>  mdadm.c       |  69 +++++++++++++++++++++++++++-
>  mdadm.h       |  20 +++++++-
>  super0.c      |   4 +-
>  super1.c      | 145 +++++++++++++++++++++++++++++++++++++++++++++++-----=
------
>  util.c        |  60 ++++++++++++++++++++++++
>  18 files changed, 458 insertions(+), 87 deletions(-)
>=20


Thanks.  This looked like it is getting close.  Most of the things I have
commented on a fairly minor and should be easy to fix.
Hopefully the next time you post I have just add all the patched to my git
tree and we can take incremental patches from there.

I hope to make a 3.3.3 release of mdadm soonish, and then I'll target 3.4 to
primarily just add the clustering stuff.
If I get the next patchset before I've released 3.3.3, I'll just put it in a
separate branch and merge it later.

Thanks,
NeilBrown


--Sig_/GzmnBYZ//giITgrxXVXKH8W
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWKtEznsnt1WYoG5AQJt5RAAn2sOUgfCh11gnKcUqnXi1/UTqU6DXY+1
iPI2mkftXxXCb0osLw257o+mjR2Tco8RfhzEpTovvkH8JN+Pl9sKxTwtulDex7AM
35K4Xen9mCEV65eZJxFPYINU3l+sECfZkY84NvFTfx1ovLJw59FqSyWFEq1FADJP
qQaVYUzLMaYekHeBz3y2X9kQXU0OP/pdh6sVfw/dT8owXnKpvortf5miHUGwPwO2
FCC+J4qKM73V64ArGSnl2sv31vp4hHnqdsfQf1XTBfdcgMamquN0GkUs29eNNQpq
McC7vAdPqTa2DLmeB8C762VVTRievM5lXKtzo2Nk+tJC2Wr1NI5JMpbTPul5J1f5
cOEHRzkBMHNPop/XgflcCbjXtwFw53edibKssc24McwCHtDt41BVqf/yaOMgNlqu
CHlS0szh5th+6EnxOohYsyfLaLE5knddHkzP8PZeVhVJvY4PwiGLU9AfazObiBwt
UZjL/YNkK8g6pNpjgzSKVzg+7q4XKx1U62tLKX0BrKWRiL+pwyTxW1iJPrsX6xW0
g8Y9gW9DeZHwNYpg/XTjB8Xm33JMex3qBF1sYUis8gG/JEvTj+qs/QJlax289gdK
wMDAlW5p9Xx+AdR2XKpL+TyAtyShJvpRfCuSfESiYfHK9pgo/18PRBukjoK7e619
UmUq/b2Bv7Q=
=ETbQ
-----END PGP SIGNATURE-----

--Sig_/GzmnBYZ//giITgrxXVXKH8W--
