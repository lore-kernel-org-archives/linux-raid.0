Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8DE0C47082
	for <linux-raid@archiver.kernel.org>; Mon,  7 Jun 2021 11:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB5136101A
	for <linux-raid@archiver.kernel.org>; Mon,  7 Jun 2021 11:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhFGLYs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Jun 2021 07:24:48 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34644 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhFGLYs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Jun 2021 07:24:48 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D0CF421A91;
        Mon,  7 Jun 2021 11:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623064976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x1SWGPhCts1d1ModnEovTJ4Djoyi0/RcWNZDulUSeZ4=;
        b=rdNtyzyNEOTacEm+t1I6alANBQUaxvXUQGIuZLjPAMU3pKAZrdwSxxBv/HhAxMkOKUstOb
        h0O0JIuoAHBMm0QkUyD2TVmWdFXNK4IJOn4t0qpZgX1TFMmzBOJgXk0A3jR+kmOzKnwmAp
        SIh7HR1Ijg1laoyOddqch3VyhrnFyEA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623064976;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x1SWGPhCts1d1ModnEovTJ4Djoyi0/RcWNZDulUSeZ4=;
        b=wqfXQp+4H1WQNu1SFOjLSRBJ0ulqnzqBfwUO3fwnimO6NiwVjQNM/YI9MMBM2I9ERaU7NV
        9HyDoLEYtcHHDZAA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 8A3F9118DD;
        Mon,  7 Jun 2021 11:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623064976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x1SWGPhCts1d1ModnEovTJ4Djoyi0/RcWNZDulUSeZ4=;
        b=rdNtyzyNEOTacEm+t1I6alANBQUaxvXUQGIuZLjPAMU3pKAZrdwSxxBv/HhAxMkOKUstOb
        h0O0JIuoAHBMm0QkUyD2TVmWdFXNK4IJOn4t0qpZgX1TFMmzBOJgXk0A3jR+kmOzKnwmAp
        SIh7HR1Ijg1laoyOddqch3VyhrnFyEA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623064976;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x1SWGPhCts1d1ModnEovTJ4Djoyi0/RcWNZDulUSeZ4=;
        b=wqfXQp+4H1WQNu1SFOjLSRBJ0ulqnzqBfwUO3fwnimO6NiwVjQNM/YI9MMBM2I9ERaU7NV
        9HyDoLEYtcHHDZAA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id hViaD48BvmA2VQAALh3uQQ
        (envelope-from <neilb@suse.de>); Mon, 07 Jun 2021 11:22:55 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     gal.ofri@storing.io
Cc:     linux-raid@vger.kernel.org, "Gal Ofri" <gal.ofri@storing.io>,
        "Song Liu" <song@kernel.org>
Subject: Re: [PATCH v2] md/raid5: avoid device_lock in read_one_chunk()
In-reply-to: <20210607110702.660443-1-gal.ofri@storing.io>
References: <162302508816.16225.936948442459930625@noble.neil.brown.name>,
 <20210607110702.660443-1-gal.ofri@storing.io>
Date:   Mon, 07 Jun 2021 21:22:52 +1000
Message-id: <162306497207.32569.4821556528932781303@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 07 Jun 2021, gal.ofri@storing.io wrote:
> From: Gal Ofri <gal.ofri@storing.io>
>=20
> There is a lock contention on device_lock in read_one_chunk().
> device_lock is taken to sync conf->active_aligned_reads and
> conf->quiesce.
> read_one_chunk() takes the lock, then waits for quiesce=3D0 (resumed)
> before incrementing active_aligned_reads.
> raid5_quiesce() takes the lock, sets quiesce=3D2 (in-progress), then waits
> for active_aligned_reads to be zero before setting quiesce=3D1
> (suspended).
>=20
> Introduce a fast (lockless) path in read_one_chunk(): activate aligned
> read without taking device_lock.  In case quiesce starts while
> activating the aligned-read in fast path, deactivate it and revert to
> old behavior (take device_lock and wait for quiesce to finish).
>=20
> Add smp store/load in raid5_quiesce()/read_one_chunk() respectively to
> gaurantee that read_one_chunk() does not miss an ongoing quiesce.
>=20
> My setups:
> 1. 8 local nvme drives (each up to 250k iops).
> 2. 8 ram disks (brd).
>=20
> Each setup with raid6 (6+2), 1024 io threads on a 96 cpu-cores (48 per
> socket) system. Record both iops and cpu spent on this contention with
> rand-read-4k. Record bw with sequential-read-128k.  Note: in most cases
> cpu is still busy but due to "new" bottlenecks.
>=20
> nvme:
>               | iops           | cpu  | bw
> -----------------------------------------------
> without patch | 1.6M           | ~50% | 5.5GB/s
> with patch    | 2M (throttled) | 0%   | 16GB/s (throttled)
>=20
> ram (brd):
>               | iops           | cpu  | bw
> -----------------------------------------------
> without patch | 2M             | ~80% | 24GB/s
> with patch    | 4M             | 0%   | 55GB/s
>=20
> CC: Song Liu <song@kernel.org>
> CC: Neil Brown <neilb@suse.de>
> Signed-off-by: Gal Ofri <gal.ofri@storing.io>

