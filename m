Received: from va-2-40.ptr.blmpb.com (va-2-40.ptr.blmpb.com [209.127.231.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F856279DCC
	for <linux-raid@vger.kernel.org>; Sat, 18 Jul 2026 11:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784372574; cv=none; b=jIUhz+WW3q/v9UrOsBK4UF5HLw0cyFSAkuUx/GBSoOHp+vdnyaoVwL6HUIBiUlJl1I7uEr/nd646z83PShXGJYvStBMfZqc1gd2EHbqu+TExQ55wNDZqalq8OnZn5G1w8nQSZYA/0t+oRVD7ACIEMVs5I5hSTtsnXaCeLZXF1P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784372574; c=relaxed/simple;
	bh=jSeaIFQvoPKLjFQRrTPlgKP55rLNKw6HebqoNA4UtUQ=;
	h=From:Mime-Version:Subject:Message-Id:References:In-Reply-To:
	 Content-Type:To:Cc:Date; b=IBhbLdseZNKZIcNRrvLlKJ2iAkkPJWUqmeJxaDTstMtA1XnITPYC8xv0uQIQecOS9VbF+3PJvueLVAgojETnc3GbU5j7YAxqvvCoHDq0jp5hbbj2xBsoDWdc7b1PKHw1Ovp72dgIYfym50gMP5iicC1nR5auNL/hhpV14ahoEEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=G46JFx6o; arc=none smtp.client-ip=209.127.231.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="G46JFx6o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1784372566;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ARBGJvNNnklAEL9/AW7ooWp1niqTNXuSz1X3lLQK18I=;
 b=G46JFx6ofrWdzX0FHgVwbi3egKLhq8rIxt4VSYWvzONHnppQDYT8eVDol32ZcDf4DEtQ5D
 cfFsO4gFWnKkGyBjjF9B8MR+/vdUF6wRvE/ARhLPo3p1+nnVfQNuHoqFPeiaLhON6pIcb6
 U9u+B9hhEqigCNXBUIUydgllbAo5kPosRSVzi2KAPxdrJ1WpcDq/s8NJG+d7m59if1jQOH
 z57ThmsWnRkqEb2EbRguGZk/jmxxZQuEiKwS11GPywx35uhL8zVYBcBkCqB4+nmjvszdVA
 Q9CBzeRvSQLg2qRqk7gzY9NvkXDYbDixP/z3+PdRSUIr3/ASeyocBrwrbYd1Zw==
From: "Chen Cheng" <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH] md: use READ_ONCE() for lockless reads of sb_flags
Message-Id: <71b83357-0fd2-4537-9a96-8b5bf894718e@fnnas.com>
References: <20260711025121.3991689-1-chencheng@fnnas.com> <654cb68a-32e1-4fa7-a735-5a6f833db39e@fygo.io>
User-Agent: Mozilla Thunderbird
In-Reply-To: <654cb68a-32e1-4fa7-a735-5a6f833db39e@fygo.io>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.8.80] ([183.34.161.69]) by smtp.feishu.cn with ESMTPS; Sat, 18 Jul 2026 19:02:43 +0800
X-Original-From: Chen Cheng <chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a5b5d54+2ba37e+vger.kernel.org+chencheng@fnnas.com>
To: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sat, 18 Jul 2026 19:02:42 +0800

