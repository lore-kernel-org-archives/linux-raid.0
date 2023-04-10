Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25478C76196
	for <linux-raid@archiver.kernel.org>; Mon, 10 Apr 2023 21:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjDJVyN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Apr 2023 17:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjDJVyM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 Apr 2023 17:54:12 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B62619B6
        for <linux-raid@vger.kernel.org>; Mon, 10 Apr 2023 14:54:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id ADEBB21A25;
        Mon, 10 Apr 2023 21:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681163648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bf2DHyP9u9EIK+h/BbZm6RMAg0k54faWO6d9BFKbedE=;
        b=gdu/fpsMFDqDlVovNUXbZRyxI2byeaF1/GZA6kXXrJLuWY8s0E5SRohZGS7CTHs8Vxj7Qq
        Phn2173VztyoeiaKKqMhvZNOrqj1Gy0vhEnhMMsirfaA3qT3pi+qSdnf6R967yuLTKi9T7
        6K+mJT0FRN2LPVMnLlxjRxWYbGGcf4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681163648;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bf2DHyP9u9EIK+h/BbZm6RMAg0k54faWO6d9BFKbedE=;
        b=V3AB+TxeY7ZsZVhdbFm6KdeydHVKUSTRGMBIeTwCmIJzhNJ7Rftbuq34UdJkeXFJa/aN2u
        7Cru0iRDEgcKOeCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7468D13902;
        Mon, 10 Apr 2023 21:54:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mg1rCn+FNGR1SwAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 10 Apr 2023 21:54:07 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Jes Sorensen" <jes@trained-monkey.org>
Cc:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
        "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>
Subject: Re: mdadm minimum kernel version requirements?
In-reply-to: <e8ed86bb-4162-7d8e-ece9-eb75e045bcc5@trained-monkey.org>
References: <e8ed86bb-4162-7d8e-ece9-eb75e045bcc5@trained-monkey.org>
Date:   Tue, 11 Apr 2023 07:54:04 +1000
Message-id: <168116364433.24821.9557577764628245206@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 11 Apr 2023, Jes Sorensen wrote:
> Hi,
> 
> I bumped the minimum kernel version required for mdadm to 2.6.32.
> 
> Should we drop support for anything prior to 3.10 at this point, since
> RHEL7 is 3.10 based and SLES12 seems to be 3.12 based.
> 
> Thoughts?

When you talk about changing the required kernel version, I would find
it helpful if you at least mention what actual kernel features you now
want to depend on - at least the more significant ones.

Aside from features, I'd rather think about how old the kernel is.
2.6.32 is over 13 years old.
3.10 is very nearly 10 years old.
If there is something significant that landed in 3.10 that we want to
depend on, then requiring that seems perfectly reasonable.

I think the oldest SLE kernel that you might care about would be 4.12
(SLE12-SP5 - nearly 6 years old).  Anyone using an older SLE release
values stability over new functionality and is not going to be trialling
a new mdadm.

Thanks,
NeilBrown
