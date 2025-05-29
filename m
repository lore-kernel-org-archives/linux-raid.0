Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13927215F53;
	Thu, 29 May 2025 09:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748509412; cv=none; b=CpAmfqz66TxHATFjAZtWHgSJjCW6hPt/Ps5ZGuDvydl8QtlI1+TP6YBWXs2Qs0+bSXG9uVwW/kQc/UXFIxmNJchpZpzdujEZsNizOJVNrjEesY+LBNfT6q84ouJh5oy3F8l4xHlne0cklxwQPSmlE5TX2JBEJLf+mNCRy9owFbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748509412; c=relaxed/simple;
	bh=J7NxoBMtaTkBpaBj4y6PZe06UU2bm+m2zYAG/Bh2SAY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=P+e5khNrEkUaav3u0kcHxtgm48saOoPnpMHtdnRUUyMANwn3/aI15gjelDLc2VFc23Jk+hZMlr+ewfZ467iow5WWM0c/Z5zCuADMII1hSNM3gRQcLcQCR7xw8hbvta139IayMhmV1RZpTUzdLS/XB5cOXg31qvSd8juvwMfiA98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4b7L4G416gz4f3jJG;
	Thu, 29 May 2025 17:02:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DE4D71A0B0A;
	Thu, 29 May 2025 17:03:19 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDXOl_VIjho4gVzNw--.64257S3;
	Thu, 29 May 2025 17:03:19 +0800 (CST)
Subject: Re: [PATCH 18/23] md/md-llbitmap: implement APIs to mange bitmap
 lifetime
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-19-yukuai1@huaweicloud.com>
 <CALTww2-+0h2Pxq0PJLZQxcoYpMJuiKuv6CZQ3kgX5PeqBkxKsQ@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0f5b4641-cd4a-dccc-6f13-f2fa3221dee1@huaweicloud.com>
Date: Thu, 29 May 2025 17:03:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww2-+0h2Pxq0PJLZQxcoYpMJuiKuv6CZQ3kgX5PeqBkxKsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOl_VIjho4gVzNw--.64257S3
X-Coremail-Antispam: 1UD129KBjvJXoWfGF4fGw1xWw47Ar1DJw4fXwb_yoWDtF4rpF
	WxXFn8Ka13JryrXr17Xr97ZFWFqr4ktr9Fvr97Aa4rGr1qkrs3KryrGFyUG34kZr1rGF4k
	A3W5GrsxuF18WFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/29 15:03, Xiao Ni 写道:
> Hi Kuai
> 
> Is it better to put this patch before patch15. I'm reading patch15.
> But I need to read this patch first to understand how llbitmap is
> created and loaded. Then I can go to read the io related part.

Never mind, I'll merge patch 15-23 into one single patch in the next
version, it's better for review.

Thanks,
Kuai

