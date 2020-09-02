Return-Path: <SRS0=XO6g=CL=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 924B9C433E2
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 12:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69DB02078B
	for <linux-raid@archiver.kernel.org>; Wed,  2 Sep 2020 12:04:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ENnPKf5N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIBMEy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Sep 2020 08:04:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25416 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726269AbgIBMEw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Sep 2020 08:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599048291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IHG16AcB4vwtlJ3ozcJKeMziOSccOOHJT4jKvx5+32I=;
        b=ENnPKf5NcqtkZBm1JuzJn2Cc0qnx6ERudqif545dSHawMW7npT0iKlmJ+PCOkSaMdl93z1
        QLLhrgKwOBgKJzBBxeddFeCw+P0ZSw3eaTozjntZ6Dcs3JnIJC/gfRbC2E/LmbwhkBCpJe
        XX6d8AZLYC7FuCEVZYM9n9MM/wRvrq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-hGZ1qrdzM06ZpCiCuAcAfA-1; Wed, 02 Sep 2020 08:04:49 -0400
X-MC-Unique: hGZ1qrdzM06ZpCiCuAcAfA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8370010082F9;
        Wed,  2 Sep 2020 12:04:47 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE76278B3C;
        Wed,  2 Sep 2020 12:04:43 +0000 (UTC)
Subject: Re: [PATCH V6 0/3] md/raid10: Improve handling raid10 discard request
From:   Xiao Ni <xni@redhat.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     heinzm@redhat.com, ncroxon@redhat.com,
        guoqing.jiang@cloud.ionos.com, colyli@suse.de
References: <1599048023-9957-1-git-send-email-xni@redhat.com>
Message-ID: <0211630b-d005-cd8c-7bf6-15fd378be5b0@redhat.com>
Date:   Wed, 2 Sep 2020 20:04:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <1599048023-9957-1-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song

I did test with reshape, it still has problems. So I remove discard 
support for reshape in this patch set.
I'll add reshape support once all problems are fixed.

Regards
Xiao

On 09/02/2020 08:00 PM, Xiao Ni wrote:
> Hi all
>
> Now mkfs on raid10 which is combined with ssd/nvme disks takes a long time.
> This patch set tries to resolve this problem.
>
> v1:
> Coly helps to review these patches and give some suggestions:
> One bug is found. If discard bio is across one stripe but bio size is
> bigger than one stripe size. After spliting, the bio will be NULL.
> In this version, it checks whether discard bio size is bigger than
> (2*stripe_size).
> In raid10_end_discard_request, it's better to check R10BIO_Uptodate
> is set or not. It can avoid write memory to improve performance.
> Add more comments for calculating addresses.
>
> v2:
> Fix error by checkpatch.pl
> Fix one bug for offset layout. v1 calculates wrongly split size
> Add more comments to explain how the discard range of each component disk
> is decided.
>
> v3:
> add support for far layout
> Change the patch name
>
> v4:
> Pull codes that wait for blocked device into a seprate function
> It can't use (stripe_size-1) as a mask to calculate. (stripe_size-1) may
> not be power of 2.
> It doesn't need to use a full copy of geo.
> Fix warning by checkpatch.pl
>
> v5:
> In 32bit platform, it doesn't support 64bit devide by 32bit value.
> Reported-by: kernel test robot <lkp@intel.com>
>
> v6:
> Move the codes that calculate discard start/size into specific raid type.
> Remove discard support for reshape
>
> Xiao Ni (3):
>    md: calculate discard start address and size in specific raid type
>    md/raid10: improve raid10 discard request
>    md/raid10: improve discard request for far layout
>
>   drivers/md/md.c     |   9 +-
>   drivers/md/md.h     |   3 +-
>   drivers/md/raid0.c  |   5 +-
>   drivers/md/raid10.c | 296 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>   drivers/md/raid10.h |   1 +
>   5 files changed, 303 insertions(+), 11 deletions(-)
>

