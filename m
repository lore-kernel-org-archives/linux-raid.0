Received: from va-2-17.ptr.blmpb.com (va-2-17.ptr.blmpb.com [209.127.231.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFE1469847
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 19:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439218; cv=none; b=j/fzUEd4cIPY/DPBHNIhV1SJKAOogYwkZPtre4MzIlf0Lbk2H1l7USAuG17jVxGq2COgixWONs74Y9jcTAWQfgFDObArdCy4gYOhnR8hoOQ99bKnqPyYjo1nirbjFS0VqFPX/gcdglyRACynyG07T9kqN96yJ8eCkoDcn/FaBdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439218; c=relaxed/simple;
	bh=GzzVnMwycEXjEZ97IVroGrd1aG2e56AX/3V12POMHUg=;
	h=Message-Id:In-Reply-To:To:References:Subject:Date:Content-Type:Cc:
	 From:Mime-Version; b=qni9RK1c3XheqEM89vDNgPHDY0ONcyn8YAwtazCipb6B/I8k30KA/we3QoWTERmvwNZD1j8BqlQyG6TYynGaw8075EAPisaH8nDf5fIXcw+TlEkNpQ94cPYh97SUsN9peWijcZdJerVKQxtRsu2nuEj6WhgXrK+3AFWBtTtxaHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=DddNXyqM; arc=none smtp.client-ip=209.127.231.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="DddNXyqM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785439202;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=S3sci9l0181twER9UtdcYjx33AS4ybhJY0a1m+pCNpg=;
 b=DddNXyqM8UjRj2fdMtOhAUnZLeRnsA6KC7Oa7wroUGMF1AEfoF4SeY1RFXXFMlQ5f7xdsy
 O1fRl1EDHCK5G95j7Qr6qDOSllQCKiQWnPT2MV4qoeQ94BYACbbDqI/4l5jFuTEjBAgZjj
 ONuvwSPJwzibSfSNYx2mc2JjmX/qf2V9boBNJgG8sHshtEkUAJM7Ix44TQcHaM5CRQZvGu
 hOPvhV44CUcC/H+a7alm+e7nt6N0ZZSkIp263Zhp8EcPL/d2Ffu6D5tSzozDH/hbFFYVQ9
 p97apDOao4uFwpfnWjmADrB07FRdXh+9btA65sO9oE5XAsjkk1WMtIptDiLmBg==
Message-Id: <cec87d2c-a275-4eb1-88ce-c4fd2fed6c09@fygo.io>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 19:20:01 +0000
In-Reply-To: <20260710132329.7273-2-nishidafmly@gmail.com>
To: "Hiroshi Nishida" <nishidafmly@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
References: <20260710132329.7273-1-nishidafmly@gmail.com> <20260710132329.7273-2-nishidafmly@gmail.com>
Reply-To: yukuai@fygo.io
Subject: Re: [PATCH 1/2] md: change chunk_sectors and stripe cache counts to unsigned int
Date: Fri, 31 Jul 2026 03:19:57 +0800
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a6ba3e2+0aaedf+vger.kernel.org+yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/7/10 21:23, Hiroshi Nishida =E5=86=99=E9=81=93:
> chunk_sectors, new_chunk_sectors, prev_chunk_sectors, max_nr_stripes,
> and min_nr_stripes are never negative. Using signed int is semantically
> wrong and prevents the compiler from optimizing division/modulo by
> power-of-two chunk sizes to right shifts in the hot I/O path.
>
> Change all struct fields and derived local variables to unsigned int:
>    mddev->chunk_sectors
>    mddev->new_chunk_sectors
>    r5conf->chunk_sectors
>    r5conf->prev_chunk_sectors
>    r5conf->max_nr_stripes
>    r5conf->min_nr_stripes
>    Local: sectors_per_chunk, new_chunk, chunk_sectors
>
> The min() in r5c_check_cached_full_stripe() required both operands to
> match signedness; this is now satisfied with max_nr_stripes unsigned.
>
> Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
> ---
>   drivers/md/md.h    |  4 ++--
>   drivers/md/raid5.c | 14 +++++++-------
>   drivers/md/raid5.h |  8 ++++----
>   3 files changed, 13 insertions(+), 13 deletions(-)

Patch looks fine, but you're missing some places like raid5_show_stripe_cac=
he_size(),
where %d is used to print min_nr_stripes.

>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index d8daf0f75cbb..b9ad26844799 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -437,7 +437,7 @@ struct mddev {
>   	int				external;	/* metadata is
>   							 * managed externally */
>   	char				metadata_type[17]; /* externally set*/
> -	int				chunk_sectors;
> +	unsigned int			chunk_sectors;
>   	time64_t			ctime, utime;
>   	int				level, layout;
>   	char				clevel[16];
> @@ -466,7 +466,7 @@ struct mddev {
>   	 */
>   	sector_t			reshape_position;
>   	int				delta_disks, new_level, new_layout;
> -	int				new_chunk_sectors;
> +	unsigned int			new_chunk_sectors;
>   	int				reshape_backwards;
>  =20
>   	struct md_thread __rcu		*thread;	/* management thread */
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0c5c9fb0606e..28828e083c2b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2970,7 +2970,7 @@ sector_t raid5_compute_sector(struct r5conf *conf, =
sector_t r_sector,
>   	sector_t new_sector;
>   	int algorithm =3D previous ? conf->prev_algo
>   				 : conf->algorithm;
> -	int sectors_per_chunk =3D previous ? conf->prev_chunk_sectors
> +	unsigned int sectors_per_chunk =3D previous ? conf->prev_chunk_sectors
>   					 : conf->chunk_sectors;
>   	int raid_disks =3D previous ? conf->previous_raid_disks
>   				  : conf->raid_disks;
> @@ -3166,7 +3166,7 @@ sector_t raid5_compute_blocknr(struct stripe_head *=
sh, int i, int previous)
>   	int raid_disks =3D sh->disks;
>   	int data_disks =3D raid_disks - conf->max_degraded;
>   	sector_t new_sector =3D sh->sector, check;
> -	int sectors_per_chunk =3D previous ? conf->prev_chunk_sectors
> +	unsigned int sectors_per_chunk =3D previous ? conf->prev_chunk_sectors
>   					 : conf->chunk_sectors;
>   	int algorithm =3D previous ? conf->prev_algo
>   				 : conf->algorithm;
> @@ -3584,7 +3584,7 @@ static void end_reshape(struct r5conf *conf);
>   static void stripe_set_idx(sector_t stripe, struct r5conf *conf, int pr=
evious,
>   			    struct stripe_head *sh)
>   {
> -	int sectors_per_chunk =3D
> +	unsigned int sectors_per_chunk =3D
>   		previous ? conf->prev_chunk_sectors : conf->chunk_sectors;
>   	int dd_idx;
>   	int chunk_offset =3D sector_div(stripe, sectors_per_chunk);
> @@ -6103,7 +6103,7 @@ static enum stripe_result make_stripe_request(struc=
t mddev *mddev,
>   static sector_t raid5_bio_lowest_chunk_sector(struct r5conf *conf,
>   					      struct bio *bi)
>   {
> -	int sectors_per_chunk =3D conf->chunk_sectors;
> +	unsigned int sectors_per_chunk =3D conf->chunk_sectors;
>   	int raid_disks =3D conf->raid_disks;
>   	int dd_idx;
>   	struct stripe_head sh;
> @@ -7930,7 +7930,7 @@ static int raid5_run(struct mddev *mddev)
>   		sector_t here_new, here_old;
>   		int old_disks;
>   		int max_degraded =3D (mddev->level =3D=3D 6 ? 2 : 1);
> -		int chunk_sectors;
> +		unsigned int chunk_sectors;
>   		int new_data_disks;
>  =20
>   		if (journal_dev) {
> @@ -8832,7 +8832,7 @@ static int raid5_check_reshape(struct mddev *mddev)
>   	 * to be used by a reshape pass.
>   	 */
>   	struct r5conf *conf =3D mddev->private;
> -	int new_chunk =3D mddev->new_chunk_sectors;
> +	unsigned int new_chunk =3D mddev->new_chunk_sectors;
>  =20
>   	if (mddev->new_layout >=3D 0 && !algorithm_valid_raid5(mddev->new_layo=
ut))
>   		return -EINVAL;
> @@ -8866,7 +8866,7 @@ static int raid5_check_reshape(struct mddev *mddev)
>  =20
>   static int raid6_check_reshape(struct mddev *mddev)
>   {
> -	int new_chunk =3D mddev->new_chunk_sectors;
> +	unsigned int new_chunk =3D mddev->new_chunk_sectors;
>  =20
>   	if (mddev->new_layout >=3D 0 && !algorithm_valid_raid6(mddev->new_layo=
ut))
>   		return -EINVAL;
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index cb5feae04db2..5cd9d0f36b6e 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -572,12 +572,12 @@ struct r5conf {
>   	/* only protect corresponding hash list and inactive_list */
>   	spinlock_t		hash_locks[NR_STRIPE_HASH_LOCKS];
>   	struct mddev		*mddev;
> -	int			chunk_sectors;
> +	unsigned int		chunk_sectors;
>   	int			level, algorithm, rmw_level;
>   	int			max_degraded;
>   	int			raid_disks;
> -	int			max_nr_stripes;
> -	int			min_nr_stripes;
> +	unsigned int		max_nr_stripes;
> +	unsigned int		min_nr_stripes;
>   #if PAGE_SIZE !=3D DEFAULT_STRIPE_SIZE
>   	unsigned long	stripe_size;
>   	unsigned int	stripe_shift;
> @@ -595,7 +595,7 @@ struct r5conf {
>   	 */
>   	sector_t		reshape_safe;
>   	int			previous_raid_disks;
> -	int			prev_chunk_sectors;
> +	unsigned int		prev_chunk_sectors;
>   	int			prev_algo;
>   	short			generation; /* increments with every reshape */
>   	seqcount_spinlock_t	gen_lock;	/* lock against generation changes */

--=20
Thanks,
Kuai
