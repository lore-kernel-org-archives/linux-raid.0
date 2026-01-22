Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13DB36AB44;
	Thu, 22 Jan 2026 02:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769047938; cv=none; b=Tdh+JzcBWpbXrOQa3hgQtm73xjSoHwZlugkx7U9M+0LHo6aTzpyvFpO7wnmDAlp1Ijc97u4eupm3pV7clyEXU7FvSVLFo6ODE2nfPPjNJarlDExfmyHvt9kAEHkesvdvse4jgusBxMaZMnmoJ8hpmO98qKyW549JTj54Ef8q1B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769047938; c=relaxed/simple;
	bh=swin7wg16VLIwRzf0hszZDFQ0Ea0561DkZqyhch89K0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qo73+O/f07o4hADjlDcCc5XgYxyIgMDOl5eQTLvVTDy/rgVR/Y6t0Fse0HB4sG4a+foqTDgTpu8wONeA+Dc9BrvcKK9JTPyvOvGi+LMSNMX+u6s+6vgSv7PMCKPIrtFpm4ucFYSqQ1fuXEigzQPBZAwF3K4kj7YUyCkn7nxn5Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dxPgt6qXHzYQtvm;
	Thu, 22 Jan 2026 10:11:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6494740590;
	Thu, 22 Jan 2026 10:12:05 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgBHp_dzh3FpmD6nEg--.65200S3;
	Thu, 22 Jan 2026 10:12:05 +0800 (CST)
Message-ID: <a0423bf6-c924-0012-172b-1217069ff3ec@huaweicloud.com>
Date: Thu, 22 Jan 2026 10:12:03 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 06/15] md/raid1,raid10: use folio for sync path IO
To: Xiao Ni <xni@redhat.com>, linan666@huaweicloud.com
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20251217120013.2616531-1-linan666@huaweicloud.com>
 <20251217120013.2616531-7-linan666@huaweicloud.com>
 <CALTww28w8EJL2TVs06f_h98SjkiGAiYD9+BUvqEG2HKsrssSsg@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CALTww28w8EJL2TVs06f_h98SjkiGAiYD9+BUvqEG2HKsrssSsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHp_dzh3FpmD6nEg--.65200S3
X-Coremail-Antispam: 1UD129KBjvJXoW3XryfJF17Gw15WF1Duw1fXrb_yoW3KF18pF
	W8GFn5tFW5XFWruFs2qF4kCF1Fkry5JrWUtF43Wa43Z3Z5Kr9akF18Ww45WF1UCF97Cay0
	vF40yw45uFs5tFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9K14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUY3kuUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/20 23:53, Xiao Ni 写道:
