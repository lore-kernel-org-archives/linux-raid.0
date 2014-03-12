From: "Scott D'Vileskis" <sdvileskis@gmail.com>
Subject: Re: Replace RAID devices without resorting to degraded mode?
Date: Tue, 11 Mar 2014 20:00:42 -0400
Message-ID: <CAK_KU4Yun-=HyDnCVvddCPuUkNPjbVbqP1VEo=v=-z6FNwuMCA@mail.gmail.com>
References: <CAK_KU4ZfsCOyZxgkxLC7AFOJ2XEvcHi-Gr7itv4q_pPOQbaAYA@mail.gmail.com>
	<531F9BAE.1040001@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <531F9BAE.1040001@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for the response..


>> Does Linux MD RAID support a method of hot replacing a disk WITHOUT
>> having to resort to degraded mode?
>
>
> Yes, it does, if you use a recent kernel + mdadm

I remembered reading about this once, and researching once before, but
I am pretty sure my Xubuntu 13.10 distro doesn't have the flavor of
mdadm I need.  (Awesome work on this tool Neil! With mdadm you have
transformed the utility of the md subsystem, and made it almost
impossible to break an array with bad options)
>
> However, you have another option anyway. Just remove the hot spare,
> re-partition as needed, then grow the raid5 to raid6.
> 1) Wait for the re-sync to complete
> 2) Drop another old drive from the array
> 3) Re-partition
> 4) Add back to the array and re-sync
> You will never have worse redundancy than current during the above process.
> Personally, I'd probably use the hot spare to move to RAID6, and then use
> the migration to move a drive to its replacement (assuming you have another
> spare drive available).

Thanks for pointing out that obvious solution, I had almost forgot! I
think this had crossed my mind at some point, but I wasn't sure if I
needed RAID6 at this time. The 2TB Samsung F4EG drives have a 1e^15
BER, which is on par with enterprise drives. I've been using them for
about 3 years, and they are still barely audible and perform great. I
have even purchased several used (The genuine Samsung article, Made in
Korea, not the post-merger Seagate flavor) and they all seem to behave
awesome.
The other kink to this solution is that I only plan to have 4 drives
in the system when all is said and done. I might just go with a RAID10
in that case.

If I decide to go this route, migrating to RAID6 is certainly a great solution.
>
>
>> However, in my situation, my RAID5 partitions start in the middle of
>> the drive, complicating that slightly... Fortunately, I have a spare
>> drive or two to assist.
>> 1) Stop RAID array
>> 2) Clone one of the RAID devices to a larger disk (Using dd)
>> 3) Remove the old RAID device from the system
>> 4) Restart the RAID array in readonly mode (to test that the clone was
>> successful without marking the array as dirty, otherwise, revert to
>> the removed disk)
>> 5) Optional: Restart the RAID array in readwrite mode to confirm
>> 6) Repeat 1-5 for each additional disk
>> 7) Grow the array (Resync starts at the new space)
>> 8) Grow the filesystem
>
I did start this process and migrated the first drive. Array downtime
was acceptable to me.. Details:
1) I stopped the RAID array
2) I created a partition on my spare drive
   (starting at sector 2048 so my 4K sector drive lies on a 4K boundary)
3) I cloned the partition with dd, It ran for a few hours at 100MB/min
sustained:
dd if=/dev/sda2 of=/dev/sdf1 bs=1M
(in another terminal: "while killall -USR1 dd; do sleep 60; done" was
pretty handy for monitoring progress)
4) I couldn't figure out how to start the array readonly, but I
assembled it manually with the following:
mdadm --assemble /dev/md5 /dev/sdf1 /dev/sdb2 /dev/sdc2 /dev/sdd2
/dev/sde2 --no-degraded
mdadm: /dev/md5 has been started with 5 drives.

So, while this solution does require a spare disk, this is an option
for migrating raid5 without running the array in degraded mode.
>
> Actually, I was trying to find the URL to show the migrate options, but
> couldn't seem to find any docs in the mdadm wiki at:
> http://vger.kernel.org/vger-lists.html#linux-raid
> Also, the debian raid wiki, the Neil Brown blog, and various other
> resources. Hopefully someone else will be able to provide the relevant link.
> Perhaps searching the mailing list itself would be best (I definitely recall
> seeing it discussed here), but I'm out of time now. Good luck.

I recall seeing it at one point too.. Maybe it was in the btrfs man pages?
Thanks again!
