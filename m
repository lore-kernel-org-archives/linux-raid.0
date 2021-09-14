Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30545C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 14 Sep 2021 07:26:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1066C6044F
	for <linux-raid@archiver.kernel.org>; Tue, 14 Sep 2021 07:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240735AbhINH2D (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Sep 2021 03:28:03 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41890 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240218AbhINH17 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Sep 2021 03:27:59 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 517EF21F32;
        Tue, 14 Sep 2021 07:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631604402; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rzhYveKnEuQDKvAji7c4wmzEnmDO38ogMFPC41Q7zUc=;
        b=jFMXlqjjxUlwkfuEprEFQTKUyJiLY79HiAfHmYx5BzQf3w/Vdq2W1hwBcfwOqgLV5CciwX
        zDjUN9qxYF71aJzCbNE3K1Ct14xPD9nEXmWTOfiar0dVn/9rH5X1fCWJBgD1vz40P40MBN
        XHZqci+BntaovA1RH33eIThZc5iiLMM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631604402;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rzhYveKnEuQDKvAji7c4wmzEnmDO38ogMFPC41Q7zUc=;
        b=sLET9nBBTaQRVwTuB1hjd7uv9iDKY4JXhAH89Wa8Kjae41uUUfhacaFNb5voS5E+3uyWqq
        rgho9ateJYGJ5+CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 45C6513E55;
        Tue, 14 Sep 2021 07:26:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id j9jGELJOQGEyAgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Sep 2021 07:26:42 +0000
Subject: Re: [PATCH] mdadm: split off shared library
To:     Xiao Ni <xni@redhat.com>
Cc:     Jes Sorensen <jsorensen@fb.com>, Coly Li <colyli@suse.de>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <7461b27b-2a4b-fbbb-5cfd-8fab416cbc9f@suse.de>
 <CALTww29nZV4A1BM_ShrmL1ud4YZC2YTG8q4LvW8pfhZwb=MhVQ@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <75fdd0fe-154b-f8eb-9ac3-bb948b432e39@suse.de>
Date:   Tue, 14 Sep 2021 09:26:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CALTww29nZV4A1BM_ShrmL1ud4YZC2YTG8q4LvW8pfhZwb=MhVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/14/21 9:08 AM, Xiao Ni wrote:
> Hi Hannes
> 
> Thanks for these patches. It's a good idea to make codes more clearly
> that which codes belong to which file.
> There are many efforts that move codes from mdadm.c and mdadm.h to
> specific files. Is it better to put these
> patches together? For example, the patches(6, 11, 12, 16, 19, 20, 27,
> 28) try to clean mdadm.c. Could you put
> similar patches together? And there are some rename patches too, they
> are sporadic.
> 
Sure. Wasn't sure how you'd like to handle it; some prefer smaller
patches, some prefer less patches overall ...

> For patch03, the argument is name, but it uses optarg in the function
> mdadm_get_layout. Is it an error?
> 
Have to check.

> By the way, are there some other users who use the library besides mdadm/mdmon?
> 
Not yet, but there is a program I wrote some time ago

https://github.com/hreinecke/md_monitor.git

which currently does an 'exec' on mdadm, and error handling _that_ is a
major pain. Having a shared library will make life easier there.
And I've some projects planned which would need to leverage mdadm
functionality, so for those a mdadm library would be ideal.

> And it's good for me if you send patches directly by email to
> linux-raid mail list.
> 

Sure.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
