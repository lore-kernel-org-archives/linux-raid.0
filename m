Return-Path: <SRS0=c9Ba=EI=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08565C00A89
	for <linux-raid@archiver.kernel.org>; Mon,  2 Nov 2020 08:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95F0C2071E
	for <linux-raid@archiver.kernel.org>; Mon,  2 Nov 2020 08:02:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dq++Vap5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgKBICM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Nov 2020 03:02:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25092 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727802AbgKBICL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Nov 2020 03:02:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604304129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MAcCSziPSZLxQtchkW5FgE96MjPeBrhusgB4MKSuagU=;
        b=Dq++Vap5JApaQhYge8FxtPR6K8umWCSSmBGPGVrO7rMPFiKT/JpbNB4WqSldioxtMg5RmK
        7iEf65z2SugU5n/HX7V8cIVnqcFR9QLvYQ3olZZSXOXBwhDu/uiKMnQ6J7qbfvtNMgG33C
        FeCKvkAwg3o7uEHJdL+YIx/zek1S5aM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-VvGprGT4MWWzijxkfL_I7Q-1; Mon, 02 Nov 2020 03:02:07 -0500
X-MC-Unique: VvGprGT4MWWzijxkfL_I7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 571158015B1;
        Mon,  2 Nov 2020 08:02:06 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 793EA5B4D1;
        Mon,  2 Nov 2020 08:02:03 +0000 (UTC)
Subject: Re: [PATCH 2/3] md: align superblock writes to physical blocks
To:     Christopher Unkel <cunkel@drivescale.com>,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org
References: <20201029201358.29181-1-cunkel@drivescale.com>
 <20201029201358.29181-3-cunkel@drivescale.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <070b938f-472e-83b5-96ab-376a6e5fa6ec@redhat.com>
Date:   Mon, 2 Nov 2020 16:02:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20201029201358.29181-3-cunkel@drivescale.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 10/30/2020 04:13 AM, Christopher Unkel wrote:
> Writes of the md superblock are aligned to the logical blocks of the
> containing device, but no attempt is made to align them to physical
> block boundaries.  This means that on a "512e" device (4k physical, 512
> logical) every superblock update hits the 512-byte emulation and the
> possible associated performance penalty.
>
> Respect the physical block alignment when possible, that is, when the
> write padded out to the physical block doesn't run into the data or
> bitmap.
>
> Signed-off-by: Christopher Unkel <cunkel@drivescale.com>
> ---
> This series replaces the first patch of the previous series
> (https://lkml.org/lkml/2020/10/22/1058), with the following changes:
>
> 1. Creates a helper function super_1_sb_length_ok().
> 2. Fixes operator placement style violation.
> 3. Covers case in super_1_sync().
> 4. Refactors duplicate logic.
> 5. Covers a case in existing code where aligned superblock could
>     run into bitmap.
>
>   drivers/md/md.c | 45 +++++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 41 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d6a55ca1d52e..802a9a256fe5 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1646,15 +1646,52 @@ static __le32 calc_sb_1_csum(struct mdp_superblock_1 *sb)
>   	return cpu_to_le32(csum);
>   }
>   
> +static int
> +super_1_sb_length_ok(struct md_rdev *rdev, int minor_version, int sb_len)
> +{
> +	int sectors = sb_len / 512;
> +	struct mdp_superblock_1 *sb;
> +
> +	/* superblock is stored in memory as a single page */
> +	if (sb_len > PAGE_SIZE)
> +		return 0;
> +
> +	/* check if sb runs into data */
> +	if (minor_version) {
> +		if (rdev->sb_start + sectors > rdev->data_offset
> +		    || rdev->sb_start + sectors > rdev->new_data_offset)
> +			return 0;
> +	} else if (sb_len > 4096)
> +		return 0;
> +
> +	/* check if sb runs into bitmap */
> +	sb = page_address(rdev->sb_page);
> +	if (le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET) {
> +		__s32 bitmap_offset = (__s32)le32_to_cpu(sb->bitmap_offset);
> +		if (bitmap_offset > 0 && sectors > bitmap_offset)
> +			return 0;
> +	}
> +
> +	return 1;
> +}
> +
For super1.0 it doesn't need to consider this. Because the data and 
bitmap is before superblock.
For super1.1 and 1.2 it only needs to check whether it runs into bitmap. 
The data is behind the
bitmap.

Regards
Xiao
>   /*
>    * set rdev->sb_size to that required for number of devices in array
>    * with appropriate padding to underlying sectors
>    */
>   static void
> -super_1_set_rdev_sb_size(struct md_rdev *rdev, int max_dev)
> +super_1_set_rdev_sb_size(struct md_rdev *rdev, int max_dev, int minor_version)
>   {
>   	int sb_size = max_dev * 2 + 256;
> -	rdev->sb_size = round_up(sb_size, bdev_logical_block_size(rdev->bdev));
> +	int pb_aligned_size = round_up(sb_size,
> +				       bdev_physical_block_size(rdev->bdev));
> +
> +	/* generate physical-block aligned writes if legal */
> +	if (super_1_sb_length_ok(rdev, minor_version, pb_aligned_size))
> +		rdev->sb_size = pb_aligned_size;
> +	else
> +		rdev->sb_size = round_up(sb_size,
> +					 bdev_logical_block_size(rdev->bdev));
>   }
>   
>   static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_version)
> @@ -1730,7 +1767,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
>   		rdev->new_data_offset += (s32)le32_to_cpu(sb->new_offset);
>   	atomic_set(&rdev->corrected_errors, le32_to_cpu(sb->cnt_corrected_read));
>   
> -	super_1_set_rdev_sb_size(rdev, le32_to_cpu(sb->max_dev));
> +	super_1_set_rdev_sb_size(rdev, le32_to_cpu(sb->max_dev), minor_version);
>   
>   	if (minor_version
>   	    && rdev->data_offset < sb_start + (rdev->sb_size/512))
> @@ -2140,7 +2177,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
>   
>   	if (max_dev > le32_to_cpu(sb->max_dev)) {
>   		sb->max_dev = cpu_to_le32(max_dev);
> -		super_1_set_rdev_sb_size(rdev, max_dev);
> +		super_1_set_rdev_sb_size(rdev, max_dev, mddev->minor_version);
>   	} else
>   		max_dev = le32_to_cpu(sb->max_dev);
>   

