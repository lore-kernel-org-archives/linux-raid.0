Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3F142AA5
	for <linux-raid@vger.kernel.org>; Mon, 30 Jun 2025 02:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751249701; cv=none; b=mNk7C9pHd9sFy5KONKshyspiezRXrdtyQcFf3TCEZkaVRW3bFbb1yEZx8bJJDRSz2Hv8EnXOkw4JEGQeV6OipL6u0SxY0IWFc6iu2R/VsQyVQguAO13mX0xvjKuy9A1+1HktuMPBy/GV6l8HSk2xO+mBaaDckqozbderomn9ebI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751249701; c=relaxed/simple;
	bh=2KoBE1QB7mRTAs5ECLw60gzYqVreQbPGQTrd4hrxh7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=orX89kUaKjemKEti+D91p304hLCIQ2YccJSQW0g8bzZEbb5VD/Hdu6t81kkngEsxBAFWKmJM2wRXEZMQTIiRpRdpbtPwq+xmaTNL06B/vrt3N1rm0HQVhxuh5XH4vwICGMGjDjzHmjn6s41d6x8XDBMlgcDQPKjOjIJiSpKxHyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CdpCSDu+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CdpCSDu+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751249698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wNJ+u7SJcGRviylYQXB2XQ5rM1G8Fa8LeI/dxuZO8A0=;
	b=CdpCSDu+olTRdiLEPLBde2aFo4DNz/a1wb/8TWuoVoS0gYgo6l5NSaft+Qp2Jv6DylorPu
	43IeYXnH3DbTHurFXLUMStQiBEbjC5IEvU3k2+u1C7D8gJnnQ+Q/1g4WmC4qLG1xSihiJw
	dpjlpYxMFRXx7/MnH+gOTyJcUH0q/o4=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-bQdy4b3OMrOB9m37BkU8iA-1; Sun, 29 Jun 2025 22:14:56 -0400
X-MC-Unique: bQdy4b3OMrOB9m37BkU8iA-1
X-Mimecast-MFC-AGG-ID: bQdy4b3OMrOB9m37BkU8iA_1751249695
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b0f807421c9so2784585a12.0
        for <linux-raid@vger.kernel.org>; Sun, 29 Jun 2025 19:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751249695; x=1751854495;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wNJ+u7SJcGRviylYQXB2XQ5rM1G8Fa8LeI/dxuZO8A0=;
        b=ANgKUIP4f5lLDNqzxTQUQ9XVgE95puyKtbjU6DMVa1sXzkPJdOrQZE9xnyeLOHErqB
         e3uPczz2/1420CcqVoQj2229bL5x4hVvs5LcpUjRdZC7gwqpH35tC4c8xQKvPibxFBgb
         vAaUiI94Z0F8czmsgWDFSYg2l1UZpgqVwTEk7LgPq22k1qilARb53e5Ce0M4R0QkLjih
         qWjpa2GbbdkuknfXXE/YpQ0uvg2KMGoyMUSQBBBdeVdHRPagWahIYxM0w+F6Gp/9V0XP
         Ztrv/Z1jMB6rTt717Pwbv9UmfRz2raFvriTfYuunRZ0wKUFS2nHonhc7LrzFFqcEP6eY
         nOVA==
X-Forwarded-Encrypted: i=1; AJvYcCWa3sLuz0ESuAHI5Zqc6L78+Blhr41FXxv80NOrj5vfay61b7AjXSjN0jeD3f9PN6aHcgZ0Qha7oj/t@vger.kernel.org
X-Gm-Message-State: AOJu0YzI5pPh4jM3HpITXL4NG1BPYgpLtBsuBWT1BRKJ/mzNgrOU8xbN
	yAKO4rtACKPgJAIDtT9EmGUKsQCY0P6TzdDl/4I5u05Eq5St9+HEeMq81rp7wi+te4XC1cYwNpO
	8LtAJ1wnFH4KDYCTTXD6NVfSX514En/2h3utQrI+rkmkJDy+bYzqYHXEeY8yMU7I=
