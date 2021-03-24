Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F202C433C1
	for <linux-raid@archiver.kernel.org>; Wed, 24 Mar 2021 08:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE9F5619F6
	for <linux-raid@archiver.kernel.org>; Wed, 24 Mar 2021 08:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbhCXICv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Mar 2021 04:02:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33364 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231189AbhCXICj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 24 Mar 2021 04:02:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616572958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0/so4huTcA9FRHLqhIFFFdJTaRkry5Q0P3lSXxtypu8=;
        b=bdZb5UDwPUodP49Ew1E1jJx6TOvsGSHy5DgZ6KoUK3WLPkn/p0wtb+5he/wbDNTKdzvbz3
        f2CD79rFuuw1dC18Fan7Gd106yT1Jso5nqHN075xBEI2hQAhV+eXvVV09np53aO2b+mc4n
        wMumKvH6QUGiwuHI9XwKjJF88Rj9DaA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-b1mDMzlWNVOt3lUKxvBhiw-1; Wed, 24 Mar 2021 04:02:33 -0400
X-MC-Unique: b1mDMzlWNVOt3lUKxvBhiw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71CBA5B368;
        Wed, 24 Mar 2021 08:02:32 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-33.pek2.redhat.com [10.72.8.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B21629AD7;
        Wed, 24 Mar 2021 08:02:28 +0000 (UTC)
Subject: Re: raid5 crash on system which PAGE_SIZE is 64KB
To:     Yufen Yu <yuyufen@huawei.com>, Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        kent.overstreet@gmail.com
References: <225718c0-475c-7bd7-e067-778f7097a923@redhat.com>
 <cdb11ed6-646e-85e6-79f7-cbf38c92b324@huawei.com>
 <CAPhsuW5hV_-0+hcoK4b18h8gP6yy8UffV=wRQKtoCZbfXVu6fw@mail.gmail.com>
 <de820ff9-4ae7-2f83-d8c6-58a78322b2a7@huawei.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <aeeabec0-d030-0d90-ff90-0ac13365b728@redhat.com>
Date:   Wed, 24 Mar 2021 16:02:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <de820ff9-4ae7-2f83-d8c6-58a78322b2a7@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>
>
> I can also reproduce this problem on my qemu vm system, with 3 10G disks.
> But, there is no problem when I change mkfs.xfs option 'agcount' (default
> value is 16 for my system). For example, if I set agcount=15, there is no
> problem when mount xfs, likely:
>
> mkfs.xfs -d agcount=15 -f /dev/md0
> mount /dev/md0 /mnt/test

Hi Yufen

I did test with agcount=15, this problem exists too in my environment.

Test1:
[root@ibm-p8-11 ~]# mdadm -CR /dev/md0 -l5 -n3 /dev/sd[b-d]1 --size=20G
[root@ibm-p8-11 ~]# mkfs.xfs /dev/md0 -f
meta-data=/dev/md0               isize=512    agcount=16, agsize=655232 blks
...
[root@ibm-p8-11 ~]# mount /dev/md0 /mnt/test
mount: /mnt/test: mount(2) system call failed: Structure needs cleaning.

Test2:
[root@ibm-p8-11 ~]# mkfs.xfs /dev/md0 -f -d agcount=15
Warning: AG size is a multiple of stripe width.  This can cause performance
problems by aligning all AGs on the same disk.  To avoid this, run mkfs with
an AG size that is one stripe unit smaller or larger, for example 699008.
meta-data=/dev/md0               isize=512    agcount=15, agsize=699136 blks
...
[root@ibm-p8-11 ~]# mount /dev/md0 /mnt/test
mount: /mnt/test: mount(2) system call failed: Structure needs cleaning.


>
> In addition, I try to write a 128MB file to /dev/md0 and then read it out
> during md resync, they are same by checking md5sum, likely:
>
> dd if=randfile of=/dev/md0 bs=1M count=128 oflag=direct seek=10240
> dd if=/dev/md0 of=out.randfile bs=1M count=128 oflag=direct skip=10240
>
> BTW, I found mkfs.xfs have some options related to raid device, such as
> sunit, su, swidth, sw. I guess this problem may be caused by data 
> alignment.
> But, I have no idea how it happen. More time may needed.

The problem doesn't happen if mkfs without resync. Is there a 
possibility that resync and mkfs
write to the same page?

Regards
Xiao

