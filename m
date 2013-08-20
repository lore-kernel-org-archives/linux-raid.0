From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Small chunk size read performance penalty
Date: Mon, 19 Aug 2013 21:28:43 -0500
Message-ID: <5212D45B.4070505@hardwarefreak.com>
References: <kurge6$qi0$1@ger.gmane.org> <521177A2.2010704@hardwarefreak.com> <kusbkh$il1$1@ger.gmane.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <kusbkh$il1$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/19/2013 12:49 AM, Ian Pilcher wrote:
> On 08/18/2013 08:40 PM, Stan Hoeppner wrote:
>> Can you elaborate on your workload that demonstrates this?  Different
>> workloads behave differently with different chunk sizes.
> 
> dd ... at block sizes between 4KiB and 1MiB, on RAID-5 and -6 arrays
> with chunk sizes in the same range.
> 
> Hardware is 5 7200 RPM SATA drives in a NAS (Thecus N5550) with an Atom
> D2550 processor and an ICH10R chipset.  The drives are all connected to
> the chipset's built-in AHCI controller.
> 
>> If you can see it, then please demonstrate this read penalty with
>> numbers.  You obviously have test data from the same set of disks with
>> two different RAID5s of different chunk sizes.  This is required to see
>> such a difference in performance.  Please share this data with us.
> 
> I've uploaded the data (in OpenDocument spreadsheet form) to Dropbox.  I
> think that it's accessible at this link:
> 
>   https://www.dropbox.com/s/4dq93th4wu5rr2y/nas_benchmarks.ods
> 
> (This is my first attempt at sharing anything via Dropbox, so let me
> know if it doesn't work.)
> 
> I actually find your response really interesting.  From my Interweb
> searching, the "small stripe size read penalty" seems to be pretty
> widely accepted, much as the "large stripe size write penalty" is.  It
> certainly does show up in my data; as the chunk size increases reads of
> even small blocks get faster.

Everything in the world of storage performance depends on the workload.
 The statements above assume an unstated workload, and are so general as
to not be worth repeating, and certainly not putting any stock in.

The former is true of large streaming workloads.  If your workload deals
with small IO reads, such as mail serving, then a small stripe is not
detrimental as the mail file you're reading is almost always smaller
than the stripe size, and often smaller than the chunk size.  Using a
large chunk/stripe with such a workload can create hotspots on some
disks in the array, increasing latency, and decreasing throughput.

However, in this scenario, the big win is in write latency.  A large
chunk/stripe size will generate a huge amount of unnecessary read IO
during RMW cycles to recalculate parity when you write a new mail
message into an existing stripe.  With an optimal chunk/stripe for this
workload, you read few extra sectors during RMW.  It's often very
difficult to get this balance right.  And even if you do, mail workloads
are still many times slower on parity RAID than on mirrors or striped
mirrors (RAID10).  This obviously depends on load.  Even "low end"
modern server hardware with md RAID6 and a handful of disks can easily
handle a few hundred active mail users.  Once you get into the thousands
you'll need mirror based RAID as RMW latency will grind you to a halt.
The same hardware is plenty.  You simply change the RAID level.  You'll
need a couple more disks to maintain total capacity, but simply changing
to mirror based RAID will increase throughput 5-15 fold, and decrease
latency substantially.

Any "large stripe size write penalty" will be a function of mismatching
the workload to the RAID stripe and/or array/drive hardware.  Using a
large stripe with a mail workload will yield poor performance indeed due
to large RMW bandwidth/latency.  Large stripe with this workload
typically means >32-64KB.  Yes, that's stripe, not chunk.  For this
workload using a 6 drive RAID6 you'd want an 8-16KB chunk for a 32-64KB
stripe.  This is the opposite of the meme you quote above.  Again,
workload dependent.

If your workload is HPC file serving, where user files are 10s to 100s
of GB, even TBs in size, then you'd want the largest chunk/strip/stripe
your hardware can perform well with.  This may be as low as 512KB or it
may be as large as 2MB.  And it will likely be hardware based RAID, not
Linux md.

-- 
Stan



