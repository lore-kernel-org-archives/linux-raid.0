Return-Path: <SRS0=hplT=DP=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D71A0C4363A
	for <linux-raid@archiver.kernel.org>; Thu,  8 Oct 2020 03:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AF742145D
	for <linux-raid@archiver.kernel.org>; Thu,  8 Oct 2020 03:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="TXzMNJFC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgJHDgj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Oct 2020 23:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727449AbgJHDgj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Oct 2020 23:36:39 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A82C061755
        for <linux-raid@vger.kernel.org>; Wed,  7 Oct 2020 20:36:39 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id b193so2187833pga.6
        for <linux-raid@vger.kernel.org>; Wed, 07 Oct 2020 20:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=xyDqpGX8z6FVNmaaC33/Usk/XYKevA3rJbqGwTCZow4=;
        b=TXzMNJFCTf8p45zsnyacclwnmCRzbBS1N0bkE43Sxwl7LIwSfuX/0xj9eEBryTv+06
         sJJit9W6gllIurAhhiD8lKOIB6mxfUIkv+cNwT4AwlwAcmooE6qw/i4yxmxnR6ubHZRg
         vr/LeCmDuqQwIBoA/anWCupNDPiDINNEWCmINby5u0ARi+xYZWxk+Wtad+tvsHagvq3U
         2x2J9FjUCp9DK0Mn4O97R1RhYHU3uXZWU9T3lwM1/VaSd6eI3LTKiSowOM5D8a8Q9eMI
         fMByfjelaCoYjm8XGp4eTT4+Ry6aJEgfMlJVhYyvGnrzocSm+Of/8GVCgOj9zdwke65v
         2okw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xyDqpGX8z6FVNmaaC33/Usk/XYKevA3rJbqGwTCZow4=;
        b=Q5TlddfXT69u75WTAoznUKFaptCLFTBXaGReBLfsVB2ohvUcc/hHcGoC5ns4gVkTa/
         ilx965j1Djrr3Ro0xUWPjCLzWX+lxb62cKCmw2zdZy2UQdkLhAamQUxDpUXT+aG66Cp1
         Mym+kXn3N9winsQVtSAG6hE0JWHqGOhuWMuUjRidrlzaqKQX0HZkMUgQI7MnKGmI6msI
         RMgZ4f1BLipIXdFamL5B1En707oftkds4U74MyDxvPzxfgzc6gsTu+Vi0y0EC7bqgiE5
         8GGO+gsoDsKdfdd00Z100YL703/1CeKRxUXzORNF6PO7bSlEoGnWNuHC6yrnykd00R0x
         nnyw==
X-Gm-Message-State: AOAM532zsNYFVsDMTXiwjFz7ZTaa0IuA4l0h57EaLSGBKqJzbOyo4Q00
        afQBrOP1g3WoilU3uF6T1a5sQg==
X-Google-Smtp-Source: ABdhPJzJzkIjtYi9clEuyu3Gn//0vvNMwAtAW1pGTsNcbiQu6P0nL4/rXrjL3w8Rt0kI9fBQrGZekw==
X-Received: by 2002:a17:90b:4b82:: with SMTP id lr2mr5865641pjb.184.1602128198563;
        Wed, 07 Oct 2020 20:36:38 -0700 (PDT)
Received: from [10.8.2.9] ([196.245.9.44])
        by smtp.gmail.com with ESMTPSA id i24sm4789548pfd.15.2020.10.07.20.36.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 20:36:37 -0700 (PDT)
Subject: Re: [PATCH] [md-cluster] fix memory leak for bitmap
To:     Zhao Heming <heming.zhao@suse.com>, linux-raid@vger.kernel.org,
        song@kernel.org
References: <1601185213-7464-1-git-send-email-heming.zhao@suse.com>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <fd2dddb4-13d1-31a3-a2ee-031a8e781634@cloud.ionos.com>
Date:   Thu, 8 Oct 2020 05:36:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1601185213-7464-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 9/27/20 07:40, Zhao Heming wrote:
> current code doesn't free temporary bitmap memory.
>
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
>   drivers/md/md-bitmap.c  | 1 +
>   drivers/md/md-cluster.c | 1 +
>   2 files changed, 2 insertions(+)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index b10c519..593fe15 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2012,6 +2012,7 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
>   	md_bitmap_unplug(mddev->bitmap);
>   	*low = lo;
>   	*high = hi;
> +	md_bitmap_free(bitmap);
>   
>   	return rv;
>   }
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index d50737e..afbbc55 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1166,6 +1166,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
>   			 * can't resize bitmap
>   			 */
>   			goto out;
> +		md_bitmap_free(bitmap);
>   	}
>   
>   	return 0;

I'd prefer add a comment for get_bitmap_from_slot to mention it's caller 
need to
free bitmap.

Thanks,
Guoqing
