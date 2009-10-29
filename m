From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 5 to raid 6 reshape failure after reboot
Date: Thu, 29 Oct 2009 14:32:16 +1100
Message-ID: <19177.3264.968930.336821@notabene.brown>
References: <20091018181033.0255346c@borg.bxl.tuxicoman.be>
	<358606dfd356518f7fa42219f26082d2.squirrel@neil.brown.name>
	<20091019155322.65b4287f@zombie>
	<5744c797713398f21b00e5323ddeac1e.squirrel@neil.brown.name>
	<c57ee40d9e6139de2993fb18934837c2.squirrel@neil.brown.name>
	<20091020103731.5dc611ff@zombie>
	<19167.40181.250468.925659@notabene.brown>
	<20091022162029.0cc2a1aa@zombie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy Martin on Thursday October 22
Sender: linux-raid-owner@vger.kernel.org
To: Guy Martin <gmsoft@tuxicoman.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 22, gmsoft@tuxicoman.be wrote:
> 
> Neil,
> 
> While redoing the reboot test, I've also noticed this :
> When I first issue the --grow command, I see the following in dmesg :
> [192752.106467] md: reshape of RAID array md0
> [192752.106473] md: minimum _guaranteed_  speed: 200000 KB/sec/disk.
> [192752.106479] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
> 
> The minimum guaranteed speed should be 1000KB/sec according to the
> entry in /proc/sys/dev/raid/speed_limit_min.

This is expected.
Each array can have a local setting in /sys/block/mdX/md/sync_speed_min
which overrides the global setting.
When a reshape does not change the size of the array, we need to
constantly create a backup of the few stripes 'currently' being
reshaped, so that in the event on an unclean shutdown (crash/power
failure) we can restart the reshape without data loss.
The process of reading data to make the backup looks like non-sync IO
to md, so it would normally slow down the resync process.

That is not a good idea, so mdadm deliberately sets
..../md/sync_speed_min very high to keep the resync moving.


> 
> Also, the performances are not really good. I have about 400K/sec according to /proc/mdstat.
> 
> Now, if I stop the array and assemble it again, things are better. The output in dmesg displays the correct value :
> [193138.646204] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [193138.646210] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.

This is different because when assembling the array, mdadm doesn't set
the sync_speed_min until after the reshape has started.  I might try
to get mdadm to set it before starting the reshape to avoid confusion.


> 
> And perf are much better, I now get ~1500K/s which shrinks the time of the reshape from ~2 weeks to 'only' a few days.

That is surprising.  The speed of 1500K/sec seems more reasonable, but
the fact that it changed after you restarted does surprise me.
(goes off to experiment and explore the code).

Ahhh... bug.

in Grow_reshape, we have code:
		if (ndata == odata) {
			/* Make 'blocks' bigger for better throughput, but
			 * not so big that we reject it below.
			 */
			if (blocks * 32 < sra->component_size)
				blocks *= 16;
		} else

This is meant to do the backup in larger chunks in the case where the
array isn't changing size (where the array does change size, we only
do the backup for a fraction of a second so it doesn't matter).
However sra->component_size is not initialised, so it zero, so
'blocks' does not get changed.
(->component size gets set a little later in "sra = sysfs_read(fd,.....)")

So the reshape is being done with a very small buffer, and you get
bad performance.
The matching code in Grow_continue doesn't check for component_size
and so doesn't suffer the same problem.

A bit of experimentation shows that you can increase the throughput
quite a bit more by changing the multiply factor to e.g. 64 and 
increasing the stripe_cache_size (in /sys/.../md/)

I wonder how to pick an 'optimal' size....
Maybe I could get the backup process to occasionally look at 
stripe_cache_size and adjust the backup size based on that.
Then the admin could try increasing the cache size to improve
throughput, but be careful not to exhaust memory.

I'll have to think about it a bit.

Thanks for your feedback.

NeilBrown