> On Wed, Dec 17, 2025 at 8:11 PM <linan666@huaweicloud.com> wrote:
>>
>> From: Li Nan <linan122@huawei.com>
>>
>> Convert all IO on the sync path to use folios. Rename page-related
>> identifiers to match folio.
>>
>> Retain some now-unnecessary while and for loops to minimize code
>> changes, clean them up in a subsequent patch.
>>
>> Signed-off-by: Li Nan <linan122@huawei.com >> -static inline int resync_alloc_pages(struct resync_pages *rp,
>> +static inline int resync_alloc_folio(struct resync_folio *rf,
>>                                       gfp_t gfp_flags)
>>   {
>> -       int i;
>> -
>> -       for (i = 0; i < RESYNC_PAGES; i++) {
>> -               rp->pages[i] = alloc_page(gfp_flags);
>> -               if (!rp->pages[i])
>> -                       goto out_free;
>> -       }
>> +       rf->folio = folio_alloc(gfp_flags, get_order(RESYNC_BLOCK_SIZE));
>> +       if (!rf->folio)
>> +               return -ENOMEM;
> 
> Is it ok to add an error log here? Compare with the multipage
> situation, the possibility of failure will be somewhat higher because
> it needs to alloc a contiguous block of physical memory.
> 

Hi, Xiao

Thanks for your review.

In patch 15 we fall back to a smaller order if sync folio alloc fails.
After that the alloc usually succeeds, so an error log seems noisy. Should
I add a log before the fallback and keep it in patch 15?

>> -static void md_bio_reset_resync_pages(struct bio *bio, struct resync_pages *rp,
>> +static void md_bio_reset_resync_folio(struct bio *bio, struct resync_folio *rf,
>>                                 int size)
>>   {
>> -       int idx = 0;
>> -
>>          /* initialize bvec table again */
>>          do {
>> -               struct page *page = resync_fetch_page(rp, idx);
>> -               int len = min_t(int, size, PAGE_SIZE);
>> +               struct folio *folio = resync_fetch_folio(rf);
>> +               int len = min_t(int, size, RESYNC_BLOCK_SIZE);
>>
>> -               if (WARN_ON(!bio_add_page(bio, page, len, 0))) {
>> +               if (WARN_ON(!bio_add_folio(bio, folio, len, 0))) {
> 
> Is it ok to use bio_add_folio(bio, folio, RESYNC_BLOCK_SIZE, 0)
> directly here? It removes `size -= len` below, so it's not useless to
> compare size and RESYNC_BLOCK_SIZE above?
> 

Same as the previous one, the size is no longer a fixed value after
patch 15. I think keeping it here gives better compatibility.

>>          /*
>> -        * Allocate RESYNC_PAGES data pages and attach them to
>> -        * the first bio.
>> +        * Allocate data folio and attach them to the first bio.
> 
> typo error
> s/attach them/attach it/g
> 

I will fix it later. Thanks.

>> @@ -2284,44 +2278,30 @@ static void process_checks(struct r1bio *r1_bio)
>>                  }
>>          r1_bio->read_disk = primary;
>>          for (i = 0; i < conf->raid_disks * 2; i++) {
>> -               int j = 0;
>>                  struct bio *pbio = r1_bio->bios[primary];
>>                  struct bio *sbio = r1_bio->bios[i];
>>                  blk_status_t status = sbio->bi_status;
>> -               struct page **ppages = get_resync_pages(pbio)->pages;
>> -               struct page **spages = get_resync_pages(sbio)->pages;
>> -               struct bio_vec *bi;
>> -               int page_len[RESYNC_PAGES] = { 0 };
>> -               struct bvec_iter_all iter_all;
>> +               struct folio *pfolio = get_resync_folio(pbio)->folio;
>> +               struct folio *sfolio = get_resync_folio(sbio)->folio;
>>
>>                  if (sbio->bi_end_io != end_sync_read)
>>                          continue;
>>                  /* Now we can 'fixup' the error value */
>>                  sbio->bi_status = 0;
>>
>> -               bio_for_each_segment_all(bi, sbio, iter_all)
>> -                       page_len[j++] = bi->bv_len;
>> -
>> -               if (!status) {
>> -                       for (j = vcnt; j-- ; ) {
>> -                               if (memcmp(page_address(ppages[j]),
>> -                                          page_address(spages[j]),
>> -                                          page_len[j]))
>> -                                       break;
>> -                       }
>> -               } else
>> -                       j = 0;
>> -               if (j >= 0)
>> +               if (status || memcmp(folio_address(pfolio),
>> +                                    folio_address(sfolio),
>> +                                    r1_bio->sectors << 9)) {
>>                          atomic64_add(r1_bio->sectors, &mddev->resync_mismatches);
>> -               if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
>> -                             && !status)) {
>> -                       /* No need to write to this device. */
>> -                       sbio->bi_end_io = NULL;
>> -                       rdev_dec_pending(conf->mirrors[i].rdev, mddev);
>> -                       continue;
>> +                       if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
>> +                               bio_copy_data(sbio, pbio);
>> +                               continue;
>> +                       }
> 
> The logic is changed here. The original logic:
> 1. read ok, no mismatch: no bio_copy_data
> 2. read ok, mismatch, check: no bio_copy_data
> 3. read ok, mismatch, no check: need bio_copy_data
> 4. read fail: need bio_copy_data
> 
> The 4 is broken.
> 
> How about adding a temporary need_write to make logic more clear?
> 
> something like:
>          if (!status) {
>              int ret = 0;
>              ret = memcpy(folio_address(pfolio),
>                               folio_address(sfolio),
>                               r1_bio->sectors << 9);
>              if (ret) {
>                  atomic64_add(r1_bio->sectors, &mddev->resync_mismatches);
>                  if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
>                      need_write = true;
>              }
>          } else
>              need_write = true;
> 
>          if (need_write)
>              bio_copy_data(sbio, pbio);
>          else {
>              /* No need to write to this device. */
>              sbio->bi_end_io = NULL;
>              rdev_dec_pending(conf->mirrors[i].rdev, mddev);
>          }
> 

Nice catch, read failis is indeed broken. I’ll fix it in v2.

>>                  }
>>
>> -               bio_copy_data(sbio, pbio);
>> +               /* No need to write to this device. */
>> +               sbio->bi_end_io = NULL;
>> +               rdev_dec_pending(conf->mirrors[i].rdev, mddev);
>>          }
>>   }
>> >> @@ -3020,24 +2997,24 @@ static sector_t 	(struct mddev *mddev, sector_t 
sector_nr,
>>                  }
>>
>>                  for (i = 0 ; i < conf->raid_disks * 2; i++) {
>> -                       struct resync_pages *rp;
>> +                       struct resync_folio *rf;
>>
>>                          bio = r1_bio->bios[i];
>> -                       rp = get_resync_pages(bio);
>> +                       rf = get_resync_folio(bio);
>>                          if (bio->bi_end_io) {
>> -                               page = resync_fetch_page(rp, page_idx);
>> +                               folio = resync_fetch_folio(rf);
>>
>>                                  /*
>>                                   * won't fail because the vec table is big
>>                                   * enough to hold all these pages
>>                                   */
> 
> The comments above may not be needed anymore. Because there is only
> one vec in the bio.
> 

I will clean it up.

>> -                               __bio_add_page(bio, page, len, 0);
>> +                               bio_add_folio_nofail(bio, folio, len, 0);
>>                          }
>>                  }
>>                  nr_sectors += len>>9;
>>                  sector_nr += len>>9;
>>                  sync_blocks -= (len>>9);
> 
> These three lines are not needed anymore.
> 

It is cleaned up in later patches. In this patch I only want minimal
changes, just folio API and naming replacements. Do you think I should move
those cleanups into this patch?


>>          /*
>> -        * Allocate RESYNC_PAGES data pages and attach them
>> -        * where needed.
>> +        * Allocate data folio and attach them where needed.
> 
> typo error
> s/attach them/attach it/g
> 

I will fix it in v2.

>>           */
>>          for (j = 0; j < nalloc; j++) {
>>                  struct bio *rbio = r10_bio->devs[j].repl_bio;
>> -               struct resync_pages *rp, *rp_repl;
>> +               struct resync_folio *rf, *rf_repl;
>>
>> -               rp = &rps[j];
>> +               rf = &rfs[j];
>>                  if (rbio)
>> -                       rp_repl = &rps[nalloc + j];
>> +                       rf_repl = &rfs[nalloc + j];
>>
>>                  bio = r10_bio->devs[j].bio;
>>
>>                  if (!j || test_bit(MD_RECOVERY_SYNC,
>>                                     &conf->mddev->recovery)) {
>> -                       if (resync_alloc_pages(rp, gfp_flags))
>> +                       if (resync_alloc_folio(rf, gfp_flags))
>>                                  goto out_free_pages;
> 
> s/out_free_pages/out_free_folio/g
> 

I will fix it in v2.

>>                  } else {
>> -                       memcpy(rp, &rps[0], sizeof(*rp));
>> -                       resync_get_all_pages(rp);
>> +                       memcpy(rf, &rfs[0], sizeof(*rf));
>> +                       resync_get_all_folio(rf);
> 
> Maybe the name resync_get_folio is better?

Agree, I will rename it in v2.

>> @@ -2492,19 +2480,21 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
>>
>>                  rdev = conf->mirrors[dr].rdev;
>>                  addr = r10_bio->devs[0].addr + sect;
>> -               ok = sync_page_io(rdev,
>> -                                 addr,
>> -                                 s << 9,
>> -                                 pages[idx],
>> -                                 REQ_OP_READ, false);
>> +               ok = sync_folio_io(rdev,
>> +                                  addr,
>> +                                  s << 9,
>> +                                  sect << 9,
>> +                                  folio,
>> +                                  REQ_OP_READ, false);
> 
> By the comments at the beginning of fix_recovery_read_error, it needs
> to submit io with a page size unit, right? If so, it still needs to
> use sync_page_io here.
> 

Here 's' is PAGE_SIZE. We just use a 'page' from folio. In patch 10,
I will change it to use logical block size instead, which should be more
reasonable.

>>          /*
>>           * Allow skipping a full rebuild for incremental assembly
>> @@ -3277,7 +3265,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
>>           * with 2 bios in each, that correspond to the bios in the main one.
>>           * In this case, the subordinate r10bios link back through a
>>           * borrowed master_bio pointer, and the counter in the master
>> -        * includes a ref from each subordinate.
>> +        * bio_add_folio includes a ref from each subordinate.
> 
> What's the reason change this? And I don't understand the new version.
> 

It looks like a typo. I will remove it.

> Best Regards
> Xiao

Thanks again for your careful review.

-- 
Thanks,
Nan

