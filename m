Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FAD3B3C0E
	for <linux-raid@vger.kernel.org>; Mon, 17 Aug 2026 10:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786963998; cv=none; b=N8q/6PHLtGSHVu6kHxKZjGBRz9MfBWiqhuyVriwShwwJwZXcd8Sk/hnTa9Txs4cc9E66UeY85C7ZDIucPVHykhqX7tYzBSqj3NQzVN8DhT6hW/VrKUQ5KvQmdFk2JwFjzitP/mXPUhqKerD0EDaS13F9AC4zcSUIK4mnSfYBJOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786963998; c=relaxed/simple;
	bh=5ie2AMA4OlqzsKLIWhQVFxljsBecwzGm3eWQ2SoxBMw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WJua8XXpBgVIYweMKLeAKfmbiuJF0WW/wrFxbJYUWVB6EhAKQq8QgNlj44ck8oTvmSCMCXRxo1KnFDqMFyyufbOuXZVmkdC0kt7suCfMBXAZIpc1v75ZbFht2DYbpLS3y8Tz50C/CvGeoxkPW58i/DQYHvKLtIfK9ETRD5MRUuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NIirbdP8; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NIirbdP8"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4956242332dso34509325e9.2
        for <linux-raid@vger.kernel.org>; Mon, 17 Aug 2026 03:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786963990; x=1787568790; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Njn/5IXjz288EjWMX6pRlyreJSk0SUvuSaQvQyxwDsE=;
        b=NIirbdP8Pf7nth8sthj/nml01zoXpSTgUyFRVCVArUPHKH7qRM464Bc2tLq5z/vyda
         LW3LIKMuf/+zlLnB9Cx4XaXZ4Q83HxBFE47HfWoWOcyuYKtgok1pihcIqXgyakUFrq1o
         U/A5CsnlwnXc5GRI799nTT/0fbwdNDvB9iQ2wEqKAJzfbgqbjixI70VoO+O2T/PagTSu
         WXoXTLEgPZ4JaMzv0pDtBW+gScKr93bx5gOHGsx/Gtj4jmxg2qR7/0i1tnhjXP0Iziyu
         DOtW4zc15BNmzm//jYnD3Jp1OHaH/yKh+2o0uhYk3JFpoEpZ5BLmkBB0s4I3mzvYxIDo
         9hTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786963990; x=1787568790;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Njn/5IXjz288EjWMX6pRlyreJSk0SUvuSaQvQyxwDsE=;
        b=G1g07Ur/BigeAghM6awx8l9JgRMzjB4WYqnuXwQ9Vo80MfdPBFqJD48Z1Waz5Qcbtx
         SGvfshwMotjyusYDoM3fvbF8Vp2pV6MgZCg04pbIcLa7Ku4Rk4WrLsgaKmpNTPRcgzdB
         QLCkuSkxx2nkK0ZrBjK0fesCny4K6+68ETy7ZSccIz8OBl0BAhmwIC4UQ7H/wDJcDleg
         Rivv+umhLz6Cs+BWA3+TNnhtVK4imB/2H9wmJVduC8fe/MWOq/dc10nNYGG7oh0Ah+Cp
         y5iBAIgAKUSytI4DjjIOupKg5PFwNg3JfCNsyEUl239Ynwjw3u9cSvWJaJNC3zj3RTod
         azBg==
X-Forwarded-Encrypted: i=1; AHgh+RrmzYbkZIKwRxgtgOHSoujc8Q+XKCi+5U1ZaxE7hRjbcI1BSDNyqxMJNyupZOL8vjxjVNp5V6DiOgQU@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7FTmcsWjbNf6CPLDIN1naZob8Dd47rn80727vBDvNywpG6yUi
	/c1adiqR+CDfKlbB4+Pzpi0z/icTQBMuUXgJUCBWfWSI1NPF5CcbYFxt2Eyq+Q==
X-Gm-Gg: AR+sD11mHV0QvgTkLWsRGne55IQKDhZCzrYTrDrtvO1yCGQXsUc69bUVLs+NKm79f7f
	9gHZz+sC5NWAd0hZZk+UMz9ZFgWFJTYn/E2dovBpX/ieReyLfBzbHHbtUZEpZxlZt92Wj7ywyDc
	uz4o1Jf/YZHC/FKL6eF2+aOsKwM1BGSbxWvYerWK5+fdt0wjLtbgwQ9agB+UbvxxxjauTysTwsj
	nNz8fHnvWpEMfuaXfJjMg0r60Wc+W1hKKJWYBisQ5oow1mRGZ+yrqPXN0eBavoz/TUW7C8ux/Qr
	4hMoiUWl2Hd+TPDoAbCAzMbNkYXX6sdyWVqyH4UUVBdBGG6RiR+S0tVmsSqgc1RvsjqtR415j8Z
	l5RSAMXI5wS33awlLCjiel/3dNEqtm34udzhe4ZLBUHMGDA2mX8aLCyjg0CnZi0nV5SKBZgOE3k
	sAqegFTr3j25iLfX2u+eFLrXdZdWQ9RdLGwX/WQXR5EhvN9nhVHwJEp1nJDTy/ZjHLAcLmM52JB
	7yDvO+XZo/jWU7I5vpbkg==
