Received: from va-2-30.ptr.blmpb.com (va-2-30.ptr.blmpb.com [209.127.231.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FEF339875
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 03:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782097698; cv=none; b=Ci4dMVCGR0KnAAqoviX+h2T2DX99nJRR6+kGXG0hcSlgmuNvrNvUWH4KbskrC0SVGLaxKyyHJ1IxWSy0sen0X7rfE2scrMTnCTYwKyZgNW56uszmxf+age9xFLbcB32ruKYqInavcJaTdciTz1ZIN64jaTbkS9pgfIev1FsXXqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782097698; c=relaxed/simple;
	bh=mHMEQ2hTMvatG05K0fCn1t/JlR9fbHd2DMZLrzmqAvM=;
	h=In-Reply-To:References:Cc:To:Date:Message-Id:Mime-Version:
	 Content-Type:From:Subject; b=f3N9fWFqly8jhp26rhJG5wRA6t8SoDVpEOGVSVxL6kKN9NhjhyjysC9dH/R0EWpA1Q7yzw8yBGLL/ZZwa8BBYZGUPFkQB+f1DkZ5Q39wBWJcFYKvLUGyEqU0J4hGZ0r1vMeUW/bidalnGuVvNwTNuNbutAqNvcJ26DVeloGzhOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=gp3kSzbH; arc=none smtp.client-ip=209.127.231.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="gp3kSzbH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782097685;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=LHIx6o/H/UkvE11HDqTaKcKNdlaRR/5SJpZk5W4iaGM=;
 b=gp3kSzbH04Kwq9Eg3c0iToY1jCSXxQl27j3ai5s58uu1G+60+A8OpgOD8MwW5ILQvRgOhR
 OUuDc1C5Ed4aE0/3XGHwrSic2YCA7dsIFo+XAVx343BHjOVzgFZa3loHHij6p0eZh8Cnro
 NsN63d1LyDgmRDvOHmruknz1a/DHR7s8d8pVeZOPoYNBCCsTKZssu5ibCUY6qZZsCoZXuK
 J1be+vSrcZwXjJPxKms8u6v0pCHUO8QfLQFSAKJ4CQbGp6yQyf8VCWOFbpuVk43+1P0DOa
 Ruuc9HSvIsM5RB0aWP3LFa4ganYUOhZaWp0EHO7mNpWGNOiTyyKc5vzZcIsCLw==
In-Reply-To: <e958cb97-556a-4320-8e76-9aed18a435bc@fygo.io>
References: <20260619081109.1218112-1-chencheng@fnnas.com> <e958cb97-556a-4320-8e76-9aed18a435bc@fygo.io>
X-Lms-Return-Path: <lba+26a38a713+d8bdf2+vger.kernel.org+chencheng@fnnas.com>
Cc: <linux-kernel@vger.kernel.org>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
X-Original-From: Chen Cheng <chencheng@fnnas.com>
To: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
Date: Mon, 22 Jun 2026 11:08:00 +0800
Message-Id: <727bd8e8-cbbe-4bbb-a239-41c9fa18dc93@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.8.62] ([183.34.162.92]) by smtp.feishu.cn with ESMTPS; Mon, 22 Jun 2026 11:08:02 +0800
Content-Type: text/plain; charset=UTF-8
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: Re: [PATCH v2] md/raid5: read batch_head under stripe_lock in make_stripe_request

=E5=9C=A8 2026/6/21 06:01, yu kuai =E5=86=99=E9=81=93:
> Hi,
>=20
> =E5=9C=A8 2026/6/19 16:11, Chen Cheng =E5=86=99=E9=81=93:
>> From: Chen Cheng <chencheng@fnnas.com>
>>
>> KCSAN reports race in raid5_make_request() vs. stripe_add_to_batch_list(=
)
>>
>> Writer flow (stripe_add_to_batch_list):
>> 1. grab `head` stripe;
>> 2. lock_two_stripes(head, sh);
>> 3. re-check stripe_can_batch() for both head and sh, which requires
>>      STRIPE_BATCH_READY set on both;
>> 4. write head->batch_head =3D head and sh->batch_head =3D head;
>> 5. unlock_two_stripes.
>>
>> STRIPE_BATCH_READY is cleared in two places:
>> - clear_batch_ready(), at the entry of handle_stripe();
>> - __add_stripe_bio(), for non-batchable bios.
>> And, both need to acquire `stripe_lock`.
>>
>> Under stripe_lock, if STRIPE_BATCH_READY is clear, then:
>> - New writers cannot install a batch_head;
>> - Existing writers have already finished.
>> So .. handle_stripe() readers can ready `batch_head` locklessly.
>=20
> This does not explain the race clearly, I still have no clue yet.


 From the semantic correctness perspective, I think the lock is needed.

 From the race consequence perspective, the worst consequence I can see=20
is that it could add to a batch member stripe. But=20
`conf->preread_active_stripes` should only add to batch head or lone stripe=
.



the scenario:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
sh1 and sh2 are neighbor, wich means,
if sh1 start with sector X, then, sh2 start with sectorX + STRIPE_SECTORS,

CPU0                                    CPU1
make_stripe_request(sh2)
-> add_all_stripe_bios(sh2)             make_stripe_request(sh2)
                                         -> add_all_stripe_bios(sh2)
                                         -> stripe_add_to_batch_list(sh2)
                                            -> lock_two_stripes(sh1, sh2)
                                            -> sh1->batch_head =3D sh1
                                            -> sh2->batch_head =3D sh1
                                            -> test_and_clear_bit(
                                                 STRIPE_PREREAD_ACTIVE,
                                                 &sh2->state)
                                            -> unlock_two_stripes(sh1, sh2)
-> if ((!sh2->batch_head ||
         sh2 =3D=3D sh2->batch_head) &&
        REQ_SYNC &&
        !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh2->state))
        atomic_inc(&conf->preread_active_stripes)