=E5=9C=A8 2026/7/12 02:16, yu kuai =E5=86=99=E9=81=93:
> Hi,
>=20
> =E5=9C=A8 2026/7/11 10:51, Chen Cheng =E5=86=99=E9=81=93:
>> From: Chen Cheng <chencheng@fnnas.com>
>>
>> sb_flags is checked without a lock in md, raid1, raid5, and raid10.
>> KCSAN reports these reads as data races.
>>
>> The write side uses atomic bit ops.
>> The read side still has plain loads in a few places.
>>
>> Use READ_ONCE() for the lockless reads of sb_flags.
>>
>> KCSAN reports #1:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> BUG: KCSAN: data-race in md_check_recovery / md_write_start
>>
>> write (marked) to 0xffff8e39f897f030 of 8 bytes by task 248146 on cpu 8:
>>     md_write_start+0x5dd/0x910
>>     raid10_make_request+0x9b/0x1080
>>     md_handle_request+0x4a2/0xa40
>>     [........]
>>
>> read to 0xffff8e39f897f030 of 8 bytes by task 250445 on cpu 11:
>>     md_check_recovery+0x574/0x900
>>     raid10d+0xb7/0x2950
>>     [........]
>>
>> KCSAN reports #2:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KCSAN: data-race in md_check_recovery / md_write_start
>>
>> write (marked) to 0xffff8e39e953f030 of 8 bytes by task 540091 on cpu 11=
:
>>     md_write_start+0x5dd/0x910
>>     raid1_make_request+0x141/0x1990
>>     [........]
>>
>> read to 0xffff8e39e953f030 of 8 bytes by task 580822 on cpu 0:
>>     md_check_recovery+0x574/0x900
>>     raid1d+0xcc/0x3840
>>     [........]
>>
>> value changed: 0x0000000000000002 -> 0x0000000000000006
>>
>> KCSAN reports #3:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KCSAN: data-race in md_check_recovery / md_do_sync.cold
>>
>> write (marked) to 0xffff8e39e9404030 of 8 bytes by task 492473 on cpu 6:
>>     md_do_sync.cold+0x3f6/0x1686
>>     [........]
>>
>> read to 0xffff8e39e9404030 of 8 bytes by task 492402 on cpu 3:
>>     md_check_recovery+0x16d/0x900
>>     raid1d+0xcc/0x3840
>>     [........]
>>
>> value changed: 0x0000000000000000 -> 0x0000000000000002
>>
>> KCSAN reports #4:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KCSAN: data-race in md_do_sync.cold / raid5d
>>
>> write (marked) to 0xffff8e39c35cb030 of 8 bytes by task 192196 on cpu 10=
:
>>     md_do_sync.cold+0x3f6/0x1686
>>     md_thread+0x15a/0x2d0
>>     [........]
>>
>> read to 0xffff8e39c35cb030 of 8 bytes by task 190759 on cpu 5:
>>     raid5d+0x7f9/0xba0
>>     md_thread+0x15a/0x2d0
>>     [........]
>>
>> value changed: 0x0000000000000000 -> 0x0000000000000002
>>
>> Fixes: 2953079c692d ("md: separate flags for superblock changes")
>>
>> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
>> ---
>> v1 -> v2
>> 	- pass checkpatch.pl check.
>> ---
>>    drivers/md/md.c     | 8 ++++----
>>    drivers/md/raid1.c  | 2 +-
>>    drivers/md/raid10.c | 4 ++--
>>    drivers/md/raid5.c  | 7 ++++---
>>    4 files changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 096bb64e87bd..e72bf2010287 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -6830,11 +6830,11 @@ int md_run(struct mddev *mddev)
>>    		 * via sysfs - until a lack of spares is confirmed.
>>    		 */
>>    		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>>    	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>>   =20
>> -	if (mddev->sb_flags)
>> +	if (READ_ONCE(mddev->sb_flags))
>>    		md_update_sb(mddev, 0);
>>   =20
>>    	if (IS_ENABLED(CONFIG_MD_BITMAP) && !mddev->bitmap_info.file &&
>>    	    !mddev->bitmap_info.offset)
>>    		md_bitmap_set_none(mddev);
>> @@ -7024,11 +7024,11 @@ static void __md_stop_writes(struct mddev *mddev=
)
>>    			mddev->bitmap_ops->flush(mddev);
>>    	}
>>   =20
>>    	if (md_is_rdwr(mddev) &&
>>    	    ((!mddev->in_sync && !mddev_is_clustered(mddev)) ||
>> -	     mddev->sb_flags)) {
>> +	     READ_ONCE(mddev->sb_flags))) {
>>    		/* mark array as shutdown cleanly */
>>    		if (!mddev_is_clustered(mddev))
>>    			mddev->in_sync =3D 1;
>>    		md_update_sb(mddev, 1);
>>    	}
>> @@ -10294,11 +10294,11 @@ static bool md_should_do_recovery(struct mddev=
 *mddev)
>>    	/*
>>    	 * MD_SB_CHANGE_PENDING indicates that the array is switching from c=
lean to
>>    	 * active, and no action is needed for now.
>>    	 * All other MD_SB_* flags require to update the superblock.
>>    	 */
>> -	if (mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING))
>> +	if (READ_ONCE(mddev->sb_flags) & ~(1<<MD_SB_CHANGE_PENDING))
>>    		return true;
>=20
> So this should be a v3, and the above line still not fixed. Please check =
checkpatch
> warnings.

hi.

I run checkpatch.pl to double-check again .. 0 err 0 warn report .

thanks
cheng.

