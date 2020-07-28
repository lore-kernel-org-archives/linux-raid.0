From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH V2 1/3] Move codes related with submitting discard bio
 into one function
Date: Tue, 28 Jul 2020 20:41:20 +0800
Message-ID: <d4a66f24-08ae-29ec-356c-bd290ecf0aea@redhat.com>
References: <1595920703-6125-1-git-send-email-xni@redhat.com>
 <1595920703-6125-2-git-send-email-xni@redhat.com>
 <407c8e78-93d0-5347-1056-192613fff708@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <407c8e78-93d0-5347-1056-192613fff708@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, song@kernel.org, linux-raid@vger.kernel.org
Cc: colyli@suse.de, ncroxon@redhat.com, heinzm@redhat.com
List-Id: linux-raid.ids

Hi Guoqing

Thanks for reviewing this patch set.


On 07/28/2020 04:21 PM, Guoqing Jiang wrote:
> Hi Xiao,
>
> Better to add a prefix before subject like "md" ...", the same to 
> other patches.
Sure.
>
> On 7/28/20 9:18 AM, Xiao Ni wrote:
>> These codes can be used in raid10. So we can move these codes into
>> md.c. raid0 and raid10 can share these codes.
>>
>> Reviewed-by: Coly Li <colyli@suse.de>
>> Signed-off-by: Xiao Ni <xni@redhat.com>
>> ---
>>   drivers/md/md.c    | 22 ++++++++++++++++++++++
>>   drivers/md/md.h    |  3 +++
>>   drivers/md/raid0.c | 15 ++-------------
>>   3 files changed, 27 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 07e5b67..2b8f654 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -8559,6 +8559,28 @@ void md_write_end(struct mddev *mddev)
>>     EXPORT_SYMBOL(md_write_end);
>
> Could you add comment before the function to inform it is used by 
> raid0 and raid10?
I'll add comments in next version.

Regards
Xiao
>
>> +void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>> +                struct bio *bio,
>> +                sector_t dev_start, sector_t dev_end)
>
> Thanks,
> Guoqing
>
