Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9240C433DB
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 07:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BBF064F41
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 07:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbhBDHjX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 02:39:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234566AbhBDHjX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Feb 2021 02:39:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612424267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x+b7qvX1u42Gd5bYrXzuwpMzhpZDwNGm5Etu0QQQ4s8=;
        b=EktEcDy+EmxVl8ndS7UkZkLVGajZtPD9YIf1VgIP7M15wzie/IUQt8fdCMWL4IYy6HaJ0c
        J4xIHnGTGTPQwez+wyJ01zFM6Zzj+7sah35wLKfjO9B+fQUO9qs+/ixybmgu4gLLSAE5zY
        c1mO2VrZ7gqPGGqqJeT+3Ld4/8V4DSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-R0rhvTj6Pwu_MWrabIKENQ-1; Thu, 04 Feb 2021 02:37:43 -0500
X-MC-Unique: R0rhvTj6Pwu_MWrabIKENQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49428801962;
        Thu,  4 Feb 2021 07:37:42 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCE215D9C0;
        Thu,  4 Feb 2021 07:37:37 +0000 (UTC)
Subject: Re: [PATCH 1/5] md: add md_submit_discard_bio() for submitting
 discard bio
To:     Christoph Hellwig <hch@infradead.org>
Cc:     songliubraving@fb.com, linux-raid@vger.kernel.org,
        matthew.ruffell@canonical.com, colyli@suse.de,
        guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com
References: <1612359931-24209-1-git-send-email-xni@redhat.com>
 <1612359931-24209-2-git-send-email-xni@redhat.com>
 <20210203154425.GA4078626@infradead.org>
 <f2b663fd-349b-56b4-5b9b-3103184dbdda@redhat.com>
 <20210204071916.GA123308@infradead.org>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <52ed5df2-26c9-6959-17e8-90a28572804b@redhat.com>
Date:   Thu, 4 Feb 2021 15:37:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20210204071916.GA123308@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 02/04/2021 03:19 PM, Christoph Hellwig wrote:
> On Thu, Feb 04, 2021 at 12:07:58PM +0800, Xiao Ni wrote:
>>>> +extern void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>>>> +			struct bio *bio, sector_t start, sector_t size);
>>> no need for the extern.
>>>
>> Hi Christoph
>>
>> It needs to export it here. If not, there is compile error.
>>
>> raid0.c:502:3: error: implicit declaration of function
>> ???md_submit_discard_bio??? [-Werror=implicit-function-declaration]
>>     md_submit_discard_bio(mddev, rdev, bio,
> Yes, the prototype needs to be in the header.  But the extern keyword
> is no needed for function declarations.
>
Thanks for pointing about this.

