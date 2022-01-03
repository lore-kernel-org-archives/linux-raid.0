Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B3EC433F5
	for <linux-raid@archiver.kernel.org>; Mon,  3 Jan 2022 13:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiACNto (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 3 Jan 2022 08:49:44 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39780 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiACNto (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 3 Jan 2022 08:49:44 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6BCFF1F38A;
        Mon,  3 Jan 2022 13:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641217783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=95gDvEaPxu/pa+B8X0IK+oUb2sWgPGGYPKYQ1vB8wQY=;
        b=kAwWX1T9QFBlqNsreKOKxfABvt/x8yLO279Fc6XffXRL4ZH9ovWcqwjyVv1ZKLKaHH9Jhr
        lk4pU4hk5/c+f1JhiWAasICJsWjgJKOIECf699+5KqD/odj6O2zq8eY5n6R4T6cDWG2gsG
        3UzlRAjx25Vj7gVWfY2i3cKEPhyl69w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641217783;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=95gDvEaPxu/pa+B8X0IK+oUb2sWgPGGYPKYQ1vB8wQY=;
        b=j4HeetdASuIDpjE4E+HPpQz/Pve7bxRqqw6/1YqHYYHd0AK04mXGEW9RHVRwSmsswc68Bz
        dHoowqR4FvZgh8BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 58B1513AAE;
        Mon,  3 Jan 2022 13:49:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ajeBFPf+0mEQRgAAMHmgww
        (envelope-from <dmueller@suse.de>); Mon, 03 Jan 2022 13:49:43 +0000
From:   Dirk =?ISO-8859-1?Q?M=FCller?= <dmueller@suse.de>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] Skip benchmarking of non-best xor_syndrome functions
Date:   Mon, 03 Jan 2022 14:49:43 +0100
Message-ID: <17479780.g37Zg15fLm@magnolia>
Organization: SUSE Software Solutions Germany GmbH; GF: Ivo Totev; HRB 36809 (AG =?UTF-8?B?TsO8cm5iZXJnKQ==?=
In-Reply-To: <CAPhsuW7N-_v7ivE6SXphgXiA4An0kruF+W25QrFhO15fkUZYfg@mail.gmail.com>
References: <20211229223407.11647-1-dmueller@suse.de> <CAPhsuW7N-_v7ivE6SXphgXiA4An0kruF+W25QrFhO15fkUZYfg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sonntag, 2. Januar 2022 00:49:17 CET Song Liu wrote:

> > For x86_64, this removes 8 out of 18 benchmark loops which each take
> > 16 jiffies, so up to 160 jiffies saved on module load (640ms on a 250HZ
> > kernel).
> How critical is 160 (or 128?) jiffies saving here? 

For my usecase, this initialization codepath is just over 50% of the total 
runtime of my initrd, so it is significant. this is small initrd for virtual 
environments, using however the standard distribution kernel image (which has 
benchmarking enabled per Kconfig recommendation).

> If it is critical for some use cases, maybe we can gate the change with a
> CONFIG?

I can't see how it is critical for usecases, because of 

* the outcome of the benchmarking is discarded
* there is no configuration or commandline option to manually select a different 
xor variant if you as a linux user chose to select a different one based on 
manual review of the xor benchmarking results
* benchmarking is recommended to be enabled by default. if you disable it, it 
will simply pick the first that works from the static list (which is basically 
ordered by hardware features reverse, or by most likely best performance). 

I'm happy to have that behind yet another config option if that makes the patch 
upstreamable, just let me know and I'll send a new variant. 

Greetings,
Dirk



