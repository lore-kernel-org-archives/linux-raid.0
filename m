Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 309ACC61DA4
	for <linux-raid@archiver.kernel.org>; Sat,  4 Feb 2023 00:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbjBDAUu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Feb 2023 19:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjBDAUt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Feb 2023 19:20:49 -0500
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71A18AC3F
        for <linux-raid@vger.kernel.org>; Fri,  3 Feb 2023 16:20:10 -0800 (PST)
Received: by mail-qt1-f180.google.com with SMTP id g7so7443147qto.11
        for <linux-raid@vger.kernel.org>; Fri, 03 Feb 2023 16:20:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KkoMTSq4l3G1c49HimqfC19O87IH6JspHAce298n11w=;
        b=E03COcTQYth2iHB1aZxqo+AJhT9KCz88DwP9peYutjz1w0Zjjn3rkH6N7FnApXiiyK
         bJ8IZpcNAMyioXHC0AsV3l3k9EsN1P7i9sV3u79E5wykF7m0+y399kYx4+bahc5K2bWX
         K6WQ/Y+b8YIoZTiTw/KlioJ2TJVhfBOG3ViyrqyUOXEaA0p3EnXiH6tWkfHkMuQmzB+0
         gE3bGVATHzolq/+rux+LfixLbCAQEH+Q9bUgmCWSAq3c1CBr+6axOsVZ0pJMk42YMYEl
         qlmWUPqekixuzVSRpP7Csu147y5XBYGONyQemtikWMQndouq85AZnAfSlQtez5vwzQyh
         osZQ==
X-Gm-Message-State: AO0yUKUGSgoh567NMs7G/0Ft12rJATOxjVx7Hls18i+nE/yJBZuPG3FO
        lKvHT/Tko69lGSccmumqw8CHbsREeJgha1I=
X-Google-Smtp-Source: AK7set8kb03l51pPPK2sD000T3nG6rEGMEgSpN3Th8LXVdJ9cJkEm26hx9e4hZWuukXmwkgbfjBXSQ==
X-Received: by 2002:ac8:7f50:0:b0:3a5:1ea1:bae2 with SMTP id g16-20020ac87f50000000b003a51ea1bae2mr19566958qtk.34.1675470010067;
        Fri, 03 Feb 2023 16:20:10 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net. [68.160.166.30])
        by smtp.gmail.com with ESMTPSA id g17-20020ae9e111000000b006ce580c2663sm2801394qkm.35.2023.02.03.16.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 16:20:09 -0800 (PST)
Date:   Fri, 3 Feb 2023 19:20:08 -0500
From:   Mike Snitzer <snitzer@kernel.org>
To:     Benjamin Marzinski <bmarzins@redhat.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: block: remove submit_bio_noacct
Message-ID: <Y92kuOeVIaVimXbf@redhat.com>
References: <20230202181423.2910619-1-hch@lst.de>
 <Y9xqvF6nTptzHwpv@redhat.com>
 <Y9x8pagVnO7Xtnbn@redhat.com>
 <20230203150053.GA28516@lst.de>
 <Y904yA+mS9go9XKP@redhat.com>
 <20230203235028.GC17327@octiron.msp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203235028.GC17327@octiron.msp.redhat.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Feb 03 2023 at  6:50P -0500,
Benjamin Marzinski <bmarzins@redhat.com> wrote:

> On Fri, Feb 03, 2023 at 11:39:36AM -0500, Mike Snitzer wrote:
> > On Fri, Feb 03 2023 at 10:00P -0500,
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > On Thu, Feb 02, 2023 at 10:16:53PM -0500, Mike Snitzer wrote:
> > > > > > The current usage of submit_bio vs submit_bio_noacct which skips the
> > > > > > VM events and task account is a bit unclear.  It seems to be mostly
> > > > > > intended for sending on bios received by stacking drivers, but also
> > > > > > seems to be used for stacking drivers newly generated metadata
> > > > > > sometimes.
> > > > > 
> > > > > Your lack of confidence conveyed in the above shook me a little bit
> > > > > considering so much of this code is attributed to you -- I mostly got
> > > > > past that, but I am a bit concerned about one aspect of the
> > > > > submit_bio() change (2nd to last comment inlined below).
> > > 
> > > The confidence is about how it is used.  And that's up to the driver
> > > authors, not helped by them not having any guidelines.  And while
> > > I've touched this code a lot, the split between the two levels of API
> > > long predates me.
> > > 
> > > > > > Remove the separate API and just skip the accounting if submit_bio
> > > > > > is called recursively.  This gets us an accounting behavior that
> > > > > > is very similar (but not quite identical) to the current one, while
> > > > > > simplifying the API and code base.
> > > > > 
> > > > > Can you elaborate on the "but not quite identical"? This patch is
> > > > > pretty mechanical, just folding code and renaming.. but you obviously
> > > > > saw subtle differences.  Likely worth callign those out precisely.
> > > 
> > > The explanation was supposed to be in the Lines above.  Now accounting
> > > is skipped if in a ->submit_bio recursion.  Before that it dependent
> > > on drivers calling either submit_bio or submit_bio_noacct, for which
> > > there was no clear guideline and drivers have been a bit sloppy about.
> > 
> > OK, but afaict the code is identical after your refactoring.
> > Side-effect is drivers that were double accounting will now be fixed.
> 
> Doesn't this open dm up to double accounting? Take dm-delay for
> instance. If the delay is 0, then submit_bio() for the underlying device
> will be called recursively and will skip the accounting.  If the delay
> isn't 0, then submit_bio() for the underlying device will be called
> later from a workqueue and the accounting will happen again, even though
> the same amount of IO happens in either case. Or am I missing something
> here?
> 
> -Ben 

Nope, you aren't missing anything, good catch!

Callers of dm_submit_bio_remap() are the poster-child for submitting
bios from a different task.

So yeah...

Nacked-by: Mike Snitzer <snitzer@kernel.org>

(Could be that many submit_bio_noacct callers can be converted but we
really do need to keep the submit_bio_noacct interface)
