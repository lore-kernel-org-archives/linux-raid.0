From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is this expected RAID10 performance?
Date: Thu, 06 Jun 2013 22:25:35 -0500
Message-ID: <51B152AF.90101@hardwarefreak.com>
References: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNH4eFyshhhohw0wQ13j98BTRELTiWF9uDLp3vmFsOEfwQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/6/2013 6:52 PM, Steve Bergman wrote:
> I have a Dell T310 server set up with 4 Seagate ST2000NM0011 2TB
> drives connected to the 4 onboard SATA (3Gbit/s) ports of the
> motherboard. Each drive is capable of doing sequential writes at
> 151MB/s and sequential reads at 204MB/s according to bonnie++. I've
> done an installation of Scientific Linux 6.4 (RHEL 6.4) and let the
> installer set up the RAID10 and logical volumes. What I got was a
> RAID10 device with a 512K chunk size, and ext4 extended options of
> stride=128 & stripe-width=256, with a filesystem block size of 4k. All
> of this seems correct to me.

If this is vanilla RAID10, not one of md's custom layouts, then a 512K
chunk gives an EXT4 stride of 512K and stripe-width of 1MB.  So your
parameters don't match.  Fix your EXT4 alignment to match the array.

> But when I run bonnie++ on the array (with ext4 mounted
> data=writeback,nobarrier)  I get a sequential write speed of only
> 160MB/s, and a sequential read speed of only 267MB/s. I've verified
> that the drives' write caches are enabled.

So with md/RAID10 you're getting about half of bonnie++ single disk+EXT4
throughput.

> "sar -d" shows all 4 drives in operation, writing 80MB/s during the
> sequential write phase, which agrees with the 160MB/s I'm seeing for
> the whole array. (I haven't monitored the read test with sar.)
> 
> Is this about what I should expect? I would have expected both read
> and write speeds to be higher. As it stands, writes are barely any
> faster than for a single drive. And reads are only ~30% faster.

It's not uncommon to see individual drive throughput in md that is less
than a single drive.  There are a number of things that affect this,
including the benchmarks themselves, the number of concurrent threads
issuing IOs (i.e. you need overlapping IO), the Linux tunables in
/sys/block/sdX/queue/.  One of the most important is the elevator.  CFQ,
typically the default, will yield sub optimal throughput with arrays,
hard or soft.  With md and no HBA BBWC you'll want to use deadline.  If
your bonnie test is using X threads for a single drive test then double
that amount for your RAID10 test as you have 2x as many data spindles.

What md/RAID10 layout did the installer choose for you?
Does throughput improve when you change the EXT4 alignment?
Have you performed any other throughput testing other than bonnie?
Are you using buffered IO or O_DIRECT?

One last note.  Test with parameters you will use in production.  Do not
test with barriers disabled.  You need them in production to prevent
filesystem corruption.  The point of benchmarking isn't to determine the
absolute maximal throughput of the hardware.  The purpose is to
determine how much of that you can actually get with your production
workload.

-- 
Stan

