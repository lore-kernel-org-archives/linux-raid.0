From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH] md:fix a trivial typo in comments
Date: Mon, 13 Mar 2017 17:23:38 +0800
Message-ID: <58C6651A.3090106@suse.com>
References: <1489384407-12672-1-git-send-email-zlliu@suse.com>
 <CA+res+SABO1y1FAXX3CrncmmYHKis5QQiNUm=AVcV9i2Ej3-rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+res+SABO1y1FAXX3CrncmmYHKis5QQiNUm=AVcV9i2Ej3-rA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <jack.wang.usish@gmail.com>, Zhilong Liu <zlliu@suse.com>
Cc: shli@fb.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 03/13/2017 05:10 PM, Jack Wang wrote:
> 2017-03-13 6:53 GMT+01:00 Zhilong Liu <zlliu@suse.com>:
>> fix a trivial typo in freeze_array() of raid1.c
>>
>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>> ---
>>   drivers/md/raid1.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 7b0f647..2ec0617 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -958,7 +958,7 @@ static void allow_barrier(struct r1conf *conf, sector_t start_next_window,
>>   static void freeze_array(struct r1conf *conf, int extra)
>>   {
>>          /* stop syncio and normal IO and wait for everything to
>> -        * go quite.
>> +        * go quit.
>>           * We wait until nr_pending match nr_queued+extra
>>           * This is called in the context of one normal IO request
>>           * that has failed. Thus any sync request that might be pending
>> --
> s/quite/quietly ?

I guess it should be "quiet" if referring from freeze_array in raid10.c.

Thanks,
Guoqing

