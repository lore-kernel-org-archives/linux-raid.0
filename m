Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EBD8C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  3 Jan 2022 16:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbiACQ2y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 3 Jan 2022 11:28:54 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:53454 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiACQ2x (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 3 Jan 2022 11:28:53 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2F8D81F381;
        Mon,  3 Jan 2022 16:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641227332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lgm3e5dGjwsKfuRvbL8So6WJYe8iAVF6kzuE7ckYeVI=;
        b=vZAu6Z4ngvKuxQSG6l2tBmziELbMCv/VdnTsGlbZ97TlEcVibpQTa/e7658AsGelTS/fWG
        DfB7x5LDP1DnWfXudFNutMCvuRD8I7Bl4V7kTijgDDZzR0aJoMLPLgBezvOGLGlby1GxtI
        mWW0rAAkHkb4BoPn303qGuaJmZ+NTgY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641227332;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lgm3e5dGjwsKfuRvbL8So6WJYe8iAVF6kzuE7ckYeVI=;
        b=VHSQmQZCSBwfeKzhFQwccA8BfYiomC27wt4FmQKWcbCWfhJKoSYFHrcPsFEg2RMdQEKmXK
        QIu5p6JsTAiuhzCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1AC9613AFD;
        Mon,  3 Jan 2022 16:28:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SB58BUQk02GmewAAMHmgww
        (envelope-from <dmueller@suse.de>); Mon, 03 Jan 2022 16:28:52 +0000
From:   Dirk =?ISO-8859-1?Q?M=FCller?= <dmueller@suse.de>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] Use strict priority ranking for pq gen() benchmarking
Date:   Mon, 03 Jan 2022 17:28:51 +0100
Message-ID: <4023010.WmdfGTY597@magnolia>
Organization: SUSE Software Solutions Germany GmbH; GF: Ivo Totev; HRB 36809 (AG =?UTF-8?B?TsO8cm5iZXJnKQ==?=
In-Reply-To: <CAPhsuW6+kfUFoJNQVbTnWPaqPZECnwEUXf6q7FbSQpJGtMMsYg@mail.gmail.com>
References: <20211229223600.29346-1-dmueller@suse.de> <CAPhsuW6+kfUFoJNQVbTnWPaqPZECnwEUXf6q7FbSQpJGtMMsYg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sonntag, 2. Januar 2022 01:03:44 CET Song Liu wrote:

> We need  more explanation/documentation about 0 vs. 1 vs. 2 priority.

In the commit message? in the code? this is basically a copy&paste of the same 
concept and code from a few lines below the diff, struct raid6_recov_calls
which works the same way and currently has no documentation at all.

want me to add to both then?

> >                         if ((*algo)->valid && !(*algo)->valid())
> 
> If the module load time is really critical, maybe we can run all
> ->valid() calls first and
> find the highest valid priority. Then, we only run the benchmark for
> these algorithms.

thats exactly what the code always did. previously all x86_64 specific 
implementations (be it SSE1/SSE2/AVX2/AVX512) all had the same priority level 
1, over the default priority level 0 for the implemented-in-C int*.c routines. 
with this change, we have one more level p refering AVX* over the rest, so 
that we skip testing SSE1/SSE2 (similary to how the integer implementations 
have always been skipped before). 

> Does this make sense?

the valid call is not probing anything by itself. it just iterates over a 
small array of functions and stops executing benchmarks for those that have 
lower priority ranks. 

so there isn't really a lot of cycles to win by changing the execution order 
here. I would assume it will actually slow things down as we have to store the 
valid() result for the 2nd iteration. 

Greetings,
Dirk