X-Received: by 2002:a7b:c5ce:0:b0:499:726c:d658 with SMTP id 5b1f17b1804b1-499879bb9e5mr264052275e9.19.1786963989505;
        Mon, 17 Aug 2026 03:53:09 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([141.2.113.154])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49987b1a31esm283048745e9.2.2026.08.17.03.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 03:53:08 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Zizhi Wo <wozizhi@huawei.com>, song@kernel.org, yukuai@fygo.io,
 magiclinan@didiglobal.com, xiao@kernel.org, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yangerkun@huawei.com,
 chengzhihao1@huawei.com, wozizhi@huawei.com
Subject: Re: [PATCH V2 2/2] md/raid10: fix missing wakeup in
 wait_barrier_nolock
In-Reply-To: <20260817033340.418119-3-wozizhi@huawei.com>
References: <20260817033340.418119-1-wozizhi@huawei.com>
 <20260817033340.418119-3-wozizhi@huawei.com>
Date: Mon, 17 Aug 2026 12:53:03 +0200
Message-ID: <m27blp2f3k.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Aug 17, 2026 at 11:33 +0800, Zizhi Wo wrote:
> [BUG]
> Recently, our fuzz testing triggered a hungtask issue in RAID10:
>
> INFO: task md0_raid10:1273 blocked for more than 120 seconds.
>       Not tainted 7.2.0-rc6+ #94
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:md0_raid10      state:D stack:0     pid:1273  tgid:1273  ppid:2
> Call Trace:
>  <TASK>
>  __schedule+0xdf9/0x5c90
>  ? _raw_spin_unlock_irqrestore+0xe/0x40
>  schedule+0x74/0x1f0
>  raid10d.cold+0x7db/0x1992
>  md_thread+0x1ce/0x3e0
>  kthread+0x327/0x410
>  ......
>
> [CAUSE]
> The root cause of the issue is as follows:
> [read process1]			[read process2]			[raid10d]
> raid10_make_request
> ...
>  // nr_pending == 1
>  atomic_inc(&conf->nr_pending)
> ...
> raid10_end_read_request
>  reschedule_retry
>   md_wakeup_thread(mddev->thread)
> 				raid10_read_request
> 				 regular_request_wait
> 				  wait_barrier
> 				   wait_barrier_nolock
> 				    seq = read_seqbegin(&conf->resync_lock)
> 				    // nr_pending == 2
> 				    atomic_inc(&conf->nr_pending)
> 								raid10d
> 								 handle_read_error
> 								  freeze_array
> 								   write_seqlock_irq(&conf->resync_lock)
> 								   conf->array_freeze_pending++
> 								   WRITE_ONCE(conf->barrier, conf->barrier + 1)
> 								   conf->nr_waiting++
> 								   // nr_pending == 2, nr_queued == 0
> 								   wait_event_barrier_cmd
> 								    write_sequnlock_irq(&(conf)->resync_lock)
> 								    schedule	// hungtask!!
> 				    read_seqretry(&conf->resync_lock, seq)
> 				    // not wakeup because conf->nr_pending == 1
> 				    atomic_dec_and_test(&conf->nr_pending)
> 				   /* Hungtask will also occur here: since the barrier is non-zero,
> 				    * this I/O can never complete, so it can't call allow_barrier()
> 				    * to wake up the pending freeze_array(). */
> 				   wait_event_barrier(conf, stop_waiting_barrier(conf))
>
> wait_barrier_nolock() speculatively increments nr_pending and, on a seqlock
> retry, rolls it back with atomic_dec_and_test(). The wake fires only when
> nr_pending reaches 0. This causes the freeze_array() in the aforementioned
> raid10d flow to never be woken up.
>
> [FIX]
> Referring to allow_barrier(), this issue can be fixed by adding a wake-up
> condition for "conf->array_freeze_pending" in wait_barrier_nolock().
>
> Fixes: b9b083f9044a ("md/raid10: convert resync_lock to use seqlock")
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>  drivers/md/raid10.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index dc40110a6736..8dadf13c2b4d 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -994,11 +994,12 @@ static bool wait_barrier_nolock(struct r10conf *conf)
>  
>  	atomic_inc(&conf->nr_pending);
>  	if (!read_seqretry(&conf->resync_lock, seq))
>  		return true;
>  
> -	if (atomic_dec_and_test(&conf->nr_pending))
> +	if (atomic_dec_and_test(&conf->nr_pending) ||
> +	    READ_ONCE(conf->array_freeze_pending))
>  		wake_up_barrier(conf);
>  
>  	return false;
>  }
>  
> -- 
> 2.52.0
>
>

It looks good to me.
Reviewed-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

-- 
Best Regards,
Abd-Alrhman
