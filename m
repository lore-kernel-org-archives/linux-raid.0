Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639B23081A2
	for <linux-raid@vger.kernel.org>; Wed, 26 Nov 2025 02:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764124640; cv=none; b=j60JRIA+U0dGpIg+jspz4MXu/0V8fzDPdMI9fallQ87Z2KGLz0MEix8lDaJc5FFsjvQunG/9CWbtCucg5k+lh85ml8yUbMyCOcxXQlkFXUOcO/cQBBCsDRndPeA9DACaHXMDiAQC9NLYfZQ2kOy7gHb/r/C4qcbDYVE4G+WJjHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764124640; c=relaxed/simple;
	bh=pxuO7lo4RNzUGyMrbTrssQJXkAqOwV8BIy37TFUn0yo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pIZSXGONna1Fgvue3YdkZvhX2Fy+T9ugqwk13Kzbt+Syj9OuX9yAVywLZm9eeln/s9Ji110I5Yw7to7QASfiWc6qLxafJ8X7I2ZRwV88HwmhB+5auoBYOvV/GxuSjEyvYd2SUY/l88+JqjcifQ5InX0b69D2CGXScEX1ww/y45A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ePDQuscH; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ePDQuscH"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7aae5f2633dso7199223b3a.3
        for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 18:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764124637; x=1764729437; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qt1MZpNKWoqgVDxQoUbhRRb+/kXBWmuaotwFheQ1vHc=;
        b=ePDQuscHlpeVYlTJjupu6ow0HHp3S8MZ7E2BF6UN689I9U0gWf7p3l2fOUrLSbMrvM
         cU4xbPXAaI/QtabkcyYat7C/pby0aVq5YbpwenEV3zVMH6yRYXDjb09w38JfSoL5PaDA
         E3G5cKs0ypI4vqifsWl+dI4BpqGoIYeboRTaAHNs3tXPBFOUGW13dgMh2bzj1VfE3YQh
         ydmjF8d2UCjbqhs6Y1UvOq6cFAk2dNmuNZw5VJA99TaM6vDgGf9XG1bmOAuZd1wOSNl4
         PfPLBdE+N1K+20tKWUPcPBpXOVOmnCJe+s2s+QtTfOZjpsZzxnKo3IJldP2Lxvkp9TJp
         W86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764124637; x=1764729437;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qt1MZpNKWoqgVDxQoUbhRRb+/kXBWmuaotwFheQ1vHc=;
        b=UWnUGA3cs792cW3QdSh+YZUAiX9zYMQBmhM38OAyCJwkKsrpi4Zg02nvXRER9BtBUz
         UkHZSToivDTbv9ZgGgQD3YlSnk+IxgOcEZmorQ96V5czivoRRJXnRmpAd7HZ47MV8wif
         tgo8QP2PZD7IuBEVeHz+4z1mPzB4hcMrVfnbLuETE3H3JxrIe4pwEXCnkFnOAyjo7A8p
         egOsRWBFHfbJc1d0zYh6ZeIfAD36blCcGGiY6kLNaQRn955zaysTS/r4A//N4DzFmjtc
         8WPjmsEA7Tprhpx1/MjrHCF1wWqEGg7Sp+ocadv8Zf6bjUH7WS2afa7u5f6cBurvFj6g
         vlLA==
X-Forwarded-Encrypted: i=1; AJvYcCVBpG0gDWFwbm4qhOu7dRjgUvWMKHdzAfE7SDXs3YK6ZpQ8JBHAkwtDtSoBBOWBppNmRHQwHwLW3Y53@vger.kernel.org
X-Gm-Message-State: AOJu0YwZb62UVTN202ZQxh0O9azochF9I21Vmb32vE0XoMUXUGrua9tG
	a67njp1xDWaFVHpFYbaMd/BlxIDbsoOb+lPrXJQHBz0/BN49o+bZsuJu
X-Gm-Gg: ASbGncs/pEffa1z5zGxTFUvWsEV52PL87Fa+JR1m/Ik0bpCj+bX7gv/mT2T1YjBYFQt
	IZbjq0IHR+o14YFKDyjo6tJ/FEsIaTGp0pwAiZv/+eCezVVnmbPnk3I3Y8cXJE+Deyj2pp3UEy2
	fsKkHjqWM1LPKlBfA+6KZ0UOWZ8SoaVWGJkxk+3bWnUpsq+rcxTwakysP10cahY2n1syBGPm8I3
	G1yzj/0jyAKXygbO56ro9RF5px0rLz7cZ/bkL4G4hhTLv2dxhxwQfg9k2LSa5hOTmVUYCWbWIAt
	+I5rIHKxFGIt0AOy5fkdGdP3kM51etSg4olgif8oRQoJQYlg71IrrOZf9pHM+Sni1HGLKDfH1tW
	vCSy1aOD9TNGoHQiDtUPUCSXWQ49v8qolBd+mtZGsm8eTskw9wKYPhlBybSYDY4YOTjf0RHnPwd
	LjLQ1mdyRXHktwXRy4ypczgG7deDNyQw==
X-Google-Smtp-Source: AGHT+IFMPVdPASuME6boYfK9CSm7iGISD/qVZKhPKWlRPsY/Zck4GXkccO8MN1rBK0lovp98a7V31w==
X-Received: by 2002:a05:6a00:3906:b0:77f:efd:829b with SMTP id d2e1a72fcca58-7c58e602dcdmr17676868b3a.22.1764124636518;
        Tue, 25 Nov 2025 18:37:16 -0800 (PST)
