Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AE842188C;
	Tue, 20 Jan 2026 11:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768909765; cv=none; b=QASYhGZedvuR0v9zTbLHmetj1qCzy0ERWN++emtb94r+nvGPyTaNaj/YndtrNo+ZQkKXeFxKzZQXiieya1vpxRxgAJPPqBNXal+EKvrIeX9ueGfYy1Y0j6F85XsisSe6YaNZzLmXyymepkwEUF9qT+qtnFdGExGye2sbZzfaduo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768909765; c=relaxed/simple;
	bh=3TSYt8d9fuEyT+ChLWWV2AwpXslL6ddzkvubDYLjZNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qx/2TyAjIhJLMfddAL2w5f3Ac2tdX1w8m6qbNNMDs4xMZCnH6qtIS1d6HufXrhQvpayjZmBaJ14zBFh2uHRBUPBTZjqQMeyUFs2yL4SU5okTacZr71EZvAtLZh75E3EZmj8RIb9HI1kYSwrsrPMd4WMrcQ0Uaa9cPaO78JvOF3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dwQZ93jKMzKHLtd;
	Tue, 20 Jan 2026 19:48:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B7E944058A;
	Tue, 20 Jan 2026 19:49:18 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgCX+Pi9a29ph1XmEQ--.39303S3;
	Tue, 20 Jan 2026 19:49:18 +0800 (CST)
Message-ID: <2d00b70a-a947-9ded-76b3-c954432bdb06@huaweicloud.com>
Date: Tue, 20 Jan 2026 19:49:17 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 03/15] md: use folio for bb_folio
To: Xiao Ni <xni@redhat.com>, linan666@huaweicloud.com
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20251217120013.2616531-1-linan666@huaweicloud.com>
 <20251217120013.2616531-4-linan666@huaweicloud.com>
 <CALTww28tZDgBVy=G=doJQ3yfWtuiLk5QoMMyL1cmveacXHLynA@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CALTww28tZDgBVy=G=doJQ3yfWtuiLk5QoMMyL1cmveacXHLynA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCX+Pi9a29ph1XmEQ--.39303S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAw4kJF4ktF13CFW5Ww4DJwb_yoWrCr4rpa
	ykW3Z0yr15Xr1UXw17WFsYkasYv39xKr4UtrW3A3W3X3Z8tw1DKF1UtFW7ZFyDAF9xAF4I
	qr4UurZ8u3Z2grUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Cr0_Gr1UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUoAwIDUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/19 11:03, Xiao Ni 写道:
> On Wed, Dec 17, 2025 at 8:11 PM <linan666@huaweicloud.com> wrote:
>>
>> From: Li Nan <linan122@huawei.com>
>>
>> Convert bio_page to bio_folio and use it throughout.
>>
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>   drivers/md/md.h |  3 ++-
>>   drivers/md/md.c | 25 +++++++++++++------------
>>   2 files changed, 15 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 410f8a6b75e7..aa6d9df50fd0 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -144,7 +144,8 @@ struct md_rdev {
>>          struct block_device *bdev;      /* block device handle */
>>          struct file *bdev_file;         /* Handle from open for bdev */
>>
>> -       struct page     *sb_page, *bb_page;
>> +       struct page     *sb_page;
>> +       struct folio    *bb_folio;
>>          int             sb_loaded;
>>          __u64           sb_events;
>>          sector_t        data_offset;    /* start of data in array */
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 9dfd6f8da5b8..0732bbcdb95d 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -1073,9 +1073,9 @@ void md_rdev_clear(struct md_rdev *rdev)
>>                  rdev->sb_start = 0;
>>                  rdev->sectors = 0;
>>          }
>> -       if (rdev->bb_page) {
>> -               put_page(rdev->bb_page);
>> -               rdev->bb_page = NULL;
>> +       if (rdev->bb_folio) {
>> +               folio_put(rdev->bb_folio);
>> +               rdev->bb_folio = NULL;
>>          }
>>          badblocks_exit(&rdev->badblocks);
>>   }
>> @@ -1909,9 +1909,10 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
>>
>>          rdev->desc_nr = le32_to_cpu(sb->dev_number);
>>
>> -       if (!rdev->bb_page) {
>> -               rdev->bb_page = alloc_page(GFP_KERNEL);
>> -               if (!rdev->bb_page)
>> +       if (!rdev->bb_folio) {
>> +               rdev->bb_folio = folio_alloc(GFP_KERNEL, 0);
>> +
>> +               if (!rdev->bb_folio)
>>                          return -ENOMEM;
>>          }
>>          if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BAD_BLOCKS) &&
>> @@ -1930,10 +1931,10 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
>>                  if (offset == 0)
>>                          return -EINVAL;
>>                  bb_sector = (long long)offset;
>> -               if (!sync_page_io(rdev, bb_sector, sectors << 9,
>> -                                 rdev->bb_page, REQ_OP_READ, true))
>> +               if (!sync_folio_io(rdev, bb_sector, sectors << 9, 0,
>> +                                 rdev->bb_folio, REQ_OP_READ, true))
>>                          return -EIO;
>> -               bbp = (__le64 *)page_address(rdev->bb_page);
>> +               bbp = (__le64 *)folio_address(rdev->bb_folio);
>>                  rdev->badblocks.shift = sb->bblog_shift;
>>                  for (i = 0 ; i < (sectors << (9-3)) ; i++, bbp++) {
>>                          u64 bb = le64_to_cpu(*bbp);
>> @@ -2300,7 +2301,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
>>                  md_error(mddev, rdev);
>>          else {
>>                  struct badblocks *bb = &rdev->badblocks;
>> -               __le64 *bbp = (__le64 *)page_address(rdev->bb_page);
>> +               __le64 *bbp = (__le64 *)folio_address(rdev->bb_folio);
>>                  u64 *p = bb->page;
>>                  sb->feature_map |= cpu_to_le32(MD_FEATURE_BAD_BLOCKS);
>>                  if (bb->changed) {
>> @@ -2953,7 +2954,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
>>                                  md_write_metadata(mddev, rdev,
>>                                                    rdev->badblocks.sector,
>>                                                    rdev->badblocks.size << 9,
>> -                                                 rdev->bb_page, 0);
>> +                                                 folio_page(rdev->bb_folio, 0), 0);
>>                                  rdev->badblocks.size = 0;
>>                          }
>>
>> @@ -3809,7 +3810,7 @@ int md_rdev_init(struct md_rdev *rdev)
>>          rdev->sb_events = 0;
>>          rdev->last_read_error = 0;
>>          rdev->sb_loaded = 0;
>> -       rdev->bb_page = NULL;
>> +       rdev->bb_folio = NULL;
>>          atomic_set(&rdev->nr_pending, 0);
>>          atomic_set(&rdev->read_errors, 0);
>>          atomic_set(&rdev->corrected_errors, 0);
>> --
>> 2.39.2
>>
> 
> Hi Nan
> 
> Bad block page is only one single page. I don't think it's necessary
> to use folio here. And it uses folio_page to get the page again. Or do
> you plan to replace all page apis to folio apis? Looking through all
> patches, sync_page_io is not removed. In patch02, it says sync_page_io
> will be removed. So maybe it's better to switch bb_page to bb_folio in
> your second patch set? And this patch set only focuses on replacing
> sync pages with folio. It's my 2 cents point. If you think it's better
> to change the bad block page here, I'm still ok.
> 
> Best Regards
> Xiao
> 

Hi Xiao,

Thanks for your review. Move it to next patch set is fine. I will delete
this patch in v2.

-- 
Thanks,
Nan

