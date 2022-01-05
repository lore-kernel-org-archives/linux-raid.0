Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C50EC433F5
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jan 2022 16:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241995AbiAEQkK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jan 2022 11:40:10 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:57894 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241975AbiAEQj7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 5 Jan 2022 11:39:59 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 687BB210ED;
        Wed,  5 Jan 2022 16:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641400798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3caPqe7foBipGxqiA7QY++YSIF8wuUBHsEU3nvXcNDo=;
        b=Me6M62gtf89jyH8pIveALEBzEzSgbLzoiZaplOZxf6OGqwVSJUieOrhp7luF7mmDYWf6Sv
        rSEu3AdXYWw+JGekuEkubZzxdRdB24X/wFRZpewI7piTMz7gAcFjlOtHtgPtUIAa0npWkA
        D8Mc/RW5LzkFomIQn0ijWg3Rxy9YelQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641400798;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3caPqe7foBipGxqiA7QY++YSIF8wuUBHsEU3nvXcNDo=;
        b=rgm5CQ6hs3SfpEsgioFqVTMUtmNKjEGzXjLEJKskIF/5ktYvA/cmXC3nm8O753qAAatTQ/
        OBXLmSPGRKcrWdDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 567BF13BF8;
        Wed,  5 Jan 2022 16:39:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8WcoFN7J1WEMEQAAMHmgww
        (envelope-from <dmueller@suse.de>); Wed, 05 Jan 2022 16:39:58 +0000
From:   Dirk =?ISO-8859-1?Q?M=FCller?= <dmueller@suse.de>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] Use strict priority ranking for pq gen() benchmarking
Date:   Wed, 05 Jan 2022 17:39:57 +0100
Message-ID: <24151720.NQFCmDR0bW@magnolia>
Organization: SUSE Software Solutions Germany GmbH; GF: Ivo Totev; HRB 36809 (AG =?UTF-8?B?TsO8cm5iZXJnKQ==?=
In-Reply-To: <CAPhsuW5ThAK78JNfVZ0P8W1vKm2nWk7kYm350WFdSzBwcR3-ZQ@mail.gmail.com>
References: <20211229223600.29346-1-dmueller@suse.de> <4023010.WmdfGTY597@magnolia> <CAPhsuW5ThAK78JNfVZ0P8W1vKm2nWk7kYm350WFdSzBwcR3-ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Dienstag, 4. Januar 2022 18:28:39 CET Song Liu wrote:

> > want me to add to both then?
> I guess we only need something like:
>   .priority = 2   /* avx is always faster than sse */

Ah okay, makes total sense. added to v2. 

> Let's keep this part as-is then.

Thank you!

Greetings,
Dirk



