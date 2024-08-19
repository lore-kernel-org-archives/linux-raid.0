Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473CA14C58C;
	Mon, 19 Aug 2024 11:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724065588; cv=none; b=p1+FQU9l9VsVb1YkzMlEse1ONHXO0ol9LI3OBCIkAMU9Tubv5OAX6JmOtLifMtZUsh1wR5LdoFTKH1mxVdO4wjm10tbqmMPurBoWMfeZf2oZI1UoSlMGjRnKpqWsbbD3NGukUWvLQmDpB/Dk+iHxcKDwwGualFYGbw/3yVeaU0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724065588; c=relaxed/simple;
	bh=QbuK6q65LYbdgNWFUcvkvZEJr0OQYdLRM5kZFLaqr4k=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=A+Im3msrti6hTKh4jXXtdLWmuTjfswIbrM6628ZQ7v0iHEWra4fWnUohfvua8ODHq6FB2Ne2RYCG5Y/E7k96IOZo4Qs4+aZGHK+eb6qDPMVMFmF6Z2nTD4mwvtarj1if4Tb2IQlyaMEiMSpnft0RfdJ/cxYnpZjIb8jziO3Fihs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WnVC25y5Tz4f3jry;
	Mon, 19 Aug 2024 19:06:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D9D1F1A058E;
	Mon, 19 Aug 2024 19:06:20 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoQrJ8Nm_Xt+CA--.65463S3;
	Mon, 19 Aug 2024 19:06:20 +0800 (CST)
Subject: Re: [PATCH RFC -next v2 11/41] md/md-bitmap: simplify
 md_bitmap_create() + md_bitmap_load()
To: Su Yue <l@damenly.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@linux.intel.com, hch@infradead.org, song@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20240814071113.346781-1-yukuai1@huaweicloud.com>
 <20240814071113.346781-12-yukuai1@huaweicloud.com> <ikvxorrl.fsf@damenly.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c86bcd71-1efd-3794-774d-3a3d8882a8c8@huaweicloud.com>
Date: Mon, 19 Aug 2024 19:06:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ikvxorrl.fsf@damenly.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXPoQrJ8Nm_Xt+CA--.65463S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKF18AF1kKFWkKFyDtFyftFb_yoW3Cw4Upr
	4ktFy5Gry5Jr1rXr1UJryDAFyUJr1Dtwnrtr1xXa45Gr1UArn0gF48WF1jgw1UAr48JF4D
	Xr15JrnrZr17Xr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/08/19 16:10, Su Yue 写道:
> 
> On Wed 14 Aug 2024 at 15:10, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Other than internal api get_bitmap_from_slot(), all other places will
>> set returned bitmap to mddev->bitmap. So move the setting of
>> mddev->bitmap into md_bitmap_create() to simplify code.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>  drivers/md/md-bitmap.c | 23 +++++++++++++++--------
>>  drivers/md/md-bitmap.h |  2 +-
>>  drivers/md/md.c        | 30 +++++++++---------------------
>>  3 files changed, 25 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index eed3b930ade4..75e58da9a1a5 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -1879,7 +1879,7 @@ void md_bitmap_destroy(struct mddev *mddev)
>>   * if this returns an error, bitmap_destroy must be called to   do 
>> clean up
>>   * once mddev->bitmap is set
>>   */
>> -struct bitmap *md_bitmap_create(struct mddev *mddev, int slot)
>> +static struct bitmap *bitmap_create(struct mddev *mddev, int slot)
>>  {
>>      struct bitmap *bitmap;
>>      sector_t blocks = mddev->resync_max_sectors;
>> @@ -1966,6 +1966,17 @@ struct bitmap *md_bitmap_create(struct mddev 
>> *mddev, int slot)
>>      return ERR_PTR(err);
>>  }
>>
>> +int md_bitmap_create(struct mddev *mddev, int slot)
>>
> NIT: We have two functions named md_bitmap_create() now. The static
> one will be renamed to __md_bitmap_create in next patch. Better to rename
> in this patch.

The static is renamed to bitmap_create() in this patch. And in the next
patch, the static is renamed to __bitmap_create() while the exported one
is renamed to bitmap_create().

I'll rename the static one to __bitmap_create() directly.