X-Gm-Gg: ASbGnctgMRnAKxUtD/+mRFfuUlCSP65A9lxxicOo0NxiBwtIMf6zWEakm2Aesn1RT0K
	WAHgnlTQliGft7ebR5ZWYs72UC1dmCnUraR6VlaIIdQ+uc1n3LNgoy1o0zErENPDKMaLGwxgT4H
	sURhGPPWbvsi/H31F4eXHN1nvES+bNiFqZQYu5esL9TlGz/GTXnzef1+OFVAB3xO+nllKMM9zas
	tVfgxhS4PiAaqpZdIMubG67l2wt9G6D3OyPHq9NXI8zPHQNjcShEy0oyx5uy2DI4hOeV9mr7o0g
	0sFG0eJ1J1z9tnlytwwyxdOa33SATw==
X-Received: by 2002:a17:90b:2e0f:b0:313:bdbf:36c0 with SMTP id 98e67ed59e1d1-318c8cd2734mr19806777a91.0.1751249694930;
        Sun, 29 Jun 2025 19:14:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCPlcpfQFTq/V6/gHThqQ9N4NTZ23eiYFz7gK1DAsMxkjeEIG9Lrvn+uquEaPWJf0Aq93UgQ==
X-Received: by 2002:a17:90b:2e0f:b0:313:bdbf:36c0 with SMTP id 98e67ed59e1d1-318c8cd2734mr19806747a91.0.1751249694486;
        Sun, 29 Jun 2025 19:14:54 -0700 (PDT)
Received: from [10.72.120.15] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-318c139210bsm7911126a91.5.2025.06.29.19.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jun 2025 19:14:53 -0700 (PDT)
Message-ID: <c76f44c0-fc61-41da-a16b-5a3510141487@redhat.com>
Date: Mon, 30 Jun 2025 10:14:47 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/23] md/md-llbitmap: implement bit state machine
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, colyli@kernel.org,
 song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-17-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <20250524061320.370630-17-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/5/24 下午2:13, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
