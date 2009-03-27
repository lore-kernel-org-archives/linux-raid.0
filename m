From: "NeilBrown" <neilb@suse.de>
Subject: Re: [md PATCH 4/6] md/raid5: change reshape-progress measurement
     to cope with reshaping backwards.
Date: Sat, 28 Mar 2009 06:54:31 +1100 (EST)
Message-ID: <38a7f1dc05f8b3cedebd2e30a0288929.squirrel@neil.brown.name>
References: <20090324084629.15383.10271.stgit@notabene.brown>
    <20090324085332.15383.94300.stgit@notabene.brown>
    <20090327161936.GQ17185@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090327161936.GQ17185@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, March 28, 2009 3:19 am, Andre Noll wrote:
> On 19:53, NeilBrown wrote:
>> -			if (logical_sector >= conf->expand_progress) {
>> +			if (mddev->delta_disks < 0
>> +			    ? logical_sector < conf->reshape_progress
>> +			    : logical_sector >= conf->reshape_progress) {
>>  				disks = conf->previous_raid_disks;
>>  				previous = 1;
>>  			} else {
>> -				if (logical_sector >= conf->expand_lo) {
>> +				if (mddev->delta_disks < 0
>> +				    ? logical_sector < conf->reshape_safe
>> +				    : logical_sector >= conf->reshape_safe) {
>>  					spin_unlock_irq(&conf->device_lock);
>>  					schedule();
>>  					goto retry;
>
> Is it only me who finds such code hard to comprehend?  Given that
> the patch adds checks of the form
>
> 	(delta < 0 && s < r) || (delta >= 0 && s >= r)

They are really of the form
       delta < 0 ? s < r : s >= r

I guess I could use something like

 static inline inorder(mddev_t *mddev, sector_t a, sector_t b)
 {
      if (mddev->delta_disks < 0)
                return b > a;
      else
                return a <= b;
 }

However sometimes it is '<' vs '>=' and sometimes  '<' vs '>',
so I'm not sure it would apply universally.....


>
> at several locations, it might make sense to introduce a marco or an
> inline function for this check.
>
>> +	/* reshape_progress is the leading edge of a 'reshape'
>> +	 * It has value MaxSector when no expand is happening
>
> s/expand/reshape

Thanks.
Fixed.


NeilBrown

>
> Regards
> Andre
> --
> The only person who always got his work done by Friday was Robinson Crusoe
>

