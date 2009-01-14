From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: southbridge/sata controller performance?
Date: Wed, 14 Jan 2009 17:34:36 -0500
Message-ID: <496E687C.90603@tmr.com>
References: <20090103193429.GA17462@sewage.raw-sewage.fake> <495FC67A.2030201@gmail.com> <alpine.DEB.1.10.0901040451520.18797@p34.internal.lan> <20090104194023.GB10174@sewage.raw-sewage.fake> <496123ED.5050809@gmail.com> <20090105032728.GA24328@sewage.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090105032728.GA24328@sewage.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Roger Heflin <rogerheflin@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matt Garman wrote:
> On Sun, Jan 04, 2009 at 03:02:37PM -0600, Roger Heflin wrote:
>   
>> Yes, that is valid, so long as the md device is fairly quiet at
>> the time of the test.  Since you already have a machine, please
>> post the mb type, and number/type of sata ports and the 1-disk,
>> 2-disk, 3-disk,... numbers that you get.
>>     
>
> I attached a little Perl script I hacked up for running many
> instances of dd in parallel or individually.  It takes one or more
> block devices on the command line, and issues parallel dd reads for
> each one.  (Note my block size and count params are enormous; I made
> these huge to avoid caching effects of having 4 GB of RAM.)
>
> I have two MD arrays in my system:
>
> $ cat /proc/mdstat 
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
> md1 : active raid5 sdb1[0] sdd1[3] sdc1[2] sde1[1]
>       2930279808 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
>             
> md0 : active raid5 sdf1[0] sdi1[3] sdh1[2] sdg1[1]
>       2197715712 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
>             
> unused devices: <none>
>
>
> This is on Ubuntu server 8.04.  Hardware is an Intel DQ35JO
> motherboard (Q35/ICH9DO chipsets) with 4 GB RAM and an E5200 CPU.
>
>     - md1 has four WD RE2 GP 1 TB hard drives (the 5400 RPM ones).
>       These are drives are connected to two 2-port PCIe SATA add-on
>       cards with the Silicon Image 3132 controller.
>
>     - md0 has four WD 750 GB drives (neither "RE2" version nor
>       GreenPower).  These drives are connected directly to the
>       on-board SATA ports (i.e. ICH9DO).
>
> For md1 (RE2 GP drives on SiI 3132), it looks like I get about 80
> MB/s when running dd on one drive:
>
> $ sudo ./sata_performance.pl /dev/sd[b]
> /dev/sdb: 13107200000 bytes (13 GB) copied, 163.757 s, 80.0 MB/s
>
> With all four drives, it only drops to about 75 MB/s per drive:
>
> $ sudo ./sata_performance.pl /dev/sd[bcde]
> /dev/sdb: 13107200000 bytes (13 GB) copied, 171.647 s, 76.4 MB/s
> /dev/sde: 13107200000 bytes (13 GB) copied, 172.052 s, 76.2 MB/s
> /dev/sdd: 13107200000 bytes (13 GB) copied, 172.737 s, 75.9 MB/s
> /dev/sdc: 13107200000 bytes (13 GB) copied, 172.777 s, 75.9 MB/s
>
> For md0 (4x750 GB drives), performance is a little better; these
> drives are definitely faster (7200 rpm vs 5400 rpm), and IIRC, the
> SiI 3132 chipsets are known to be lousy performers.
>
> Anyway, single drive performance is just shy of 100 MB/s:
>
> $ sudo ./sata_performance.pl /dev/sd[f]
> /dev/sdf: 13107200000 bytes (13 GB) copied, 133.099 s, 98.5 MB/s
>
> And I lose virtually nothing when running all four disks at once:
>
> $ sudo ./sata_performance.pl /dev/sd[fghi]
> /dev/sdi: 13107200000 bytes (13 GB) copied, 130.632 s, 100 MB/s
> /dev/sdf: 13107200000 bytes (13 GB) copied, 133.077 s, 98.5 MB/s
> /dev/sdh: 13107200000 bytes (13 GB) copied, 133.411 s, 98.2 MB/s
> /dev/sdg: 13107200000 bytes (13 GB) copied, 138.481 s, 94.6 MB/s
>
> Read performance only drops a bit when reading from all eight
> drives:
>
> $ sudo ./sata_performance.pl /dev/sd[bcdefghi]
> /dev/sdi: 13107200000 bytes (13 GB) copied, 133.086 s, 98.5 MB/s
> /dev/sdf: 13107200000 bytes (13 GB) copied, 135.59 s, 96.7 MB/s
> /dev/sdh: 13107200000 bytes (13 GB) copied, 135.86 s, 96.5 MB/s
> /dev/sdg: 13107200000 bytes (13 GB) copied, 140.215 s, 93.5 MB/s
> /dev/sdb: 13107200000 bytes (13 GB) copied, 182.402 s, 71.9 MB/s
> /dev/sdc: 13107200000 bytes (13 GB) copied, 183.234 s, 71.5 MB/s
> /dev/sdd: 13107200000 bytes (13 GB) copied, 189.025 s, 69.3 MB/s
> /dev/sde: 13107200000 bytes (13 GB) copied, 189.517 s, 69.2 MB/s
>
>
> Note: in all the above test runs, I actually ran them all three
> times to catch any variance; all runs were consistent.
>   

There are several things left out here. First, you didn't say you 
dropped caches with
  echo 1 >/proc/sys/vm/drop_caches
before you start. And running dd as a test, using the "iflag=direct" 
will allow you to isolate the effect of the system cache on i/o performance.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


