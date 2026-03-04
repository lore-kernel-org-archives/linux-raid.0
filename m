Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A99382F29
	for <linux-raid@vger.kernel.org>; Wed,  4 Mar 2026 07:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772610223; cv=none; b=sWI3iCcGpON6tzNm8ImmP49JN4/kM/CDQvnwEcVUym7kNIxgD3W9lUb89vkjPvUpid9S92zstbb1bFwxBneoqNsKp2fard24lj1UtkPmJUE9ssx5sLrEUNe7woZbk73PZUebRzhkKQ+vBkC0Q3QD75MJoCcqvRUPaJFKbwHo62s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772610223; c=relaxed/simple;
	bh=Ch6lnBm5hRNJaKPEFUZeDWG4M+WgYvTRB9UYDZERwW8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=maL1BC+5yVLT6LrKJp+hZlwxscoASlBEPHHlLrSAVfWy6+pemXBcgEsJ5FRi607VRg9VMB6kPWVcYN5PacU5dONLEufhoq+33f9t2l6hjq2tLifLZBVdiHA7m3aE7N3UkZ5uJLvpyyweM1ctK+u6AOAj2yLhUaMydYIx8MrxQbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.192] (ip5f5af751.dynamic.kabel-deutschland.de [95.90.247.81])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id EE6E24C44300C0;
	Wed, 04 Mar 2026 08:43:10 +0100 (CET)
Message-ID: <f86f7203-c619-4d6e-808c-02d7e997f824@molgen.mpg.de>
Date: Wed, 4 Mar 2026 08:43:10 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: remove unused mddev argument from export_rdev
From: Paul Menzel <pmenzel@molgen.mpg.de>
To: Chen Cheng <chencheng@fnnas.com>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
 Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org
References: <20260304111417.20777-1-chencheng@fnnas.com>
 <891274e7-cdb0-4864-bb0a-bc4ee915ea84@molgen.mpg.de>
Content-Language: en-US
In-Reply-To: <891274e7-cdb0-4864-bb0a-bc4ee915ea84@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Cheng,


Am 04.03.26 um 08:34 schrieb Paul Menzel:

> Am 04.03.26 um 12:14 schrieb Chen Cheng:
>> The mddev argument in export_rdev() is never used. Remove it to
>> simplify callers.
> 
> Nice catch. Was it like this from the beginning?

Commit 99892147f028 (md: fix warning for holder mismatch from 
export_rdev()) remove the argument usage, as far as I can see.

> Was the compiler noticing this itself, so the code stays the same?

I am still curious about this.

>> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
>> ---
>>   drivers/md/md.c | 28 ++++++++++++++--------------
>>   1 file changed, 14 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index c2cc2302d727..521d9b34cd9e 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -98,7 +98,7 @@ static struct workqueue_struct *md_misc_wq;
>>   static int remove_and_add_spares(struct mddev *mddev,
>>                    struct md_rdev *this);
>>   static void mddev_detach(struct mddev *mddev);
>> -static void export_rdev(struct md_rdev *rdev, struct mddev *mddev);
>> +static void export_rdev(struct md_rdev *rdev);
>>   static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
>>   /*
>> @@ -959,7 +959,7 @@ void mddev_unlock(struct mddev *mddev)
>>       list_for_each_entry_safe(rdev, tmp, &delete, same_set) {
>>           list_del_init(&rdev->same_set);
>>           kobject_del(&rdev->kobj);
>> -        export_rdev(rdev, mddev);
>> +        export_rdev(rdev);
>>       }
>>       if (!legacy_async_del_gendisk) {
>> @@ -2632,7 +2632,7 @@ void md_autodetect_dev(dev_t dev);
>>   /* just for claiming the bdev */
>>   static struct md_rdev claim_rdev;
>> -static void export_rdev(struct md_rdev *rdev, struct mddev *mddev)
>> +static void export_rdev(struct md_rdev *rdev)
>>   {
>>       pr_debug("md: export_rdev(%pg)\n", rdev->bdev);
>>       md_rdev_clear(rdev);
>> @@ -4850,7 +4850,7 @@ new_dev_store(struct mddev *mddev, const char 
>> *buf, size_t len)
>>       err = bind_rdev_to_array(rdev, mddev);
>>    out:
>>       if (err)
>> -        export_rdev(rdev, mddev);
>> +        export_rdev(rdev);
>>       mddev_unlock_and_resume(mddev);
>>       if (!err)
>>           md_new_event();
>> @@ -7142,7 +7142,7 @@ static void autorun_devices(int part)
>>               rdev_for_each_list(rdev, tmp, &candidates) {
>>                   list_del_init(&rdev->same_set);
>>                   if (bind_rdev_to_array(rdev, mddev))
>> -                    export_rdev(rdev, mddev);
>> +                    export_rdev(rdev);
>>               }
>>               autorun_array(mddev);
>>               mddev_unlock_and_resume(mddev);
>> @@ -7152,7 +7152,7 @@ static void autorun_devices(int part)
>>            */
>>           rdev_for_each_list(rdev, tmp, &candidates) {
>>               list_del_init(&rdev->same_set);
>> -            export_rdev(rdev, mddev);
>> +            export_rdev(rdev);
>>           }
>>           mddev_put(mddev);
>>       }
>> @@ -7340,13 +7340,13 @@ int md_add_new_disk(struct mddev *mddev, 
>> struct mdu_disk_info_s *info)
>>                   pr_warn("md: %pg has different UUID to %pg\n",
>>                       rdev->bdev,
>>                       rdev0->bdev);
>> -                export_rdev(rdev, mddev);
>> +                export_rdev(rdev);
>>                   return -EINVAL;
>>               }
>>           }
>>           err = bind_rdev_to_array(rdev, mddev);
>>           if (err)
>> -            export_rdev(rdev, mddev);
>> +            export_rdev(rdev);
>>           return err;
>>       }
>> @@ -7389,7 +7389,7 @@ int md_add_new_disk(struct mddev *mddev, struct 
>> mdu_disk_info_s *info)
>>               /* This was a hot-add request, but events doesn't
>>                * match, so reject it.
>>                */
>> -            export_rdev(rdev, mddev);
>> +            export_rdev(rdev);
>>               return -EINVAL;
>>           }
>> @@ -7415,7 +7415,7 @@ int md_add_new_disk(struct mddev *mddev, struct 
>> mdu_disk_info_s *info)
>>                   }
>>               }
>>               if (has_journal || mddev->bitmap) {
>> -                export_rdev(rdev, mddev);
>> +                export_rdev(rdev);
>>                   return -EBUSY;
>>               }
>>               set_bit(Journal, &rdev->flags);
>> @@ -7430,7 +7430,7 @@ int md_add_new_disk(struct mddev *mddev, struct 
>> mdu_disk_info_s *info)
>>                   /* --add initiated by this node */
>>                   err = mddev->cluster_ops->add_new_disk(mddev, rdev);
>>                   if (err) {
>> -                    export_rdev(rdev, mddev);
>> +                    export_rdev(rdev);
>>                       return err;
>>                   }
>>               }
>> @@ -7440,7 +7440,7 @@ int md_add_new_disk(struct mddev *mddev, struct 
>> mdu_disk_info_s *info)
>>           err = bind_rdev_to_array(rdev, mddev);
>>           if (err)
>> -            export_rdev(rdev, mddev);
>> +            export_rdev(rdev);
>>           if (mddev_is_clustered(mddev)) {
>>               if (info->state & (1 << MD_DISK_CANDIDATE)) {
>> @@ -7503,7 +7503,7 @@ int md_add_new_disk(struct mddev *mddev, struct 
>> mdu_disk_info_s *info)
>>           err = bind_rdev_to_array(rdev, mddev);
>>           if (err) {
>> -            export_rdev(rdev, mddev);
>> +            export_rdev(rdev);
>>               return err;
>>           }
>>       }
>> @@ -7615,7 +7615,7 @@ static int hot_add_disk(struct mddev *mddev, 
>> dev_t dev)
>>       return 0;
>>   abort_export:
>> -    export_rdev(rdev, mddev);
>> +    export_rdev(rdev);
>>       return err;
>>   }
> 
> The diff looks good:
> 
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>

Kind regards,

Paul
