From: Neil Brown <neilb@suse.de> (by way of Neil Brown <neilb@suse.de>)
Subject: Re: Horrible mirror write performance, alignment?
Date: Thu, 29 Apr 2010 14:09:31 +1000
Message-ID: <20100429140931.0b12b835@notabene.brown>
References: <20100428064059.GC2119@tracyreed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100428064059.GC2119@tracyreed.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tracy Reed <treed@ultraviolet.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 27 Apr 2010 23:41:00 -0700
Tracy Reed <treed@ultraviolet.org> wrote:

> 
> Anyone know why my mirror devices would be doing (apparently)
> unaligned writes to my ethernet SAN causing horrible performance and
> massive seeking and lots of reading? BUT writing to the device
> directly is very fast and no extra reads? I am measuring the
> reads/writes on the SAN device in iostat as it is a Linux box.
> 
> I am running the 2.6.18-164.11.1.el5xen xen/kernel which came with
> CentOS 5.4
> 
> After spending a lot of time banging my head on this I seem to have
> finally tracked it down to mirroring.  I never would have thought it
> would be this but it is extremely reproduceable. We're talking a
> difference of 4-5x in write speed.  Reads are equally fast everywhere.
> 
> I am using AoE v72 kernel module (initiator) on a Dell R610's to talk
> to vblade-19 (target) on Dell R710's all running CentOS 5.4. I have
> striped two 7200 RPM SATA disks and exported the md with AoE (although
> I have done these tests with individual disks also). Read performance
> from a raw device is excellent:
> 
> # dd of=/dev/null if=/dev/xvdg1 bs=4096 count=3000000
> 3000000+0 records in
> 3000000+0 records out
> 12288000000 bytes (12 GB) copied, 106.749 seconds, 115 MB/s
> 
> or from a mirror:
> 
> # dd if=foo of=/dev/null bs=4096
> 1073916+0 records in
> 1073916+0 records out
> 4398759936 bytes (4.4 GB) copied, 37.7441 seconds, 117 MB/s
> 
> foo is a 4.4G file I created in the filesystem.
> 
> I always dropped the cache with:
> 
> echo 1 > /proc/sys/vm/drop_caches
> 
> on both target and initiator before starting the test. This is great
> for just a single gig-e link. This suggests that the network/SAN is
> fine.
> 
> And iostat shows only writes and no reads happening.
> 
> However, write performance to a mirror is odious. Typically around
> 20MB/s.  
> 
> # dd if=/dev/zero of=foo bs=4096 count=3000000
> 1724073+0 records in
> 1724073+0 records out
> 7061803008 bytes (7.1 GB) copied, 324.606 seconds, 21.8 MB/s
> 
> It should be more like 70MB/s per disk or better (7200rpm SATA) and
> max out my gig-e with write performance similar to the above read
> performance. I mentioned above that I suspect these are somewhow
> unaligned writes because when running iostat on the target machine I
> can see lots of reads happening which are surely causing seeks and
> killing performance. Typical is something like 8MB/s of reads while
> doing 16MB/s of writes.
> 
> I have tried manually aligning the disk by setting the beginning of
> data on the partition from 63 to 64 (although I don't think this
> should matter for a mirror as much as a stripe or raid5, right?)  and I have
> tried changing the disk geometry to account for the extra partition
> table which causes a half-block page-cache misalignment as described
> by the ever insightful Kelsey Hudson in his writeup on the issue here:
> 
> http://copilotco.com/Virtualization/wiki/aoe-caching-alignment.pdf/at_download/file
> 
> All to no avail. It remains that whenever I write to the mirrored
> disks performance is terrible but when I write to each individual
> block device with a filesystem on it performance is good. It seems to
> point to some sort of problem with the mirroring. 
> 
> Any ideas or suggestions would be very appreciated very much.
> 

It is always good to provide lots of concrete details, like "mdadm -D" of
all arrays, and "cat /proc/mdstat", etc.
I'm guessing that you have an internal bitmap enabled.  Maybe you
want to try removing it and recreating it with a much larger bitmap
chunk size.
  mdadm -G /dev/md0 --bitmap none
  mdadm -G /dev/md0 --bitmap internal --bitmap-chunk 65536

NeilBrown