Received: from [10.189.138.37] ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f1262364sm19518773b3a.58.2025.11.25.18.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 18:37:16 -0800 (PST)
Message-ID: <b18c489f-d6ee-4986-94be-a9aade7d3a47@gmail.com>
Date: Wed, 26 Nov 2025 10:37:10 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [f2fs-dev] [PATCH V3 6/6] xfs: ignore discard return value
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, axboe@kernel.dk,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, kch@nvidia.com,
 jaegeuk@kernel.org, chao@kernel.org, cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 bpf@vger.kernel.org, linux-xfs@vger.kernel.org,
 Yongpeng Yang <yangyongpeng@xiaomi.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-7-ckulkarnilinux@gmail.com>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
In-Reply-To: <20251124234806.75216-7-ckulkarnilinux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/25/25 07:48, Chaitanya Kulkarni wrote:
> __blkdev_issue_discard() always returns 0, making all error checking
> in XFS discard functions dead code.
> 
> Change xfs_discard_extents() return type to void, remove error variable,
> error checking, and error logging for the __blkdev_issue_discard() call
> in same function.
> 
> Update xfs_trim_perag_extents() and xfs_trim_rtgroup_extents() to
> ignore the xfs_discard_extents() return value and error checking
> code.
> 
> Update xfs_discard_rtdev_extents() to ignore __blkdev_issue_discard()
> return value and error checking code.
> 
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
> ---
>   fs/xfs/xfs_discard.c | 27 +++++----------------------
>   fs/xfs/xfs_discard.h |  2 +-
>   2 files changed, 6 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 6917de832191..b6ffe4807a11 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -108,7 +108,7 @@ xfs_discard_endio(
>    * list. We plug and chain the bios so that we only need a single completion
>    * call to clear all the busy extents once the discards are complete.
>    */
> -int
> +void
>   xfs_discard_extents(
>   	struct xfs_mount	*mp,
>   	struct xfs_busy_extents	*extents)
> @@ -116,7 +116,6 @@ xfs_discard_extents(
>   	struct xfs_extent_busy	*busyp;
>   	struct bio		*bio = NULL;
>   	struct blk_plug		plug;
> -	int			error = 0;
>   
>   	blk_start_plug(&plug);
>   	list_for_each_entry(busyp, &extents->extent_list, list) {
> @@ -126,18 +125,10 @@ xfs_discard_extents(
>   
>   		trace_xfs_discard_extent(xg, busyp->bno, busyp->length);
>   
> -		error = __blkdev_issue_discard(btp->bt_bdev,
> +		__blkdev_issue_discard(btp->bt_bdev,
>   				xfs_gbno_to_daddr(xg, busyp->bno),
>   				XFS_FSB_TO_BB(mp, busyp->length),
>   				GFP_KERNEL, &bio);

If blk_alloc_discard_bio() fails to allocate a bio inside
__blkdev_issue_discard(), this may lead to an invalid loop in
list_for_each_entry{}. Instead of using __blkdev_issue_discard(), how
about allocate and submit the discard bios explicitly in
list_for_each_entry{}?

Yongpeng,

> -		if (error && error != -EOPNOTSUPP) {
> -			xfs_info(mp,
> -	 "discard failed for extent [0x%llx,%u], error %d",
> -				 (unsigned long long)busyp->bno,
> -				 busyp->length,
> -				 error);
> -			break;
> -		}
>   	}
>   
>   	if (bio) {
> @@ -148,8 +139,6 @@ xfs_discard_extents(
>   		xfs_discard_endio_work(&extents->endio_work);
>   	}
>   	blk_finish_plug(&plug);
> -
> -	return error;
>   }
>   
>   /*
> @@ -385,9 +374,7 @@ xfs_trim_perag_extents(
>   		 * list  after this function call, as it may have been freed by
>   		 * the time control returns to us.
>   		 */
> -		error = xfs_discard_extents(pag_mount(pag), extents);
> -		if (error)
> -			break;
> +		xfs_discard_extents(pag_mount(pag), extents);
>   
>   		if (xfs_trim_should_stop())
>   			break;
> @@ -496,12 +483,10 @@ xfs_discard_rtdev_extents(
>   
>   		trace_xfs_discard_rtextent(mp, busyp->bno, busyp->length);
>   
> -		error = __blkdev_issue_discard(bdev,
> +		__blkdev_issue_discard(bdev,
>   				xfs_rtb_to_daddr(mp, busyp->bno),
>   				XFS_FSB_TO_BB(mp, busyp->length),
>   				GFP_NOFS, &bio);
> -		if (error)
> -			break;
>   	}
>   	xfs_discard_free_rtdev_extents(tr);
>   
> @@ -741,9 +726,7 @@ xfs_trim_rtgroup_extents(
>   		 * list  after this function call, as it may have been freed by
>   		 * the time control returns to us.
>   		 */
> -		error = xfs_discard_extents(rtg_mount(rtg), tr.extents);
> -		if (error)
> -			break;
> +		xfs_discard_extents(rtg_mount(rtg), tr.extents);
>   
>   		low = tr.restart_rtx;
>   	} while (!xfs_trim_should_stop() && low <= high);
> diff --git a/fs/xfs/xfs_discard.h b/fs/xfs/xfs_discard.h
> index 2b1a85223a56..8c5cc4af6a07 100644
> --- a/fs/xfs/xfs_discard.h
> +++ b/fs/xfs/xfs_discard.h
> @@ -6,7 +6,7 @@ struct fstrim_range;
>   struct xfs_mount;
>   struct xfs_busy_extents;
>   
> -int xfs_discard_extents(struct xfs_mount *mp, struct xfs_busy_extents *busy);
> +void xfs_discard_extents(struct xfs_mount *mp, struct xfs_busy_extents *busy);
>   int xfs_ioc_trim(struct xfs_mount *mp, struct fstrim_range __user *fstrim);
>   
>   #endif /* XFS_DISCARD_H */

