Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD5EC433DB
	for <linux-raid@archiver.kernel.org>; Sat, 20 Feb 2021 08:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3602064EDE
	for <linux-raid@archiver.kernel.org>; Sat, 20 Feb 2021 08:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBTIOI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 20 Feb 2021 03:14:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29651 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229667AbhBTIOG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 20 Feb 2021 03:14:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613808759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dNulLozu70boJlRZGryS2JuyuZzhM40X9hZstF5MHAM=;
        b=e8gh3opSopRnYZsNIcIZunHbtjA+8/DqS7TSCi00Xt5SsvgfqUdawd9jNBe3jqm603QnaC
        ySR+0YBp5KOt1iVXnmFhHXqQhb+QhuPZnIf2MdZm+EsYCIOI5LPmaFueLBYAHeT6cgmA3g
        4Ykp1onijmP7BckFJYOwlMsrizMMUuU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-0lNROqlQOpq3f6hGMMgIkQ-1; Sat, 20 Feb 2021 03:12:36 -0500
X-MC-Unique: 0lNROqlQOpq3f6hGMMgIkQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC151801965;
        Sat, 20 Feb 2021 08:12:34 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-39.pek2.redhat.com [10.72.8.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B12EE5C8B3;
        Sat, 20 Feb 2021 08:12:31 +0000 (UTC)
Subject: Re: [PATCH V2 0/5] md/raid10: Improve handling raid10 discard request
To:     Matthew Ruffell <matthew.ruffell@canonical.com>,
        songliubraving@fb.com
Cc:     linux-raid@vger.kernel.org, colyli@suse.de,
        guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com
References: <1612425047-10953-1-git-send-email-xni@redhat.com>
 <d86c7211-787f-ee34-d2c1-cf780ecd9322@canonical.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <75ba722d-f11e-ebe5-5507-b0c380c203e9@redhat.com>
Date:   Sat, 20 Feb 2021 16:12:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <d86c7211-787f-ee34-d2c1-cf780ecd9322@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Matthew

Thanks very much for those test. And as you said, it's better to wait 
more test results.
By the way, do you know the date of 5.13 merge window?

Regards
Xiao

On 02/15/2021 12:05 PM, Matthew Ruffell wrote:
> Hi Xiao,
>
> Thanks for posting the patchset. I have been testing them over the past week,
> and they are looking good.
>
> I backported [0] the patchset to the Ubuntu 4.15, 5.4 and 5.8 kernels, and I have
> been testing them on public clouds.
>
> [0] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1896578/comments/13
>
> For performance, formatting a Raid10 array on NVMe disks drops from 8.5 minutes
> to about 6 seconds [1], on AWS i3.8xlarge with 4x 1.7TB disks, due to the
> speedup in block discard.
>
> [1] https://paste.ubuntu.com/p/NNGqP3xdsc/
>
> I have also tested the data corruption reproducer from my original problem
> report [2], and I have found that throughout each of the steps of formatting the
> array, doing a consistency check, writing data, doing a consistency check,
> issuing a fstrim, doing a consistency check, the /sys/block/md0/md/mismatch_cnt
> was always 0, and all deep fsck checks came back clean for individual disks [3].
>
> [2] https://www.spinics.net/lists/kernel/msg3765302.html
> [3] https://paste.ubuntu.com/p/5DK57TzdFH/
>
> So I think your patches do solve the data corruption problem. Great job.
>
> To try and get some more eyes on the patches, I have provided my test kernels to
> 5 other users who are hitting the Raid10 block discard performance problem, and
> I have asked them to test on spare test servers, and to provide feedback on
> performance and data safety.
>
> I will let you know their feedback as it comes in.
>
> As for getting this merged, I actually agree with Song, the 5.12 merge window
> is happening right now, and it is a bit too soon for large changes like this.
> I think we should wait for the 5.13 merge window. That way we can do some more
> testing, get feedback from some users, and make sure we don't cause any more
> data corruption regressions.
>
> I will write back soon with some user feedback and more test results.
>
> Thanks,
> Matthew
>

