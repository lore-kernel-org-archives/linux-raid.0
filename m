Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC384C433FE
	for <linux-raid@archiver.kernel.org>; Sat,  5 Nov 2022 22:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiKEWeQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Nov 2022 18:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiKEWeP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 5 Nov 2022 18:34:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D758A11154
        for <linux-raid@vger.kernel.org>; Sat,  5 Nov 2022 15:34:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7B8FF1F37C;
        Sat,  5 Nov 2022 22:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667687652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6/IBun3eEoGw1C80XiwUaEKaky/xKSAd5oZts/sTyQ4=;
        b=BKPC7h47sd2H7fPhqhbQ1TtDwjlbvWUQzcmeOxT5qsTPQvYhrSuWxmQx3nRhNlzQVgVLAI
        qXrjkTXPi94vYZlUHErd43BAiDCHOe/JcCou1W6bX8FAnjFcZ08xspit06zkRCGeu7JgYd
        7jppqVwlmEX5PBO4I9RyoVHCcBicytg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667687652;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6/IBun3eEoGw1C80XiwUaEKaky/xKSAd5oZts/sTyQ4=;
        b=/sPFWZB9yGBpazM/9uco8Hm1PEqvIvzYUjW7Ldg5rV1HjO0Z7W2QiQRO/Suh6HsT0bE1ay
        ZZ5PT5qYpKSE7HAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 71D6413AD7;
        Sat,  5 Nov 2022 22:34:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PTeoCuLkZmNUdAAAMHmgww
        (envelope-from <neilb@suse.de>); Sat, 05 Nov 2022 22:34:10 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Mikulas Patocka" <mpatocka@redhat.com>
Cc:     "Song Liu" <song@kernel.org>,
        "Guoqing Jiang" <guoqing.jiang@linux.dev>,
        "Zdenek Kabelac" <zkabelac@redhat.com>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] md: fix a crash in mempool_free
In-reply-to: =?utf-8?q?=3Calpine=2ELRH=2E2=2E21=2E2211040941112=2E19553=40fi?=
 =?utf-8?q?le01=2Eintranet=2Eprod=2Eint=2Erdu2=2Eredhat=2Ecom=3E?=
References: =?utf-8?q?=3Calpine=2ELRH=2E2=2E21=2E2211031121070=2E18305=40fil?=
 =?utf-8?q?e01=2Eintranet=2Eprod=2Eint=2Erdu2=2Eredhat=2Ecom=3E=2C?=
 <166753684502.19313.12105294223332649758@noble.neil.brown.name>, 
 =?utf-8?q?=3Calpine=2ELRH=2E2=2E21=2E2211040941112=2E19553=40file01=2Eintra?=
 =?utf-8?q?net=2Eprod=2Eint=2Erdu2=2Eredhat=2Ecom=3E?=
Date:   Sun, 06 Nov 2022 09:34:04 +1100
Message-id: <166768764482.19313.4863003667431957512@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, 05 Nov 2022, Mikulas Patocka wrote:
> 
> On Fri, 4 Nov 2022, NeilBrown wrote:
> 
> > > ---
> > >  drivers/md/md.c |    6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > Index: linux-2.6/drivers/md/md.c
> > > ===================================================================
> > > --- linux-2.6.orig/drivers/md/md.c	2022-11-03 15:29:02.000000000 +0100
> > > +++ linux-2.6/drivers/md/md.c	2022-11-03 15:33:17.000000000 +0100
> > > @@ -509,13 +509,14 @@ static void md_end_flush(struct bio *bio
> > >  	struct md_rdev *rdev = bio->bi_private;
> > >  	struct mddev *mddev = rdev->mddev;
> > >  
> > > +	bio_put(bio);
> > > +
> > >  	rdev_dec_pending(rdev, mddev);
> > >  
> > >  	if (atomic_dec_and_test(&mddev->flush_pending)) {
> > >  		/* The pre-request flush has finished */
> > >  		queue_work(md_wq, &mddev->flush_work);
> > >  	}
> > > -	bio_put(bio);
> > >  }
> > >  
> > >  static void md_submit_flush_data(struct work_struct *ws);
> > > @@ -913,10 +914,11 @@ static void super_written(struct bio *bi
> > >  	} else
> > >  		clear_bit(LastDev, &rdev->flags);
> > >  
> > > +	bio_put(bio);
> > > +
> > >  	if (atomic_dec_and_test(&mddev->pending_writes))
> > >  		wake_up(&mddev->sb_wait);
> > >  	rdev_dec_pending(rdev, mddev);
> > > -	bio_put(bio);
> > >  }
> > 
> > Thanks. I think this is a clear improvement.
> > I think it would be a little better if the rdev_dec_pending were also
> > move up.
> > Then both code fragments would be:
> >   bio_put ; rdev_dec_pending ; atomic_dec_and_test
> > 
> > Thanks,
> > NeilBrown
> 
> Yes, I'll send a second patch that moves rdev_dec_pending up too.
> 
> BTW. even this is theoretically incorrect:
> 
> > >     if (atomic_dec_and_test(&mddev->pending_writes))
> > >             wake_up(&mddev->sb_wait);
> 
> Suppose that you execute atomic_dec_and_test and then there's a context 
> switch to a process that destroys the md device and then there's a context 
> switch back and you call "wake_up(&mddev->sb_wait)" on freed memory.
> 
> I think that we should use wait_var_event/wake_up_var instead of sb_wait. 
> That will use preallocated hashed wait queues.
> 

I agree there is a potential problem.  Using wait_var_event is an
approach that could work.
An alternate would be to change that code to

  if (atomic_dec_and_lock(&mddev->pending_writes, &mddev->lock)) {
           wake_up(&mddev->sb_wait);
           spin_unlock(&mddev->lock);
  }

As __md_stop() takes mddev->lock, it would not be able to get to the
'free' until after the lock was dropped.

Thanks,
NeilBrown
