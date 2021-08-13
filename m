Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E41DC4338F
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 07:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 364016103E
	for <linux-raid@archiver.kernel.org>; Fri, 13 Aug 2021 07:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239269AbhHMHTl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Aug 2021 03:19:41 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:40038 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239248AbhHMHTl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Aug 2021 03:19:41 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7BFEB222A9;
        Fri, 13 Aug 2021 07:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628839154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rPBVGwqjXL7VFX/bv8R5A0Lwbv6GE8yTlpKK+xm6Si8=;
        b=0Toc8Yzu1183ap67oZsH8gItazcmLVIaaZfZrvuhIdZil90fUAJakcCHUv/GRxrX7yETWl
        JKQV+x2FPg6SspQsyq9qRuSJVG7tJ8gS5ggaooumNlRSoc1kmPF7XJKczwVZLvPE2elYEJ
        tPWzDV0R4Y45U12xYRNZt4mn9F/P/N0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628839154;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rPBVGwqjXL7VFX/bv8R5A0Lwbv6GE8yTlpKK+xm6Si8=;
        b=mP2Ce4ZEb67OMALZ6SnTPuWX0cSJZ+whyFa5SlnbkbLkijjufp+GhRJtwvTFKZfMnViGnY
        cZ5NvYXWt0t/Q7Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E2F4D13A00;
        Fri, 13 Aug 2021 07:19:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3nsWKPAcFmHvYgAAMHmgww
        (envelope-from <neilb@suse.de>); Fri, 13 Aug 2021 07:19:12 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     "Nigel Croxon" <ncroxon@redhat.com>, jes@trained-monkey.org,
        xni@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH V2] Fix return value from fstat calls
In-reply-to: <5b71689a-6d07-0dfd-a4b6-26322ee3136e@linux.intel.com>
References: <20210810151507.1667518-1-ncroxon@redhat.com>,
 <20210811190930.1822317-1-ncroxon@redhat.com>,
 <162872237888.31578.18083659195262526588@noble.neil.brown.name>,
 <346e8651-d861-45c7-9058-68008e691b93@Canary>,
 <162881060124.15074.6150940509008984778@noble.neil.brown.name>,
 <5b71689a-6d07-0dfd-a4b6-26322ee3136e@linux.intel.com>
Date:   Fri, 13 Aug 2021 17:19:10 +1000
Message-id: <162883915010.1695.14187049458830945568@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 13 Aug 2021, Tkaczyk, Mariusz wrote:
> 
> Maybe It won't be useful for users but it may help developers to avoid
> trivial mistakes. As you told, if everything is fine then check is dead.
> In my opinion any error handling is better than nothing.

Error handling that is buggy, or that is hard to maintain is not better
than nothing.  If I can't guarantee that we never pass a bad file
descriptor, then you cannot guarantee that the error handling has no
bugs.   Less code generally means less bugs.

Any attempt to try to handle an error that should not be able to happen
other than crashing is fairly pointless - you cannot guess the real
cause, so you cannot know how to repair.  Just printing a message and
continuing could be as bad as not checking the error.

NeilBrown