> 
> Regards
> Xiao
> 
> On Sat, May 24, 2025 at 2:18 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Include following APIs:
>>   - llbitmap_create
>>   - llbitmap_resize
>>   - llbitmap_load
>>   - llbitmap_destroy
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/md-llbitmap.c | 322 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 322 insertions(+)
>>
>> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
>> index 4d5f9a139a25..23283c4f7263 100644
>> --- a/drivers/md/md-llbitmap.c
>> +++ b/drivers/md/md-llbitmap.c
>> @@ -689,4 +689,326 @@ static void llbitmap_resume(struct llbitmap *llbitmap, int page_idx)
>>          wake_up(&pctl->wait);
>>   }
>>
>> +static int llbitmap_check_support(struct mddev *mddev)
>> +{
>> +       if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
>> +               pr_notice("md/llbitmap: %s: array with journal cannot have bitmap\n",
>> +                         mdname(mddev));
>> +               return -EBUSY;
>> +       }
>> +
>> +       if (mddev->bitmap_info.space == 0) {
>> +               if (mddev->bitmap_info.default_space == 0) {
>> +                       pr_notice("md/llbitmap: %s: no space for bitmap\n",
>> +                                 mdname(mddev));
>> +                       return -ENOSPC;
>> +               }
>> +       }
>> +
>> +       if (!mddev->persistent) {
>> +               pr_notice("md/llbitmap: %s: array must be persistent\n",
>> +                         mdname(mddev));
>> +               return -EOPNOTSUPP;
>> +       }
>> +
>> +       if (mddev->bitmap_info.file) {
>> +               pr_notice("md/llbitmap: %s: doesn't support bitmap file\n",
>> +                         mdname(mddev));
>> +               return -EOPNOTSUPP;
>> +       }
>> +
>> +       if (mddev->bitmap_info.external) {
>> +               pr_notice("md/llbitmap: %s: doesn't support external metadata\n",
>> +                         mdname(mddev));
>> +               return -EOPNOTSUPP;
>> +       }
>> +
>> +       if (mddev_is_dm(mddev)) {
>> +               pr_notice("md/llbitmap: %s: doesn't support dm-raid\n",
>> +                         mdname(mddev));
>> +               return -EOPNOTSUPP;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int llbitmap_init(struct llbitmap *llbitmap)
>> +{
>> +       struct mddev *mddev = llbitmap->mddev;
>> +       sector_t blocks = mddev->resync_max_sectors;
>> +       unsigned long chunksize = MIN_CHUNK_SIZE;
>> +       unsigned long chunks = DIV_ROUND_UP(blocks, chunksize);
>> +       unsigned long space = mddev->bitmap_info.space << SECTOR_SHIFT;
>> +       int ret;
>> +
>> +       while (chunks > space) {
>> +               chunksize = chunksize << 1;
>> +               chunks = DIV_ROUND_UP(blocks, chunksize);
>> +       }
>> +
>> +       llbitmap->chunkshift = ffz(~chunksize);
>> +       llbitmap->chunksize = chunksize;
>> +       llbitmap->chunks = chunks;
>> +       mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
>> +
>> +       ret = llbitmap_cache_pages(llbitmap);
>> +       if (ret)
>> +               return ret;
>> +
>> +       llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1, BitmapActionInit);
>> +       return 0;
>> +}
>> +
>> +static int llbitmap_read_sb(struct llbitmap *llbitmap)
>> +{
>> +       struct mddev *mddev = llbitmap->mddev;
>> +       unsigned long daemon_sleep;
>> +       unsigned long chunksize;
>> +       unsigned long events;
>> +       struct page *sb_page;
>> +       bitmap_super_t *sb;
>> +       int ret = -EINVAL;
>> +
>> +       if (!mddev->bitmap_info.offset) {
>> +               pr_err("md/llbitmap: %s: no super block found", mdname(mddev));
>> +               return -EINVAL;
>> +       }
>> +
>> +       sb_page = llbitmap_read_page(llbitmap, 0);
>> +       if (IS_ERR(sb_page)) {
>> +               pr_err("md/llbitmap: %s: read super block failed",
>> +                      mdname(mddev));
>> +               ret = -EIO;
>> +               goto out;
>> +       }
>> +
>> +       sb = kmap_local_page(sb_page);
>> +       if (sb->magic != cpu_to_le32(BITMAP_MAGIC)) {
>> +               pr_err("md/llbitmap: %s: invalid super block magic number",
>> +                      mdname(mddev));
>> +               goto out_put_page;
>> +       }
>> +
>> +       if (sb->version != cpu_to_le32(BITMAP_MAJOR_LOCKLESS)) {
>> +               pr_err("md/llbitmap: %s: invalid super block version",
>> +                      mdname(mddev));
>> +               goto out_put_page;
>> +       }
>> +
>> +       if (memcmp(sb->uuid, mddev->uuid, 16)) {
>> +               pr_err("md/llbitmap: %s: bitmap superblock UUID mismatch\n",
>> +                      mdname(mddev));
>> +               goto out_put_page;
>> +       }
>> +
>> +       if (mddev->bitmap_info.space == 0) {
>> +               int room = le32_to_cpu(sb->sectors_reserved);
>> +
>> +               if (room)
>> +                       mddev->bitmap_info.space = room;
>> +               else
>> +                       mddev->bitmap_info.space = mddev->bitmap_info.default_space;
>> +       }
>> +       llbitmap->flags = le32_to_cpu(sb->state);
>> +       if (test_and_clear_bit(BITMAP_FIRST_USE, &llbitmap->flags)) {
>> +               ret = llbitmap_init(llbitmap);
>> +               goto out_put_page;
>> +       }
>> +
>> +       chunksize = le32_to_cpu(sb->chunksize);
>> +       if (!is_power_of_2(chunksize)) {
>> +               pr_err("md/llbitmap: %s: chunksize not a power of 2",
>> +                      mdname(mddev));
>> +               goto out_put_page;
>> +       }
>> +
>> +       if (chunksize < DIV_ROUND_UP(mddev->resync_max_sectors,
>> +                                    mddev->bitmap_info.space << SECTOR_SHIFT)) {
>> +               pr_err("md/llbitmap: %s: chunksize too small %lu < %llu / %lu",
>> +                      mdname(mddev), chunksize, mddev->resync_max_sectors,
>> +                      mddev->bitmap_info.space);
>> +               goto out_put_page;
>> +       }
>> +
>> +       daemon_sleep = le32_to_cpu(sb->daemon_sleep);
>> +       if (daemon_sleep < 1 || daemon_sleep > MAX_SCHEDULE_TIMEOUT / HZ) {
>> +               pr_err("md/llbitmap: %s: daemon sleep %lu period out of range",
>> +                      mdname(mddev), daemon_sleep);
>> +               goto out_put_page;
>> +       }
>> +
>> +       events = le64_to_cpu(sb->events);
>> +       if (events < mddev->events) {
>> +               pr_warn("md/llbitmap :%s: bitmap file is out of date (%lu < %llu) -- forcing full recovery",
>> +                       mdname(mddev), events, mddev->events);
>> +               set_bit(BITMAP_STALE, &llbitmap->flags);
>> +       }
>> +
>> +       sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
>> +       mddev->bitmap_info.chunksize = chunksize;
>> +       mddev->bitmap_info.daemon_sleep = daemon_sleep;
>> +
>> +       llbitmap->chunksize = chunksize;
>> +       llbitmap->chunks = DIV_ROUND_UP(mddev->resync_max_sectors, chunksize);
>> +       llbitmap->chunkshift = ffz(~chunksize);
>> +       ret = llbitmap_cache_pages(llbitmap);
>> +
>> +out_put_page:
>> +       __free_page(sb_page);
>> +out:
>> +       kunmap_local(sb);
>> +       return ret;
>> +}
>> +
>> +static void llbitmap_pending_timer_fn(struct timer_list *t)
>> +{
>> +       struct llbitmap *llbitmap = from_timer(llbitmap, t, pending_timer);
>> +
>> +       if (work_busy(&llbitmap->daemon_work)) {
>> +               pr_warn("daemon_work not finished\n");
>> +               set_bit(BITMAP_DAEMON_BUSY, &llbitmap->flags);
>> +               return;
>> +       }
>> +
>> +       queue_work(md_llbitmap_io_wq, &llbitmap->daemon_work);
>> +}
>> +
>> +static void md_llbitmap_daemon_fn(struct work_struct *work)
>> +{
>> +       struct llbitmap *llbitmap =
>> +               container_of(work, struct llbitmap, daemon_work);
>> +       unsigned long start;
>> +       unsigned long end;
>> +       bool restart;
>> +       int idx;
>> +
>> +       if (llbitmap->mddev->degraded)
>> +               return;
>> +
>> +retry:
>> +       start = 0;
>> +       end = min(llbitmap->chunks, PAGE_SIZE - BITMAP_SB_SIZE) - 1;
>> +       restart = false;
>> +
>> +       for (idx = 0; idx < llbitmap->nr_pages; idx++) {
>> +               struct llbitmap_page_ctl *pctl = llbitmap->pctl[idx];
>> +
>> +               if (idx > 0) {
>> +                       start = end + 1;
>> +                       end = min(end + PAGE_SIZE, llbitmap->chunks - 1);
>> +               }
>> +
>> +               if (!test_bit(LLPageFlush, &pctl->flags) &&
>> +                   time_before(jiffies, pctl->expire)) {
>> +                       restart = true;
>> +                       continue;
>> +               }
>> +
>> +               llbitmap_suspend(llbitmap, idx);
>> +               llbitmap_state_machine(llbitmap, start, end, BitmapActionDaemon);
>> +               llbitmap_resume(llbitmap, idx);
>> +       }
>> +
>> +       /*
>> +        * If the daemon took a long time to finish, retry to prevent missing
>> +        * clearing dirty bits.
>> +        */
>> +       if (test_and_clear_bit(BITMAP_DAEMON_BUSY, &llbitmap->flags))
>> +               goto retry;
>> +
>> +       /* If some page is dirty but not expired, setup timer again */
>> +       if (restart)
>> +               mod_timer(&llbitmap->pending_timer,
>> +                         jiffies + llbitmap->mddev->bitmap_info.daemon_sleep * HZ);
>> +}
>> +
>> +static int llbitmap_create(struct mddev *mddev)
>> +{
>> +       struct llbitmap *llbitmap;
>> +       int ret;
>> +
>> +       ret = llbitmap_check_support(mddev);
>> +       if (ret)
>> +               return ret;
>> +
>> +       llbitmap = kzalloc(sizeof(*llbitmap), GFP_KERNEL);
>> +       if (!llbitmap)
>> +               return -ENOMEM;
>> +
>> +       llbitmap->mddev = mddev;
>> +       llbitmap->io_size = bdev_logical_block_size(mddev->gendisk->part0);
>> +       llbitmap->bits_per_page = PAGE_SIZE / llbitmap->io_size;
>> +
>> +       timer_setup(&llbitmap->pending_timer, llbitmap_pending_timer_fn, 0);
>> +       INIT_WORK(&llbitmap->daemon_work, md_llbitmap_daemon_fn);
>> +       atomic_set(&llbitmap->behind_writes, 0);
>> +       init_waitqueue_head(&llbitmap->behind_wait);
>> +
>> +       mutex_lock(&mddev->bitmap_info.mutex);
>> +       mddev->bitmap = llbitmap;
>> +       ret = llbitmap_read_sb(llbitmap);
>> +       mutex_unlock(&mddev->bitmap_info.mutex);
>> +       if (ret)
>> +               goto err_out;
>> +
>> +       return 0;
>> +
>> +err_out:
>> +       kfree(llbitmap);
>> +       return ret;
>> +}
>> +
>> +static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
>> +{
>> +       struct llbitmap *llbitmap = mddev->bitmap;
>> +       unsigned long chunks;
>> +
>> +       if (chunksize == 0)
>> +               chunksize = llbitmap->chunksize;
>> +
>> +       /* If there is enough space, leave the chunksize unchanged. */
>> +       chunks = DIV_ROUND_UP(blocks, chunksize);
>> +       while (chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {
>> +               chunksize = chunksize << 1;
>> +               chunks = DIV_ROUND_UP(blocks, chunksize);
>> +       }
>> +
>> +       llbitmap->chunkshift = ffz(~chunksize);
>> +       llbitmap->chunksize = chunksize;
>> +       llbitmap->chunks = chunks;
>> +
>> +       return 0;
>> +}
>> +
>> +static int llbitmap_load(struct mddev *mddev)
>> +{
>> +       enum llbitmap_action action = BitmapActionReload;
>> +       struct llbitmap *llbitmap = mddev->bitmap;
>> +
>> +       if (test_and_clear_bit(BITMAP_STALE, &llbitmap->flags))
>> +               action = BitmapActionStale;
>> +
>> +       llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1, action);
>> +       return 0;
>> +}
>> +
>> +static void llbitmap_destroy(struct mddev *mddev)
>> +{
>> +       struct llbitmap *llbitmap = mddev->bitmap;
>> +
>> +       if (!llbitmap)
>> +               return;
>> +
>> +       mutex_lock(&mddev->bitmap_info.mutex);
>> +
>> +       timer_delete_sync(&llbitmap->pending_timer);
>> +       flush_workqueue(md_llbitmap_io_wq);
>> +       flush_workqueue(md_llbitmap_unplug_wq);
>> +
>> +       mddev->bitmap = NULL;
>> +       llbitmap_free_pages(llbitmap);
>> +       kfree(llbitmap);
>> +       mutex_unlock(&mddev->bitmap_info.mutex);
>> +}
>> +
>>   #endif /* CONFIG_MD_LLBITMAP */
>> --
>> 2.39.2
>>
> 
> 
> .
> 

