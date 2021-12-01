Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC36C4332F
	for <linux-raid@archiver.kernel.org>; Wed,  1 Dec 2021 21:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353187AbhLAVy4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Dec 2021 16:54:56 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:59834 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343507AbhLAVyx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Dec 2021 16:54:53 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8A01121891;
        Wed,  1 Dec 2021 21:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638395484; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Is3EXfMmm4sOy7Ez5vGGqUB6ZzIQ9MFiGWYrVEnb728=;
        b=GfPFM+C7SmePhrGjYMQfebMkSWZNGctbkAF8JptnNUPhCh4YCZU7qfL1eNg//98IfRn21R
        V7LEfPVI+5WaZfqOtDzUoxovaYVeIXk9Tf4pGrt1hqtvFInFpn6BOOWtJoO4ZXuoqjBv9Q
        3GCf1+4CuZU4npxqCps/Q/w1BX2WC+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638395484;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Is3EXfMmm4sOy7Ez5vGGqUB6ZzIQ9MFiGWYrVEnb728=;
        b=9B42FY1urghyOkUUHtW0lsgFqtrgTwqZreWhVLyGApPYKKKvr8R5xdLhDR/u1IU1eqiXI6
        MSzLo126+OQtzQAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B518E13D8E;
        Wed,  1 Dec 2021 21:51:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xRYWGlrup2GeEgAAMHmgww
        (envelope-from <neilb@suse.de>); Wed, 01 Dec 2021 21:51:22 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Coly Li" <colyli@suse.de>
Cc:     "Benjamin Brunner" <bbrunner@suse.com>, linux-raid@vger.kernel.org,
        "mtkaczyk" <mariusz.tkaczyk@linux.intel.com>,
        "Jes Sorensen" <jsorensen@fb.com>
Subject: Re: [PATCH] mdadm/systemd: change KillMode from none to mixed in
 service files
In-reply-to: <39d432ad-b451-082a-e52d-ffa32155529b@suse.de>
References: <20211201062245.6636-1-colyli@suse.de>,
 <20211201170843.00005f69@linux.intel.com>,
 <9ee380c8-e43b-8f58-c7d5-5bddb6f2e688@suse.de>,
 <73287b77-33aa-a9bd-7efa-5816e098f02f@suse.com>,
 <39d432ad-b451-082a-e52d-ffa32155529b@suse.de>
Date:   Thu, 02 Dec 2021 08:51:19 +1100
Message-id: <163839547917.26075.6431438000167570600@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 02 Dec 2021, Coly Li wrote:
> On 12/2/21 12:28 AM, Benjamin Brunner wrote:
> > Hi all,
> >
> > On 01.12.21 17:23, Coly Li wrote:
> >> On 12/2/21 12:08 AM, mtkaczyk wrote:
> >>> Hi Coly,
> >>>
> >>>> This patch changes KillMode in above listed service files from "none"
> >>>> to "mixed", to follow systemd recommendation and avoid potential
> >>>> unnecessary issue.
> >>> What about mdmonitor.service? Should we add it there too? Now it is not
> >>> defined.
> >>
> >> It was overlooked when I did grep KillMode. Yes, I agree 
> >> mdmonitor.service should have a KillMode key word as well.
> >>
> >> Let me post a v2 version.
> >>
> > JFYI, when KillMode is not set, it defaults to KillMode=control-group, 
> > see https://www.freedesktop.org/software/systemd/man/systemd.kill.html.
> >
> > Therefore, it shouldn't be necessary to explicitly add it (as long as 
> > control-group is working in case of mdmonitor.service, of course).
> 
> Hi Benjamin,
> 
> Please correct me if I am wrong, I see the difference of the KillMode is,
> -- KillMode=mixed stops the processes more gentally, it kill the main 
> process with SIGTERM and the remaining processes with SIGKILL.
> -- KillMode=control-group kills all in-cgroup processes with SIGKILL, 
> which I feel a bit cruel for the main process.

There is no point sending SIGTERM to a process which doesn't respond to
it.  mdmon is the only mdadm service which handles SIGTERM.  So it might
make sense to uise KillMode=mixed for that.
For anything else, SIGKILL via KillMode=control-group is perfectly
acceptable. 

NeilBrown


> 
> IMHO both method (explicit mixed mode or implicit control-group mode) 
> should works for the fixing issue, but I feel removing the KillMode 
> lines might be better as you indicated since the files can be a bit 
> simpler. Do I understand you correct ?
> 
> Thanks.
> 
> Coly Li
> 
> 
