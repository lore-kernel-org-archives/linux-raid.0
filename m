Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F44FC433E1
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 22:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75CDC20674
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 22:39:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d1hBgOf5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgHTWj1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 18:39:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56894 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728139AbgHTWj0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 18:39:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597963164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rjoahkzc/vi1bsLcN2+Op3yiKCeqAb0kmTq/h24W9HY=;
        b=d1hBgOf59Yk9b4TNb8ny0bY7av6xDT+PM0DkykfoXNFHX9B18XdIud/clMhQ9KAHNvdbG7
        gRujeK+1DDRBi7sgblTspowo12E4gbA+Th0wK/sJe/+FT2nT7d2VawERa5QsIUa9rhkTzI
        nnTf9ueVsCAHtET4X8zoHIHSSl02DNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-Po3UIw-0NiahiAbcJiyybQ-1; Thu, 20 Aug 2020 18:39:22 -0400
X-MC-Unique: Po3UIw-0NiahiAbcJiyybQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 581ED1006708;
        Thu, 20 Aug 2020 22:39:21 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B21B5E1DE;
        Thu, 20 Aug 2020 22:39:18 +0000 (UTC)
Subject: Re: [PATCH V3 3/4] md/raid10: improve raid10 discard request
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>, Coly Li <colyli@suse.de>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
References: <1597306476-8396-1-git-send-email-xni@redhat.com>
 <1597306476-8396-4-git-send-email-xni@redhat.com>
 <CAPhsuW4sa8PBC8sn4u+9SBMEHkinoAr2jRss1bSsvV+WQ+yPuA@mail.gmail.com>
 <21012936-9397-40f9-115b-87dda93d9017@redhat.com>
 <CAPhsuW6fuhEL60Wnjr5O33+pX0Bo+xS9xVHSan6VXE6YfR-U-A@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <afca977d-40bd-ae88-58df-69d094643a63@redhat.com>
Date:   Fri, 21 Aug 2020 06:39:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6fuhEL60Wnjr5O33+pX0Bo+xS9xVHSan6VXE6YfR-U-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 08/21/2020 06:13 AM, Song Liu wrote:
> On Thu, Aug 20, 2020 at 12:22 AM Xiao Ni <xni@redhat.com> wrote:
> [...]
>
>> +
>> +       if (conf->reshape_progress != MaxSector &&
>> +           ((bio->bi_iter.bi_sector >= conf->reshape_progress) !=
>> +            conf->mddev->reshape_backwards))
>> +               geo = conf->prev;
>> +
>> +       stripe_size = (1<<geo.chunk_shift) * geo.raid_disks;
>>
>> This could be raid_disks << chunk_shift
>>
>> +       stripe_mask = stripe_size - 1;
>>
>> Does this work when raid_disks is not power of 2?
>>
>> In test I used 5 disks to create the raid10 too, it worked well. Could you explain what
>> you worried in detail?
> Say we have geo.raid_disks == 5, and geo.chunk_shift == 8. Then we get
> stripe_size == 0x500 and stripe_mask == 0x4ff == b'100 1111 1111
> Is this the proper stripe_mask?
>
> Thanks,
> Song
>
I got it. Thanks very much. It can't use mask here to justify whether 
start/end address is aligned
with stripe size. It should check whether it's a multiple of stripe 
size. I'll send patch again after
fixing all problems.

Regards
Xiao

