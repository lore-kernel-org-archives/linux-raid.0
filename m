Received: from va-2-49.ptr.blmpb.com (va-2-49.ptr.blmpb.com [209.127.231.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3A133EAF9
	for <linux-raid@vger.kernel.org>; Sat, 11 Jul 2026 15:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783784277; cv=none; b=OP6oMsML+KHiPHrYvMGKgoPlwiQuIOzTZotU3wYpMbfEmqa4XaAs7Rr5e7XB44Gx4CUEpDS5Xbuve0BdKxJYNoHf8k2HuQENrVtlk8dNdKE8Cc+FebY8E1ftxMVUPBvcg9Yi5yo3LT5h5YAP3glrLKpY74rSe6UeXdcI4bKbL6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783784277; c=relaxed/simple;
	bh=BY8G15qWH/I2bDC/MGKJFnSAdfnLhDEVnQYifTjdQUc=;
	h=Subject:Message-Id:Mime-Version:From:Date:References:To:Cc:
	 In-Reply-To:Content-Type; b=YQsqb/pnHDl7m2DNYhZ6t7Jp/KLgzesO6/6mvQUTkNtJYHemG/4nc614B6PLb8ualQavihcc11bgGsqih/EIZsHBGROUv0OSQ/HO+GdDatXBa8LwzQXBk1GiPApfFdR7e1IpCmRtk7vrmOQpES1CI5QNQbggT3V1wcq6xe3nb9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=l+hFnzQk; arc=none smtp.client-ip=209.127.231.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="l+hFnzQk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783784252;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=o9wtXnejuzo06u1kgNqaOy7AVDTsetig6TiVmrQwkS8=;
 b=l+hFnzQk1LlMG//MuR4DnEPcRVmcvYPCz+nMWVuAoQBRqms52ocN1JTngBy4AUuknBwntL
 Zkqmw6YsBWDCXwR/eR5W2ploLxrBRhSprRyd+AAEt8UYImkt6x3eFX1K+JhEGSHr18ATBp
 reIPW8T50OyrFF40X+gWZLgmtQlJjT8S7NHks2vwF6KjvXMru0SgG2G9QTYjgLysYyF50o
 mbExi2WP8MoJiLLS1DOS0olSi9vSk6urW+IsWT/spsOak0NsYW1y0jY1NfSu92oz7Rcqpt
 SxkD2MWRvLbsKDRGIrxGSdhFjXrsefoX1KKQUD5kUGG0UvCjEpjmFOQ9tku5Iw==
Subject: Re: [PATCH] md/raid5: protect lockless reshape_progress accesses
Message-Id: <ca9687a1-e562-47ee-9fa9-404b99825249@fygo.io>
Reply-To: yukuai@fygo.io
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "yu kuai" <yukuai@fygo.io>
Date: Sat, 11 Jul 2026 23:37:27 +0800
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a52633c+51587c+vger.kernel.org+yukuai@fygo.io>
References: <20260627105524.144022-1-chencheng@fnnas.com>
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Cc: <linux-kernel@vger.kernel.org>
In-Reply-To: <20260627105524.144022-1-chencheng@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Sat, 11 Jul 2026 15:37:31 +0000

Hi,

=E5=9C=A8 2026/6/27 18:55, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> During reshape:
> - reshape_request() advances conf->reshape_progress.
> - reshape_request() itself also reads conf->reshape_progress several time=
s
>    while calculating sector_nr, writepos, and readpos for the current
>    reshape step.
> - use_new_offset() reads conf->reshape_progress locklessly to decide
>    whether the current stripe should use data_offset or new_data_offset.
>
> one possible scenario is:
>
> CPU1                            CPU2
> reshape_request()
> -> conf->reshape_progress +=3D delta
>                                  ops_run_io()
>                                  -> use_new_offset(conf, sh)
>                                  -> progress =3D conf->reshape_progress
>                                  -> decide old layout or new layout
>                                  -> use data_offset or new_data_offset
>
> reshape_progress is the boundary between old and new layout mapping.
>
> If CPU2 observes an unprotected reshape_progress value, it can choose
> the wrong layout offset for the current stripe.
>
> if reshape_request() reads reshape_progress multiple times without
> a stable snapshot, one iteration of reshape can calculate its range from
> inconsistent progress values.
>
> Fixes: 7a6613810785 ("md/raid5: reshape using largest of old and new chun=
k size")
>
> The race report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KCSAN: data-race in ops_run_io / reshape_request
>
> write to 0xffff89a8d3ef2270 of 8 bytes by task 1299 on cpu 7:
>   reshape_request+0x1292/0x17b0
>   raid5_sync_request+0x815/0xa00
>   md_do_sync.cold+0xf8d/0x1516
>   md_thread+0x15a/0x2d0
>   [....]
>
> read to 0xffff89a8d3ef2270 of 8 bytes by task 1292 on cpu 9:
>   ops_run_io+0xc25/0x1960
>   handle_stripe+0x2273/0x4570
>   handle_active_stripes.isra.0+0x6e0/0xa50
>   raid5d+0x7d5/0xb90
>   [....]
>
> value changed: 0x0000000000173700 -> 0x0000000000173800
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 34 +++++++++++++++++++++-------------
>   1 file changed, 21 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index eaee7f206ab8..b6809f1a3ab4 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1011,11 +1011,11 @@ static void stripe_add_to_batch_list(struct r5con=
f *conf,
>   /* Determine if 'data_offset' or 'new_data_offset' should be used
>    * in this stripe_head.
>    */
>   static int use_new_offset(struct r5conf *conf, struct stripe_head *sh)
>   {
> -	sector_t progress =3D conf->reshape_progress;
> +	sector_t progress =3D READ_ONCE(conf->reshape_progress);
>   	/* Need a memory barrier to make sure we see the value
>   	 * of conf->generation, or ->data_offset that was set before
>   	 * reshape_progress was updated.
>   	 */
>   	smp_rmb();
> @@ -6340,24 +6340,25 @@ static sector_t reshape_request(struct mddev *mdd=
ev, sector_t sector_nr, int *sk
>   	sector_t writepos, readpos, safepos;
>   	sector_t stripe_addr;
>   	int reshape_sectors;
>   	struct list_head stripes;
>   	sector_t retn;
> +	sector_t reshape_progress =3D READ_ONCE(conf->reshape_progress);
>  =20
>   	if (sector_nr =3D=3D 0) {
>   		/* If restarting in the middle, skip the initial sectors */
>   		if (mddev->reshape_backwards &&
> -		    conf->reshape_progress < raid5_size(mddev, 0, 0)) {
> +		    reshape_progress < raid5_size(mddev, 0, 0)) {
>   			sector_nr =3D raid5_size(mddev, 0, 0)
> -				- conf->reshape_progress;
> +				- reshape_progress;
>   		} else if (mddev->reshape_backwards &&
> -			   conf->reshape_progress =3D=3D MaxSector) {
> +			   reshape_progress =3D=3D MaxSector) {
>   			/* shouldn't happen, but just in case, finish up.*/
>   			sector_nr =3D MaxSector;
>   		} else if (!mddev->reshape_backwards &&
> -			   conf->reshape_progress > 0)
> -			sector_nr =3D conf->reshape_progress;
> +			   reshape_progress > 0)
> +			sector_nr =3D reshape_progress;
>   		sector_div(sector_nr, new_data_disks);
>   		if (sector_nr) {
>   			mddev->curr_resync_completed =3D sector_nr;
>   			sysfs_notify_dirent_safe(mddev->sysfs_completed);
>   			*skipped =3D 1;
> @@ -6377,13 +6378,13 @@ static sector_t reshape_request(struct mddev *mdd=
ev, sector_t sector_nr, int *sk
>   	 * the data about to be copied would over-write the source of
>   	 * the data at the front of the range.  i.e. one new_stripe
>   	 * along from reshape_progress new_maps to after where
>   	 * reshape_safe old_maps to
>   	 */
> -	writepos =3D conf->reshape_progress;
> +	writepos =3D reshape_progress;
>   	sector_div(writepos, new_data_disks);
> -	readpos =3D conf->reshape_progress;
> +	readpos =3D reshape_progress;
>   	sector_div(readpos, data_disks);
>   	safepos =3D conf->reshape_safe;
>   	sector_div(safepos, data_disks);
>   	if (mddev->reshape_backwards) {
>   		if (WARN_ON(writepos < reshape_sectors))
> @@ -6404,11 +6405,11 @@ static sector_t reshape_request(struct mddev *mdd=
ev, sector_t sector_nr, int *sk
>  =20
>   	/* Having calculated the 'writepos' possibly use it
>   	 * to set 'stripe_addr' which is where we will write to.
>   	 */
>   	if (mddev->reshape_backwards) {
> -		if (WARN_ON(conf->reshape_progress =3D=3D 0))
> +		if (WARN_ON(reshape_progress =3D=3D 0))
>   			return MaxSector;
>  =20
>   		stripe_addr =3D writepos;
>   		if (WARN_ON((mddev->dev_sectors &
>   		    ~((sector_t)reshape_sectors - 1)) -
> @@ -6514,14 +6515,21 @@ static sector_t reshape_request(struct mddev *mdd=
ev, sector_t sector_nr, int *sk
>   			set_bit(STRIPE_HANDLE, &sh->state);
>   		}
>   		list_add(&sh->lru, &stripes);
>   	}
>   	spin_lock_irq(&conf->device_lock);
> -	if (mddev->reshape_backwards)
> -		conf->reshape_progress -=3D reshape_sectors * new_data_disks;
> -	else
> -		conf->reshape_progress +=3D reshape_sectors * new_data_disks;
> +	if (mddev->reshape_backwards) {
> +		sector_t progress =3D conf->reshape_progress;
> +
> +		progress -=3D reshape_sectors * new_data_disks;
> +		WRITE_ONCE(conf->reshape_progress, progress);
> +	} else {
> +		sector_t progress =3D conf->reshape_progress;
> +
> +		progress +=3D reshape_sectors * new_data_disks;
> +		WRITE_ONCE(conf->reshape_progress, progress);
> +	}
>   	spin_unlock_irq(&conf->device_lock);
>   	/* Ok, those stripe are ready. We can start scheduling
>   	 * reads on the source stripes.
>   	 * The source stripes are determined by mapping the first and last
>   	 * block on the destination stripes.

AI report there are still other places, please check:

 =C2=A0 1. get_reshape_loc(), the fast path before taking device_lock:

 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (likely(conf->reshape_progress =3D=
=3D MaxSector))
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return LOC_=
NO_RESHAPE;

 =C2=A0 =C2=A0 =C2=A0The comment right below it already mentions the 64bit-=
on-32bit tearing
 =C2=A0 =C2=A0 =C2=A0concern, so it makes sense to mark it:

 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (likely(READ_ONCE(conf->reshape_prog=
ress) =3D=3D MaxSector))

 =C2=A0 2. raid5_make_request():

 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (likely(conf->reshape_progress =3D=
=3D MaxSector)) {

 =C2=A0 =C2=A0 =C2=A0Same - called on every IO, lockless.

 =C2=A0 For consistency the `=3D=3D MaxSector` check in raid5_remove_disk()=
 could use
 =C2=A0 READ_ONCE() too, though it's a reconfig path.


--=20
Thanks,
Kuai
