Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3161C4361B
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 15:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E7DE2310E
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 15:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391384AbgLJPXj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Dec 2020 10:23:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44742 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391398AbgLJPX1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 10 Dec 2020 10:23:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607613720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+fvUmT3iFDohh88PQ/WI3uu4dOjGkilnLL9FRPht4Zw=;
        b=ERhoLwQ5JMQ2s9ks4r8ep3TjnYU1QWcf3G2+6fR6gyvVurl+4g4c0LYMKd0SWiBcPAJfTO
        HvbgJ1fUTRh1yDa3VqBgsRx0oC7ku+M8DNqDaRzvwzvw7+izbtsvDSG091WPUVpwZCj0zT
        S7yZwZKjoS1APTPk8HelfL0vPydBejE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-LjpYo7DpNe-XoDO5-ImcrA-1; Thu, 10 Dec 2020 10:21:58 -0500
X-MC-Unique: LjpYo7DpNe-XoDO5-ImcrA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 183C2192D7A4;
        Thu, 10 Dec 2020 15:21:38 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E28BA5D9CC;
        Thu, 10 Dec 2020 15:21:37 +0000 (UTC)
Date:   Thu, 10 Dec 2020 10:21:37 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Xiao Ni <xni@redhat.com>,
        Matthew Ruffell <matthew.ruffell@canonical.com>
Subject: Re: [GIT PULL v2] md-fixes 20201209
Message-ID: <20201210152136.GB9856@redhat.com>
References: <0C161FAC-8A21-4EAF-B3B4-A7BF04089213@fb.com>
 <aa01f088-c4a5-2eed-3e74-2288554ea98a@kernel.dk>
 <20201210145119.GA9856@redhat.com>
 <00e0d114-e45e-9fbc-0f44-2eb1d81f992d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00e0d114-e45e-9fbc-0f44-2eb1d81f992d@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 10 2020 at  9:53am -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 12/10/20 7:51 AM, Mike Snitzer wrote:
> > On Thu, Dec 10 2020 at  9:08am -0500,
> > Jens Axboe <axboe@kernel.dk> wrote:
> > 
> >> On 12/9/20 9:59 PM, Song Liu wrote:
> >>> Hi Jens, 
> >>>
> >>> Please consider pulling the following changes on top of your block-5.10 
> >>> branch. This is to fix raid10 data corruption [1] in 5.10-rc7. 
> >>
> >> Pulled, thanks.
> > 
> > Hi Jens,
> > 
> > Can you please pick this related revert up too?:
> > https://patchwork.kernel.org/project/dm-devel/patch/20201209215814.2623617-1-songliubraving@fb.com/
> > 
> > I asked Song to do so in v2.. seems it got overlooked.
> > 
> > Patchwork didn't grab my Acked-by, but I did provide it (should be in
> > your INBOX).
> 
> I would, but looks like the offending patch isn't even in my block-5.10.
> So probably best if you just ship that one.

Ha, you already pulled the dm-raid revert in via Song's v2... I just
missed that Song _did_ include it in v2 like I asked.

Mike

