From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: slow 'check'
Date: Sun, 11 Feb 2007 11:30:11 +0200
Message-ID: <5d96567b0702110130u5b404af2y37d27c794d6ddfcc@mail.gmail.com>
References: <45CD5B26.5030707@eyal.emu.id.au>
	 <Pine.LNX.4.64.0702100425150.8446@p34.internal.lan>
	 <45CD9B32.20202@eyal.emu.id.au>
	 <Pine.LNX.4.64.0702100522270.8446@p34.internal.lan>
	 <45CE2C7A.2060106@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45CE2C7A.2060106@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I suggest you test all drives concurrently with dd.
load dd on sda , then sdb slowly one after the other and
see whether the throughput degrades. use iostat.
furtheremore, dd is not the measure for random access.

On 2/10/07, Bill Davidsen <davidsen@tmr.com> wrote:
> Justin Piszcz wrote:
> >
> >
> > On Sat, 10 Feb 2007, Eyal Lebedinsky wrote:
> >
> >> Justin Piszcz wrote:
> >>>
> >>>
> >>> On Sat, 10 Feb 2007, Eyal Lebedinsky wrote:
> >>>
> >>>> I have a six-disk RAID5 over sata. First two disks are on the mobo and
> >>>> last four
> >>>> are on a Promise SATA-II-150-TX4. The sixth disk was added recently
> >>>> and I decided
> >>>> to run a 'check' periodically, and started one manually to see how
> >>>> long it should
> >>>> take. Vanilla 2.6.20.
> >>>>
> >>>> A 'dd' test shows:
> >>>>
> >>>> # dd if=/dev/md0 of=/dev/null bs=1024k count=10240
> >>>> 10240+0 records in
> >>>> 10240+0 records out
> >>>> 10737418240 bytes transferred in 84.449870 seconds (127145468
> >>>> bytes/sec)
> >>>>
> >>>> This is good for this setup. A check shows:
> >>>>
> >>>> $ cat /proc/mdstat
> >>>> Personalities : [raid6] [raid5] [raid4]
> >>>> md0 : active raid5 sda1[0] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1]
> >>>>      1562842880 blocks level 5, 256k chunk, algorithm 2 [6/6] [UUUUUU]
> >>>>      [>....................]  check =  0.8% (2518144/312568576)
> >>>> finish=2298.3min speed=2246K/sec
> >>>>
> >>>> unused devices: <none>
> >>>>
> >>>> which is an order of magnitude slower (the speed is per-disk, call it
> >>>> 13MB/s
> >>>> for the six). There is no activity on the RAID. Is this expected? I
> >>>> assume
> >>>> that the simple dd does the same amount of work (don't we check
> >>>> parity on
> >>>> read?).
> >>>>
> >>>> I have these tweaked at bootup:
> >>>>     echo 4096 >/sys/block/md0/md/stripe_cache_size
> >>>>     blockdev --setra 32768 /dev/md0
> >>>>
> >>>> Changing the above parameters seems to not have a significant effect.
> >>>>
> >>>> The check logs the following:
> >>>>
> >>>> md: data-check of RAID array md0
> >>>> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> >>>> md: using maximum available idle IO bandwidth (but not more than
> >>>> 200000 KB/sec) for data-check.
> >>>> md: using 128k window, over a total of 312568576 blocks.
> >>>>
> >>>> Does it need a larger window (whatever a window is)? If so, can it
> >>>> be set dynamically?
> >>>>
> >>>> TIA
> >>>>
> >>>> --
> >>>> Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
> >>>>     attach .zip as .dat
> >>>
> >>> As you add disks onto the PCI bus it will get slower.  For 6 disks you
> >>> should get faster than 2MB/s however..
> >>>
> >>> You can try increasing the min speed of the raid rebuild.
> >>
> >> Interesting - this does help. I wonder why it used much more i/o by
> >> default before. It still uses only ~16% CPU.
> >>
> >> # echo 20000 >/sys/block/md0/md/sync_speed_min
> >> # echo check >/sys/block/md0/md/sync_action
> >> ... wait about 10s for the process to settle...
> >> # cat /proc/mdstat
> >> Personalities : [raid6] [raid5] [raid4]
> >> md0 : active raid5 sda1[0] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1]
> >>      1562842880 blocks level 5, 256k chunk, algorithm 2 [6/6] [UUUUUU]
> >>      [>....................]  check =  0.1% (364928/312568576)
> >> finish=256.6min speed=20273K/sec
> >> # echo idle >/sys/block/md0/md/sync_action
> >>
> >> Raising it further only manages about 21MB/s (the _max is set to
> >> 200MB/s)
> >> as expected; this is what the TX4 delivers with four disks. I need a
> >> better
> >> controller (or is the linux driver slow?).
> >>
> >>> Justin.
> >
> > You are maxing out the PCI Bus, remember each bit/parity/verify
> > operation has to go to each disk.  If you get an entirely PCI-e system
> > you will see rates 50-100-150-200MB/s easily.  I used to have 10 x
> > 400GB drives on a PCI bus, after 2 or 3 drives, you max out the PCI
> > bus, this is why you need PCI-e, each slot has its own lane of bandwidth.
>
> >
> > 21MB/s is about right for 5-6 disks, when you go to 10 it drops to
> > about 5-8MB/s on a PCI system.
> Wait, let's say that we have three drives and 1m chunk size. So we read
> 1M here, 1M there, and 1M somewhere else, and get 2M data and 1M parity
> which we check. With five we would read 4M data and 1M parity, but have
> 4M checked. The end case is that for each stripe we read N*chunk bytes
> and verify (N-1)*chunk. In fact the data is (N-1)/N of the stripe, and
> the percentage gets higher (not lower) as you add drives. I see no
> reason why more drives would be slower, a higher percentage of the bytes
> read are data.
>
> That doesn't mean that you can't run out of Bus bandwidth, but number of
> drives is not obviously the issue.
>
> --
> bill davidsen <davidsen@tmr.com>
>   CTO TMR Associates, Inc
>   Doing interesting things with small computers since 1979
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Raz
