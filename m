From: Neil Brown <neilb@suse.de>
Subject: Re: RAID-6 check slow..
Date: Tue, 22 Aug 2006 17:52:04 +1000
Message-ID: <17642.47012.109307.542850@cse.unsw.edu.au>
References: <44EAB1B7.7010208@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Brad Campbell on Tuesday August 22
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday August 22, brad@wasp.net.au wrote:
> G'day all,
> 
> I have a box with 15 SATA drives in it, they are all on the PCI bus and it's a relatively slow machine.
> 
> I can extract about 100MB/s combined read speed from these drives with dd.
> 
> When reading /dev/md0 with dd I get about 80MB/s, but when I ask it to check the array on a 
> completely idle system with echo check > /sys/block/md/md0/sync_action I get a combined read speed 
> across all drives of 31.9MB/s
> 
> I'm not that fussed I guess, given the system does have extended idle periods, it would be nice to 
> have a sync or check complete as quickly as the hardware allows. Experience has shown that a rebuild 
> of a single disk failure takes 10-12 hours but the check seems to take forever
> 
> brad@storage1:~$ cat /proc/mdstat
> Personalities : [raid6]
> md0 : active raid6 sda[0] sdo[14] sdn[13] sdm[12] sdl[11] sdk[10] sdj[9] sdi[8] sdh[7] sdg[6] sdf[5] 
> sde[4] sdd[3] sdc[2] sdb[1]
>        3186525056 blocks level 6, 128k chunk, algorithm 2 [15/15] [UUUUUUUUUUUUUUU]
>        [>....................]  resync =  0.1% (458496/245117312) finish=1881.9min speed=2164K/sec

Hmm....  nothing obvious.
Have you tried increasing 
  /proc/sys/dev/raid/speed_limit_min:1000
just in case that makes a difference (it shouldn't but you seem to be
down close to that speed).

What speed in the raid6 algorithm used - as reported at boot time?
Again, I doubt that is the problem - if should be about 1000 times
speed you are seeing.

What if you try increasing /sys/block/md0/md/stripe_cache_size ?

That's all I can think of for now.

NeilBrown
