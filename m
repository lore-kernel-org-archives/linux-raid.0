Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4216D3ACEE4;
	Tue, 20 Jan 2026 11:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768909889; cv=none; b=Z3O0mbJovJmeYarYzS8EnT8L5ZLXFYByuxuvCHhdcZ0SIfuq4W0iNi8Y+mgTUTNcMk2bMeQ87QVe+cpHczSsILiPmbo+LdYBdfa9FmWHCRLeiczIN7scE3IorguaI2mAl9Yy6CLMQpzHqdbPf3CUdRdHBxpzSVpNoduVQDfU0vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768909889; c=relaxed/simple;
	bh=jTSpppwKXcjp24Px23L+QDMYDbamFRGwfwzC/Od/QUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NmESi931RyCqKFBIeITKT82MY4GAlgrx+Kz9OvJ6KoXvkRSj5vlW2J2W6jg1CTctg2MDEPx/cmgjuMzSf5r9vlPcoK5hHs66IA1N3pDLt98HluS1n+xLSQT7zo4dF7bWIxG2gFjm+l/nwhl7DcJEzhELc6pYDJxMcW93ZPYtDZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dwQdG43DvzYQtxq;
	Tue, 20 Jan 2026 19:50:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4E82440574;
	Tue, 20 Jan 2026 19:51:22 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvc4bG9p3oDmEQ--.29175S3;
	Tue, 20 Jan 2026 19:51:22 +0800 (CST)
Message-ID: <fe42c415-75ab-69bb-663c-247b038d3bc5@huaweicloud.com>
Date: Tue, 20 Jan 2026 19:51:20 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 04/15] md/raid1: use folio for tmppage
To: Xiao Ni <xni@redhat.com>, linan666@huaweicloud.com
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20251217120013.2616531-1-linan666@huaweicloud.com>
 <20251217120013.2616531-5-linan666@huaweicloud.com>
 <CALTww2-bCOHsK=iXqkTokFBdG=kxc6NsdgtyfWPXBaSX6pmcAA@mail.gmail.com>
 <e6f77ede-444b-4d5c-9353-b18f84376ee7@redhat.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <e6f77ede-444b-4d5c-9353-b18f84376ee7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBnFvc4bG9p3oDmEQ--.29175S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKF18Zw4xJF1UCw15ArWDArb_yoWxtF4fpr
	1kJF1UJryUJr18Jr1UJr1UJryUJr1UJ3WUJr1UJF1UJr4UJr1jqr1UXr1jgr1UJr48Jr1U
	Jr1UJr13ZF1UJrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Cr0_Gr1UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUO0PfDUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/20 11:38, Xiao Ni 写道:
