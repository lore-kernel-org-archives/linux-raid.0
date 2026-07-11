Received: from va-2-57.ptr.blmpb.com (va-2-57.ptr.blmpb.com [209.127.231.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CAB2AD35
	for <linux-raid@vger.kernel.org>; Sat, 11 Jul 2026 18:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783793780; cv=none; b=HS6aOET+bgEPCxL9KDQb2Inc2tLS+oLmelxYghhe1wI3v+TFyUTuJ0aqS2NW7JUKSlJpfOXFOlueYGXXd5ZbBy/XnazPcgTQOkkvzc95DM0tk0p57CZ7AkWVilx7kajRSZw4Cp2WjRERW5oajTaWJgvwN0icbqCy8dl5GYQvG/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783793780; c=relaxed/simple;
	bh=4MPpNDsC3+zXFVdXJPxUHNRgpDH49bOaXXgALzu56o8=;
	h=Subject:References:Cc:From:Mime-Version:Content-Type:To:Date:
	 Message-Id:In-Reply-To; b=N0yj1iZ8ZiHCFi1/sAsA4oLaA3c8BVejk3Dq16Yq3+B73jw4fZWSTaeY2/Cjnty4B17InMYtUk6ei37DiL4nR3P8xxNFMgvZtV4gS0ScN8uAa4nWcwUF3R3VounD90Zc/bL0307rQZ9s1EYYCt12COEhinwuevHqnT/oT7tzYQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=dsTOostP; arc=none smtp.client-ip=209.127.231.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="dsTOostP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783793767;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=xLhOvieB8schKQ0UHProLEoOxJ4Ogx3dEe1fKxopK5A=;
 b=dsTOostPVRYDtNyfoeOuJjpbRSYMOCWoFjyAxQMzCK42aP0W/6jXuVbm+GvTDSIcImfBag
 gg2ulc45jlC/fBO1wku5XS9STQhb5Ofr5/lBtllD2GrwMInrJTrn8c0LDT+BrRKlP+AE3z
 7yKg6AZZceVX4oAn7oXRye0z4t5QAVS7yfs1mKUcaWSuiFZbsRmPydxfpRvXNxdMmd6Ll3
 dbe4bUk95cnZd+1ee75/Kz+nym7K5X/BxqTH/cvWbFADOZLkVPFpvNqXQyeeSvFl1NcpB0
 2EevY6LE0x4m2y1EP/p8R3xUXe+xT61SI4p61x2QNV2945jnFeBmkiSV19J3iA==
X-Original-From: yu kuai <yukuai@fygo.io>
Subject: Re: [PATCH] md: use READ_ONCE() for lockless reads of sb_flags
X-Lms-Return-Path: <lba+26a528866+40e111+vger.kernel.org+yukuai@fygo.io>
References: <20260711025121.3991689-1-chencheng@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Sat, 11 Jul 2026 18:16:05 +0000
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Cc: <linux-kernel@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>
Date: Sun, 12 Jul 2026 02:16:03 +0800
Message-Id: <654cb68a-32e1-4fa7-a735-5a6f833db39e@fygo.io>
In-Reply-To: <20260711025121.3991689-1-chencheng@fnnas.com>

Hi,

=E5=9C=A8 2026/7/11 10:51, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> sb_flags is checked without a lock in md, raid1, raid5, and raid10.
> KCSAN reports these reads as data races.
>
> The write side uses atomic bit ops.
> The read side still has plain loads in a few places.
>
> Use READ_ONCE() for the lockless reads of sb_flags.
>
> KCSAN reports #1:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> BUG: KCSAN: data-race in md_check_recovery / md_write_start
>
> write (marked) to 0xffff8e39f897f030 of 8 bytes by task 248146 on cpu 8:
>    md_write_start+0x5dd/0x910
>    raid10_make_request+0x9b/0x1080
>    md_handle_request+0x4a2/0xa40
>    [........]
>
> read to 0xffff8e39f897f030 of 8 bytes by task 250445 on cpu 11:
>    md_check_recovery+0x574/0x900
>    raid10d+0xb7/0x2950
>    [........]
>
> KCSAN reports #2:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KCSAN: data-race in md_check_recovery / md_write_start
>
> write (marked) to 0xffff8e39e953f030 of 8 bytes by task 540091 on cpu 11:
>    md_write_start+0x5dd/0x910
>    raid1_make_request+0x141/0x1990
>    [........]
>
> read to 0xffff8e39e953f030 of 8 bytes by task 580822 on cpu 0:
>    md_check_recovery+0x574/0x900
>    raid1d+0xcc/0x3840
>    [........]
>
> value changed: 0x0000000000000002 -> 0x0000000000000006
>
> KCSAN reports #3:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KCSAN: data-race in md_check_recovery / md_do_sync.cold
>
> write (marked) to 0xffff8e39e9404030 of 8 bytes by task 492473 on cpu 6:
>    md_do_sync.cold+0x3f6/0x1686
>    [........]
>
> read to 0xffff8e39e9404030 of 8 bytes by task 492402 on cpu 3:
>    md_check_recovery+0x16d/0x900
>    raid1d+0xcc/0x3840
>    [........]
>
> value changed: 0x0000000000000000 -> 0x0000000000000002
>
> KCSAN reports #4:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KCSAN: data-race in md_do_sync.cold / raid5d
>
> write (marked) to 0xffff8e39c35cb030 of 8 bytes by task 192196 on cpu 10:
>    md_do_sync.cold+0x3f6/0x1686
>    md_thread+0x15a/0x2d0
>    [........]
>
> read to 0xffff8e39c35cb030 of 8 bytes by task 190759 on cpu 5:
>    raid5d+0x7f9/0xba0
>    md_thread+0x15a/0x2d0
>    [........]
>
> value changed: 0x0000000000000000 -> 0x0000000000000002
>
> Fixes: 2953079c692d ("md: separate flags for superblock changes")
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
> v1 -> v2
> 	- pass checkpatch.pl check.
> ---
>   drivers/md/md.c     | 8 ++++----
>   drivers/md/raid1.c  | 2 +-
>   drivers/md/raid10.c | 4 ++--
>   drivers/md/raid5.c  | 7 ++++---
>   4 files changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 096bb64e87bd..e72bf2010287 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6830,11 +6830,11 @@ int md_run(struct mddev *mddev)
>   		 * via sysfs - until a lack of spares is confirmed.
>   		 */
>   		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>  =20
> -	if (mddev->sb_flags)
> +	if (READ_ONCE(mddev->sb_flags))
>   		md_update_sb(mddev, 0);
>  =20
>   	if (IS_ENABLED(CONFIG_MD_BITMAP) && !mddev->bitmap_info.file &&
>   	    !mddev->bitmap_info.offset)
>   		md_bitmap_set_none(mddev);
> @@ -7024,11 +7024,11 @@ static void __md_stop_writes(struct mddev *mddev)
>   			mddev->bitmap_ops->flush(mddev);
>   	}
>  =20
>   	if (md_is_rdwr(mddev) &&
>   	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
> -	     mddev->sb_flags)) {
> +	     READ_ONCE(mddev->sb_flags))) {
>   		/* mark array as shutdown cleanly */
>   		if (!mddev_is_clustered(mddev))
>   			mddev->in_sync =3D 1;
>   		md_update_sb(mddev, 1);
>   	}
> @@ -10294,11 +10294,11 @@ static bool md_should_do_recovery(struct mddev =
*mddev)
>   	/*
>   	 * MD_SB_CHANGE_PENDING indicates that the array is switching from cle=
an to
>   	 * active, and no action is needed for now.
>   	 * All other MD_SB_* flags require to update the superblock.
>   	 */
> -	if (mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING))
> +	if (READ_ONCE(mddev->sb_flags) & ~(1<<MD_SB_CHANGE_PENDING))
>   		return true;

