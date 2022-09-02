Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BBDC54EE9
	for <linux-raid@archiver.kernel.org>; Fri,  2 Sep 2022 23:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiIBXrA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiIBXq7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 2 Sep 2022 19:46:59 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619C194138;
        Fri,  2 Sep 2022 16:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:References:Cc:To:From:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=tdSEJSc6M60H3vdwpPTVi6BuVF7V/BZRhYM7gk9QbLg=; b=fJGbGnsuCnlzItsYbMvLKx/S96
        IEuh2MrPOwVyD2YJG7jxMCUJ3QzMvWnpyzC35QwHhNT05rk9Q4liFpif7djdeZK+aw+LAMnBcCTQt
        Q5sDaMDcKVxJ9P7zsMp2XgV6qlxYH7lQp4ZQbJf0o1IILAB9N/295JtXrJmrvMbjJZ0nSsYu8IVv/
        r0mN9zfWOU+Jyu4wkNjQWUL/44ueh3G4ZkmqcZxZIH3qXrKU9QCInBrX0hCshgdyzYWrv/xQ+ieyX
        ugpbDhwqT3RVy2S0Mg+3EwxRX7bJ0JCMQSzU0g/jUmA/VidUR7j8aunCYg7xWpuNBFeKOBRzwLg2j
        D3BXaJWQ==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oUGNE-00EoIo-JC; Fri, 02 Sep 2022 17:46:57 -0600
Message-ID: <d338b978-325b-b066-5b14-5ec42ae2b1e6@deltatee.com>
Date:   Fri, 2 Sep 2022 17:46:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-CA
From:   Logan Gunthorpe <logang@deltatee.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>
References: <7f3b87b6-b52a-f737-51d7-a4eec5c44112@deltatee.com>
In-Reply-To: <7f3b87b6-b52a-f737-51d7-a4eec5c44112@deltatee.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: axboe@kernel.dk, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: Deadlock Issue with blk-wbt and raid5+journal
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org




On 2022-08-25 16:19, Logan Gunthorpe wrote:
> Given the conditions of hitting the bug, I fully expected this to be an
> issue in the raid code, but unless I'm missing something, it sure looks
> to me like a deadlock issue in the wbt code, which makes me wonder why
> nobody else has hit it. Is there something else I'm missing that are
> supposed to be waking up these processes? Or something weird about the
> raid5+journal+loop code that is causing wb_recent_wait() to always be false?

I've made some progress on this nasty bug. I've got far enough to know it's not
related to the blk-wbt or the block layer.

Turns out a bunch of bios are stuck queued in a blk_plug in the md_raid5 
thread while that thread appears to be stuck in an infinite loop (so it never
schedules or does anything to flush the plug). 

I'm still debugging to try and find out the root cause of that infinite loop, 
but I just wanted to send an update that the previous place I was stuck at
was not correct.

Logan
