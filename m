From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH 1/2] RAID5: check_reshape() shouldn't call mddev_suspend
Date: Fri, 26 Feb 2016 11:47:58 +0100
Message-ID: <56D02D5E.3040608@intel.com>
References: <b228d35f9a8e94969d667edbcc9d7f613d706b02.1456424579.git.shli@fb.com>
 <87a8mol9xz.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a8mol9xz.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/25/2016 11:08 PM, NeilBrown wrote:
> On Fri, Feb 26 2016, Shaohua Li wrote:
> 
>> check_reshape() is called from raid5d thread. raid5d thread shouldn't
>> call mddev_suspend(), because mddev_suspend() waits for all IO finish
>> but IO is handled in raid5d thread, we could easily deadlock here.
>>
>> Artur,
>> It would be great if you can verify this works for your test.
>>
>> Reported-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>> Cc: NeilBrown <neilb@suse.com>
>> Signed-off-by: Shaohua Li <shli@fb.com>
>> ---
>>  drivers/md/raid5.c | 18 ++++++++++++++++++
>>  drivers/md/raid5.h |  2 ++
>>  2 files changed, 20 insertions(+)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 7f770b0..c7fd070 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -2089,6 +2089,14 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
>>  	unsigned long cpu;
>>  	int err = 0;
>>  
>> +	/*
>> +	 * Never shrink. And mddev_suspend() could deadlock if this is called
>> +	 * from raid5d. In that case, scribble_disks and scribble_sectors
>> +	 * should equal to new_disks and new_sectors
>> +	 */
>> +	if (conf->scribble_disks >= new_disks &&
>> +	    conf->scribble_sectors >= new_sectors)
>> +		return 0;
>>  	mddev_suspend(conf->mddev);
>>  	get_online_cpus();
>>  	for_each_present_cpu(cpu) {
>> @@ -2110,6 +2118,10 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
>>  	}
>>  	put_online_cpus();
>>  	mddev_resume(conf->mddev);
>> +	if (!err) {
>> +		conf->scribble_disks = new_disks;
>> +		conf->scribble_sectors = new_sectors;
>> +	}
>>  	return err;
>>  }
>>  
>> @@ -6413,6 +6425,12 @@ static int raid5_alloc_percpu(struct r5conf *conf)
>>  	}
>>  	put_online_cpus();
>>  
>> +	if (!err) {
>> +		conf->scribble_disks = max(conf->raid_disks,
>> +			conf->previous_raid_disks);
>> +		conf->scribble_sectors = max(conf->chunk_sectors,
>> +			conf->prev_chunk_sectors) / STRIPE_SECTORS;
> 
> Here we set ->scribble_sectors to a number of stripes rather than a
> number of sectors.  I think you need to remove the "/ STRIPE_SECTORS".

That's correct. I've tested the patch and it works well but only without
the "/ STRIPE_SECTORS". 

Thanks,
Artur

