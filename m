From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] md: raid5: add prerequisite to run underneath dm-raid
Date: Mon, 9 May 2016 23:31:04 +0200
Message-ID: <57310198.9070001@redhat.com>
References: <1462809009-2809-1-git-send-email-heinzm@redhat.com>
 <wrfj8tzjrmbd.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj8tzjrmbd.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 05/09/2016 10:47 PM, Jes Sorensen wrote:
> heinzm@redhat.com writes:
>> From: Heinz Mauelshagen <heinzm@redhat.com>
>>
>> In case md runs underneath the dm-raid target, the mddev does not have
>> a request queue or gendisk, thus avoid accesses.
>>
>> This patch adds a missing conditional to the raid5 personality.
>>
>>
>> Signed-of-by: Heinz Mauelshagen <heinzm@redhat.com>
>>
>>
>> ---
>>   drivers/md/raid5.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 8ab8b65..ce79ce6 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -7574,8 +7574,10 @@ static void raid5_finish_reshape(struct mddev *mddev)
>>   
>>   		if (mddev->delta_disks > 0) {
>>   			md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
>> -			set_capacity(mddev->gendisk, mddev->array_sectors);
>> -			revalidate_disk(mddev->gendisk);
>> +			if (mddev->queue) {
>> +				set_capacity(mddev->gendisk, mddev->array_sectors);
>> +				revalidate_disk(mddev->gendisk);
>> +			}
> Since we're in the code taste mode, this is a reminder that kernel code
> is 80 characters per line :)

Hehe, gotta shorten > 20 lines in raid5.c alone then :-)

Heinz

>
> Jes

