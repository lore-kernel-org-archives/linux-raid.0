From: Maarten <maarten@ultratux.net>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Thu, 18 Apr 2013 15:58:43 +0200
Message-ID: <516FFC13.2030803@ultratux.net>
References: <516869D2.9030506@bucksch.org> <516B3077.9020507@schinagl.nl> <516B590C.5060807@bucksch.org> <516AE7A0.4070504@schinagl.nl> <516BD5E0.4040007@bucksch.org> <516FF25B.4000907@bucksch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516FF25B.4000907@bucksch.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/04/13 15:17, Ben Bucksch wrote:
> To re-summarize (for full info, see first post of thread):
> * There are 2 RAID5 arrays in the machine, each have 8 disks.
> * I upgraded Ubuntu 10.04 to 12.04.
> * After reboot, both arrays had each ejected one disk.
>   The ejected disks are working fine (at least now).
> * During the resync mandated by above ejection,
>    one other drive failed, this one fatally with a real hardware failure.
> * The second array resynced fine, further proving that the
>    disks ejected during upgrade were working.
> * Now I am left with: originally 8-disk RAID5, 6 disks are healthy,
>   1 disk with hardware failure, and 1 disk that was ejected, but is
> working.
> * The latter is currently marked "spare" by md and has an event count
>   (only) 2 events lower than the other 6 disks.
> * My task is to get the latter disk back online *with* its data, without
> resync.
> 
> I desperately need help, please.
> 
> Based on suggestions here by Oliver and on forums, I did (and the result
> is):
> 
>> # mdadm --stop /dev/md0
>> mdadm: stopped /dev/md0
>> # mdadm --assemble --run --force /dev/md0 /dev/sd[jlmnopq]
>> mdadm: failed to RUN_ARRAY /dev/md0:  
>> mdadm: Not enough devices to start the array.

At this point, does dmesg show anything pointing to that input/output
error ? The procedure is correct, I've used that myself on several
occasions when confronted with a two-disk failure.
What you ought to do before anything, is ascertain all those seven
drives are fully readable without any problems occurring. I use
dd_rescue for that; dd_rescue /dev/sd{x} /dev/null. You can run parallel
dd_rescue sessions. When finished, verify that all dd_rescue sessions
reported zero errors. If not, clone that drive using dd_rescue to a
fresh new drive, as retry assembly with that new one instead.

I have no (further) idea why mdadm insists there are not enough devices,
but I'm willing to bet it is that input/output error that is at the root
of that. So do the dd_rescue procedure as described.

Oh and, make sure you get that drive out of the array as spare, as that
is definitely NOT what you want. When in doubt how to do that safely,
clone it first, attempt removal later. If you value your data.

Good luck!

Maarten

>> # cat /proc/mdstat
>> md0 : inactive sdj[0] sdq[7] sdn[6] sdp[5] sdo[4] sdm[3]
>>       5860574976 blocks
>> (Note that sdl is not even listed)
>> # mdadm --re-add /dev/md0 /dev/sdl
>> mdadm: re-added /dev/sdl
>> # cat /proc/mdstat
>> md0 : inactive sdl[8](S) sdj[0] sdq[7] sdn[6] sdp[5] sdo[4] sdm[3]
>>       6837337472 blocks
>>
>> Now, sdl is listed, but as spare. I need it to be treated not as
>> spare, but as good drive with correct data (well, almost, 2 events off
>> only). How do I do that?
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

