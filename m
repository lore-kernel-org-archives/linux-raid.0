Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21369C433FE
	for <linux-raid@archiver.kernel.org>; Mon, 10 Oct 2022 01:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiJJBFa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 9 Oct 2022 21:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiJJBFJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 9 Oct 2022 21:05:09 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F41A3EA67
        for <linux-raid@vger.kernel.org>; Sun,  9 Oct 2022 17:55:24 -0700 (PDT)
Subject: Re: Memory leak when raid10 takeover raid0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665363322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Du/T1CpqWXA/HME+e6yQb/31KBF51UNwsp++7QEmkyE=;
        b=xbPCFmt9i2o3XZb6INr/ChZVs41ze+UK9nuSthJYy/A7JG4XzaiBZ9vFaL9AusNBnHQ/et
        /JRZ/XD3aDNkkZEmCgYLhGzXL+1bO1jG7LULGmzKmnvLslm+w3OdYWx8Q1mC4SvMxoYpOP
        E/aL8IN12gBo90nMDq8H2FaFIADOdFk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>
Cc:     Song Liu <song@kernel.org>
References: <CALTww2-EAeM6aKeZbZ2udTwS5RFwNWfF9uag=npewB9j0H51Hw@mail.gmail.com>
 <35f4a626-7f83-56c5-4cad-73ede197ccbf@linux.dev>
Message-ID: <121c39a6-54e4-ee2a-9984-f1f64182a5d0@linux.dev>
Date:   Mon, 10 Oct 2022 08:55:22 +0800
MIME-Version: 1.0
In-Reply-To: <35f4a626-7f83-56c5-4cad-73ede197ccbf@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 10/10/22 8:40 AM, Guoqing Jiang wrote:
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index afaf36b2f6ab..5a7134e3c182 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3979,6 +3979,9 @@ level_store(struct mddev *mddev, const char 
> *buf, size_t len)
>                 goto out_unlock;
>         }
>
> +       /* Only accept IO after takeover is done */
> +       mddev->pers = NULL;
> +
>         /* Looks like we have a winner */
>         mddev_suspend(mddev); 

mddev->pers->quiesce is called in suspend/resume, so we need relevant 
checking in them
accordingly, maybe other places as well.

Thanks,
Guoqing
