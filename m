From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [PATCH] mdadm: Unitialized variable rdev
Date: Tue, 16 May 2017 11:02:36 +0800
Message-ID: <27a58b32-f234-d449-e8b7-39fcac22746b@suse.com>
References: <CA+wAi7cy6bMvv+uXWry=05E9biq0chUO2Wt9d91P6hQGZTVuMg@mail.gmail.com>
 <bf542fb4-42d3-10b8-c770-ba98e45aff87@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bf542fb4-42d3-10b8-c770-ba98e45aff87@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, James John <joejames70@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 05/16/2017 05:22 AM, Jes Sorensen wrote:
> On 05/11/2017 05:15 PM, James John wrote:
>> mdadm: Uninitialized variable rdev
>>
>> rdev is not initialized properly causing compiler complaint.
>>
>> Signed-off-by: James Puthukattukaran <joejames70@gmail.com>
>>

Hi James,

Thanks very very much for fixing this.

Best regards,
-Zhilong

>> diff --git a/super-ddf.c b/super-ddf.c
>> index 9c82f4f..ac14017 100644
>> --- a/super-ddf.c
>> +++ b/super-ddf.c
>> @@ -3526,7 +3526,7 @@ static int validate_geometry_ddf_bvd(
>> struct supertype *st,
>>                  return 1;
>>          }
>>          /* This device must be a member of the set */
>> -       if (!stat_is_blkdev(dev, NULL))
>> +       if (!stat_is_blkdev(dev, &rdev))
>>                  return 0;
>>          for (dl = ddf->dlist ; dl ; dl = dl->next) {
>>                  if (dl->major == (int)major(rdev) &&
>>
>
> Hi James,
>
> This looks correct, but unfortunately you are using a broken mail 
> client which replaced the tabs with spaces, and also included HTML junk.
>
> Would you mind sending me a version that works, and I'll be happy to 
> apply it.
>
> Thanks,
> Jes
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

