Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9232FC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  1 Jun 2022 22:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiFAWmS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Jun 2022 18:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbiFAWmR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Jun 2022 18:42:17 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306C1192C56;
        Wed,  1 Jun 2022 15:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=2f0BHsBpq85ivP1dIKJ0uio8fENOzyRfwTPQnpZYJRg=; b=E8t1tTnSSJXVJy3I2k7upgMPeH
        0w8So78p5JydBzf/h8IBbidTNc3H3InOcEay072ojxPnVkdJMjZtr7ZGoYIa99SC+aStt8zhnrraS
        2bE+hAgI/cZhrYTv27dMhr2OmjDqVj8WeXhylMakQcWmGgfpfaPYMNx2Ipp+kHGts1gGhT4SCqx6M
        7V1w6zsIuTqmimpvydCSqyzD8GYYQEkTfEz9xhlkrr/bE+jUn6K6RVG2OXBZ86SxDIcxs30REEmae
        5hRkaroXlHnJ3rTWCAqrWUJdSXMfbUBg76T3iTbRSe5PxSOm+pfENCg41Ptz7fr2U3E5STY1y6MBI
        u8SmnH8Q==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1nwX2T-00DcNy-Hz; Wed, 01 Jun 2022 16:42:06 -0600
Message-ID: <6605fb80-47c4-3a42-1fde-fbb42886ebc3@deltatee.com>
Date:   Wed, 1 Jun 2022 16:42:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Song Liu <song@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220526163604.32736-1-logang@deltatee.com>
 <20220526163604.32736-13-logang@deltatee.com>
 <YpRdL+2e7gngOYPa@infradead.org>
 <c59d233a-c0d1-a3cc-3dad-0a5af449ff83@deltatee.com>
 <CAPhsuW56YAwByRKnYDpkbBk1pi01Wdx3NL9yLY2sADWfMmTMeQ@mail.gmail.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CAPhsuW56YAwByRKnYDpkbBk1pi01Wdx3NL9yLY2sADWfMmTMeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: song@kernel.org, hch@infradead.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v2 12/17] md/raid5-cache: Move struct r5l_log definition
 to raid5-log.h
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-06-01 16:36, Song Liu wrote:
>> I guess we could do that. All the inline functions in raid5-log.h are
>> there to choose between the r5l or the ppl implementaiton. So it that
>> would mean the r5l implementation would probably be inlined and ppl
>> would be doing a second out of line call. Not sure if that matters, but
>> it seems a little odd.
> 
> I like the current version better. raid5-log.h is not used in many files anyway.

It's a moot point now. v3 will follow Christoph's other feedback which
essentially removes the RCU access altogether and adds an appropriate
lock in a couple places.

Logan
