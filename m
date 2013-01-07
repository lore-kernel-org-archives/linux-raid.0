From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 3 of 4] MD RAID10:  Improve redundancy for 'far' and 'offset' algorithms (part 2)
Date: Mon, 7 Jan 2013 14:56:45 -0600
Message-ID: <47132ADF-82B8-456E-92F1-0BF7A5A14D29@redhat.com>
References: <1355769616.15326.25.camel@f16> <20130107170429.79325ccd@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130107170429.79325ccd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids

Neil,

In the normal case (I hope!) most people will choose to have a device count that is a multiple of 'copies'.  My hope was to avoid doing too much extra work just because we need to allow for the possibility of non-mulitples.  (In fact, I had considered encapsulating the assignment of 'last_far_set_start|size' in a conditional so it would normally be avoided, but didn't.)  Having the conditionals signals (to me) that we are treating the last set differently... because it is different in the non-multiple case.  Without the conditionals, we would treat the last set differently even in the proper 'multiple' case (i.e. the case where the last set is /not/ different from the others).

It is clearer to me the way it is, but it seems like a simple preference and nothing more.  I will happily change it if you like.

 brassow

(sorry for top post)

On Jan 7, 2013, at 12:04 AM, NeilBrown wrote:

> 
> Hi Jon,
> I really like the way you have coded this - it makes for very neat code.
> 
> I'm happy to take  it as it is, however I'll just note a couple of little
> issues that you could change if you like:
> 
>> --- linux-upstream.orig/drivers/md/raid10.c
>> +++ linux-upstream/drivers/md/raid10.c
>> @@ -550,6 +550,13 @@ static void __raid10_find_phys(struct ge
>> 	sector_t stripe;
>> 	int dev;
>> 	int slot = 0;
>> +	int last_far_set_start, last_far_set_size;
>> +
>> +	last_far_set_start = (geo->raid_disks / geo->far_set_size) - 1;
>> +	last_far_set_start *= geo->far_set_size;
>> +
>> +	last_far_set_size = geo->far_set_size;
>> +	last_far_set_size += (geo->raid_disks % geo->far_set_size);
>> 
>> 	/* now calculate first sector/dev */
>> 	chunk = r10bio->sector >> geo->chunk_shift;
>> @@ -575,9 +582,16 @@ static void __raid10_find_phys(struct ge
>> 		for (f = 1; f < geo->far_copies; f++) {
>> 			set = d / geo->far_set_size;
>> 			d += geo->near_copies;
>> -			d %= geo->far_set_size;
>> -			d += geo->far_set_size * set;
>> 
>> +			if ((geo->raid_disks % geo->far_set_size) &&
>                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> This test isn't needed.  If it is false, then last_far_set_size will be the
> same as geo->far_set_size, so both branches will do the same thing.
> 
> 
>> +			    (d > last_far_set_start)) {
>> +				d -= last_far_set_start;
>> +				d %= last_far_set_size;
>> +				d += last_far_set_start;
>> +			} else {
>> +				d %= geo->far_set_size;
>> +				d += geo->far_set_size * set;
>> +			}
>> 			s += geo->stride;
>> 			r10bio->devs[slot].devnum = d;
>> 			r10bio->devs[slot].addr = s;
>> @@ -615,6 +629,18 @@ static sector_t raid10_find_virt(struct
>> 	struct geom *geo = &conf->geo;
>> 	int far_set_start = (dev / geo->far_set_size) * geo->far_set_size;
>> 	int far_set_size = geo->far_set_size;
>> +	int last_far_set_start;
>> +
>> +	if (geo->raid_disks % geo->far_set_size) {
> 
> Similarly I don't think this test is needed - just perform the following code
> in any case.
> Maybe you will think the code is more clear the way it is.  If so, I'm fine
> to leave it as it is.
> 
> Thanks,
> NeilBrown
> 
> 
> 
>> +		last_far_set_start = (geo->raid_disks / geo->far_set_size) - 1;
>> +		last_far_set_start *= geo->far_set_size;
>> +
>> +		if (dev >= last_far_set_start) {
>> +			far_set_size = geo->far_set_size;
>> +			far_set_size += (geo->raid_disks % geo->far_set_size);
>> +			far_set_start = last_far_set_start;
>> +		}
>> +	}
>> 
>> 	offset = sector & geo->chunk_mask;
>> 	if (geo->far_offset) {
>> 
> 

