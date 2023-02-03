Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26054C61DA4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Feb 2023 03:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjBCDRn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 22:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjBCDRm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 22:17:42 -0500
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883A576A2
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 19:16:55 -0800 (PST)
Received: by mail-qv1-f53.google.com with SMTP id jf11so2223464qvb.4
        for <linux-raid@vger.kernel.org>; Thu, 02 Feb 2023 19:16:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=chy9YyvhK7mXtGQ0tGQeB7OCTzTRKLRhbvbjGLVTm2I=;
        b=gs7T/e3FLLDsscCzlPDGj2pXZiJb3R05RV9K/3DqBES++pQk/tYRe2BukxdniL7pDg
         8NREHlEUfu0PgDb4jI+awzRsh0rnH93XJXuWte6bJgFBHdH0uROTSmmfLowvLLNI14wN
         oW1gcx53PnWfOkQMBUDZQEmtBGN51YPOoZi2/FoYLOvrbv4hsj6t6Eakb6EOr6pE+AZz
         VkZa2bN8MBGiPtyIDttoVdlK1SVVgnCVgpAAaTxkNmKoX/OgETJENqONsm9gOy94OgkL
         gaEMXcvceVTBRww4ifbAkfneXTksXAVlJdHlD8cYRVw/+L/qBLwkOU5ZFuUeHvjkAYaZ
         9ngQ==
X-Gm-Message-State: AO0yUKU5v+r7MVxm3kPTOMZXuSySg+CT1/AtkudVNS3T/PWxBnHURKnd
        Ogh+qfkrIP/7rOA0GNR1J6jo
X-Google-Smtp-Source: AK7set/2v3K4VImtWp4wHlaBIXTCJSzpiCix8tANg3EljgK7D+Bw6KwYPu2AFz6rnlkQQv5scx+9Zg==
X-Received: by 2002:a0c:e9c9:0:b0:537:6f8c:2c2c with SMTP id q9-20020a0ce9c9000000b005376f8c2c2cmr12293368qvo.41.1675394214581;
        Thu, 02 Feb 2023 19:16:54 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net. [68.160.166.30])
        by smtp.gmail.com with ESMTPSA id ea7-20020a05620a488700b007290be5557bsm1000464qkb.38.2023.02.02.19.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 19:16:54 -0800 (PST)
Date:   Thu, 2 Feb 2023 22:16:53 -0500
From:   Mike Snitzer <snitzer@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, dm-devel@redhat.com
Subject: Re: block: remove submit_bio_noacct
Message-ID: <Y9x8pagVnO7Xtnbn@redhat.com>
References: <20230202181423.2910619-1-hch@lst.de>
 <Y9xqvF6nTptzHwpv@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9xqvF6nTptzHwpv@redhat.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 02 2023 at  9:00P -0500,
Mike Snitzer <snitzer@kernel.org> wrote:

> On Thu, Feb 02 2023 at  1:14P -0500,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > The current usage of submit_bio vs submit_bio_noacct which skips the
> > VM events and task account is a bit unclear.  It seems to be mostly
> > intended for sending on bios received by stacking drivers, but also
> > seems to be used for stacking drivers newly generated metadata
> > sometimes.
> 
> Your lack of confidence conveyed in the above shook me a little bit
> considering so much of this code is attributed to you -- I mostly got
> past that, but I am a bit concerned about one aspect of the
> submit_bio() change (2nd to last comment inlined below).
> 
> > Remove the separate API and just skip the accounting if submit_bio
> > is called recursively.  This gets us an accounting behavior that
> > is very similar (but not quite identical) to the current one, while
> > simplifying the API and code base.
> 
> Can you elaborate on the "but not quite identical"? This patch is
> pretty mechanical, just folding code and renaming.. but you obviously
> saw subtle differences.  Likely worth callign those out precisely.
> 
> How have you tested this patch?  Seems like I should throw all the lvm
> and DM tests at it.
> 

...

> > @@ -716,6 +712,27 @@ void submit_bio_noacct(struct bio *bio)
> >  
> >  	might_sleep();
> >  
> > +	/*
> > +	 * We only want one ->submit_bio to be active at a time, else stack
> > +	 * usage with stacked devices could be a problem.  Use current->bio_list
> > +	 * to collect a list of requests submited by a ->submit_bio method while
> > +	 * it is active, and then process them after it returned.
> > +	 */
> > +	if (current->bio_list) {
> > +		bio_list_add(&current->bio_list[0], bio);
> > +		return;
> > +	}
> 
> It seems pretty aggressive to queue the bio to current->bio_list so
> early. Before this patch, that didn't happen until the very end
> (meaning all the negative checks of submit_bio_noacct were done before
> doing the bio_list_add() due to recursion). This is my primary concern
> with this patch. Is that the biggest aspect of your "not quite
> identical" comment in the patch header?
> 
> In practice this will manifest as delaying the negative checks, until
> returning from active submit_bio, but they will still happen.

Actually, I don't think those checks are done at all now.

Unless I'm missing something, this seems like it needs proper
justification and a lot of review and testing.

So why do this change?
