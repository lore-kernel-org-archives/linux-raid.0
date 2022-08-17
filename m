Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9A8C25B08
	for <linux-raid@archiver.kernel.org>; Wed, 17 Aug 2022 05:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbiHQFyh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Aug 2022 01:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiHQFyg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 17 Aug 2022 01:54:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D3F7C317
        for <linux-raid@vger.kernel.org>; Tue, 16 Aug 2022 22:54:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1E69B1F97F;
        Wed, 17 Aug 2022 05:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1660715673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u96qQ4na9TR6DQhoyhO0U56iKVW5IpANePQgcpGN1jw=;
        b=K6GfAPWkqEJ3R2B/Ij8s84D9Gxf9b7HzWCMTEGVrPxy98L+tmDgRW320r53I/o7fHSw0Ir
        RVa5SzCIzeoLcHAwaK+unLlPfzeGggA0amR9geqgfL56uKY22McIFAmMcT9G9CX1sivdoM
        9j2IQxhi7Q+EcpbmLqemRrHoEjm1Wek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1660715673;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u96qQ4na9TR6DQhoyhO0U56iKVW5IpANePQgcpGN1jw=;
        b=10DIY1V+dysRAKHwxUXrzr1geZ2iJ81f5Y3MH74W83YxHhCcdx8S1NaPJQEGeB0sJhbLfO
        DUx/6RN3X9gNNDAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 048E513A93;
        Wed, 17 Aug 2022 05:54:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1QBSO5iC/GJZIAAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 17 Aug 2022 05:54:32 +0000
Message-ID: <828ee094-fbb0-2e55-0728-6fad769dd7ac@suse.de>
Date:   Wed, 17 Aug 2022 07:54:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: Timeout waiting for /dev/md/imsm0 ?
Content-Language: en-US
To:     "David F." <df7729@gmail.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <CAGRSmLvY48qanq6qdi40LE_50xT9ZzUq456KntesLSrxt8AmBw@mail.gmail.com>
 <20220816082344.00001dbf@linux.intel.com>
 <CAGRSmLvKtjtDtrmv1pp7YEdxOGRYnRXs0WaFS_y0HJxX3NYSaA@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAGRSmLvKtjtDtrmv1pp7YEdxOGRYnRXs0WaFS_y0HJxX3NYSaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/17/22 04:04, David F. wrote:
> What rules should be used?   I don't see a /dev/md directory, I
> created one, stopped the raid (all the /dev/md* devices went away)
> and tried to start the raid, same thing and only /dev/md127 gets
> created, nothing in /dev/md/ directory and none of the md126 devices ?
>   You then get the timeout.
> 
Please check the device-mapper status.

My guess is that device-mapper gets in the way (as it probably will be 
activated from udev, too), and blocks the devices when mdadm is trying 
to access them.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
