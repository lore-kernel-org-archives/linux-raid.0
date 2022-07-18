Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2E6C43334
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 07:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbiGRHAf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 03:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbiGRHAf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 03:00:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF6CD107;
        Mon, 18 Jul 2022 00:00:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0BD2020B97;
        Mon, 18 Jul 2022 07:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658127633; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GYyMI3DijEDdp+H2+qieGFeMKJ0gB9VeKq/KBfQ9r8U=;
        b=JguzxDCIvtOhFAv6djbhjSyaCQ9dAgYKLdc+AOUXxqOAOAcOomL/CIpCoAAo+Let9qaqJf
        OBS8e71IFWx07ZosEPs5VbRq8mKVz3SMEb4f4Aalysu17i/DGsxpKl5UYa1MosSeiYkrgx
        xFCxzmN/EapOhxv36ZuhlfD4lKhYTTM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658127633;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GYyMI3DijEDdp+H2+qieGFeMKJ0gB9VeKq/KBfQ9r8U=;
        b=fDIySju8xrZir5E7jRXwA0qJ6e4Tq81QQRkuHcMXNWukKGRauqv2Tedn6wfMdvycqQjFUY
        7bhMuM2qicMbgfDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E9E6413754;
        Mon, 18 Jul 2022 07:00:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id upy3NxAF1WKgZgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 18 Jul 2022 07:00:32 +0000
Message-ID: <60ac9180-eb7a-6bf3-660b-6aa9ab37a5d1@suse.de>
Date:   Mon, 18 Jul 2022 09:00:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 02/10] md: fix error handling in md_alloc
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-3-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220718063410.338626-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/18/22 08:34, Christoph Hellwig wrote:
> Error handling in md_alloc is a mess.  Untangle it to just free the mddev
> directly before add_disk is called and thus the gendisk is globally
> visible.  After that clear the hold flag and let the mddev_put take care
> of cleaning up the mddev through the usual mechanisms.
> 
> Fixes: 5e55e2f5fc95 ("[PATCH] md: convert compile time warnings into runtime warnings")
> Fixes: 9be68dd7ac0e ("md: add error handling support for add_disk()")
> Fixes: 7ad1069166c0 ("md: properly unwind when failing to add the kobject in md_alloc")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 45 ++++++++++++++++++++++++++++++++-------------
>   1 file changed, 32 insertions(+), 13 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes


