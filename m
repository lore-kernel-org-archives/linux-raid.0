From: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Subject: Re: Mdadm server eating drives
Date: Mon, 1 Jul 2013 19:17:00 -0500
Message-ID: <CAPSPcXhZosdmKiG-rhQXu+NcNJ2yLjfT1hAor1cCHWi1kM08aA@mail.gmail.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com>
	<51B896A2.9090105@websitemanagers.com.au>
	<CAPSPcXihHrAi2TB9Fuxb1qOGMc_WzwGoXAA7nHdwe2knkO0LkQ@mail.gmail.com>
	<CAPSPcXib4YZ9Ah-jLvL_kPwpKHLxaGT0rNaDL4XQcFm=RtjcAQ@mail.gmail.com>
	<CAPSPcXhn8WKcZMVWhSDBVkRyqwo5XCyDc55f2sgr6davVsN5XA@mail.gmail.com>
	<51BA7B28.9030808@turmel.org>
	<CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com>
	<CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com>
	<CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com>
	<51BB8A67.5000605@turmel.org>
	<51BB8B86.9050803@turmel.org>
	<CAPSPcXi-SZjGusAtL4dj4cNNvovRcNR-uFAwAt7-9G8YRmGHkw@mail.gmail.com>
	<alpine.DEB.2.00.1306180609260.4696@uplift.swm.pp.se>
	<CAPSPcXiXo=pVfmp770==Vvj+yMU1sLMVxNf1dwCoh0At1zz3vQ@mail.gmail.com>
	<51CC72A4.4040508@jungers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51CC72A4.4040508@jungers.net>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am very sorry to keep bugging this list, but I am really lost.

After learning about erc and timeouts the severity of the problem was
reduced to the point that I could atleast get my system back to a
raid6.  I ran a repair and fixed 5477 mismatches, and then a check
showed it clean.  Yet drives continue to give me DRDY statuses.  I
replaced the two that were doing it with WD reds (which my intent is
to only buy from now on).  Then I tried to run a repair again, and my
system crashed, as if the timers were mismatched, but I had set the
driver timeouts on all drives to 180, even the ones with erc to be
safe.  This repair crashed several (3-4) times under these conditions
(usually within a few minutes of starting).  Finally instead of a
repair I ran a check which somehow completed fine and showed zero
mismatches.

I started rsync to verify my data against a backup.  And now 3 drives
are giving me DRDY statuses.  Two of them have REALLY failed out of
the array, giving DRDY DF ERR messages, and don't even show superblock
present from mdadm --examine, so now I'm back to the bare minimum of
my raid6.  One of the two drives that is so bad it lost it's
superblock is one of the WD reds I just bought and installed 5 days
ago.

Any thoughts on what is going on?  I have to ask again if it's
possibly my motherboard is frying the hardware in these drives?



cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]

md0 : active raid6 sdd[6](F) sdc[7] sda[9] sdf[8](F) sdb[0] sde[4]
      7813531648 blocks super 1.2 level 6, 512k chunk, algorithm 2
[6/4] [U__UUU]

unused devices: <none>

sudo mdadm -D /dev/md0 | nopaste
http://pastie.org/8101687

sudo mdadm --examine /dev/sd[a-f] 2>&1 | nopaste
http://pastie.org/8101681


sudo smartctl -x /dev/sda | nopaste
http://pastie.org/8101691

sudo smartctl -x /dev/sdb | nopaste
http://pastie.org/8101693

sudo smartctl -x /dev/sdc | nopaste
http://pastie.org/8101694

sudo smartctl -x /dev/sdd | nopaste
http://pastie.org/8101695

sudo smartctl -x /dev/sde | nopaste
http://pastie.org/8101696

sudo smartctl -x /dev/sdf | nopaste
http://pastie.org/8101697

for x in /sys/block/sd[a-f]/device/timeout ; do echo $x $(< $x); done
/sys/block/sda/device/timeout 180
/sys/block/sdb/device/timeout 180
/sys/block/sdc/device/timeout 180
/sys/block/sdd/device/timeout 180
/sys/block/sde/device/timeout 180
/sys/block/sdf/device/timeout 180






On Thu, Jun 27, 2013 at 12:13 PM, Nicolas Jungers <nicolas@jungers.net> wrote:
> On 06/27/2013 02:23 AM, Barrett Lewis wrote:
>>
>> Everything is going well, I am just trying to replace the parts that
>> are on the way out.
>> I ran a 'repair' and it came out with 5477 under
>> /sys/block/md0/md/mismatch_cnt.  Then a 'check' came out with 0.
>>
>> Then I went out and bought a couple WD Reds (I'm done with greens now
>> that I know they lack ERC).  I replaced one of the two drives Phil
>> said was not ok, which had many reallocations (I can personally see
>> those) in the smart status.  I then ran another repair to be safe.  It
>> came up with 0 mismatches, but in the process /dev/sda started giving
>> me tons (and tons and tons, rolled over dmesg) of these "failed
>> command: READ FPDMA QUEUED status: { DRDY ERR } error: { UNC }"
>> errors. sda hadn't been giving me problems before but I'll come back
>> to it.
>>
>> The second disk Phil said was "not ok" was this one which showed
>> "several pending errors".
>> (original smart status) http://pastie.org/8040852
>> I was going to replace it with my second spare Red, but the errors
>> seem to have gone away.
>> (current smart status) http://pastie.org/8084278
>> Or maybe I am looking in the wrong place to find the pending errors
>> (looking at "197 Current_Pending_Sector").  Is the drive currently in
>> need of replacement?  I'm not sure what I'm looking for.
>>
>> What about this one (sda), after it gave all of those errors during a
>> repair?  http://pastie.org/8084292
>> I get the "5 Reallocated_Sector_Ct", but where do you find pending errors?
>>
>> What does it mean to get all these "failed command: READ FPDMA QUEUED
>> status: { DRDY ERR } error: { UNC }" errors and the smart status seems
>> to be fine even after a repair?
>
>
> Have you considered that your SATA may be faulty? I had consistent bad
> experiences with "cheap" SATA cables. I also use exclusively now cables with
> latches. I said "cheap" because the price is not an absolute criteria,
> quality of sourcing is more important in my experience.
>
> Regards,
> N.
>
>
>>
>> Thanks everyone, I'm learning a lot.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