>
> Each bit is one byte, contain 6 difference state, see llbitmap_state. And
> there are total 8 differenct actions, see llbitmap_action, can change
> state:
>
> llbitmap state machine: transitions between states
>
> |           | Startwrite | Startsync | Endsync | Abortsync| Reload   | Daemon | Discard   | Stale     |
> | --------- | ---------- | --------- | ------- | -------  | -------- | ------ | --------- | --------- |
> | Unwritten | Dirty      | x         | x       | x        | x        | x      | x         | x         |
> | Clean     | Dirty      | x         | x       | x        | x        | x      | Unwritten | NeedSync  |
> | Dirty     | x          | x         | x       | x        | NeedSync | Clean  | Unwritten | NeedSync  |
> | NeedSync  | x          | Syncing   | x       | x        | x        | x      | Unwritten | x         |
> | Syncing   | x          | Syncing   | Dirty   | NeedSync | NeedSync | x      | Unwritten | NeedSync  |
>
> Typical scenarios:
>
> 1) Create new array
> All bits will be set to Unwritten by default, if --assume-clean is set,
> All bits will be set to Clean instead.
>
> 2) write data, raid1/raid10 have full copy of data, while raid456 donen't and
> rely on xor data
>
> 2.1) write new data to raid1/raid10:
> Unwritten --StartWrite--> Dirty
>
> 2.2) write new data to raid456:
> Unwritten --StartWrite--> NeedSync
>
> Because the initial recover for raid456 is skipped, the xor data is not build
> yet, the bit must set to NeedSync first and after lazy initial recover is
> finished, the bit will finially set to Dirty(see 5.1 and 5.4);
>
> 2.3) cover write
> Clean --StartWrite--> Dirty
>
> 3) daemon, if the array is not degraded:
> Dirty --Daemon--> Clean
>
> For degraded array, the Dirty bit will never be cleared, prevent full disk
> recovery while readding a removed disk.
>
> 4) discard
> {Clean, Dirty, NeedSync, Syncing} --Discard--> Unwritten
>
> 5) resync and recover
>
> 5.1) common process
> NeedSync --Startsync--> Syncing --Endsync--> Dirty --Daemon--> Clean
>
> 5.2) resync after power failure
> Dirty --Reload--> NeedSync
>
> 5.3) recover while replacing with a new disk
> By default, the old bitmap framework will recover all data, and llbitmap
> implement this by a new helper llbitmap_skip_sync_blocks:
>
> skip recover for bits other than dirty or clean;
>
> 5.4) lazy initial recover for raid5:
> By default, the old bitmap framework will only allow new recover when there
> are spares(new disk), a new recovery flag MD_RECOVERY_LAZY_RECOVER is add
> to perform raid456 lazy recover for set bits(from 2.2).
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md-llbitmap.c | 83 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 83 insertions(+)
>
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 1a01b6777527..f782f092ab5d 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -568,4 +568,87 @@ static int llbitmap_cache_pages(struct llbitmap *llbitmap)
>   	return 0;
>   }
>   
> +static void llbitmap_init_state(struct llbitmap *llbitmap)
> +{
> +	enum llbitmap_state state = BitUnwritten;
> +	unsigned long i;
> +
> +	if (test_and_clear_bit(BITMAP_CLEAN, &llbitmap->flags))
> +		state = BitClean;
> +
> +	for (i = 0; i < llbitmap->chunks; i++)
> +		llbitmap_write(llbitmap, state, i);
> +}
> +
> +/* The return value is only used from resync, where @start == @end. */
> +static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
> +						  unsigned long start,
> +						  unsigned long end,
> +						  enum llbitmap_action action)
> +{
> +	struct mddev *mddev = llbitmap->mddev;
> +	enum llbitmap_state state = BitNone;
> +	bool need_resync = false;
> +	bool need_recovery = false;
> +
> +	if (test_bit(BITMAP_WRITE_ERROR, &llbitmap->flags))
> +		return BitNone;
> +
> +	if (action == BitmapActionInit) {
> +		llbitmap_init_state(llbitmap);
> +		return BitNone;
> +	}
> +
> +	while (start <= end) {
> +		enum llbitmap_state c = llbitmap_read(llbitmap, start);
> +
> +		if (c < 0 || c >= nr_llbitmap_state) {
> +			pr_err("%s: invalid bit %lu state %d action %d, forcing resync\n",
> +			       __func__, start, c, action);
> +			state = BitNeedSync;
> +			goto write_bitmap;
> +		}
> +
> +		if (c == BitNeedSync)
> +			need_resync = true;
> +
> +		state = state_machine[c][action];
> +		if (state == BitNone) {
> +			start++;
> +			continue;
> +		}

For reload action, it runs continue here.

And doesn't it need a lock when reading the state?

> +
> +write_bitmap:
> +		/* Delay raid456 initial recovery to first write. */
> +		if (c == BitUnwritten && state == BitDirty &&
> +		    action == BitmapActionStartwrite && raid_is_456(mddev)) {
> +			state = BitNeedSync;
> +			need_recovery = true;
> +		}
> +
> +		llbitmap_write(llbitmap, state, start);

Same question here, doesn't it need a lock when writing bitmap bits?

Regards

Xiao

> +
> +		if (state == BitNeedSync)
> +			need_resync = true;
> +		else if (state == BitDirty &&
> +			 !timer_pending(&llbitmap->pending_timer))
> +			mod_timer(&llbitmap->pending_timer,
> +				  jiffies + mddev->bitmap_info.daemon_sleep * HZ);
> +
> +		start++;
> +	}
> +
> +	if (need_recovery) {
> +		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +		set_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
> +		md_wakeup_thread(mddev->thread);
> +	} else if (need_resync) {
> +		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> +		md_wakeup_thread(mddev->thread);
> +	}
> +
> +	return state;
> +}
> +
>   #endif /* CONFIG_MD_LLBITMAP */

