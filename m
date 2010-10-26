From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] md/raid5: skip wait for MD_CHANGE_DEVS acknowledgement
 in the external case
Date: Tue, 26 Oct 2010 00:20:25 -0700
Message-ID: <4CC68139.7010700@intel.com>
References: <20101022180311.6563.6666.stgit@localhost6.localdomain6>	<20101022180354.6563.52476.stgit@localhost6.localdomain6> <20101026162243.263a96ae@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101026162243.263a96ae@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On 10/25/2010 10:22 PM, Neil Brown wrote:
> On Fri, 22 Oct 2010 11:03:54 -0700
> Dan Williams<dan.j.williams@intel.com>  wrote:
>
>> mdmon is orchestrating the reshape progress and we rely on it to manage the
>> reshape position and metadata updates.
>>
>> Reported-by: Adam Kwolek<adam.kwolek@intel.com>
>> Signed-off-by: Dan Williams<dan.j.williams@intel.com>
>> ---
>>   drivers/md/raid5.c |    6 +++---
>>   1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 69b0a16..9e8ecd5 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -4243,7 +4243,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
>>   		set_bit(MD_CHANGE_DEVS,&mddev->flags);
>>   		md_wakeup_thread(mddev->thread);
>>   		wait_event(mddev->sb_wait, mddev->flags == 0 ||
>> -			   kthread_should_stop());
>> +			   !mddev->persistent || kthread_should_stop());
>>   		spin_lock_irq(&conf->device_lock);
>>   		conf->reshape_safe = mddev->reshape_position;
>>   		spin_unlock_irq(&conf->device_lock);
>> @@ -4344,8 +4344,8 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
>>   		set_bit(MD_CHANGE_DEVS,&mddev->flags);
>>   		md_wakeup_thread(mddev->thread);
>>   		wait_event(mddev->sb_wait,
>> -			   !test_bit(MD_CHANGE_DEVS,&mddev->flags)
>> -			   || kthread_should_stop());
>> +			   !test_bit(MD_CHANGE_DEVS,&mddev->flags) ||
>> +			   !mddev->persistent || kthread_should_stop());
>>   		spin_lock_irq(&conf->device_lock);
>>   		conf->reshape_safe = mddev->reshape_position;
>>   		spin_unlock_irq(&conf->device_lock);
>
>
> Do we really need this?

Sorry, not anymore, this patch predated the md_update_sb() rework and is 
no longer needed as far as I can see.

--
Dan
