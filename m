From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: Odd (slow) RAID performance
Date: Mon, 4 Dec 2006 18:33:19 -0700
Message-ID: <e9c3a7c20612041733h5999ac0erc7ab4a7174882683@mail.gmail.com>
References: <456F4872.2090900@tmr.com>
	 <20061201092211.4ACDB12EDE@bluewhale.planbit.co.uk>
	 <45710EDC.9050805@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45710EDC.9050805@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Roger Lucas <roger@planbit.co.uk>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On 12/1/06, Bill Davidsen <davidsen@tmr.com> wrote:
> Thank you so much for verifying this. I do keep enough room on my drives
> to run tests by creating any kind of whatever I need, but the point is
> clear: with N drives striped the transfer rate is N x base rate of one
> drive; with RAID-5 it is about the speed of one drive, suggesting that
> the md code serializes writes.
>
> If true, BOO, HISS!
>
> Can you explain and educate us, Neal? This look like terrible performance.
>
Just curious what is your stripe_cache_size setting in sysfs?

Neil, please include me in the education if what follows is incorrect:

Read performance in kernels up to and including 2.6.19 is hindered by
needing to go through the stripe cache.  This situation should improve
with the stripe-cache-bypass patches currently in -mm.  As Raz
reported in some cases the performance increase of this approach is
30% which is roughly equivalent to the performance difference I see of
a 4-disk raid5 versus a 3-disk raid0.

For the write case I can say that MD does not serialize writes.  If by
serialize you mean that there is 1:1 correlation between writes to the
parity disk and writes to a data disk.  To illustrate I instrumented
MD to count how many times it issued a write to the parity disk and
compared that to how many writes it performed to the member disks for
the workload "dd if=/dev/zero of=/dev/md0 bs=1024k count=100".  I
recorded 8544 parity writes and 25600 member disk writes which is
about 3 member disk writes per parity write, or pretty close to
optimal for a 4-disk array.  So, serialization is not the cause,
performing sub-stripe width writes is not the cause as >98% of the
writes happened without needing to read old data from the disks.
However, I see the same performance on my system, about equal to a
single disk.

Here is where I step into supposition territory.  Perhaps the
discrepancy is related to the size of the requests going to the block
layer.  raid5 always makes page sized requests with the expectation
that they will coalesce into larger requests in the block layer.
Maybe we are missing coalescing opportunities in raid5 compared to
what happens in the raid0 case?  Are there any io scheduler knobs to
turn along these lines?

Dan
