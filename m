Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0588AC433DB
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 08:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B727064F44
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 08:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhBDIlQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 03:41:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26548 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234897AbhBDIlP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Feb 2021 03:41:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612427988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=malPoafG7M6l+V7ySxytLK5NZSFFDnhjTvb2bGP/0U4=;
        b=AfbMh0spZSwKuE+euCPXrbtlXesScRBAEDSrS2Fb8amFRTZcsO/3wjq6mGR5HiACV76Rbw
        gb+9p2Vor2zyt3IxGSXEnsTq+6498idTQaQWTTQzDKcRgDVPwmK6/y2oq+igOiFioaWt+t
        +gb7Lf4b3h+hmlAALVpypFi/nP67Hvc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-_vMzg4ykPSOp6EHMiMxrPA-1; Thu, 04 Feb 2021 03:39:44 -0500
X-MC-Unique: _vMzg4ykPSOp6EHMiMxrPA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D3691934101;
        Thu,  4 Feb 2021 08:39:43 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA00560C13;
        Thu,  4 Feb 2021 08:39:39 +0000 (UTC)
Subject: Re: [PATCH V2 0/5] md/raid10: Improve handling raid10 discard request
To:     Song Liu <song@kernel.org>
Cc:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        Coly Li <colyli@suse.de>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Nigel Croxon <ncroxon@redhat.com>, hch@infradead.org
References: <1612418238-9976-1-git-send-email-xni@redhat.com>
 <6359e6e0-4e50-912c-1f97-ae07db3eba70@redhat.com>
 <CAPhsuW6paostmNby1sHTPYM+2mmz_wxKBTw7e1G6tGFtema7Ow@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <3b95c7ad-f400-0a60-7f7a-6bc3e49967f8@redhat.com>
Date:   Thu, 4 Feb 2021 16:39:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6paostmNby1sHTPYM+2mmz_wxKBTw7e1G6tGFtema7Ow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 02/04/2021 04:12 PM, Song Liu wrote:
> On Wed, Feb 3, 2021 at 11:42 PM Xiao Ni <xni@redhat.com> wrote:
>> Hi Song
>>
>> Please ignore the v2 version. There is a place that needs to be fix.
>> I'll re-send
>> v2 version again.
> What did you change in the new v2? Removing "extern" in the header?
> For small changes like this, I can just update it while applying the patches.
> If we do need resend (for bigger changes), it's better to call it v3.

Yes, it only removes "extern" in patch1.
>
> I was testing the first v2 in the past hour or so, it looks good in the test.
> I will take a closer look tomorrow. On the other hand, we are getting close
> to the 5.12 merge window, so it is a little too late for bigger
> changes like this.
> Therefore, I would prefer to wait until 5.13. If you need it in 5.12 for some
> reason, please let me know.
Is md-next a branch that is used before merging? If so, could you merge 
the patches
to md-next if your test pass? There is a bug that needs to be fixed in 
rhel. We can
backport the patches if you merge the patches to md-next.

Regards
Xiao