>=20
>>   =20
>>    	/*
>>    	 * If the array is not using external metadata and there has been no=
 data
>>    	 * written for some time, then the array's status needs to be set to
>> @@ -10423,11 +10423,11 @@ void md_check_recovery(struct mddev *mddev)
>>    			spin_lock(&mddev->lock);
>>    			set_in_sync(mddev);
>>    			spin_unlock(&mddev->lock);
>>    		}
>>   =20
>> -		if (mddev->sb_flags)
>> +		if (READ_ONCE(mddev->sb_flags))
>>    			md_update_sb(mddev, 0);
>>   =20
>>    		/*
>>    		 * Never start a new sync thread if MD_RECOVERY_RUNNING is
>>    		 * still set.
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 29b58583e381..bd6808656edb 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -2738,11 +2738,11 @@ static void raid1d(struct md_thread *thread)
>>    			handle_read_error(conf, r1_bio);
>>    		else
>>    			WARN_ON_ONCE(1);
>>   =20
>>    		cond_resched();
>> -		if (mddev->sb_flags & ~(1<<MD_SB_CHANGE_PENDING))
>> +		if (READ_ONCE(mddev->sb_flags) & ~(1 << MD_SB_CHANGE_PENDING))
>>    			md_check_recovery(mddev);
>>    	}
>>    	blk_finish_plug(&plug);
>>    }
>>   =20
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index adaf9e432e25..3ffa5a19964d 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -3030,11 +3030,11 @@ static void raid10d(struct md_thread *thread)
>>    			handle_read_error(mddev, r10_bio);
>>    		else
>>    			WARN_ON_ONCE(1);
>>   =20
>>    		cond_resched();
>> -		if (mddev->sb_flags & ~(1<<MD_SB_CHANGE_PENDING))
>> +		if (READ_ONCE(mddev->sb_flags) & ~(1 << MD_SB_CHANGE_PENDING))
>>    			md_check_recovery(mddev);
>>    	}
>>    	blk_finish_plug(&plug);
>>    }
>>   =20
>> @@ -4698,11 +4698,11 @@ static sector_t reshape_request(struct mddev *md=
dev, sector_t sector_nr,
>>    		else
>>    			mddev->curr_resync_completed =3D conf->reshape_progress;
>>    		conf->reshape_checkpoint =3D jiffies;
>>    		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>>    		md_wakeup_thread(mddev->thread);
>> -		wait_event(mddev->sb_wait, mddev->sb_flags =3D=3D 0 ||
>> +		wait_event(mddev->sb_wait, READ_ONCE(mddev->sb_flags) =3D=3D 0 ||
>>    			   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>>    		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>>    			allow_barrier(conf);
>>    			return sectors_done;
>>    		}
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index ded6a69f7795..cb58b4353995 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -1219,11 +1219,11 @@ static void ops_run_io(struct stripe_head *sh, s=
truct stripe_head_state *s)
>>    				break;
>>   =20
>>    			if (bad < 0) {
>>    				set_bit(BlockedBadBlocks, &rdev->flags);
>>    				if (!conf->mddev->external &&
>> -				    conf->mddev->sb_flags) {
>> +				    READ_ONCE(conf->mddev->sb_flags)) {
>>    					/* It is very unlikely, but we might
>>    					 * still need to write out the
>>    					 * bad block log - better give it
>>    					 * a chance*/
>>    					md_check_recovery(conf->mddev);
>> @@ -6469,11 +6469,11 @@ static sector_t reshape_request(struct mddev *md=
dev, sector_t sector_nr, int *sk
>>    					rdev->recovery_offset =3D sector_nr;
>>   =20
>>    		conf->reshape_checkpoint =3D jiffies;
>>    		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>>    		md_wakeup_thread(mddev->thread);
>> -		wait_event(mddev->sb_wait, mddev->sb_flags =3D=3D 0 ||
>> +		wait_event(mddev->sb_wait, READ_ONCE(mddev->sb_flags) =3D=3D 0 ||
>>    			   test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>>    		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>>    			return 0;
>>    		spin_lock_irq(&conf->device_lock);
>>    		conf->reshape_safe =3D mddev->reshape_position;
>> @@ -6913,11 +6913,12 @@ static void raid5d(struct md_thread *thread)
>>    						   conf->temp_inactive_list);
>>    		if (!batch_size && !released)
>>    			break;
>>    		handled +=3D batch_size;
>>   =20
>> -		if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
>> +		if (READ_ONCE(mddev->sb_flags) &
>> +		    ~(1 << MD_SB_CHANGE_PENDING)) {
>>    			spin_unlock_irq(&conf->device_lock);
>>    			md_check_recovery(mddev);
>>    			spin_lock_irq(&conf->device_lock);
>>    		}
>>    	}
>
