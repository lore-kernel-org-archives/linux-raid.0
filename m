From: "Anton Voloshin" <ashutosh@harekrishna.ru>
Subject: Re: RAID 6 reshape failed (false message about critical section) -
     success report
Date: Fri, 7 Sep 2007 00:57:17 +0400 (MSD)
Message-ID: <15415.91.122.2.245.1189112237.squirrel@ssl.harekrishna.ru>
References: <515CA0AD-2BAF-437A-8A41-260F7A27BADB@harekrishna.ru>
    <18142.41665.719883.549678@notabene.brown>
    <62E93D27-4D05-45F7-BB60-144BA46DC913@harekrishna.ru>
    <18143.35894.229908.536924@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18143.35894.229908.536924@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Dear Neil,

> At the top of Grow_restart (in Grow.c), just put
> 	return 0;
>
> That will definitely get you your array back.

Thank you for your help, I've got my array assembled, running, and all my
data back up!

But everything was not so smooth as I was (secretly) hoping originally.
Details follow.

After I first run ./mdadm --assemble /dev/md1
array actually assembled but with 6 drives out of 8. I don't know exact
reason why two partitions are missing, but attempts to add missing
partitions with
> mdadm --add /dev/md1 /dev/sda2
resulted in message that "/dev/sdc1 is locked" or something like that.
Partitions are there (fdisk -l /dev/sda supports that) and they are
present in /dev. I suspect that maybe udev was doing something wrong but I
don't know for sure. Missing partitions were ones from drives which are
used to run my root partition /dev/md0 - raid1 made of /dev/sda1 and
/dev/sdc1.

Anyway, since it's RAID6 even with two drives missing array was able to
get running. But recovery speed was zero i.e. /proc/mdstat was something
like:
(it is not verbatim copy, but a fake based on current state - just to give
an idea of what it was like before)

> md1 : active raid6 sde2[1] sdd2[7] sdb2[6] sda2[5] sdg2[3] sdf2[2]
>       2191859712 blocks super 0.91 level 6, 1024k chunk, algorithm 2
[8/6] [_UUU_UUU]
>       [=>...................]  reshape =  7.0% (51783680/730619904)
finish=1571992.7min speed=0K/sec

So speed was zero and finish time was gradually increasing from tens of
thousands to tens of millions minutes and more.

Any process trying to read from /dev/md1 would hang in "D" state,
including mount so I was not able to see my data at that moment.

Few reboots later (during those I was debugging my boot scripts to find
out that /etc/init.d/udev in startup scripts never got control back after
starting /sbin/udevsettle, but I believe this is a separate matter not
connected with md.
Anyway, during each reboot I could see the same condition - array
assembled but with 0k reshape speed (and before somebody asked -
/sys/block/md1/md/sync_speed_{min,max} had their default values - 1000 and
200000 resp). After some reboots I could see array was assembled from all
8 disks but still reshape speed was zero.

Few reboots later after fixing my startup scripts, I was rather pleasantly
surprised to hear my hard drives busily humming and to find in
/proc/mdstat that reshape speed is 800K/sec and growing (up to current
value of about 10000K/sec). Array was working from 6 partitions out of 8.

/dev/md1 mounted fine and I have all my precious data back intact, and
needless to say that I'm very happy to see that.

Now, I have my array in degraded condition (6 out of 8 drives running) and
reshaping. I don't feel adventurous enough to try to add drives to array
before it will finish current reshaping. :-)
I believe it's time to get some backup space for about 2TB of data kept in
this array.

So array's current state according to /proc/mdstat is:
> md1 : active raid6 sde2[1] sdd2[7] sdb2[6] sda2[5] sdg2[3] sdf2[2]
>       2191859712 blocks super 0.91 level 6, 1024k chunk, algorithm 2
[8/6] [_UUU_UUU]
>       [=>...................]  reshape =  8.5% (62185472/730619904)
finish=969.0min speed=11495K/sec

And I'm waiting for it to finish this operation. In the mean time /dev/md1
works fine for both read and write so our file server is happily back
online to much happiness of my colleagues.

Please let me know if I can provide any information useful for debugging
or fixing this issue. I seems to me that something needs to be fixed on
kernel side too (but I'm not really qualified to make such judgments).

I will post again after finishing current reshape operation and adding two
"lost" partitions to array. I believe it will take more than 52 hours to
finish all operations (current reshape will take 16 more hours and two
times 18 hours to add two 750 GB partitions). Will let you know
afterwards.

My thanks are going again to Niel for quick and efficient fix - he is just
living up to his reputation of living legend of programming world.

> I think the correct fix will be to put:
>
>     if (info->reshape_progress > SOME_NUMBER)
> 	return 0;
>
> at the top of Grow_restart.  I just have to review exactly how it
> works to make sure I pick the correct "SOME_NUMBER".
>
> Also
> 		if (__le64_to_cpu(bsb.length) <
> 		    info->reshape_progress)
> 			continue; /* No new data here */
>
> might need to become
> 		if (__le64_to_cpu(bsb.length) <
> 		    info->reshape_progress)
> 			return 0; /* No new data here */
>
> but I need to think carefully about that too.

I'm looking forward to see some new fixes and improvements for this
wonderful piece of software - linux md.

Best regards,
Anton "Ashutosh" Voloshin
Saint Petersburg, Russia (SCSMath)