After CPU2 batches 'sh', CPU1 can still treat it as a lone stripe and
charge preread_active_stripes. Since CPU2 has already run the follower
side compensation, the later increment has no matching decrement.



>=20
>>
>> Fix way:
>> Writer side make_stripe_request() under STRIPE_BATCH_READY, so , need
>> to be protected by stripe_lock when read something..
>>
>> v1 -> v2:
>> - re-expalin how stripe_lock and batch_head work in commit message , and=
 ,
>> - modify comment in raid5.h.
>>
>> Fixs: f4aec6a097387
>=20
> Weird fix tag again.
>=20
>>
>>
>> KCSAN report:
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>     BUG: KCSAN: data-race in raid5_make_request / raid5_make_request
>>
>>     write to 0xffff8f03062432d8 of 8 bytes by task 210246 on cpu 6:
>>       raid5_make_request+0x175e/0x2ab0
>>       md_handle_request+0x2c5/0x700
>>       md_submit_bio+0x126/0x320
>>       [.........]
>>       btrfs_sync_file+0x181/0x970
>>       vfs_fsync_range+0x71/0x110
>>       do_fsync+0x46/0xa0
>>       __x64_sys_fsync+0x20/0x30
>>
>>     read to 0xffff8f03062432d8 of 8 bytes by task 210251 on cpu 0:
>>       raid5_make_request+0x7c7/0x2ab0
>>       md_handle_request+0x2c5/0x700
>>       md_submit_bio+0x126/0x320
>>       [.........]
>>       btrfs_remap_file_range+0x266/0x980
>>       vfs_clone_file_range+0x16d/0x610
>>       ioctl_file_clone+0x64/0xd0
>>       do_vfs_ioctl+0x87f/0xbc0
>>       __x64_sys_ioctl+0xb8/0x130
>>
>>     value changed: 0x0000000000000000 -> 0xffff8f0307798728
>=20
> Is this a mismatch report?
>=20
>>
>>
>> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
>> ---
>>    drivers/md/raid5.c | 2 ++
>>    drivers/md/raid5.h | 8 +++++++-
>>    2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 5521051a9425..efc63740f867 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -6108,14 +6108,16 @@ static enum stripe_result make_stripe_request(st=
ruct mddev *mddev,
>>    		ctx->do_flush =3D false;
>>    	}
>>   =20
>>    	set_bit(STRIPE_HANDLE, &sh->state);
>>    	clear_bit(STRIPE_DELAYED, &sh->state);
>> +	spin_lock_irq(&sh->stripe_lock);
>>    	if ((!sh->batch_head || sh =3D=3D sh->batch_head) &&
>>    	    (bi->bi_opf & REQ_SYNC) &&
>>    	    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>>    		atomic_inc(&conf->preread_active_stripes);
>> +	spin_unlock_irq(&sh->stripe_lock);
>>   =20
>>    	release_stripe_plug(mddev, sh);
>>    	return STRIPE_SUCCESS;
>>   =20
>>    out_release:
>> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
>> index 1c7b710fc9c1..9ff825697ba3 100644
>> --- a/drivers/md/raid5.h
>> +++ b/drivers/md/raid5.h
>> @@ -221,11 +221,17 @@ struct stripe_head {
>>    	enum reconstruct_states reconstruct_state;
>>    	spinlock_t		stripe_lock;
>>    	int			cpu;
>>    	struct r5worker_group	*group;
>>   =20
>> -	struct stripe_head	*batch_head; /* protected by stripe lock */
>> +	/*
>> +	 * Writer protected by stripe_lock.
>> +	 * Reader hold stripe_lock when STRIPE_BATCH_READY is set.
>> +	 * Without STRIPE_BATCH_READY means no concurrent write,
>> +	 * lockless read is ok.
>> +	 */
>> +	struct stripe_head	*batch_head;
>>    	spinlock_t		batch_lock; /* only header's lock is useful */
>>    	struct list_head	batch_list; /* protected by head's batch lock*/
>>   =20
>>    	union {
>>    		struct r5l_io_unit	*log_io;
>
