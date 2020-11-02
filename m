Return-Path: <SRS0=c9Ba=EI=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F233C00A89
	for <linux-raid@archiver.kernel.org>; Mon,  2 Nov 2020 07:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0925421556
	for <linux-raid@archiver.kernel.org>; Mon,  2 Nov 2020 07:43:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hpyfpP8V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgKBHnK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Nov 2020 02:43:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727689AbgKBHnK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Nov 2020 02:43:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604302987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qWIfKd9ZiQU29ZqGSlOhjKSzRATAwUeg5+eE8ZDGiys=;
        b=hpyfpP8V8KrkEISRYKU7SIeS+DeTVM5nYQjS3JTflyM90shX0SSNxwR6EP/PqMVAG52bW5
        iuLCot+xMCeSawa7dO7SGLr5fcxVPQ0XaGS6u+KdZiNvAyCGmeYnQToH4wWeeJbwrUfpoQ
        mLgy65zO2coU4D9pwop0dI3TSlLJaqA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-N2pcUwMWNBSe0q4XT1NJLg-1; Mon, 02 Nov 2020 02:43:05 -0500
X-MC-Unique: N2pcUwMWNBSe0q4XT1NJLg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 034C71018F80;
        Mon,  2 Nov 2020 07:43:04 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AA305B4AF;
        Mon,  2 Nov 2020 07:43:01 +0000 (UTC)
Subject: Re: [PATCH v2 0/3] md superblock write alignment on 512e devices
To:     Christopher Unkel <cunkel@drivescale.com>,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org
References: <20201029201358.29181-1-cunkel@drivescale.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <265efd48-b0c6-cba5-c77e-5efb0e6b9e00@redhat.com>
Date:   Mon, 2 Nov 2020 15:42:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20201029201358.29181-1-cunkel@drivescale.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 10/30/2020 04:13 AM, Christopher Unkel wrote:
> Hello,
>
> Thanks for the feedback on the previous patch series.
>
> A updated patch series with the same function as the first patch
> (https://lkml.org/lkml/2020/10/22/1058 "md: align superblock writes to
> physical blocks") follows.
>
> As suggested, it introduces a helper function, which can be used to
> reduce some code duplication.  It handles the case in super_1_sync()
> where the superblock is extended by the addition of new component
> devices.
>
> I think it also fixes a bug where the existing code in super_1_load()
> ought to be rejecting the array with EINVAL: if the superblock padded
> out to the *logical* block length runs into the bitmap.  For example, if
> the bitmap offset is 2 (bitmap 1K after superblock) and the logical
> block size is 4K, the superblock padded out to 4K runs into the bitmap.
> This case may be unusual (perhaps only happens if the array is created
> on a 512n device and then raw contents are copied onto a 4kn device) but
> I think it is possible.
Hi Chris
For super1.1 and super1.2 bitmap offset is 8. It's a fixed value. So it 
should
not have the risk?

But for future maybe it has this problem. If the disk logical or 
physical block size
is larger than 4K in future, it has data corruption risk.
>
> With respect to the option of simply replacing
> queue_logical_block_size() with queue_physical_block_size(), I think
> this can result in the code rejecting devices that can be loaded, but
In mdadm it defines the max super size of super1 is 4096
#define MAX_SB_SIZE 4096
/* bitmap super size is 256, but we round up to a sector for alignment */
#define BM_SUPER_SIZE 512
#define MAX_DEVS ((int)(MAX_SB_SIZE - sizeof(struct mdp_superblock_1)) / 2)
#define SUPER1_SIZE     (MAX_SB_SIZE + BM_SUPER_SIZE \
                          + sizeof(struct misc_dev_info))

It should be ok to replace queue_logical_block_size with 
queue_physical_block_size?
Now it doesn't check physical block size and super block size. For 
super1, we can add
a check that if physical block size is larger than MAX_SB_SIZE, then we 
reject to create/assmble
the raid device.
> for which the physical block alignment can't be respected--the longer
> padded size would trigger the EINVAL cases testing against
> data_offset/new_data_offset.  I think it's better to proceed in such
> cases, just with unaligned superblock writes as would presently happen.
> Also if I'm right about the above bug, then I think this subsitution
> would be more likely to trigger it.
>
> Thanks,
>
>    --Chris
>
>
> Christopher Unkel (3):
>    md: factor out repeated sb alignment logic
>    md: align superblock writes to physical blocks
>    md: reuse sb length-checking logic
>
>   drivers/md/md.c | 69 +++++++++++++++++++++++++++++++++++++------------
>   1 file changed, 52 insertions(+), 17 deletions(-)
>

