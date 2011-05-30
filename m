From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Optimizing small IO with md RAID
Date: Mon, 30 May 2011 16:21:39 -0500
Message-ID: <4DE40A63.5080204@hardwarefreak.com>
References: <BANLkTi=236kncpunzodSci-1K33u_FBkPA@mail.gmail.com>	<irvuj1$rc3$1@dough.gmane.org>	<4DE38628.1050201@anonymous.org.uk>	<is04s2$2rn$1@dough.gmane.org> <BANLkTikw9cqfhHAVaxZ2T2EErroCMT5Zow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikw9cqfhHAVaxZ2T2EErroCMT5Zow@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "fibreraid@gmail.com" <fibreraid@gmail.com>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/30/2011 10:24 AM, fibreraid@gmail.com wrote:
> Hi All,
> 
> I appreciate the feedback but most of it seems around File System
> recommendations or to change to parity-less RAID, like RAID 10. In my
> tests, there is no file system; I am testing the raw block device as I
> want to establish best-numbers there before layering on the file
> system.

You're not performing valid taste case.  You will always have a
filesystem in production.  The performance of every md raid level plus
filesystem plus hardware combination will be different, and thus they
must be tuned together, not each in isolation, especially in the case of
SSDs.   Case in point:  slap EXT2 on your current array setup and then
XFS.  Test each with file based IO.  You'll see XFS has radically
superior parallel IO performance compared to EXT2.  Tweaking the array
setup will not yield significant EXT2 speedup for parallel IO.

Disk striping was invented 2+ decades ago to increase performance of
slow spindles for large file reads and writes, but the performance is
very low for small file IO due to partial stripe width operations taking
many of your spindles out of play, decreasing parallelism.  Adding
parity to the striping exacerbates this problem.  This is the classic
trade off between performance and redundancy.

SSDs have no moving parts, and natively have extremely high IOPS and
throughput rates, each SSD having on the order of 150x the seek rate of
a mech drive, and 2-3x the streaming throughput rate.  Thus, striping is
irrelevant to SSD performance, and, as you've seen, will degrade small
file performance due to partial width writes etc.

If you truly want to maximize real world performance of those 24 SSDs,
take one of your striped RAID configurations and format it with XFS
using the defaults.  Then run FIO with highly parallel file based IO
tests, i.e. two to four worker threads per CPU core.  Then delete the
array and create the linear setup I previously recommended and run the
same tests.  When comparing the  results I think you'll begin to see why
I recommend this setup for both highly parallel small and large file IO.
 Your large file IO numbers may be a little smaller with this setup, but
you should be able to play with chunk size to achieve the best balance
with both small and large file IO.

Regardless of chunk size, you should still see better overall parallel
IOPS and throughput than with striping, especially parity striping.  If
you need redundancy and maximum parallel performance, and can afford to
'waste' SSDs, create 12 RAID1 devices and make a linear array of the 12,
giving XFS 12 allocation groups.  For parallel small file workloads this
will yield better performance than RAID10 for the same cost of device
space.  Large file parallel performance should be similar.

-- 
Stan
