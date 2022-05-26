Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF12C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 26 May 2022 09:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbiEZJq0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 May 2022 05:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343511AbiEZJqZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 May 2022 05:46:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E5DC9660
        for <linux-raid@vger.kernel.org>; Thu, 26 May 2022 02:46:23 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 05C04219B0;
        Thu, 26 May 2022 09:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1653558382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xAzbDtKzD4j7WOo/trxcSaIx35b+dBXJ2jcwyhV/gKQ=;
        b=SXV6jkWmQsyI3/1uuzjpf2l3XDsS4ylcmFpC/RUuT3SBXnPVUegmL1/pufTmVlp9g6c2Ek
        Jc7ucx3BpGUTEb6/mt9TS6OxnelepCVGMMx7Q/O/MAFIo43pmjvwm/keBkHr0EJk7Sx6MM
        RspV1nG/Utem6ogBIXtF15r88ryuffA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1653558382;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xAzbDtKzD4j7WOo/trxcSaIx35b+dBXJ2jcwyhV/gKQ=;
        b=VNrE7zY5GIAyhF184Io3FFoYADvZQkPKWaHm7OFpF58xB/EGjl6JH47vXJnlhrbrtOSHaD
        Ryv02cjd9PlVrsDQ==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BE3B22C141;
        Thu, 26 May 2022 09:46:21 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 381B9A0632; Thu, 26 May 2022 11:46:21 +0200 (CEST)
Date:   Thu, 26 May 2022 11:46:21 +0200
From:   Jan Kara <jack@suse.cz>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Song Liu <song@kernel.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
Message-ID: <20220526094621.gzfm2zws325sb7wn@quack3.lan>
References: <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
 <836b2a93-65be-8d6c-8610-18373b88f86d@molgen.mpg.de>
 <5b0584a3-c128-cb53-7c8a-63744c60c667@linux.dev>
 <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
 <954f9c33-7801-b6d2-65e3-9e5237905886@linux.dev>
 <82a08e9c-e3f4-4eb6-cb06-58b96c0f01a8@deltatee.com>
 <775d6734-2b08-21a8-a093-f750d31ce6ce@linux.dev>
 <ae6d294a-e9ec-a81d-6085-a9341ed8a470@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae6d294a-e9ec-a81d-6085-a9341ed8a470@deltatee.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed 25-05-22 12:22:06, Logan Gunthorpe wrote:
> 
> 
> On 2022-05-25 03:04, Guoqing Jiang wrote:
> > I would prefer to focus on block tree or md tree. With latest block tree
> > (commit 44d8538d7e7dbee7246acda3b706c8134d15b9cb), I get below
> > similar issue as Donald reported, it happened with the cmd (which did
> > work with 5.12 kernel).
> > 
> > vm79:~/mdadm> sudo ./test --dev=loop --tests=05r1-add-internalbitmap
> 
> Ok, so this test passes for me, but my VM was not running with bfq. It
> also seems we have layers upon layers of different bugs to untangle.
> Perhaps you can try the tests with bfq disabled to make progress on the
> other regression I reported.
> 
> If I enable bfq and set the loop devices to the bfq scheduler, then I
> hit the same bug as you and Donald. It's clearly a NULL pointer
> de-reference in the bfq code, which seems to be triggered on the
> partition read after mdadm opens a block device (not sure if it's the md
> device or the loop device but I suspect the latter seeing it's not going
> through any md code).
> 
> Simplifying things down a bit, the null pointer dereference can be
> triggered by creating an md device with loop devices that have bfq
> scheduler set:
> 
>   mdadm --create --run /dev/md0 --level=1 -n2 /dev/loop0 /dev/loop1
> 
> The crash occurs in bfq_bio_bfqg() with blkg_to_bfqg() returning NULL.
> It's hard to trace where the NULL comes from in there -- the code is a
> bit complex.
> 
> I've found that the bfq bug exists in current md-next (42b805af102) but
> did not trigger in the base tag of v5.18-rc3. Bisecting revealed the bug
> was introduced by:
> 
>   4e54a2493e58 ("bfq: Get rid of __bio_blkcg() usage")
> 
> Reverting that commit and the next commit (075a53b7) on top of md-next
> was confirmed to fix the bug.
> 
> I've copied Jan, Jens and Paolo who can hopefully help with this. A
> cleaned up stack trace follows this email for their benefit.

Indeed. Thanks for easy reproduction steps. I've reproduced the issue
locally and I'm looking into it because from a quick look into the code
this shouldn't be possible which means I'm missing something obvious :).

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