So this should be a v3, and the above line still not fixed. Please check ch=
eckpatch
warnings.

>  =20
>   	/*
>   	 * If the array is not using external metadata and there has been no d=
ata
>   	 * written for some time, then the array's status needs to be set to
> @@ -10423,11 +10423,11 @@ void md_check_recovery(struct mddev *mddev)
>   			spin_lock(&mddev->lock);
>   			set_in_sync(mddev);
>   			spin_unlock(&mddev->lock);
>   		}
>  =20
> -		if (mddev->sb_flags)
> +		if (READ_ONCE(mddev->sb_flags))
>   			md_update_sb(mddev, 0);
>  =20
>   		/*
>   		 * Never start a new sync thread if MD_RECOVERY_RUNNING is
>   		 * still set.
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 29b58583e381..bd6808656edb 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2738,11 +2738,11 @@ static void raid1d(struct md_thread *thread)
>   			handle_read_error(conf, r1_bio);
>   		else
>   			WARN_ON_ONCE(1);
>  =20
>   		cond_resched();
> -		if (mddev->sb_flags & ~(1<<MD_SB_CHANGE_PENDING))
> +		if (READ_ONCE(mddev->sb_flags) & ~(1 << MD_SB_CHANGE_PENDING))
>   			md_check_recovery(mddev);
>   	}
>   	blk_finish_plug(&plug);
>   }
>  =20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index adaf9e432e25..3ffa5a19964d 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3030,11 +3030,11 @@ static void raid10d(struct md_thread *thread)
>   			handle_read_error(mddev, r10_bio);
>   		else
>   			WARN_ON_ONCE(1);
>  =20
>   		cond_resched();
> -		if (mddev->sb_flags & ~(1<<MD_SB_CHANGE_PENDING))
> +		if (READ_ONCE(mddev->sb_flags) & ~(1 << MD_SB_CHANGE_PENDING))
>   			md_check_recovery(mddev);
>   	}
>   	blk_finish_plug(&plug);
>   }
>  =20
> @@ -4698,11 +4698,11 @@ static sector_t reshape_request(struct mddev *mdd=
ev, sector_t sector_nr,
>   		else
>   			mddev->curr_resync_completed =3D conf->reshape_progress;
>   		conf->reshape_checkpoint =3D jiffies;
>   		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>   		md_wakeup_thread(mddev->thread);
> -		wait_event(mddev->sb_wait, mddev->sb_flags =3D=3D 0 ||
> +		wait_event(mddev->sb_wait, READ_ONCE(mddev->sb_flags) =3D=3D 0 ||
>   			   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>   		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>   			allow_barrier(conf);
>   			return sectors_done;
>   		}
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ded6a69f7795..cb58b4353995 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1219,11 +1219,11 @@ static void ops_run_io(struct stripe_head *sh, st=
ruct stripe_head_state *s)
>   				break;
>  =20
>   			if (bad < 0) {
>   				set_bit(BlockedBadBlocks, &rdev->flags);
>   				if (!conf->mddev->external &&
> -				    conf->mddev->sb_flags) {
> +				    READ_ONCE(conf->mddev->sb_flags)) {
>   					/* It is very unlikely, but we might
>   					 * still need to write out the
>   					 * bad block log - better give it
>   					 * a chance*/
>   					md_check_recovery(conf->mddev);
> @@ -6469,11 +6469,11 @@ static sector_t reshape_request(struct mddev *mdd=
ev, sector_t sector_nr, int *sk
>   					rdev->recovery_offset =3D sector_nr;
>  =20
>   		conf->reshape_checkpoint =3D jiffies;
>   		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>   		md_wakeup_thread(mddev->thread);
> -		wait_event(mddev->sb_wait, mddev->sb_flags =3D=3D 0 ||
> +		wait_event(mddev->sb_wait, READ_ONCE(mddev->sb_flags) =3D=3D 0 ||
>   			   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>   		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>   			return 0;
>   		spin_lock_irq(&conf->device_lock);
>   		conf->reshape_safe =3D mddev->reshape_position;
> @@ -6913,11 +6913,12 @@ static void raid5d(struct md_thread *thread)
>   						   conf->temp_inactive_list);
>   		if (!batch_size && !released)
>   			break;
>   		handled +=3D batch_size;
>  =20
> -		if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
> +		if (READ_ONCE(mddev->sb_flags) &
> +		    ~(1 << MD_SB_CHANGE_PENDING)) {
>   			spin_unlock_irq(&conf->device_lock);
>   			md_check_recovery(mddev);
>   			spin_lock_irq(&conf->device_lock);
>   		}
>   	}

--=20
Thanks,
Kuai
