Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B10179B1
	for <linux-raid@vger.kernel.org>; Fri, 16 Feb 2024 06:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708066738; cv=none; b=FXCwvFT1OArVnlE7zBUW+99K3AEDT1jGltywACHcO9ujarR2aY+RFUPPvhUrSzeKPgkWLr7CROtqAzqePBDIEA/3TLPworexrggfobGfO5gspH+nEgwS7f7rT7GRBR3cuSvtPEwYbIR84y0VAw3/HgPL8DK4VS5k5cX4ihei2Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708066738; c=relaxed/simple;
	bh=YROb+eaJNu6/59TKOvdKSLmQg7w+kXyN6IwLF2JJH4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ncUxGP6tAKpueKePzPt9o5HCCOffumlt7RiGuj1rx4CXuJj7ZkaC/M5/nN4WY4FlgKE936/JsQz7U9VQPJpjXhQy0oSEzf5aMqunGxnobMT+HFRxVylWhsV7gqHJCf4v/dgm7pIqHbe6YPXj+BKPqhyE/mth4EhPx8mwPqZzQMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PKja8pxB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PKja8pxB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708066735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BNMvTmeWJ1ziFBp7Mx8IpeakAHCa+fvWpYKZaRcTpWg=;
	b=PKja8pxB0pDJn8L6H1WBSFEYn6nXf3GO3Lo/D+I7gvKYMc4YXqwN+k9koqpilOeAaTGI1f
	WiVrbfXUCA8m/CIc0J2iW0rIiieebJWUF6p5cPN+7rmWoc1YYBs1tLULPBzTNwOQuuc2Ay
	V5+q5dZpY2zN9b2QIrmHmYZiXYv9FYM=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-SAwpKS5rOyitSTrScTIycA-1; Fri, 16 Feb 2024 01:58:53 -0500
X-MC-Unique: SAwpKS5rOyitSTrScTIycA-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6e103d403c4so2003897a34.0
        for <linux-raid@vger.kernel.org>; Thu, 15 Feb 2024 22:58:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708066732; x=1708671532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BNMvTmeWJ1ziFBp7Mx8IpeakAHCa+fvWpYKZaRcTpWg=;
        b=Q0G2/p/ePltR5o69K1pGGcwI67iQFjm96OivPbN4mOX+HglAbzmxgXnL3Bc1zFgpSQ
         55XbvrH6T3BY25iOIQsolyn+ikEhi5uS4/FE43HO69ew96VEY5MVJpdoZPpaATs8JWnf
         TdNhqbulDfvPbpiMHdLrLAkliTRCJvv7wk2HQcZu9kiZgzio6RfgrFBTn0wvcwhx9IZS
         haLTrgHt2r+QkzriUxawRfUvLcYAfz7/yCBDZaHhYZjjsCc8VlvureahRhvO/I+xyGZ4
         HtfOX1+EOgYv4+JnsjdiRtWfzh0t7o6C0uyXEOtWcmSrjOZDK5A8XuxcjTknzeaUv8I+
         am4w==
X-Forwarded-Encrypted: i=1; AJvYcCUksm7wwnu1RnMzjhWWJx5XeoawY1wrU+kgOAIS1DcEZUtb8Xgxn8a3vNTxMpUZRzjSomQ/u6CsDt1uBZDT4jE9wpdJ3mBGQBql3Q==
X-Gm-Message-State: AOJu0YxiNngimh+Lj99eEAUIbZwjat+Ljuj7qMoNxEvtUW2OnLHGuLM3
	gFt6pwUfoZdaRrGW4hYjy1V5afLoAnVYw4AaaL+GgpjWmfidUXqZB72jUwT4XnIVfYoXD/0P6eZ
	Ily/AEb6DnHURPIsia35B4i+ySmhBkgUTCsjqmYgzNCdqrS6zX77DOqV4hvPlCcJEIK2aYwefJ8
	1BdbQn2GicGVsnyKyWr+TykXdrmpFdndwJYw==
