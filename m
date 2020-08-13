Return-Path: <SRS0=qvga=BX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C540C433E1
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 08:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37E3420771
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 08:16:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wdj/zlUT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgHMIQk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Aug 2020 04:16:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37103 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726072AbgHMIQk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 13 Aug 2020 04:16:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597306599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vffrQdWzJ8OUQBjEbJtjcvHFLgmLAjUX4G4prDw/48Y=;
        b=Wdj/zlUT1vbaQrr699MyXE6YPWs3aH9N0hOPs+GIMDePiIwL+tAWs+t6zugy55ljmkkFe4
        A6t+zgkCbXkXbnur04sBYsGow7twf8VIUnu3rRPV8pLS8m1RsgILByhtbj6NBNbe4omfUW
        XHumWpkswtqe2QjcouPVhL4x8Rpk9WM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-AtvWx9GQO2ecG5Nis5pZFQ-1; Thu, 13 Aug 2020 04:16:35 -0400
X-MC-Unique: AtvWx9GQO2ecG5Nis5pZFQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4737580183C;
        Thu, 13 Aug 2020 08:16:34 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1776600D4;
        Thu, 13 Aug 2020 08:16:31 +0000 (UTC)
Subject: Re: [md PATCH V3 0/4] Improve handling raid10 discard request
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org, linux-raid@vger.kernel.org
Cc:     colyli@suse.de, guoqing.jiang@cloud.ionos.com, heinzm@redhat.com,
        ncroxon@redhat.com
References: <1597301087-6565-1-git-send-email-xni@redhat.com>
Message-ID: <32428975-556f-3d46-76b5-16de5cefb0e4@redhat.com>
Date:   Thu, 13 Aug 2020 16:16:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <1597301087-6565-1-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

Sorry, please ignore this version. I changed the name of these patches 
and re-sent them just now.

Regards
Xiao

On 08/13/2020 02:44 PM, Xiao Ni wrote:
> Hi all
>
> Now mkfs on raid10 which is combined with ssd/nvme disks takes a long time.
> This patch set tries to resolve this problem.
>
> v1:
> Coly helps to review these patches and give some suggestions:
> One bug is found. If discard bio is across one stripe but bio size is bigger
> than one stripe size. After spliting, the bio will be NULL. In this version,
> it checks whether discard bio size is bigger than 2*stripe_size.
> In raid10_end_discard_request, it's better to check R10BIO_Uptodate is set
> or not. It can avoid write memory to improve performance.
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
>
> Xiao Ni (4):
>    Move codes related with submitting discard bio into one function
>    extend r10bio devs to raid disks
>    improve raid10 discard request
>    Improve discard request for far layout
>
>   drivers/md/md.c     |  23 ++++
>   drivers/md/md.h     |   3 +
>   drivers/md/raid0.c  |  15 +--
>   drivers/md/raid10.c | 338 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>   drivers/md/raid10.h |   1 +
>   5 files changed, 361 insertions(+), 19 deletions(-)
>

