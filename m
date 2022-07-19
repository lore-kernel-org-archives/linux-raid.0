Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA66FC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 07:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbiGSHGW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 03:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbiGSHGV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 03:06:21 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE3D25C54;
        Tue, 19 Jul 2022 00:06:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0895E343ED;
        Tue, 19 Jul 2022 07:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658214379; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cy4axjJOXMKfMat433GrfT6j697ploUrhzgwUKUDuV0=;
        b=xJO5IxoPGhgcRkO+Ug+rhPc1RXbe29QTfIGBzei1JpjQ6TDStXIUABzGmBOSApWJaOgnTJ
        Z7tR0zlpOfqWLkBzFPUnxnbWKdh3YuJTPwy8x2CqpAe27KbqAFr4Xa6xM+YsShgfemNLLU
        R5CN2hTc5wpSDkCLh0XUNF2uKVp2PeE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658214379;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cy4axjJOXMKfMat433GrfT6j697ploUrhzgwUKUDuV0=;
        b=JxedaWY37X1Ba9JtNF8xG8oPXCC0EGj0fkMg43ZhjQTSwigNxp89lDLDSYz2dL/4xlyCYd
        vF5gmlUfzOP7lrCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E469913A72;
        Tue, 19 Jul 2022 07:06:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pYMsN+pX1mKJJAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 19 Jul 2022 07:06:18 +0000
Message-ID: <a109419a-b52b-e155-b7a2-77d452662deb@suse.de>
Date:   Tue, 19 Jul 2022 09:06:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 08/10] md: stop using for_each_mddev in md_exit
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Song Liu <song@kernel.org>, Logan Gunthorpe <logang@deltatee.com>,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-9-hch@lst.de>
 <61d08fa6-91e4-f809-1074-d1ba2b1a3758@suse.de>
 <20220719070306.GA28422@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220719070306.GA28422@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/19/22 09:03, Christoph Hellwig wrote:
> On Mon, Jul 18, 2022 at 09:10:59AM +0200, Hannes Reinecke wrote:
>>
>> Having thought about it some more ... wouldn't it make sense to modify
>> mddev_get() to
>>
>> if (atomic_inc_not_zero(&mddev->active))
>>      return NULL;
>>
>> to ensure we're not missing any use-after-free issues, which previously
>> would have been caught by the 'for_each_mddev()' macro?
> 
> No.  mddev->active = 0 can still be a perfectly valid mddev and they
> are not automatically deleted.  Check the conditions in mddev_put.

Sigh. Okay.
MD is a mess anyway.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
