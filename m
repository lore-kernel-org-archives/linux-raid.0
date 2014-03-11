From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Replace RAID devices without resorting to degraded mode?
Date: Wed, 12 Mar 2014 10:26:38 +1100
Message-ID: <531F9BAE.1040001@websitemanagers.com.au>
References: <CAK_KU4ZfsCOyZxgkxLC7AFOJ2XEvcHi-Gr7itv4q_pPOQbaAYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4ZfsCOyZxgkxLC7AFOJ2XEvcHi-Gr7itv4q_pPOQbaAYA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Scott D'Vileskis <sdvileskis@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/03/14 04:36, Scott D'Vileskis wrote:
> Hello--
> I have been using Linux RAID for about the last 12 years or so and
> have endured dozens of RAID migrations, swapping of disks, growing &
> shrinking arrays, transforming partitions, etc. I consider myself
> pretty well versed in RAID0/1/5, and more recently RAID6.
>
> I would like to grow my RAID5 array to fill larger devices (larger
> partitions, actually). In the past, the typical method of replacing
> all the disks/partitions with larger ones is to:
> 1) Add a larger drive/partition as a hot spare
> 2) Fail a disk
> 3) Wait for the rebuild/resync
> 4) Repeat for each disk in the array
> 5) After all drives/partitions replaced and resynced, Grow the device
> and wait for a resync of the new space.
> 6) Resize the filesystem
> While this typically works flawlessly, it does require the array to be
> operated in degraded mode for the entire operation, which many would
> consider risky.
>
> Does Linux MD RAID support a method of hot replacing a disk WITHOUT
> having to resort to degraded mode?

Yes, it does, if you use a recent kernel + mdadm

However, you have another option anyway. Just remove the hot spare, 
re-partition as needed, then grow the raid5 to raid6.
1) Wait for the re-sync to complete
2) Drop another old drive from the array
3) Re-partition
4) Add back to the array and re-sync

You will never have worse redundancy than current during the above 
process. Personally, I'd probably use the hot spare to move to RAID6, 
and then use the migration to move a drive to its replacement (assuming 
you have another spare drive available).

> Scenario: I have 6 reliable, perfectly functioning Samsung 2TB drives,
> all recently passed SMART tests, zero reallocated sectors, etc.
> --One drive is a spare
> --Five drives are each partitioned into 500G and 1500G. The five 1500G
> partitions make up a RAID5. The 500G partitions were used in a
> different RAID array; I am abandoning the 500G partitions and
> reclaiming the space, but I want to transform RAID5 to use all the
> space on each drive. (And then probably convert to a RAID6)
>
> IF-- the 1500G partitions were at the beginning of the drive, I could
> simply (and I believe I have done this in the past):
> 1) Stop the RAID array
> 2) Delete both partitions, create a single partition with the same
> offset (On a 4K sector boundary for those picky about the details)
> 3) Restart the array to check for errors/mistakes (It should come up clean)
> 4) Repeat steps 1-3 for additional drives
> 5) Grow the array (Resync starts at the *new space)
> 6) Resize the filesystem

Yep, did this recently, and it works well. As long as you are using a 
version of MD that puts the superblock at the beginning or offset from 
the beginning. If the superblock is at the end of the block device, then 
when you change the size of the partition, md won't find the superblock, 
and so the array won't assemble.

> However, in my situation, my RAID5 partitions start in the middle of
> the drive, complicating that slightly... Fortunately, I have a spare
> drive or two to assist.
> Would the following off-line scenario work?
> 1) Stop RAID array
> 2) Clone one of the RAID devices to a larger disk (Using dd)
> 3) Remove the old RAID device from the system
> 4) Restart the RAID array in readonly mode (to test that the clone was
> successful without marking the array as dirty, otherwise, revert to
> the removed disk)
> 5) Optional: Restart the RAID array in readwrite mode to confirm
> 6) Repeat 1-5 for each additional disk
> 7) Grow the array (Resync starts at the new space)
> 8) Grow the filesystem

I'm not sure I would want to do that. It means very lengthy downtime of 
the array (though it depends on how much downtime is allowed), and I'd 
prefer to let MD manage the migration rather than me and dd (ie, 
hopefully MD is more careful and knowledgeable than I am).

Hope this helps somewhat.

Actually, I was trying to find the URL to show the migrate options, but 
couldn't seem to find any docs in the mdadm wiki at:
http://vger.kernel.org/vger-lists.html#linux-raid
Also, the debian raid wiki, the Neil Brown blog, and various other 
resources. Hopefully someone else will be able to provide the relevant 
link. Perhaps searching the mailing list itself would be best (I 
definitely recall seeing it discussed here), but I'm out of time now. 
Good luck.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
