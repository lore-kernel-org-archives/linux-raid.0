Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1D1EB64DD
	for <linux-raid@archiver.kernel.org>; Mon,  7 Aug 2023 04:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjHGEvo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Aug 2023 00:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjHGEvn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Aug 2023 00:51:43 -0400
Received: from juniper.fatooh.org (juniper.fatooh.org [173.255.221.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A891733
        for <linux-raid@vger.kernel.org>; Sun,  6 Aug 2023 21:51:41 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPS id 83AFB403E5;
        Sun,  6 Aug 2023 21:51:41 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        by juniper.fatooh.org (Postfix) with ESMTP id 59D21403F3;
        Sun,  6 Aug 2023 21:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:to:cc:references:from:in-reply-to
        :content-type:content-transfer-encoding; s=dkim; bh=iHFxhXRuUXwN
        tI1xSusF9ZNGQH4=; b=e6obEwHtAgg3jwzbbr5QAqnbiOzLMWp9iDMqKbdVpLE9
        9fuUiN5VXNLjCprOz+7+eLK6+1LZt24t7I1+Mfdp4ZPlDyb1i6Z+ewVywK6XSH9P
        zZLZE7sirGDwkA795mylGgSwG3QPguHJopB/g9lrf+uBpETEtVtPm0utoFLV2pM=
DomainKey-Signature: a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:to:cc:references:from:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=dkim; b=bWdaMO
        4VotE5fUEHVaT1QINs5k6FemEQTd7qHG6HBrrjygKZveeTMEOXz2X4pahYQIevRT
        vmRDFjccZ7tNLWtsINRMDfKQ4/KooaOGJD/qU+lqn2nUAiqP/Ik3KINXh4PT/9L1
        SsHUHNl+8paesQNhYF7BUGXzebOVOyuPfiZs8=
Received: from [198.18.0.3] (unknown [104.184.153.121])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPSA id 42412403E5;
        Sun,  6 Aug 2023 21:51:41 -0700 (PDT)
Message-ID: <cddd7213-3dfd-4ab7-a3ac-edd54d74a626@fatooh.org>
Date:   Sun, 6 Aug 2023 21:51:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: NULL pointer dereference with MD write-back journal, where
 journal device is RAID-1
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>,
        'Linux RAID' <linux-raid@vger.kernel.org>,
        "yukuai (C)" <yukuai3@huawei.com>
Cc:     "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <7c57f3a8-36e9-4805-b1ea-a4fd3406f7bb@fatooh.org>
 <f8b858cc-8762-6b53-43ec-7f509a971f16@huaweicloud.com>
 <428ed674-6e8c-471b-93d7-0532549fb218@fatooh.org>
 <d7cf0981-2d7c-5285-ce63-a66caf97e1db@huaweicloud.com>
 <91d3a3b8-572e-b674-9dc2-c2a7af3b9806@huaweicloud.com>
From:   Corey Hickey <bugfood-ml@fatooh.org>
In-Reply-To: <91d3a3b8-572e-b674-9dc2-c2a7af3b9806@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2023-08-06 19:46, Yu Kuai wrote:
> can you test the following patch?
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 51a68fbc241c..a85ea19fcf14 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1266,9 +1266,8 @@ static void r5l_log_flush_endio(struct bio *bio)
>           list_for_each_entry(io, &log->flushing_ios, log_sibling)
>                   r5l_io_run_stripes(io);
>           list_splice_tail_init(&log->flushing_ios, &log->finished_ios);
> -       spin_unlock_irqrestore(&log->io_list_lock, flags);
> -
>           bio_uninit(bio);
> +       spin_unlock_irqrestore(&log->io_list_lock, flags);
>    }
> 
>    /*

My patch utility didn't like it for some reason, but I applied the 
changes manually to get what I think is the same thing. I'll paste the 
diff here just in case.

--- drivers/md/raid5-cache.c.orig	2023-08-06 20:26:10.386665042 -0700
+++ drivers/md/raid5-cache.c	2023-08-06 20:31:33.290688590 -0700
@@ -1265,9 +1265,8 @@
  	list_for_each_entry(io, &log->flushing_ios, log_sibling)
  		r5l_io_run_stripes(io);
  	list_splice_tail_init(&log->flushing_ios, &log->finished_ios);
-	spin_unlock_irqrestore(&log->io_list_lock, flags);
-
  	bio_uninit(bio);
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
  }

  /*


With a new kernel including this change, I can now no longer reproduce 
the problem; 12 successful runs seems pretty definitive given the 
failure rate I was seeing before.

This was on a newly-recreated RAID-5, and I double-checked that I did 
indeed re-enable write-back.

Thank you for this! I wasn't expecting such a fast response, especially 
on the weekend.

-Corey
