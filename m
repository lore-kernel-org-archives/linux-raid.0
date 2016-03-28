From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH] md/bitmap: call bitmap_destroy in case bitmap_create
 failed
Date: Mon, 28 Mar 2016 11:27:26 +0800
Message-ID: <56F8A49E.60705@suse.com>
References: <1458903614-21498-1-git-send-email-gqjiang@suse.com>
 <20160325220210.GA78806@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160325220210.GA78806@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids



On 03/26/2016 06:02 AM, Shaohua Li wrote:
> On Fri, Mar 25, 2016 at 07:00:14PM +0800, Guoqing Jiang wrote:
>> If bitmap_create returns an error, bitmap_destroy must be
>> called to do clean up.
>>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>>   drivers/md/bitmap.c | 14 ++++++++------
>>   1 file changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
>> index 7df6b4f..ba908e7 100644
>> --- a/drivers/md/bitmap.c
>> +++ b/drivers/md/bitmap.c
>> @@ -1865,8 +1865,10 @@ int bitmap_copy_from_slot(struct mddev *mddev, int slot,
>>   	struct bitmap_counts *counts;
>>   	struct bitmap *bitmap = bitmap_create(mddev, slot);
>>   
>> -	if (IS_ERR(bitmap))
>> +	if (IS_ERR(bitmap)) {
>> +		bitmap_destroy(mddev);
>>   		return PTR_ERR(bitmap);
>> +	}
> bitmap_create doesn't set mddev->bitmap, so bitmap_destroy will do nothing.
> is this because of reference leak of sysfs_can_clear?

Yes, use bitmap_free should be ok here since mddev->bitmap is not set.

> can we move sysfs_put(bitmap->sysfs_can_clear); to bitmap_free?

Do you mean move sysfs_put from bitmap_destroy to bitmap_free?
I guess it could be ok. Also we need make minor change to the comment.

/*
   * initialize the bitmap structure
   * if this returns an error, bitmap_destroy must be called to do clean up
+ * once mddev->bitmap is set
   */
  struct bitmap *bitmap_create(struct mddev *mddev, int slot)

Thanks,
Guoqing

