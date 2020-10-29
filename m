Return-Path: <SRS0=2a2u=EE=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D75C4363A
	for <linux-raid@archiver.kernel.org>; Thu, 29 Oct 2020 17:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D00320790
	for <linux-raid@archiver.kernel.org>; Thu, 29 Oct 2020 17:03:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YkDewNg2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgJ2RDm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Oct 2020 13:03:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725792AbgJ2RDl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 29 Oct 2020 13:03:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603991020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CG1fKRPVSdrGSp+7rK/M6F5hjq72k8gDNl1r/YhUOgg=;
        b=YkDewNg2GdGl5GIOOzdvOfNB5z5+NKeZSgRnqV5jz8u9fiRlaz2mjQK9HZ/O/I8M+I0Ys0
        kzvJzhUbmpfqj8kPVXN51Z17QMEjA74sKHSUr8jhoRnFK+q8XqfTjmiLciAWzG/D2HH2Cu
        B4gAOHc9/gugw29uNQ2ev0MKzGUVNf0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-Ip7AN7eBPIiH7fZgCqHpnA-1; Thu, 29 Oct 2020 13:03:34 -0400
X-MC-Unique: Ip7AN7eBPIiH7fZgCqHpnA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9C5A18C89C1;
        Thu, 29 Oct 2020 17:03:32 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-36.pek2.redhat.com [10.72.8.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42FB85DA2A;
        Thu, 29 Oct 2020 17:03:29 +0000 (UTC)
Subject: Re: [PATCH] mdadm/bitmap: fix wrong bitmap nodes num when adding new
 disk
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>,
        linux-raid@vger.kernel.org, jes@trained-monkey.org,
        guoqing.jiang@cloud.ionos.com
References: <1603552027-10655-1-git-send-email-heming.zhao@suse.com>
 <75940d7d-3933-a026-d878-d75aa0050905@redhat.com>
 <8f39db60-635e-f187-f134-da6fdf3b83a5@suse.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <325ed7c0-c133-a502-5212-dba32b32f2f8@redhat.com>
Date:   Fri, 30 Oct 2020 01:03:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <8f39db60-635e-f187-f134-da6fdf3b83a5@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Heming

I can reproduce this bug myself. It indeed writes the wrong cluster 
nodes to the new disk.
So the original subject is good for me. Thanks for the explanation.

Regards
Xiao

On 10/28/2020 08:37 PM, heming.zhao@suse.com wrote:
> Hello Xiao,
>
> Thank you for your comment.
> The patch code is right, but the patch subject need modification.
>
> The bug only generate one bitmap area in clustered env.
> So the more suitable subject: fixing wrong bitmap area number when adding new disk in clustered env
>
> Do you feel better for it?
>
> On 10/28/20 1:51 PM, Xiao Ni wrote:
>> Hi Heming
>>
>> In fact it's not a wrong cluster nodes. This patch only avoids to do the job that doesn't
>> need to do, right? The cluster nodes don't change when adding a new disk. Even NodeNumUpdate
>> is specified, it'll not change the cluster nodes. If so, the subject is a little confusing.
>>
>> Regards
>> Xiao
>>
>> On 10/24/2020 11:07 PM, Zhao Heming wrote:
>>> The bug introduced from commit 81306e021ebdcc4baef866da82d25c3f0a415d2d
>>> In this patch, it modified two place to support NodeNumUpdate:
>>>    Grow_addbitmap, write_init_super1
>>>
>>> The path write_init_super1 is wrong.
>>>
>>> reproducible steps:
>>> ```
>>> node1 # mdadm -S --scan
>>> node1 # for i in {a,b,c};do dd if=/dev/zero of=/dev/sd$i bs=1M count=10;
>>> done
>>> ... ...
>>> node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
>>> /dev/sdb
>>> mdadm: array /dev/md0 started.
>>> node1 # mdadm --manage --add /dev/md0 /dev/sdc
>>> mdadm: added /dev/sdc
>>> node1 # mdadm --grow --raid-devices=3 /dev/md0
>>> raid_disks for /dev/md0 set to 3
>>> node1 # mdadm -X /dev/sdc
>>>           Filename : /dev/sdc
>>>              Magic : 6d746962
>>>            Version : 5
>>>               UUID : 9b0ff8c8:2a274a64:088ade6e:a88286a3
>>>          Chunksize : 64 MB
>>>             Daemon : 5s flush period
>>>         Write Mode : Normal
>>>          Sync Size : 306176 (299.00 MiB 313.52 MB)
>>>      Cluster nodes : 4
>>>       Cluster name : tb-ha-tst
>>>          Node Slot : 0
>>>             Events : 44
>>>     Events Cleared : 0
>>>              State : OK
>>>             Bitmap : 5 bits (chunks), 0 dirty (0.0%)
>>> mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corrupted
>>>          Node Slot : 1
>>>             Events : 0
>>>     Events Cleared : 0
>>>              State : OK
>>>             Bitmap : 0 bits (chunks), 0 dirty (0.0%)
>>> ```
>>>
>>> There are three paths to call write_bitmap:
>>>    Assemble, Grow, write_init_super.
>>>
>>> 1. Assemble & Grow should concern NodeNumUpdate
>>>
>>> Grow: Grow_addbitmap => write_bitmap
>>> trigger steps:
>>> ```
>>> node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
>>> /dev/sdb
>>> node1 # mdadm -G /dev/md0 -b none
>>> node1 # mdadm -G /dev/md0 -b clustered
>>> ```
>>>
>>> Assemble: Assemble => load_devices => write_bitmap1
>>> trigger steps:
>>> ```
>>> node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
>>> /dev/sdb
>>> node2 # mdadm -A /dev/md0 /dev/sda /dev/sdb --update=nodes --nodes=5
>>> ```
>>>
>>> 2. write_init_super should use NoUpdate.
>>>
>>> write_init_super is called by Create & Manage path.
>>>
>>> Create: Create => write_init_super => write_bitmap
>>> This is initialization, it doesn't need to care node changing.
>>> trigger step:
>>> ```
>>> node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
>>> /dev/sdb
>>> ```
>>>
>>> Manage: Manage_subdevs => Manage_add => write_init_super => write_bitmap
>>> This is disk add, not node add. So it doesn't need to care node
>>> changing.
>>> trigger steps:
>>> ```
>>> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
>>> mdadm --manage --add /dev/md0 /dev/sdc
>>> ```
>>>
>>> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
>>> ---
>>>    super1.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/super1.c b/super1.c
>>> index 8b0d6ff..06fa3ad 100644
>>> --- a/super1.c
>>> +++ b/super1.c
>>> @@ -2093,7 +2093,7 @@ static int write_init_super1(struct supertype *st)
>>>            if (rv == 0 &&
>>>                (__le32_to_cpu(sb->feature_map) &
>>>                 MD_FEATURE_BITMAP_OFFSET)) {
>>> -            rv = st->ss->write_bitmap(st, di->fd, NodeNumUpdate);
>>> +            rv = st->ss->write_bitmap(st, di->fd, NoUpdate);
>>>            } else if (rv == 0 &&
>>>                md_feature_any_ppl_on(sb->feature_map)) {
>>>                struct mdinfo info;

