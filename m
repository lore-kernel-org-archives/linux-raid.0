Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC63CC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 07:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbiGSHA4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 03:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbiGSHAt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 03:00:49 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B5B12D12;
        Tue, 19 Jul 2022 00:00:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BB6D33420E;
        Tue, 19 Jul 2022 07:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658214045; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3C2pVUcGTQozX2Sr39YyNDIz2u0qnZ5YgwRlGR0ttiw=;
        b=grYSWVoDT5Eazf3P1hlLmY9c+cx5ZswoqHHv4cuhNXos2qkBfqAPZfWC1an6xZ7MPN837e
        pPIkyTZ+fWU592zTuniOn/rC+cP11xvW9CHbkF6MkjOuH26/JMplfWeKdt3CuFSw1aa7TO
        WrMV9NWyXa7BqY3Ob9f/YonLPPQHhjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658214045;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3C2pVUcGTQozX2Sr39YyNDIz2u0qnZ5YgwRlGR0ttiw=;
        b=kpoIEx0v5aYfahsL7CxfmFVtifcdYamD7eL8YFXJMz8LF5A/yxnJlI4FXQXggZGxmXDPO9
        +9rPdQBBSwWXfNDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9D1C913A72;
        Tue, 19 Jul 2022 07:00:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yh5/JZ1W1mI3IgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 19 Jul 2022 07:00:45 +0000
Message-ID: <25244480-78bc-8a37-d056-60c9db8c4d63@suse.de>
Date:   Tue, 19 Jul 2022 09:00:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 09/10] md: only delete entries from all_mddevs when the
 disk is freed
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-10-hch@lst.de>
 <b8521a53-fb41-279c-dc43-580e8d0de045@suse.de>
 <CAPhsuW6VYLt0hPsa667mr5+Zn1pxjY_670NaD8+No=2ZjoOzYg@mail.gmail.com>
 <20220719050655.GA26785@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220719050655.GA26785@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/19/22 07:06, Christoph Hellwig wrote:
> On Mon, Jul 18, 2022 at 11:20:39AM -0700, Song Liu wrote:
>>>>    static inline struct mddev *mddev_get(struct mddev *mddev)
>>>>    {
>>>> +     lockdep_assert_held(&all_mddevs_lock);
>>>> +
>>>> +     if (mddev->deleted)
>>>> +             return NULL;
>>>>        atomic_inc(&mddev->active);
>>>>        return mddev;
>>>>    }
>>>
>>> Why can't we use 'atomic_inc_unless_zero' here and do away with the
>>> additional 'deleted' flag?
> 
>> I think atomic_inc_unless_zero() should work here. Alternatively, we can
>> also grab a big from mddev->flags as MD_DELETED.
> 
> s/big/bit/ ?
> 
> Yes, this could use mddev->flags.  I don't think atomic_inc_unless_zero
> would work, as an array can have a refcount of 0 but we still allow
> to take new references to it, the deletion only happens if the other
> conditions in mddev_put are met.
> 
> Do you want me to repin the series using a flag?

I would vote for it.

Cheers,

Hannes