Thanks!
Kuai
> 
> -- 
> Su
> 
>> +{
>> +    struct bitmap *bitmap = bitmap_create(mddev, slot);
>> +
>> +    if (IS_ERR(bitmap))
>> +        return PTR_ERR(bitmap);
>> +
>> +    mddev->bitmap = bitmap;
>> +    return 0;
>> +}
>> +
>>  int md_bitmap_load(struct mddev *mddev)
>>  {
>>      int err = 0;
>> @@ -2030,7 +2041,7 @@ struct bitmap *get_bitmap_from_slot(struct mddev 
>> *mddev, int slot)
>>      int rv = 0;
>>      struct bitmap *bitmap;
>>
>> -    bitmap = md_bitmap_create(mddev, slot);
>> +    bitmap = bitmap_create(mddev, slot);
>>      if (IS_ERR(bitmap)) {
>>          rv = PTR_ERR(bitmap);
>>          return ERR_PTR(rv);
>> @@ -2381,7 +2392,6 @@ location_store(struct mddev *mddev, const char 
>> *buf, size_t len)
>>      } else {
>>          /* No bitmap, OK to set a location */
>>          long long offset;
>> -        struct bitmap *bitmap;
>>
>>          if (strncmp(buf, "none", 4) == 0)
>>              /* nothing to be done */;
>> @@ -2408,13 +2418,10 @@ location_store(struct mddev *mddev, const char 
>> *buf, size_t len)
>>              }
>>
>>              mddev->bitmap_info.offset = offset;
>> -            bitmap = md_bitmap_create(mddev, -1);
>> -            if (IS_ERR(bitmap)) {
>> -                rv = PTR_ERR(bitmap);
>> +            rv = md_bitmap_create(mddev, -1);
>> +            if (rv)
>>                  goto out;
>> -            }
>>
>> -            mddev->bitmap = bitmap;
>>              rv = md_bitmap_load(mddev);
>>              if (rv) {
>>                  mddev->bitmap_info.offset = 0;
>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>> index a8a5d4804174..e187f9099f2e 100644
>> --- a/drivers/md/md-bitmap.h
>> +++ b/drivers/md/md-bitmap.h
>> @@ -252,7 +252,7 @@ struct bitmap_operations {
>>  void mddev_set_bitmap_ops(struct mddev *mddev);
>>
>>  /* these are used only by md/bitmap */
>> -struct bitmap *md_bitmap_create(struct mddev *mddev, int slot);
>> +int md_bitmap_create(struct mddev *mddev, int slot);
>>  int md_bitmap_load(struct mddev *mddev);
>>  void md_bitmap_flush(struct mddev *mddev);
>>  void md_bitmap_destroy(struct mddev *mddev);
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index f67f2540fd6c..6e130f6c2abd 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -6211,16 +6211,10 @@ int md_run(struct mddev *mddev)
>>      }
>>      if (err == 0 && pers->sync_request &&
>>          (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
>> -        struct bitmap *bitmap;
>> -
>> -        bitmap = md_bitmap_create(mddev, -1);
>> -        if (IS_ERR(bitmap)) {
>> -            err = PTR_ERR(bitmap);
>> +        err = md_bitmap_create(mddev, -1);
>> +        if (err)
>>              pr_warn("%s: failed to create bitmap (%d)\n",
>>                  mdname(mddev), err);
>> -        } else
>> -            mddev->bitmap = bitmap;
>> -
>>      }
>>      if (err)
>>          goto bitmap_abort;
>> @@ -7275,14 +7269,10 @@ static int set_bitmap_file(struct mddev 
>> *mddev, int fd)
>>      err = 0;
>>      if (mddev->pers) {
>>          if (fd >= 0) {
>> -            struct bitmap *bitmap;
>> -
>> -            bitmap = md_bitmap_create(mddev, -1);
>> -            if (!IS_ERR(bitmap)) {
>> -                mddev->bitmap = bitmap;
>> +            err = md_bitmap_create(mddev, -1);
>> +            if (!err)
>>                  err = md_bitmap_load(mddev);
>> -            } else
>> -                err = PTR_ERR(bitmap);
>> +
>>              if (err) {
>>                  md_bitmap_destroy(mddev);
>>                  fd = -1;
>> @@ -7291,6 +7281,7 @@ static int set_bitmap_file(struct mddev *mddev, 
>> int fd)
>>              md_bitmap_destroy(mddev);
>>          }
>>      }
>> +
>>      if (fd < 0) {
>>          struct file *f = mddev->bitmap_info.file;
>>          if (f) {
>> @@ -7559,7 +7550,6 @@ static int update_array_info(struct mddev 
>> *mddev, mdu_array_info_t *info)
>>              goto err;
>>          }
>>          if (info->state & (1<<MD_SB_BITMAP_PRESENT)) {
>> -            struct bitmap *bitmap;
>>              /* add the bitmap */
>>              if (mddev->bitmap) {
>>                  rv = -EEXIST;
>> @@ -7573,12 +7563,10 @@ static int update_array_info(struct mddev 
>> *mddev, mdu_array_info_t *info)
>>                  mddev->bitmap_info.default_offset;
>>              mddev->bitmap_info.space =
>>                  mddev->bitmap_info.default_space;
>> -            bitmap = md_bitmap_create(mddev, -1);
>> -            if (!IS_ERR(bitmap)) {
>> -                mddev->bitmap = bitmap;
>> +            rv = md_bitmap_create(mddev, -1);
>> +            if (!rv)
>>                  rv = md_bitmap_load(mddev);
>> -            } else
>> -                rv = PTR_ERR(bitmap);
>> +
>>              if (rv)
>>                  md_bitmap_destroy(mddev);
>>          } else {
> .
> 

