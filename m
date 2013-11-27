From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Raid10 multi core scaling
Date: Wed, 27 Nov 2013 00:52:36 -0600
Message-ID: <529596B4.6020803@hardwarefreak.com>
References: <20131126105859.Horde.-ppIIPYRo99SlH7zGogGx_A@webmail.aeiou.pt>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131126105859.Horde.-ppIIPYRo99SlH7zGogGx_A@webmail.aeiou.pt>
Sender: linux-raid-owner@vger.kernel.org
To: Pedro Teixeira <finas@aeiou.pt>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/26/2013 4:58 AM, Pedro Teixeira wrote:
>    I created a Raid10 array with 16 sata 1TB disks and the array
> performance
> seems to be limited by the md0_raid10 taking 99% of one core and not
> scalling to other cores. 

The md RAID 5/6/10 drivers have a single write thread.  If you push
enough write IO you will peak one CPU core and hit a wall.  An effort is
currently underway to make use of multiple write threads, but this code
is not ready yet.

I tried overclocing the cpu cores and this lead to
> a small increase in performance ( but md0_raid10 keeps eating 99% of one
> core ).
> 
>    I'm using:
>     - a phenom X6 at 3600mhz
>     - 16 seagate SSHDs ( sata3 7200RPM with 8GB ssd cache )

So with this hardware you'll peak one CPU core until you've written
somewhere around 64GB, at which point you will have saturated the flash
cache on the drives.  After this point you should see a change from
being CPU bound to being disk bound, as you're writing at spindle speed.
 4x Marvell 88SE9230 based HBAs w/PCIe 2.0 x2 interfaces limit you to
4GB/s read/write throughput to flash cache.  The drives spindle
performance limits you to 2GB/s.  So somewhere in between 2-4GB/s your
3.6GHz Phenom core is running out of juice.

You should not be CPU/thread limited while reading, as reads are not
limited to a single thread.  With a pure streaming read you should be
able to get close to 4GB/s throughput, and you'll see multiple cores in
play, but the work is being done by other kernel IO threads, not the md
thread.

>    what I did to test performance was to force a check on the array, and
> this

This only tells you the behavior of resync, not a normal workload.

> leads to mdadm reporting a speed of about 990000K/sec. The hard disks
> report a 54% utilization. ( Overclocking the cpu by 200mhz increases the
> resync speed a bit and the hdd's utilizartion to about 58% )
> 
>    If I do the same with a raid5 array instead of raid10, them resync
> speed
> will be almost double of raid10, the harddisk utilization reported will be
> 98-100% and I can see at least two cores being used.

This is an apples to oranges comparison, so saying resync speed of RAID5
is double that of RAID10 doesn't mean anything.  Also, the RAID5 core
utilization you see is due to RAID5 using a second core for parity
calculations.

If you want RAID10 and you're hitting a wall at one core, your best
option currently is to build 8 RAID1 devices and build a RAID0 device of
these.  If resync is your preferred test method then you'd fire up 8
resyncs of the 8 RAID1 devices, in parallel, then sum the run times.
You can't resync a RAID0 device.  The total run time should be
significantly lower than using md/RAID10 or md/RAID5.  And you'll see
multiple cores in play, all of them actually, because you'll have 8
RAID1 devices and 6 cores.  But the utilization per core will be quite low.

There are other options to get around the core saturation problem.  You
could create multiple md/RAID10 arrays and lay a stripe over them or
concatenate them, such as a 2x8 or 4x4.  But you really must know what
you're doing to get the nested striping right, or properly layout XFS
AGs on a concatenation.  If not done properly performance could be worse
than what you have now.

Given the stripe over mirrors gets all cores in play, and doesn't have
such pitfalls, it's the better option by far.

-- 
Stan
