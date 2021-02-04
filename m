Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871E8C433E0
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 07:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3747F64F48
	for <linux-raid@archiver.kernel.org>; Thu,  4 Feb 2021 07:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbhBDHjk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Feb 2021 02:39:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234606AbhBDHjj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Feb 2021 02:39:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612424292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b5nAi1E/7m1zmPMnNvOz86pZaDvwzoNsiNuPeeFTdMU=;
        b=aDrejd/wlJbZQpoN56zKnJmR+mg/y7cb8loBkGo8wxqcoQ71McqoFBM7XBqSg8FCadvzOD
        rYrGDzGWsMdm79g8QMc+yOcyClMcmVaHf6rr6HLZq3WiFbJQqVstsg+QCpzJy9TsZusbZP
        LHzpjD8iSm8nuZnStLTb+T4TqfpkHlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-7UWOX88yOdOnhdcb52Ym-Q-1; Thu, 04 Feb 2021 02:38:08 -0500
X-MC-Unique: 7UWOX88yOdOnhdcb52Ym-Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 236F31934100;
        Thu,  4 Feb 2021 07:38:07 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C14B210013DB;
        Thu,  4 Feb 2021 07:38:03 +0000 (UTC)
Subject: Re: [PATCH V2 0/5] md/raid10: Improve handling raid10 discard request
From:   Xiao Ni <xni@redhat.com>
To:     songliubraving@fb.com
Cc:     linux-raid@vger.kernel.org, matthew.ruffell@canonical.com,
        colyli@suse.de, guoqing.jiang@cloud.ionos.com, ncroxon@redhat.com,
        hch@infradead.org
References: <1612418238-9976-1-git-send-email-xni@redhat.com>
Message-ID: <6359e6e0-4e50-912c-1f97-ae07db3eba70@redhat.com>
Date:   Thu, 4 Feb 2021 15:38:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <1612418238-9976-1-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song

Please ignore the v2 version. There is a place that needs to be fix. 
I'll re-send
v2 version again.

Regards
Xiao

On 02/04/2021 01:57 PM, Xiao Ni wrote:
> Hi all
>
> Now mkfs on raid10 which is combined with ssd/nvme disks takes a long time.
> This patch set tries to resolve this problem.
>
> This patch set had been reverted because of a data corruption problem. This
> version fix this problem. The root cause which causes the data corruption is
> the wrong calculation of start address of near copies disks.
>
> Now we use a similar way with raid0 to handle discard request for raid10.
> Because the discard region is very big, we can calculate the start/end
> address for each disk. Then we can submit the discard request to each disk.
> But for raid10, it has copies. For near layout, if the discard request
> doesn't align with chunk size, we calculate a start_disk_offset. Now we only
> use start_disk_offset for the first disk, but it should be used for the
> near copies disks too.
>
> [  789.709501] discard bio start : 70968, size : 191176
> [  789.709507] first stripe index 69, start disk index 0, start disk offset 70968
> [  789.709509] last stripe index 256, end disk index 0, end disk offset 262144
> [  789.709511] disk 0, dev start : 70968, dev end : 262144
> [  789.709515] disk 1, dev start : 70656, dev end : 262144
>
> For example, in this test case, it has 2 near copies. The start_disk_offset
> for the first disk is 70968. It should use the same offset address for second disk.
> But it uses the start address of this chunk. It discard more region. This version
> simply spilt the un-aligned part with strip size.
>
> And it fixes another problem. The calculation of stripe_size is wrong in reverted version.
>
> V2: Fix problems pointed by Christoph Hellwig.
>
> Xiao Ni (5):
>    md: add md_submit_discard_bio() for submitting discard bio
>    md/raid10: extend r10bio devs to raid disks
>    md/raid10: pull the code that wait for blocked dev into one function
>    md/raid10: improve raid10 discard request
>    md/raid10: improve discard request for far layout
>
>   drivers/md/md.c     |  20 +++
>   drivers/md/md.h     |   2 +
>   drivers/md/raid0.c  |  14 +-
>   drivers/md/raid10.c | 434 +++++++++++++++++++++++++++++++++++++++++++++-------
>   drivers/md/raid10.h |   1 +
>   5 files changed, 402 insertions(+), 69 deletions(-)
>

