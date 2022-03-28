Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F93C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 28 Mar 2022 00:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237121AbiC1Ap2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Mar 2022 20:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236727AbiC1Ap1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Mar 2022 20:45:27 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D121A824
        for <linux-raid@vger.kernel.org>; Sun, 27 Mar 2022 17:43:46 -0700 (PDT)
Subject: Re: [PATCH] md/bitmap: don't set sb values if can't pass sanity check
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648428224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ngYMjoZvzhBvYaQpw7ASUgBXdsOVe/wv6uX7t9mwEjY=;
        b=gsRWsiEZEXBMXLCyQgti8evxT79whi1GLR1OxX6oLROq2fBwO/UHHBRPF++YP8YTwha6sx
        ZseXK8OACBN+L2FW4cpPP3qd5iIHz5g8yOlglAME8+XXGE8X9GvD2R8JVjK0duWId433TL
        Y3V/z88SMo80+RWx3RmBooN38dzwKG8=
To:     Heming Zhao <heming.zhao@suse.com>, linux-raid@vger.kernel.org,
        song@kernel.org
Cc:     xni@redhat.com
References: <20220325025223.1866-1-heming.zhao@suse.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <cd198e0b-eebb-f13c-49e7-338aa6835099@linux.dev>
Date:   Mon, 28 Mar 2022 08:43:41 +0800
MIME-Version: 1.0
In-Reply-To: <20220325025223.1866-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 3/25/22 10:52 AM, Heming Zhao wrote:
> If bitmap area contains invalid data, kernel may crash or mdadm
> triggers FPE (Floating exception)
> This is cluster-md speical bug. In non-clustered env, mdadm will
> handle broken metadata case. In clustered array, only kernel space
> handles bitmap slot info. But even this bug only happened in clustered
> env, current sanity check is wrong, the code should be changed.
>
> How to trigger: (faulty injection)
>
> dd if=/dev/zero bs=1M count=3 oflag=direct of=/dev/sda
> dd if=/dev/zero bs=1M count=3 oflag=direct of=/dev/sdb
> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
> mdadm -Ss
> echo aaa > magic.txt
>   == below modifying slot 2 bitmap data ==
> dd if=magic.txt of=/dev/sda seek=16384 bs=1 count=3 <== destory magic
> dd if=/dev/zero of=/dev/sda seek=16436 bs=1 count=4 <== ZERO chunksize
> mdadm -A /dev/md0 /dev/sda /dev/sdb
>   == kernel crash. mdadm reports FPE ==

Thanks, could you also share the crash log to make people understand it
better?

>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>   drivers/md/md-bitmap.c | 40 +++++++++++++++++++++-------------------
>   1 file changed, 21 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index bfd6026d7809..f6dcdb3683bf 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -635,19 +635,6 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>   	err = -EINVAL;
>   	sb = kmap_atomic(sb_page);
>   
> -	chunksize = le32_to_cpu(sb->chunksize);
> -	daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
> -	write_behind = le32_to_cpu(sb->write_behind);
> -	sectors_reserved = le32_to_cpu(sb->sectors_reserved);
> -	/* Setup nodes/clustername only if bitmap version is
> -	 * cluster-compatible
> -	 */
> -	if (sb->version == cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
> -		nodes = le32_to_cpu(sb->nodes);
> -		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
> -				sb->cluster_name, 64);
> -	}
> -
>   	/* verify that the bitmap-specific fields are valid */
>   	if (sb->magic != cpu_to_le32(BITMAP_MAGIC))
>   		reason = "bad magic";
> @@ -668,6 +655,19 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>   		goto out;
>   	}
>   
> +	chunksize = le32_to_cpu(sb->chunksize);
> +	daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
> +	write_behind = le32_to_cpu(sb->write_behind);
> +	sectors_reserved = le32_to_cpu(sb->sectors_reserved);
> +	/* Setup nodes/clustername only if bitmap version is
> +	 * cluster-compatible
> +	 */

I suppose kernel should print the "reason" if md failed to verify bitmap sb.
And at it, pls change the comment style to

/*
  *
  */

> +	if (sb->version == cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
> +		nodes = le32_to_cpu(sb->nodes);
> +		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
> +				sb->cluster_name, 64);
> +	}
> +
>   	/* keep the array size field of the bitmap superblock up to date */
>   	sb->sync_size = cpu_to_le64(bitmap->mddev->resync_max_sectors);
>   
> @@ -700,9 +700,9 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>   
>   out:
>   	kunmap_atomic(sb);
> -	/* Assigning chunksize is required for "re_read" */
> -	bitmap->mddev->bitmap_info.chunksize = chunksize;
>   	if (err == 0 && nodes && (bitmap->cluster_slot < 0)) {
> +		/* Assigning chunksize is required for "re_read" */
> +		bitmap->mddev->bitmap_info.chunksize = chunksize;
>   		err = md_setup_cluster(bitmap->mddev, nodes);
>   		if (err) {
>   			pr_warn("%s: Could not setup cluster service (%d)\n",
> @@ -717,10 +717,12 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>   out_no_sb:
>   	if (test_bit(BITMAP_STALE, &bitmap->flags))
>   		bitmap->events_cleared = bitmap->mddev->events;
> -	bitmap->mddev->bitmap_info.chunksize = chunksize;
> -	bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
> -	bitmap->mddev->bitmap_info.max_write_behind = write_behind;
> -	bitmap->mddev->bitmap_info.nodes = nodes;
> +	if (err == 0) {
> +		bitmap->mddev->bitmap_info.chunksize = chunksize;
> +		bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
> +		bitmap->mddev->bitmap_info.max_write_behind = write_behind;
> +		bitmap->mddev->bitmap_info.nodes = nodes;
> +	}
>   	if (bitmap->mddev->bitmap_info.space == 0 ||
>   	    bitmap->mddev->bitmap_info.space > sectors_reserved)
>   		bitmap->mddev->bitmap_info.space = sectors_reserved;

Generally, I am fine with the change.

Thanks,
Guoqing
