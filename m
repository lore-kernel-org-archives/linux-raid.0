Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32542E7AD77
	for <linux-raid@archiver.kernel.org>; Tue,  3 Oct 2023 16:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240349AbjJCQKu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Oct 2023 12:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjJCQKs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 3 Oct 2023 12:10:48 -0400
X-Greylist: delayed 1380 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 03 Oct 2023 09:10:45 PDT
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE62AB
        for <linux-raid@vger.kernel.org>; Tue,  3 Oct 2023 09:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=c8fTMQRoOAH3yKhYSq3QBrsY4of6j8yY+zsW1oSVzDE=; b=djWKznI+5kwQwNMUBKvQwSwtOh
        cyqmu/yS+kjjYw92I+mJ52LfqgRoeHvYx6CTXHpssXC+9GP6NGzooC++G6k6kybgLjW29SCkFBczk
        P0KOwqH8l+Z0gLO4lFuwbOF2izyLoNZVKuut1jUHw7aLCkRBnT0URNOAwVK4ZFvk/EhUPaG+AlsFp
        yvlGJdrxaglq0vMXLhv6nZkfP9l18OEexIMAneE/vFMzgGMdNDoNYXRvmTtB1xk+BFhawoQI8IM9F
        MQCT7vQuD97DnhUXOeCs7abXyE+gt9Dw3w29Ew1VAORVG/pbf1xawMgFMwFnFWoBZZJfgiJ3NV8+w
        cJvbfg4g==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1qnhcd-003fvb-3R; Tue, 03 Oct 2023 09:47:43 -0600
Message-ID: <40c7dd5d-7dcb-b17e-593d-966b3f115fb4@deltatee.com>
Date:   Tue, 3 Oct 2023 09:47:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-CA
To:     Song Liu <song@kernel.org>, John Pittman <jpittman@redhat.com>
Cc:     David Jeffery <djeffery@redhat.com>, linux-raid@vger.kernel.org,
        Laurence Oberman <loberman@redhat.com>
References: <20231002183422.13047-1-djeffery@redhat.com>
 <CA+RJvhxrkSXRPc9wELyfYYCy_dpRaa+9=fTY7NQR0tP=MO8xUQ@mail.gmail.com>
 <CAPhsuW6iSTRGFDfbP_nQR5eeKWEY=begDZ_H8QgK+tqhKaqELw@mail.gmail.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CAPhsuW6iSTRGFDfbP_nQR5eeKWEY=begDZ_H8QgK+tqhKaqELw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: song@kernel.org, jpittman@redhat.com, djeffery@redhat.com, linux-raid@vger.kernel.org, loberman@redhat.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH] md/raid5: release batch_last before waiting for another
 stripe_head
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2023-10-03 00:48, Song Liu wrote:
> CC Logan.
> 
> On Mon, Oct 2, 2023 at 12:22 PM John Pittman <jpittman@redhat.com> wrote:
>>
>> Thanks a lot David.  Song, as a note, David's patch was tested by a
>> Red Hat customer and it indeed resolved their hit on the deadlock.
>> cc. Laurence Oberman who assisted on that case.
>>
>>
>> On Mon, Oct 2, 2023 at 2:39 PM David Jeffery <djeffery@redhat.com> wrote:
>>>
>>> When raid5_get_active_stripe is called with a ctx containing a stripe_head in
>>> its batch_last pointer, it can cause a deadlock if the task sleeps waiting on
>>> another stripe_head to become available. The stripe_head held by batch_last
>>> can be blocking the advancement of other stripe_heads, leading to no
>>> stripe_heads being released so raid5_get_active_stripe waits forever.
>>>
>>> Like with the quiesce state handling earlier in the function, batch_last
>>> needs to be released by raid5_get_active_stripe before it waits for another
>>> stripe_head.
>>>
>>>
>>> Fixes: 3312e6c887fe ("md/raid5: Keep a reference to last stripe_head for batch")
>>> Signed-off-by: David Jeffery <djeffery@redhat.com>

This makes sense to me. Nice catch on the difficult bug.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Logan
