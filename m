Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5D3C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  2 Mar 2022 23:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiCBXql (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Mar 2022 18:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiCBXq3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Mar 2022 18:46:29 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F7AC9905
        for <linux-raid@vger.kernel.org>; Wed,  2 Mar 2022 15:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
        Message-ID:References:Cc:To:From:content-disposition;
        bh=YxFCmaZiJrrL0wJI1jLUUxfwyEDZVBCgVaf27RhBKUg=; b=r99pXkwTg99Ty8ICxThkbncfAX
        CN3zawj9saJU2pbTBhTWXDeHucKOS99mdWksfw2i7Hpk9LFr8uZuqY/4Act+3/buxV/DIVBtAQEhq
        8w8BC3aqMVsvNfpsDedG1ZT2w/CKvZw2y5g6esfePZR2TxLmQ24Dev4kBZOqkBjuXEywcnkK6MFRe
        dQ8n9XFGaPXfdOyzkp1OuryiX5PiKEJwklI5loh9k21ZjknICAWeWRmPVT60fs4kaDugh7iJplCJ/
        g4AqxueYISpea3+eGSfKI+m7WxcKi9joTsM9j84DTSssUW7HC07Jr6lQaRZwbxlCGkR3WGLWzsI9i
        Isp04UHw==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1nPYL4-00D2Cr-Dq; Wed, 02 Mar 2022 16:24:59 -0700
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org
Cc:     Shaohua Li <shli@kernel.org>, Shaohua Li <shli@fb.com>,
        Song Liu <song@kernel.org>
References: <11cfe3aa-b778-b3e5-a152-50abc6c054ac@deltatee.com>
Message-ID: <34a8b64a-37d3-9966-1fe8-d57c432600d7@deltatee.com>
Date:   Wed, 2 Mar 2022 16:24:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <11cfe3aa-b778-b3e5-a152-50abc6c054ac@deltatee.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: song@kernel.org, shli@fb.com, shli@kernel.org, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: Raid5 Batching Question
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-02-24 5:17 p.m., Logan Gunthorpe wrote:
> Hello,
> 
> We've been looking at trying to improve sequential write performance out
> of Raid5 on modern hardware. Our profiling so far seems to indicate that
> one of the issues is high CPU due handling all the stripe heads, one for
> each page. Some investigation shows that Shaohua already added a
> batching feature back in 2015 which seems like it is exactly what we need.
> 
> However, after adding some additional debug prints we're not seeing any
> batching occurring in our basic testing and I find myself rather
> confused by the code.
> 
> I see that batches are supposed to be created at the end of
> add_stripe_bio() with a call to stripe_add_to_batch_list(). But in our
> testing stripe_can_batch() never returns true.
> 
> stripe_can_batch() calls is_full_stripe_write() which returns the
> following formula:
> 
>   overwrite_disks == (disks - max_degraded)
> 
> In our simple tests, disks is 3 and this is raid5 so max_degraded is 1.
> However, overwrite_disks is also always 1. So, 1 != (3-1) and
> is_full_stripe_write() always seems to return false.
> 
> overwrite_disks appears to be incremented on the stripe only once
> earlier in add_stripe_bio() after seeming to check if all sectors in the
> page are being written. But I don't see how overwrite_disks would ever
> be 2 for a single stripe.
> 
> What am I missing? How can I ensure batches are being used with large
> sequential writes?

Replying to myself:

Looks like batching is happening for me, it's just that when I tried to
test it and trace it through, the chunk size was too large and the
amount of data was too low such that there was not enough to fill up the
other disks in the chunk.

When running larger jobs batching seems to work correctly, but with
larger chunks stripe heads might be handled before the rest of the batch
is added.

So I'm back to square one trying to find some performance improvements
on the write path.

Thanks,

Logan

