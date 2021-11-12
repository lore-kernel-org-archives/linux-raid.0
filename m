Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 784CDC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 12 Nov 2021 01:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 498B76103D
	for <linux-raid@archiver.kernel.org>; Fri, 12 Nov 2021 01:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhKLBZX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 Nov 2021 20:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKLBZW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 Nov 2021 20:25:22 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B373AC061766
        for <linux-raid@vger.kernel.org>; Thu, 11 Nov 2021 17:22:32 -0800 (PST)
Subject: Re: [PATCH 018 of 29] md: Support changing rdev size on running
 arrays.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1636680150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tX71LrFwv/hO6tDd/cAEhlylm6QKQs6iGjDfzMVlp8g=;
        b=xpEEJGI+dHhHul2mBadmjQW+bHEnDclCejsJzKSfTYAXEANOrD1vS9EX1XhOZvJS3aGfuv
        zLJYgKNqx/W4nELkJZmQNEjDrU9hoYykbSHIUvChg0gihTcqdcHtEPKVmlOb7Ta+83F0+2
        VzoGcE3oDE3loYd87igAwAckBmq2GJg=
To:     Markus Hochholdinger <Markus@hochholdinger.net>,
        Neil Brown <neilb@suse.de>
Cc:     linux-raid@vger.kernel.org, Chris Webb <chris@arachsys.com>
References: <20080627164503.9671.patches@notabene>
 <1941952.8ZYzkbqb7V@enterprise> <5424512.plDBMOIIcH@enterprise>
 <2991762.XJcJRHA18g@enterprise>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <9c51d755-1be3-dfb2-d26e-1b7d71cf1bbf@linux.dev>
Date:   Fri, 12 Nov 2021 09:22:26 +0800
MIME-Version: 1.0
In-Reply-To: <2991762.XJcJRHA18g@enterprise>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/11/21 11:09 PM, Markus Hochholdinger wrote:
> It's possible, I've found the error:
>    rdev->sb_start = sb_start;
> is missing within md.c within /* minor version 0; superblock after data */
>  From my understanding, this means the new calculated superblock position isn't
> used.
>
> I changed:
> --- a/drivers/md/md.c    2021-09-30 08:11:08.000000000 +0000
> +++ b/drivers/md/md.c     2021-11-11 14:54:10.535633028 +0000
> @@ -2252,6 +2252,7 @@
>   
>                  if (!num_sectors || num_sectors > max_sectors)
>                          num_sectors = max_sectors;
> +               rdev->sb_start = sb_start;
>          }
>          sb = page_address(rdev->sb_page);
>          sb->data_size = cpu_to_le64(num_sectors);
>
> I tested it with 5.10.46 and resizing with superblock version 1.0 is now
> working for me.
>
> If this is correct, how can I get this into longterm 5.10.x and the current
> kernel upstream?

Please refer to submitting-patches.rst and stable-kernel-rules.rst which 
are under
Documentation.

And I think this tag need to be added in your patch.

Fixes: commit d9c0fa509eaf ("md: fix max sectors calculation for super 1.0")

Thanks,
Guoqing

