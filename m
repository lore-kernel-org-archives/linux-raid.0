Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC23C43217
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 12:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiDFMtV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Apr 2022 08:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbiDFMs2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Apr 2022 08:48:28 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA444AF792
        for <linux-raid@vger.kernel.org>; Wed,  6 Apr 2022 01:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649235167; x=1680771167;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LFM3dJ4XtmmQmpjm/ADKwYliPf/iPacGMSt9/3x5IFU=;
  b=XGoZ3KXIIrsDIMcOoWqqR0SHeTPS58YN9x1TRczbSLRjhTWlf+z2O7S1
   YoA5DDuACiEzD290t1D3DhpRfFd64oxfd1i4lMOpKq3N7cVvcJNchMeO0
   G/A/pl6Jve7mH3dJ2rH/GB0IbtgA90Ddy/dRP/EXnPlnPHuCZrcNHJ72A
   yBpuvcwvggSOKMqhvvPqn0ASUrAtQgaMMrZ3h1FvijoYmxx8liIAertQ1
   IJvQKK43OxZdxmZ03VrNr5+TzylN4yWebT4S4bD3ETlZvjV+/HFtV/G1g
   fGVWv0tR0u9HgY+o9+t6zmr2hN4IAfH94qfbExS9dELIDtex0r1iFL2SO
   g==;
X-IronPort-AV: E=Sophos;i="5.90,239,1643644800"; 
   d="scan'208";a="196092193"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Apr 2022 16:52:44 +0800
IronPort-SDR: ZOKxJRoa1OAkY5m4rcu5/pyBd74z1ZswtJZL/8vTFa9J6mudLXeWf3WHymsSgW22auNmXVNJM1
 pGg3N3WfIEn5Z3fDqRR0PYRTFGZG6tjukL0XJe1YD/9hTMseQ6XgNtuqJKAxR2j3L5ldmtvK0g
 tHKgQtSBko/gC3o0dJpUW7/yv/fZ98iJsLObvTTgKctHq+jVO5WCoaLCX37TjW7hht9JNHh496
 B3oG8gOfwzv1LjUhcF2/mRgraPR/jmp2K35JfG4LdJhwH+9iVzYdVVZk3pdELmZbzNyK4BLl6Q
 aLLUavQenrexEevsal1QXYlR
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Apr 2022 01:24:15 -0700
IronPort-SDR: jITeR+RSH8yKZDLvbId/mbLiK+rIotUHFx0TdcTUjV24KPEeM3hI/B8RwTHK+TRuio5vxQWqbb
 z5DSVBf63ufw8y1ssRoBxUjAJsNOqhp4exYDT2aXHGOrft5Ed/tW5r16DAGcg+wIQR1d2MmEvP
 Po3LoqUI24U1N0kZf1QxGQYiebw6Hh/J0xfksslANcIm+0fbUJYxMPgY9FiWmNcbnd5cffSRq8
 bkUeNeSqYXrgEr4+9BMPVQiKjLYD4FiRs+MAi61bWGs3fCJ8sAd0ViquUHtcLuUJbJMjrESG2Y
 osg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Apr 2022 01:52:43 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KYJDp1R5yz1SVp2
        for <linux-raid@vger.kernel.org>; Wed,  6 Apr 2022 01:52:42 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649235160; x=1651827161; bh=LFM3dJ4XtmmQmpjm/ADKwYliPf/iPacGMSt
        9/3x5IFU=; b=FzUociJ5h7WAQTsg6/of1WcVO/OsM8WZr8TGwq4XsiCjPsWYnIG
        8/w+gKZQabfM5/6lPmJQreKk5Ou6wFCFKuKzU34LNEBfiEEQgQdKgaFRiQjCbS+v
        bXmYOK12GNp/Ja0XBlu9I1309M6iplipC0iSH4zUASq/4DY1Z1ntJWZZ2gnz7v04
        gr+tHwiyI12IKqfvshI8zep4+bgj/F03PH6lDam0sCy+54uxyIAUOpes7fa1mbqW
        oKbTS+GZl8C4hDtpg8QtlcOVicbeOAAs2w8xnnXnZGy/42U80yMH8z7K4uMfNY4W
        C4OWYxx5B6+JAZVIxV0TMfw3Lljnnr2SA9w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oWToNcY4lYkp for <linux-raid@vger.kernel.org>;
        Wed,  6 Apr 2022 01:52:40 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KYJDg4WyPz1Rvlx;
        Wed,  6 Apr 2022 01:52:35 -0700 (PDT)
Message-ID: <ea3d14cb-00ea-8d7b-4615-9347fdd7aa27@opensource.wdc.com>
Date:   Wed, 6 Apr 2022 17:52:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 14/27] block: add a bdev_max_zone_append_sectors helper
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        nbd@other.debian.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-15-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220406060516.409838-15-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/6/22 15:05, Christoph Hellwig wrote:
> Add a helper to check the max supported sectors for zone append based on
> the block_device instead of having to poke into the block layer internal
> request_queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/nvme/target/zns.c | 3 +--
>   fs/zonefs/super.c         | 3 +--
>   include/linux/blkdev.h    | 6 ++++++
>   3 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
> index e34718b095504..82b61acf7a72b 100644
> --- a/drivers/nvme/target/zns.c
> +++ b/drivers/nvme/target/zns.c
> @@ -34,8 +34,7 @@ static int validate_conv_zones_cb(struct blk_zone *z,
>   
>   bool nvmet_bdev_zns_enable(struct nvmet_ns *ns)
>   {
> -	struct request_queue *q = ns->bdev->bd_disk->queue;
> -	u8 zasl = nvmet_zasl(queue_max_zone_append_sectors(q));
> +	u8 zasl = nvmet_zasl(bdev_max_zone_append_sectors(ns->bdev));
>   	struct gendisk *bd_disk = ns->bdev->bd_disk;
>   	int ret;
>   
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 3614c7834007d..7a63807b736c4 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -678,13 +678,12 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
>   	struct inode *inode = file_inode(iocb->ki_filp);
>   	struct zonefs_inode_info *zi = ZONEFS_I(inode);
>   	struct block_device *bdev = inode->i_sb->s_bdev;
> -	unsigned int max;
> +	unsigned int max = bdev_max_zone_append_sectors(bdev);
>   	struct bio *bio;
>   	ssize_t size;
>   	int nr_pages;
>   	ssize_t ret;
>   
> -	max = queue_max_zone_append_sectors(bdev_get_queue(bdev));
>   	max = ALIGN_DOWN(max << SECTOR_SHIFT, inode->i_sb->s_blocksize);
>   	iov_iter_truncate(from, max);
>   
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index a433798c3343e..f8c50b77543eb 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1188,6 +1188,12 @@ static inline unsigned int queue_max_zone_append_sectors(const struct request_qu
>   	return min(l->max_zone_append_sectors, l->max_sectors);
>   }
>   
> +static inline unsigned int
> +bdev_max_zone_append_sectors(struct block_device *bdev)
> +{
> +	return queue_max_zone_append_sectors(bdev_get_queue(bdev));
> +}
> +
>   static inline unsigned queue_logical_block_size(const struct request_queue *q)
>   {
>   	int retval = 512;

Looks good.

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
