Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC104C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  1 Mar 2022 07:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbiCAHyi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Mar 2022 02:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbiCAHyi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Mar 2022 02:54:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BFC4A6E8D2
        for <linux-raid@vger.kernel.org>; Mon, 28 Feb 2022 23:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646121236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QVnFIZhFNYTKL1SBRvgDq8aonG+DvL7dUgSwlUWc5mM=;
        b=NJrsCuRO9cLD1bOvDX1ct4+yRVz1L9lej5HJ7eG7Kd+ENz3SeG2b9z1TKEaWgMSbCzR+jn
        NyIjuaE6L3vkulUYBedQ5qe/3Fi9+MAz2beq9F1i5N1syNldiPZORH6mB8y8+B2IUW4YsN
        5kO2jOQwKaTMFrNaUmyHVDuodbLQsbQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483--LcuxTIOP2agH7IEJislwQ-1; Tue, 01 Mar 2022 02:53:55 -0500
X-MC-Unique: -LcuxTIOP2agH7IEJislwQ-1
Received: by mail-ed1-f69.google.com with SMTP id b13-20020a056402278d00b0041311e02a9bso7245972ede.13
        for <linux-raid@vger.kernel.org>; Mon, 28 Feb 2022 23:53:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QVnFIZhFNYTKL1SBRvgDq8aonG+DvL7dUgSwlUWc5mM=;
        b=FJIHQSCS3vqkTQ0qjZ3mXqYPjiITRqdSr6ITy7FOtjhTRFc6P668DPuDMFhDO0xy2z
         a54ArXWQ3uPzdJBOMQ6PgE1Bxl52jLR//m5vghMRsXYBrdebztT11rCIS0vXqboS/552
         S3jyNGKrBcC4oEDuH3pGIK4bQIaMyL0Fm3+FB0R2Uj8au4kDtqUscSCA6UZEeZ2oY5IO
         9Dlins/9W6VX+t7gR3QBWGwu8lvEmOIfdenvCHPQfL/BiP3eB3i1L8S27b4Mwlm4IsHH
         gJQAUT1W6GgAu6veQxj19JKoRNcgbq03pc9uTdrh9/oq44gOvrbQozjLh+GTZDo20eIp
         rwbQ==
X-Gm-Message-State: AOAM5326rP3ndlBOMo9HoOnOL8J+8S6XJhjDUu2qqmR+47Am22pajn/g
        y9RCYHD+j6fytYkgnqeTXRrUHb7Vg8FAeaTLp+ynfccw+SlpXeU432Xy5YGNORWjnW/EPBUmhid
        v4ECOkrbBImyRlXfxHxFMdg==
X-Received: by 2002:a17:906:d935:b0:6cc:fcfc:c286 with SMTP id rn21-20020a170906d93500b006ccfcfcc286mr18098683ejb.423.1646121234054;
        Mon, 28 Feb 2022 23:53:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysts8BwR7kcT2eYdWIeAKaNDkPSFZ3Y7NmajZMDMKGdqDOlJPCJrK4VFsbK9YtcY5F4jFAyA==
X-Received: by 2002:a17:906:d935:b0:6cc:fcfc:c286 with SMTP id rn21-20020a170906d93500b006ccfcfcc286mr18098675ejb.423.1646121233798;
        Mon, 28 Feb 2022 23:53:53 -0800 (PST)
Received: from alatyr-rpi.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id c4-20020a170906340400b006d077e850b5sm5073999ejb.23.2022.02.28.23.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 23:53:53 -0800 (PST)
Date:   Tue, 1 Mar 2022 08:53:49 +0100
From:   Peter Rajnoha <prajnoha@redhat.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     Martin Wilck <mwilck@suse.com>, Jes Sorensen <jsorensen@fb.com>,
        lvm-devel@redhat.com, linux-raid <linux-raid@vger.kernel.org>,
        Coly Li <colyli@suse.com>, dm-devel@redhat.com,
        Heming Zhao <heming.zhao@suse.com>
Subject: Re: [dm-devel] [PATCH] udev-md-raid-assembly.rules: skip if
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
Message-ID: <20220301075349.ao7a2rbjqn627oq4@alatyr-rpi.brq.redhat.com>
References: <20220216205914.7575-1-mwilck@suse.com>
 <164504936873.10228.7361167610237544463@noble.neil.brown.name>
 <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
 <20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>
 <CALTww2-_rJDyVh2GLehJ8Yg9LOy4MnkvDeJnF2uunaOy6ONu7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALTww2-_rJDyVh2GLehJ8Yg9LOy4MnkvDeJnF2uunaOy6ONu7g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi!

On Mon 28 Feb 2022 23:28, Xiao Ni wrote:
> Hi Peter
> 
> In rhel, we have a rhel only udev rule that checks
> DM_UDEV_DISABLE_OTHER_RULES_FLAG. Maybe it's the reason why you don't
> notice this. Besides DM_UDEV_DISABLE_OTHER_RULES_FLAG, it still checks
> other flags.
> 

Ah yes, that's it! I've been still recalling this to be patched once.
So looks like it just didn't get propagated upstream :-/

> # Next make sure that this isn't a dm device we should skip for some reason
> ENV{DM_UDEV_RULES_VSN}!="?*", GOTO="dm_change_end"
> ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", GOTO="dm_change_end"
> ENV{DM_SUSPENDED}=="1", GOTO="dm_change_end"
> KERNEL=="dm-*", SUBSYSTEM=="block", ENV{ID_FS_TYPE}=="linux_raid_member", \
>         ACTION=="change", RUN+="/sbin/mdadm -I $env{DEVNAME}"
> LABEL="dm_change_end"
> 
> In 10-dm.rules, if DM_SUSPENDED is 1, it sets
> DM_UDEV_DISABLE_OTHER_RULES_FLAG to 1. So we don't need the check of
> DM_SUSPENDED. But how DM_UDEV_RULES_VSN? Do we need to check it?
> 

Yes, right, the check for DM_SUSPENDED is superfluous here so we don't
actually need that one. The single check for DM_UDEV_DISABLE_OTHER_RULES_FLAG
covers it.

The DM_UDEV_RULES_VSN - this was meant for future changes in case a new
set of DM udev variables is used or existing set changed so the other rules
know what exact variable set is available for checking. But I think the rules
are settled down for a few years now and I don't expect any more radical
changes here, so we can remove that check for DM_UDEV_RULES_VSN as well.

-- 
Peter

