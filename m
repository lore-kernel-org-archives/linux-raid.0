From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [PATCH] md:array cannot be opened again after 'md_set_readonly'
Date: Tue, 28 Mar 2017 21:19:12 +0800
Message-ID: <0c5289f3-0160-8d2d-a5d8-da126b2fb468@suse.com>
References: <1490601145-5865-1-git-send-email-zlliu@suse.com>
 <20170327182214.zde4kao2gz2lazgm@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170327182214.zde4kao2gz2lazgm@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: neilb@suse.com, shli@fb.com, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids


On 03/28/2017 02:22 AM, Shaohua Li wrote:
> On Mon, Mar 27, 2017 at 03:52:25PM +0800, Zhilong Liu wrote:
>> This is a bug about array cannot be opened again after 'md_set_readonly',
>> because the MD_CLOSING bit is still waiting for clear.
>> MD_CLOSING should only be set for a short period or time to avoid certain
>> races. After the operation that set it completes, it should be cleared.
> where is the bit set? Why don't clear it after the operation but clear it in
> set_readonly?
>   

it goes two paths after set MD_CLOSING bit, do_md_stop and md_set_readonly,
the do_md_stop has done the md_clean to clear the mddev->flags, thus I 
put it in
md_set_readonly.
Thanks for your suggestion, is the following changing good for you? here 
it has
finished what it needs to do, so clear the MD_CLOSING bit in time.
if looks good, I would send this in new revision patch.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f6ae1d6..e8c1130 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6868,6 +6868,7 @@ static int md_ioctl(struct block_device *bdev, 
fmode_t mode,
                 set_bit(MD_CLOSING, &mddev->flags);
                 mutex_unlock(&mddev->open_mutex);
                 sync_blockdev(bdev);
+               clear_bit(MD_CLOSING, &mddev->flags);
         }
         err = mddev_lock(mddev);
         if (err) {

Thanks,
-Zhilong
>> Reviewed-by: NeilBrown <neilb@suse.com>
>> Cc: Guoqing Jiang <gqjiang@suse.com>
>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>> ---
>>   drivers/md/md.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index f6ae1d6..7f2db7c 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -5588,6 +5588,7 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
>>   	int err = 0;
>>   	int did_freeze = 0;
>>   
>> +	test_and_clear_bit(MD_CLOSING, &mddev->flags);
> I don't understand why this must be a test_and_clear.
>
> Thanks,
> Shaohua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

