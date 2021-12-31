Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B43BC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 31 Dec 2021 08:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhLaIfm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 31 Dec 2021 03:35:42 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:49258 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbhLaIfm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 31 Dec 2021 03:35:42 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1FCE621106;
        Fri, 31 Dec 2021 08:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640939741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t7WnV9vuWs4O+i9LwCeNm+MouGOvWxC8rsw2SwWOvK0=;
        b=z48F17mxrIRcqQlMDpmWOzwT+Or6vy/9nEk/Jdw8wiRqLNWlodxAj8aptuDxtd+Vx48Pi+
        GkgXMv0sEXPtkYHRLCb0qe1a8G2jAFHOFt6GI1amp04FtKoU/MzQVZUkR4HrLugw2Liw5y
        ns5DHhvE3OHBcHnfvsrYb4mvLvEL7HI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640939741;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t7WnV9vuWs4O+i9LwCeNm+MouGOvWxC8rsw2SwWOvK0=;
        b=AQHujU7Rlum53aQMuB53crFswnu7/7Fd9m+cest8v9mdSaxUphXIxhnA5yofbQeQrCZzrT
        YJLLcUcSryvwMFAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1193113C2F;
        Fri, 31 Dec 2021 08:35:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +EGcA93AzmHSeQAAMHmgww
        (envelope-from <dmueller@suse.de>); Fri, 31 Dec 2021 08:35:41 +0000
MIME-Version: 1.0
Date:   Fri, 31 Dec 2021 09:35:40 +0100
From:   =?UTF-8?Q?Dirk_M=C3=BCller?= <dmueller@suse.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linux-raid@vger.kernel.org
Subject: Re: [PATCH] Skip benchmarking of non-best xor_syndrome functions
In-Reply-To: <71f0f9ea-1431-a10c-084b-a956a5b9de2f@molgen.mpg.de>
References: <20211229223407.11647-1-dmueller@suse.de>
 <71f0f9ea-1431-a10c-084b-a956a5b9de2f@molgen.mpg.de>
User-Agent: Roundcube Webmail
Message-ID: <4b0faf644530d0f7317bfeb88884f114@suse.de>
X-Sender: dmueller@suse.de
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Am 2021-12-30 12:33, schrieb Paul Menzel:

Hi Paul,

Thank you for the wording improvements to the commit message, 
incorporated for the next
patch version.

>> For x86_64, this removes 8 out of 18 benchmark loops which each take
>> 16 jiffies, so up to 160 jiffies saved on module load (640ms on a 
>> 250HZ
>> kernel)
> On what system?

on a x86_64 system with avx512 capabilities. before this patch it was 
doing 3x avx512, 3x avx2 and 3x sse2 xor() benchmark runs (so 9 total, 
plus 9 gen() runs as well, leading to the 18 above). with this patch 
applied the 9 xor() runs become just 1, saving 8. exact timing depends 
on the CONFIG_HZ setting in use, as the benchmark timescale is in 
jiffies (which is a problem on its own, but that is for another patch).

> The new message below is logged?
> 
>     raid6: skipped pq benchmark and selected …

its the same message like before, just worded slightly differently. I 
can undo the wording change if requested.

> I am booting my non-RAID systems with `cryptomgr.notests` to avoid
> this boot time penalty.

the benchmark option is recommended to be turned on, and I'm trying to 
reduce the cost of that. turning it off avoids the cost altogether, but 
I'm not able to judge (yet?) whether that's a better thing to do.


Thanks
Dirk