> 
> 在 2026/1/19 11:20, Xiao Ni 写道:
>> On Wed, Dec 17, 2025 at 8:11 PM <linan666@huaweicloud.com> wrote:
>>> From: Li Nan <linan122@huawei.com>
>>>
>>> Convert tmppage to tmpfolio and use it throughout in raid1.
>>>
>>> Signed-off-by: Li Nan <linan122@huawei.com>
>>> ---
>>>   drivers/md/raid1.h |  2 +-
>>>   drivers/md/raid1.c | 18 ++++++++++--------
>>>   2 files changed, 11 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
>>> index c98d43a7ae99..d480b3a8c2c4 100644
>>> --- a/drivers/md/raid1.h
>>> +++ b/drivers/md/raid1.h
>>> @@ -101,7 +101,7 @@ struct r1conf {
>>>          /* temporary buffer to synchronous IO when attempting to repair
>>>           * a read error.
>>>           */
>>> -       struct page             *tmppage;
>>> +       struct folio            *tmpfolio;
>>>
>>>          /* When taking over an array from a different personality, we 
>>> store
>>>           * the new thread here until we fully activate the array.
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index 407925951299..43453f1a04f4 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -2417,8 +2417,8 @@ static void fix_read_error(struct r1conf *conf, 
>>> struct r1bio *r1_bio)
>>>                                rdev->recovery_offset >= sect + s)) &&
>>>                              rdev_has_badblock(rdev, sect, s) == 0) {
>>>                                  atomic_inc(&rdev->nr_pending);
>>> -                               if (sync_page_io(rdev, sect, s<<9,
>>> -                                        conf->tmppage, REQ_OP_READ, 
>>> false))
>>> +                               if (sync_folio_io(rdev, sect, s<<9, 0,
>>> +                                        conf->tmpfolio, REQ_OP_READ, 
>>> false))
>>>                                          success = 1;
>>>                                  rdev_dec_pending(rdev, mddev);
>>>                                  if (success)
>>> @@ -2447,7 +2447,8 @@ static void fix_read_error(struct r1conf *conf, 
>>> struct r1bio *r1_bio)
>>>                              !test_bit(Faulty, &rdev->flags)) {
>>>                                  atomic_inc(&rdev->nr_pending);
>>>                                  r1_sync_page_io(rdev, sect, s,
>>> -                                               conf->tmppage, 
>>> REQ_OP_WRITE);
>>> +                                               
>>> folio_page(conf->tmpfolio, 0),
>>> +                                               REQ_OP_WRITE);
>>>                                  rdev_dec_pending(rdev, mddev);
>>>                          }
>>>                  }
>>> @@ -2461,7 +2462,8 @@ static void fix_read_error(struct r1conf *conf, 
>>> struct r1bio *r1_bio)
>>>                              !test_bit(Faulty, &rdev->flags)) {
>>>                                  atomic_inc(&rdev->nr_pending);
>>>                                  if (r1_sync_page_io(rdev, sect, s,
>>> -                                               conf->tmppage, 
>>> REQ_OP_READ)) {
>>> +                                               
>>> folio_page(conf->tmpfolio, 0),
>>> +                                               REQ_OP_READ)) {
>>>                                          atomic_add(s, 
>>> &rdev->corrected_errors);
>>>                                          pr_info("md/raid1:%s: read 
>>> error corrected (%d sectors at %llu on %pg)\n",
>>>                                                  mdname(mddev), s,
>>> @@ -3120,8 +3122,8 @@ static struct r1conf *setup_conf(struct mddev *mddev)
>>>          if (!conf->mirrors)
>>>                  goto abort;
>>>
>>> -       conf->tmppage = alloc_page(GFP_KERNEL);
>>> -       if (!conf->tmppage)
>>> +       conf->tmpfolio = folio_alloc(GFP_KERNEL, 0);
>>> +       if (!conf->tmpfolio)
>>>                  goto abort;
>>>
>>>          r1bio_size = offsetof(struct r1bio, bios[mddev->raid_disks * 2]);
>>> @@ -3196,7 +3198,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
>>>          if (conf) {
>>>                  mempool_destroy(conf->r1bio_pool);
>>>                  kfree(conf->mirrors);
>>> -               safe_put_page(conf->tmppage);
>>> +               folio_put(conf->tmpfolio);
>>>                  kfree(conf->nr_pending);
>>>                  kfree(conf->nr_waiting);
>>>                  kfree(conf->nr_queued);
>>> @@ -3310,7 +3312,7 @@ static void raid1_free(struct mddev *mddev, void 
>>> *priv)
>>>
>>>          mempool_destroy(conf->r1bio_pool);
>>>          kfree(conf->mirrors);
>>> -       safe_put_page(conf->tmppage);
>>> +       folio_put(conf->tmpfolio);
>>>          kfree(conf->nr_pending);
>>>          kfree(conf->nr_waiting);
>>>          kfree(conf->nr_queued);
>>> -- 
>>> 2.39.2
>>>
>> Hi Nan
>>
>> Same question for patch04 and patch05, tmpage is used in read io path.
>>  From the cover letter, this patch set wants to resolve the multi pages
>> in sync io path. Is it better to keep them for your future patch set?
>>
>> Best Regards
>> Xiao
>>
>> Xiao
> 
> 
> After reading patch06, I understand here. r1_sync_page_io needs to change 
> to r1_sync_folio_io to handle sync read error. Please ignore my above 
> comments. patch04 and patch05 look good to me.
> 
> Best Regards
> 
> Xiao
> 

Thanks for your patient review.

-- 
Thanks,
Nan

