From: Ben Bucksch <linux.news@bucksch.org>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Thu, 18 Apr 2013 15:17:15 +0200
Message-ID: <516FF25B.4000907@bucksch.org>
References: <516869D2.9030506@bucksch.org> <516B3077.9020507@schinagl.nl> <516B590C.5060807@bucksch.org> <516AE7A0.4070504@schinagl.nl> <516BD5E0.4040007@bucksch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516BD5E0.4040007@bucksch.org>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

To re-summarize (for full info, see first post of thread):
* There are 2 RAID5 arrays in the machine, each have 8 disks.
* I upgraded Ubuntu 10.04 to 12.04.
* After reboot, both arrays had each ejected one disk.
   The ejected disks are working fine (at least now).
* During the resync mandated by above ejection,
    one other drive failed, this one fatally with a real hardware failure.
* The second array resynced fine, further proving that the
    disks ejected during upgrade were working.
* Now I am left with: originally 8-disk RAID5, 6 disks are healthy,
   1 disk with hardware failure, and 1 disk that was ejected, but is 
working.
* The latter is currently marked "spare" by md and has an event count
   (only) 2 events lower than the other 6 disks.
* My task is to get the latter disk back online *with* its data, without 
resync.

I desperately need help, please.

Based on suggestions here by Oliver and on forums, I did (and the result 
is):

> # mdadm --stop /dev/md0
> mdadm: stopped /dev/md0
> # mdadm --assemble --run --force /dev/md0 /dev/sd[jlmnopq]
> mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
> mdadm: Not enough devices to start the array.
> # cat /proc/mdstat
> md0 : inactive sdj[0] sdq[7] sdn[6] sdp[5] sdo[4] sdm[3]
>       5860574976 blocks
> (Note that sdl is not even listed)
> # mdadm --re-add /dev/md0 /dev/sdl
> mdadm: re-added /dev/sdl
> # cat /proc/mdstat
> md0 : inactive sdl[8](S) sdj[0] sdq[7] sdn[6] sdp[5] sdo[4] sdm[3]
>       6837337472 blocks
>
> Now, sdl is listed, but as spare. I need it to be treated not as 
> spare, but as good drive with correct data (well, almost, 2 events off 
> only). How do I do that?
>

