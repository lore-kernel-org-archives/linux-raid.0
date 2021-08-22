Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F453C4338F
	for <linux-raid@archiver.kernel.org>; Sun, 22 Aug 2021 22:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CE10611EF
	for <linux-raid@archiver.kernel.org>; Sun, 22 Aug 2021 22:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhHVWGp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 22 Aug 2021 18:06:45 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50456 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbhHVWGo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 22 Aug 2021 18:06:44 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 46EB421C17;
        Sun, 22 Aug 2021 22:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629669962; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n/S8qHCI8uK3dc25B9L6IxGuoik5FUdCu4V5brErfkE=;
        b=glhOVZGi0Ew59hyNVvy1PaF3Fie9ou3aqtpr0X3kiwRhi2gIdx0wPR+KHXp/1YyXNeIWP8
        AJALRGDX80FtCNIomooNNwvLAZkCPlBggCzPUltnZV3Mpjk6+mMQlExDs3hknRPIkkuRVT
        qYcQIVxpNNTsw9e/dPkaTePImOyhqv0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629669962;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n/S8qHCI8uK3dc25B9L6IxGuoik5FUdCu4V5brErfkE=;
        b=a4KfEsJHmZVtfRARYYZZMIYPvL5es9lXWzgfMTE6U0DDR6u5i8w0VFkso9UrCdevGX4iKx
        FZTHhfGIrDme8HAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 594B813A9E;
        Sun, 22 Aug 2021 22:06:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8YPHBUjKImF1bQAAMHmgww
        (envelope-from <neilb@suse.de>); Sun, 22 Aug 2021 22:06:00 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Gal Ofri" <gal.ofri@volumez.com>
Cc:     linux-raid@vger.kernel.org, "Nigel Croxon" <ncroxon@redhat.com>,
        jes@trained-monkey.org, xni@redhat.com,
        mariusz.tkaczyk@linux.intel.com
Subject: Re: [PATCH V2] Fix buffer size warning for strcpy
In-reply-to: <20210822172657.2d3405db@gofri-dell>
References: <20210819131017.2511208-1-ncroxon@redhat.com>,
 <162941140310.9892.4439598009992795158@noble.neil.brown.name>,
 <20210822172657.2d3405db@gofri-dell>
Date:   Mon, 23 Aug 2021 08:05:57 +1000
Message-id: <162966995740.9892.4195621150113145955@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 23 Aug 2021, Gal Ofri wrote:
> > You really should explain here why we change from filling with spaces to
> > filling with nuls.
> I guess that a commit-comment would still be needed, but I think that a
> more conventional approach could make it all clearer:
> 
> - memset(ve->name, ' ', 16);
> - if (name)
> -	strncpy(ve->name, name, 16);
> + int l = strnlen(ve->name, 16);
> + memcpy(ve->name, name, l);
> + if (l < 16) /* no null-termination expected when all the space is used */
> + 	ve->name[l] = '\0';

No, that would be wrong.  It doesn't clear the whole array.

NeilBrown
