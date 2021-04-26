Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7155FC43460
	for <linux-raid@archiver.kernel.org>; Mon, 26 Apr 2021 10:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CDA061178
	for <linux-raid@archiver.kernel.org>; Mon, 26 Apr 2021 10:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhDZKVX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 26 Apr 2021 06:21:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232194AbhDZKVU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 26 Apr 2021 06:21:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619432437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xLrMZfmZvY5e76TMJ77QhR7CBznM+aRPXnn9xSszgXg=;
        b=CmW8W8dSokch+AruKWUsuJtXiaSGeRWeAW5xbYtiOlYjFfTRdAeYuXXya1wAwLrSOjWYSu
        8gdQSAPdbSJfQ72scnk8PGvGzJR1mRQJHv2NFDUuIy+/awQeP8/gTuFqcwWyQXRA8oqgxN
        2NH8ZkX+0xUELNAh5F3L9sysxthFt0o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-3sJW-dDMOYGYRvJNg593wA-1; Mon, 26 Apr 2021 06:20:33 -0400
X-MC-Unique: 3sJW-dDMOYGYRvJNg593wA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6244F8030BB;
        Mon, 26 Apr 2021 10:20:32 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64BEB60BE5;
        Mon, 26 Apr 2021 10:20:29 +0000 (UTC)
Subject: Re: [PATCH 1/1] async_xor: It should add src_offs when dropping
 destination page
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Yufen Yu <yuyufen@huawei.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>
References: <1619342577-6034-1-git-send-email-xni@redhat.com>
 <CAPhsuW4UskVrBPqEdTTZuTvWztoUtNk6tb06_9ZMR+pzbLgh-w@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <a33a2bb2-1d42-9b6b-d91c-843115ac1b4e@redhat.com>
Date:   Mon, 26 Apr 2021 18:20:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW4UskVrBPqEdTTZuTvWztoUtNk6tb06_9ZMR+pzbLgh-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 04/26/2021 02:32 PM, Song Liu wrote:
> On Sun, Apr 25, 2021 at 2:23 AM Xiao Ni <xni@redhat.com> wrote:
>> Now we support sharing one page if PAGE_SIZE is not equal stripe size. To support this,
>> it needs to support calculating xor value with different offsets for each r5dev. One
>> offset array is used to record those offsets.
>>
>> In RMW mode, parity page is used as a source page. It sets ASYNC_TX_XOR_DROP_DST before
>> calculating xor value in ops_run_prexor5. So it needs to add src_list and src_offs at
>> the same time. Now it only needs src_list. So the xor value which is calculated is wrong.
>> It can cause data corruption problem.
>>
>> I can reproduce this problem 100% on a POWER8 machine. The steps are:
>> mdadm -CR /dev/md0 -l5 -n3 /dev/sdb1 /dev/sdc1 /dev/sdd1 --size=3G
>> mkfs.xfs /dev/md0
>> mount /dev/md0 /mnt/test
>> mount: /mnt/test: mount(2) system call failed: Structure needs cleaning.
>>
> Thanks for the fix! Applied to md-next.
>
> A few nits for future patches:
>
>> Fixes: 29bcff787 ("md/raid5: add new xor function to support different page offset")
> Please use "Fixes" with the first 12 characters of the hash: 29bcff787a25.
>
> Also please run checkpatch.pl for the patch. In this one, it complains:
>
> WARNING: Possible unwrapped commit description (prefer a maximum 75
> chars per line)
>
> Thanks,
> Song

Thanks for reminding me. I'll do this next time.

Regards
Xiao

