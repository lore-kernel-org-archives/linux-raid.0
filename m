Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0827EC77B7A
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 11:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbjE3LAL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 May 2023 07:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbjE3LAG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 30 May 2023 07:00:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676C6E5
        for <linux-raid@vger.kernel.org>; Tue, 30 May 2023 04:00:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 165FA21A18;
        Tue, 30 May 2023 10:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1685444390; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DLjm4vXmkf72B/B3/1r/iDlYetTRhM9Sr7WAZg6c20Y=;
        b=dphKTDN5RuvcPOhTzSQTBA1T7kipYRyHUdz7j+ZlNRs8/AtUBezjQhyPrPbvhVlSlg72zx
        xt8ZcuHUm3Fw0h5bzjSYIektb2CHmWZB4QkyFwc1YY6DisFTS8MFUfHBZQ2SHtiZr9wwsk
        x203IDEc4scW5ebza4qxGBbz7jaqt0U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1685444390;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DLjm4vXmkf72B/B3/1r/iDlYetTRhM9Sr7WAZg6c20Y=;
        b=m5hc1LhoV3I1MVRzqu8KmicT56hqtZmLmaxlIf93vVR1uieK3EWv2g9yTkm6jS1lS+6dgv
        PUGiuRJ8h6zvsSBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D764813478;
        Tue, 30 May 2023 10:59:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mDGPKCTXdWSCagAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 30 May 2023 10:59:48 +0000
Date:   Tue, 30 May 2023 18:59:46 +0800
From:   Coly Li <colyli@suse.de>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v3] Incremental: remove obsoleted calls to udisks
Message-ID: <c6jr4jmfkesjfxon7wsaxcw2qj52dvgrtjsxuuddoxhpftaly4@3vqllxix4otq>
References: <20230529160754.26849-1-colyli@suse.de>
 <20230530081718.00003cb7@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230530081718.00003cb7@linux.intel.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 30, 2023 at 08:17:18AM +0200, Mariusz Tkaczyk wrote:
> On Tue, 30 May 2023 00:07:54 +0800
> Coly Li <colyli@suse.de> wrote:
> 
> > Utilility udisks is removed from udev upstream, calling this obsoleted
> > command in run_udisks() doesn't make any sense now.
> > 
> > This patch removes the calls chain of udisks, which includes routines
> > run_udisk(), force_remove(), and 2 locations where force_remove() are
> > called. Considering force_remove() is removed with udisks util, it is
> > fair to remove Manage_stop() inside force_remove() as well.
> > 
> > In the two modifications where calling force_remove() are removed,
> > the failure from Manage_subdevs() can be safely ignored, because,
> > 1) udisks doesn't exist, no need to check the return value to umount
> >    the file system by udisks and remove the component disk again.
> > 2) After the 'I' inremental remove, there is another 'r' hot remove
> >    following up. The first incremental remove is a best-try effort.
> Hi Coly,
> 
> I'm not sure what you meant here. I know that on "remove" event udev will call
> mdadm -If <devname>. And that is all I'm familiar with. I don't see another
> branch executed in code to handle "remove" event, no second attempt for clean
> up is made. Could you clarify? How is it executed?
> Perhaps, I understand it incorrectly as second action that is always executed
> automatically. I know that there is an action "--remove" which can be manually
> triggered. Is that what you meant?
> 

What I mentioned was only related to the source code.

Before force_remove() is removed, it was called on 2 locations, one was from
remove_from_member_array(), another was from IncrementalRemove().

But remove_from_member_array() was called from IncrementalRemove() too. The
code flow is,

	if (container) {
		call remove_from_member_array()
	} else {
		call Manage_subdevs() with 'I' operation.
		if (return 2)
			call force_remove()
	}
		
	call Manage_subdevs() with 'r' operation

From the above bogus code, the first call to Manage_subdevs() was an Incremental
remove, and the second call to Manage_subdevs() was a hot remove. No matter it
succeed or failed on the first call, the second call for hot remove will always
happen.

Therefore, after removing force_remove(), it is unnecessary to check the return
value of the first call to IncrementalRemove(). Because always the second call
to Manage_subdevs() with 'r' operation will follow up.

This was what I meant, it was only related to the code I modified.


e > Therefore in this patch, where force_remove() is removed, the return
> > value of calling Manage_subdevs() is not checked too.
> > 
> > Signed-off-by: Coly Li <colyli@suse.de>
> > Cc: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> > Cc: Jes Sorensen <jes@trained-monkey.org>
> > ---
> > Changelog,
> > v3: remove the almost-useless warning message, and make the change
> >     more simplified.
> > v2: improve based on code review comments from Mariusz.
> > v1: initial version.
> 
> For the code:
> Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Thanks.

BTW, do you have any suggestion for the commit log? It seems current commit
message is not that clear, and I want to listen to your input :-)

-- 
Coly Li