X-Received: by 2002:a05:6358:d04c:b0:178:7c7b:77bd with SMTP id jb12-20020a056358d04c00b001787c7b77bdmr4796315rwb.27.1708066732249;
        Thu, 15 Feb 2024 22:58:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEIS1mWsDcddpPxFekpeD1h3hjt8dIDVsyUqaSy4AgJ7AmFMXEA/DB1AOZvjCvNo30ZSH6kg0YD0Di4qNWMKJg=
X-Received: by 2002:a05:6358:d04c:b0:178:7c7b:77bd with SMTP id
 jb12-20020a056358d04c00b001787c7b77bdmr4796292rwb.27.1708066731962; Thu, 15
 Feb 2024 22:58:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240201092559.910982-1-yukuai1@huaweicloud.com> <20240201092559.910982-2-yukuai1@huaweicloud.com>
In-Reply-To: <20240201092559.910982-2-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 16 Feb 2024 14:58:40 +0800
Message-ID: <CALTww2-ZhRBJOD3jXs=xKFaD=iR=dtoC9h2rUQi5Stpi+tJ9Bw@mail.gmail.com>
Subject: Re: [PATCH v5 01/14] md: don't ignore suspended array in md_check_recovery()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mpatocka@redhat.com, heinzm@redhat.com, blazej.kucman@linux.intel.com, 
	agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, song@kernel.org, 
	yukuai3@huawei.com, jbrassow@f14.redhat.com, neilb@suse.de, shli@fb.com, 
	akpm@osdl.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 1, 2024 at 5:30=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> mddev_suspend() never stop sync_thread, hence it doesn't make sense to
> ignore suspended array in md_check_recovery(), which might cause
> sync_thread can't be unregistered.
>
> After commit f52f5c71f3d4 ("md: fix stopping sync thread"), following
> hang can be triggered by test shell/integrity-caching.sh:

Hi Kuai

After applying this patch, it's still stuck at mddev_suspend. Maybe
the deadlock can be fixed by other patches from the patch set. But
this patch can't fix this issue. If so, the comment is not right.

>
> 1) suspend the array:
> raid_postsuspend
>  mddev_suspend
>
> 2) stop the array:
> raid_dtr
>  md_stop
>   __md_stop_writes
>    stop_sync_thread
>     set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>     md_wakeup_thread_directly(mddev->sync_thread);
>     wait_event(..., !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>
> 3) sync thread done:
> md_do_sync
>  set_bit(MD_RECOVERY_DONE, &mddev->recovery);
>  md_wakeup_thread(mddev->thread);
>
> 4) daemon thread can't unregister sync thread:
> md_check_recovery
>  if (mddev->suspended)
>    return; -> return directly
>  md_read_sync_thread
>  clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
>  -> MD_RECOVERY_RUNNING can't be cleared, hence step 2 hang;

I add some debug logs when stopping dmraid with lvremove command. The
step you mentioned are sequential but not async. The process is :
dev_remove->dm_destroy->__dm_destroy->dm_table_postsuspend_targets(raid_pos=
tsuspend)
-> dm_table_destroy(raid_dtr). It looks like mddev_suspend is waiting
for active_io to be zero.

Best Regards
Xiao

> This problem is not just related to dm-raid, fix it by ignoring
> suspended array in md_check_recovery(). And follow up patches will
> improve dm-raid better to frozen sync thread during suspend.
>
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Closes: https://lore.kernel.org/all/8fb335e-6d2c-dbb5-d7-ded8db5145a@redh=
at.com/
> Fixes: 68866e425be2 ("MD: no sync IO while suspended")
> Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2266358d8074..07b80278eaa5 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9469,9 +9469,6 @@ static void md_start_sync(struct work_struct *ws)
>   */
>  void md_check_recovery(struct mddev *mddev)
>  {
> -       if (READ_ONCE(mddev->suspended))
> -               return;
> -
>         if (mddev->bitmap)
>                 md_bitmap_daemon_work(mddev);
>
> --
> 2.39.2
>