Reviewed-by: NeilBrown <neilb@suse.de>

Thanks for this!

NeilBrown


> ---
> * tested with kcsan & lockdep; no new errors.
> * tested mixed io (70% read) with data verification (vdbench -v)
> while repeatedly changing group_thread_cnt (enter/exit quiesce).
> * thank you Neil for guiding me through this patch.
> ---
>  drivers/md/raid5.c | 29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7d4ff8a5c55e..f64259f044fd 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5396,6 +5396,7 @@ static int raid5_read_one_chunk(struct mddev *mddev, =
struct bio *raid_bio)
>  	struct md_rdev *rdev;
>  	sector_t sector, end_sector, first_bad;
>  	int bad_sectors, dd_idx;
> +	bool did_inc;
> =20
>  	if (!in_chunk_boundary(mddev, raid_bio)) {
>  		pr_debug("%s: non aligned\n", __func__);
> @@ -5443,11 +5444,24 @@ static int raid5_read_one_chunk(struct mddev *mddev=
, struct bio *raid_bio)
>  	/* No reshape active, so we can trust rdev->data_offset */
>  	align_bio->bi_iter.bi_sector +=3D rdev->data_offset;
> =20
> -	spin_lock_irq(&conf->device_lock);
> -	wait_event_lock_irq(conf->wait_for_quiescent, conf->quiesce =3D=3D 0,
> -			    conf->device_lock);
> -	atomic_inc(&conf->active_aligned_reads);
> -	spin_unlock_irq(&conf->device_lock);
> +	did_inc =3D false;
> +	if (conf->quiesce =3D=3D 0) {
> +		atomic_inc(&conf->active_aligned_reads);
> +		did_inc =3D true;
> +	}
> +	/* need a memory barrier to detect the race with raid5_quiesce() */
> +	if (!did_inc || smp_load_acquire(&conf->quiesce) !=3D 0) {
> +		/* quiesce is in progress, so we need to undo io activation and wait
> +		 * for it to finish
> +		 */
> +		if (did_inc && atomic_dec_and_test(&conf->active_aligned_reads))
> +			wake_up(&conf->wait_for_quiescent);
> +		spin_lock_irq(&conf->device_lock);
> +		wait_event_lock_irq(conf->wait_for_quiescent, conf->quiesce =3D=3D 0,
> +				    conf->device_lock);
> +		atomic_inc(&conf->active_aligned_reads);
> +		spin_unlock_irq(&conf->device_lock);
> +	}
> =20
>  	if (mddev->gendisk)
>  		trace_block_bio_remap(align_bio, disk_devt(mddev->gendisk),
> @@ -8334,7 +8348,10 @@ static void raid5_quiesce(struct mddev *mddev, int q=
uiesce)
>  		 * active stripes can drain
>  		 */
>  		r5c_flush_cache(conf, INT_MAX);
> -		conf->quiesce =3D 2;
> +		/* need a memory barrier to make sure read_one_chunk() sees
> +		 * quiesce started and reverts to slow (locked) path.
> +		 */
> +		smp_store_release(&conf->quiesce, 2);
>  		wait_event_cmd(conf->wait_for_quiescent,
>  				    atomic_read(&conf->active_stripes) =3D=3D 0 &&
>  				    atomic_read(&conf->active_aligned_reads) =3D=3D 0,
> --=20
> 2.25.1
>=20
>=20
