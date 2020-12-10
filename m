Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A6AC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 14:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B190D2310E
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 14:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgLJOxR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Dec 2020 09:53:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31148 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389857AbgLJOwx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 10 Dec 2020 09:52:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607611887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ihjkWhw1WIdmMFaq5Q3QK7K1RL8YikvYrL5y6qR2LWM=;
        b=N3zCkzTiz74owGDYesJZ8OVZOK/b/37uBs5voIwm23ymtuDqPOluM0TbHw5Hf/i0zSetFI
        aZPZli9zrEym1UViQifd02a2Jh2Jl9gvbuOGvII91S1e/0I0BjVRRFHOoEGQ41PLCDqGs0
        pHSzSMmlgwDunpEnH/KOkxeKFluxw/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-gZ0D0HGpOt-ZmdEt0vc2dw-1; Thu, 10 Dec 2020 09:51:22 -0500
X-MC-Unique: gZ0D0HGpOt-ZmdEt0vc2dw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E96DF190B2B5;
        Thu, 10 Dec 2020 14:51:20 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A9A0060C75;
        Thu, 10 Dec 2020 14:51:20 +0000 (UTC)
Date:   Thu, 10 Dec 2020 09:51:19 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Xiao Ni <xni@redhat.com>,
        Matthew Ruffell <matthew.ruffell@canonical.com>
Subject: Re: [GIT PULL v2] md-fixes 20201209
Message-ID: <20201210145119.GA9856@redhat.com>
References: <0C161FAC-8A21-4EAF-B3B4-A7BF04089213@fb.com>
 <aa01f088-c4a5-2eed-3e74-2288554ea98a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa01f088-c4a5-2eed-3e74-2288554ea98a@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 10 2020 at  9:08am -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 12/9/20 9:59 PM, Song Liu wrote:
> > Hi Jens, 
> > 
> > Please consider pulling the following changes on top of your block-5.10 
> > branch. This is to fix raid10 data corruption [1] in 5.10-rc7. 
> 
> Pulled, thanks.

Hi Jens,

Can you please pick this related revert up too?:
https://patchwork.kernel.org/project/dm-devel/patch/20201209215814.2623617-1-songliubraving@fb.com/

I asked Song to do so in v2.. seems it got overlooked.

Patchwork didn't grab my Acked-by, but I did provide it (should be in
your INBOX).

Thanks,
Mike

