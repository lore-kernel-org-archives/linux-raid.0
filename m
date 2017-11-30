From: Michael Lyle <mlyle@lyle.org>
Subject: =?UTF-8?B?UmU6IOWbnuWkje+8mltQQVRDSF0gYmNhY2hlOiBGaXggYmRldiBsZWFr?=
 =?UTF-8?Q?_during_backing_device_registering?=
Date: Thu, 30 Nov 2017 10:48:54 -0800
Message-ID: <eb5e502c-bf2a-ca47-4b18-ce2ddf00c45d@lyle.org>
References: <fd806bd1-6537-42a7-8af3-d8dee9cb8fb9.liangyan.ply@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <fd806bd1-6537-42a7-8af3-d8dee9cb8fb9.liangyan.ply@alibaba-inc.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: =?UTF-8?B?5b2t6Imv5b2m?= <liangyan.ply@alibaba-inc.com>, linux-bcache <linux-bcache@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Coly Li <colyli@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?5Y2V5Zu95paHKOa4oeazoik=?= <dubo.sgw@alibaba-inc.com>, =?UTF-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@alibaba-inc.com>
List-Id: linux-raid.ids

Hi--

On 11/30/2017 04:00 AM, 彭良彦 wrote:
> On 17/11/23 上午8:42, 彭良彦 wrote:
>> If the backing device hasn't been detached due to exceptional stop
>> like power outage, the BDEV_STATE in super block can't be reset,
>> it will fail to register this backing device in next time, but the
>> opened bdev will be hold, this makes the backing device unaccessable
>> because of FMODE_EXCL until reboot.
>>
>> Signed-off-by: Liangyan Peng <liangyan.ply@alibaba-inc.com>

This doesn't seem correct.

What is the exact problem you're seeing?  Is it, if the cache device is
missing, the backing device "leaks"?  I think this is intentional-- it
is waiting there for an appropriate cache device to be attached that
lets it leave the STATE_DIRTY and run.  That is, either the backing
device or cache device can be registered first, and if the backing
device is registered first it is supposed to "wait" and not run until
the cache shows up.

>> ---
>>  drivers/md/bcache/super.c | 15 +++++++++++----
>>  1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 66669c8f4161..0b95a594c12e 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -1174,9 +1174,7 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
>>  	list_for_each_entry(c, &bch_cache_sets, list)
>>  		bch_cached_dev_attach(dc, c);
>>  
>> -	if (BDEV_STATE(&dc->sb) == BDEV_STATE_NONE ||
>> -	    BDEV_STATE(&dc->sb) == BDEV_STATE_STALE)
>> -		bch_cached_dev_run(dc);
>> +	bch_cached_dev_run(dc);

You've moved the check out of here into the enclosing...

>>  
>>  	return;
>>  err:
>> @@ -1982,7 +1980,16 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>>  		goto err_close;
>>  
>>  	if (SB_IS_BDEV(sb)) {
>> -		struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
>> +		struct cached_dev *dc = NULL;
>> +
>> +		if (BDEV_STATE(sb) != BDEV_STATE_NONE &&
>> +			BDEV_STATE(sb) != BDEV_STATE_STALE) {
>> +			blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
>> +			err = "invalid super block";
>> +			pr_info("Failed to register %s: %s", path, err);
>> +			goto out;
>> +		}

Here we check the state-- before bch_cached_dev_attach is called.  So if
the state is BDEV_STATE_DIRTY or BDEV_STATE_CLEAN there is no chance to
ever transition to _NONE/_STALE and run the cache.  This will make it
impossible to ever start up the cache after power failure.

Mike
