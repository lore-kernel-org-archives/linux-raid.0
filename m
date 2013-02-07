From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Thu, 07 Feb 2013 17:51:59 +1100
Message-ID: <51134F0F.607@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51134E43.7090508@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry, graphs can be seen at:

http://203.98.89.64/graphs/


On 07/02/13 17:48, Adam Goryachev wrote:
> Hi all,
>
> I'm trying to resolve a significant performance issue (not arbitrary dd
> tests, etc but real users complaining, real workload performance).
>
> I'm currently using 5 x 480GB SSD's in a RAID5 as follows:
> md1 : active raid5 sdf1[0] sdc1[4] sdb1[5] sdd1[3] sde1[1]
>       1863535104 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5]
> [UUUUU]
>       bitmap: 4/4 pages [16KB], 65536KB chunk
>
> Each drive only has a single partition, and is partitioned a little
> smaller than the drive (supposedly this should improve performance).
> Each drive is set to the deadline scheduler.
>
> Drives are:
> Intel 520s MLC 480G SATA3
> Supposedly Read 550M/Write 520M
>
> I think the workload being generated is simply too much for the
> underlying drives. I've been collecting the information from
> /sys/block/<drive>/stat every 10 seconds for each drive. What makes me
> think the drives are overworked is that the backlog value gets very high
> at the same time the users complain about performance.
>
> The load is a bunch of windows VM's, which were working fine until
> recently when I migrated the main fileserver/domain controller on
> (previously it was a single SCSI Ultra320 disk on a standalone machine).
> Hence, this also seems to indicate a lack of performance.
>
> Currently the SSD's are connected to the onboard SATA ports (only SATA II):
> 00:1f.2 SATA controller: Intel Corporation Cougar Point 6 port SATA AHCI
> Controller (rev 05)
>
> There is one additional SSD which is just the OS drive also connected,
> but it is mostly idle (all it does is log the stats/etc).
>
> Assuming the issue is underlying hardware, then I'm thinking to do the
> following:
> 1) Get a battery backed RAID controller card (which should improve
> latency because the OS can pretend it is written while the card deals
> with writing it to disk).
> 2) Move from a 5 disk RAID5 to a 8 disk RAID10, giving better data
> protection (can lose up to four drives) and hopefully better performance
> (main concern right now), and same capacity as current.
>
> The real questions are:
> 1) Is this data enough to say that the performance issue is due to
> underlying hardware as opposed to a mis-configuration?
> 2) If so, any suggestions on specific hardware which would help?
> 3) Would removing the bitmap make an improvement to the performance?
>
> Motherboard is Intel S1200BTLR Serverboard - 6xSATAII / Raid 0,1,10,5
>
> It is possibly to wipe the array and re-create that would help.......
>
> Any comments, suggestions, advice greatly received.
>
> Thanks,
> Adam
>


-- 
Adam Goryachev
Website Managers
Ph: +61 2 8304 0000                            adam@websitemanagers.com.au
Fax: +61 2 8304 0001                            www.websitemanagers.com.au

