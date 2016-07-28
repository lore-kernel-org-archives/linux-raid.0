From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID5 Performance
Date: Fri, 29 Jul 2016 00:10:16 +1000
Message-ID: <0eee845d-b833-0a92-8fe6-a2522218a0e6@websitemanagers.com.au>
References: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
 <CAFx4rwR0+wR_0GXh3Y7j1hZyv0_Gy7b4OD-D2+bfxV9MRp+b3Q@mail.gmail.com>
 <7af0cc98-e395-9446-05eb-a6c0ca20f187@websitemanagers.com.au>
 <CAFx4rwTMySfR27gT6You7f2T28Hq8m5Zxme1p43Fv1vtcpt_-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwTMySfR27gT6You7f2T28Hq8m5Zxme1p43Fv1vtcpt_-Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 28/07/2016 10:11, Doug Dumitru wrote:
> On Wed, Jul 27, 2016 at 4:25 PM, Adam Goryachev
> <mailinglists@websitemanagers.com.au> wrote:
>>
>> On 27/07/2016 15:36, Doug Dumitru wrote:
>>
>> On Tue, Jul 26, 2016 at 7:24 PM, Adam Goryachev
>> <mailinglists@websitemanagers.com.au> wrote:
>>
>> Hi all,
>>
>> I know, age old question, but I have the chance to change things up a bit,
>> and I wanted to collect some thoughts/ideas.
>>
>> Currently I am using 8 x 480GB Intel SSD in a RAID5, then LVM on top, DRBD
>> on top, and finally iSCSI on top (and then used as VM raw disks for mostly
>> windows VM's).
>>
>>
>> This should help your raid-5 array, at least noticeably, provided the
>> new kernel actually has the
>> Facebook Read/Modify/Write new logic included.  Based on the version
>> it should.  You can very this by doing random writes and looking at
>> iostat.  If you see 2 reads and 2 writes for every inbound write, you
>> have the new code.  If you see 6 reads and 2 writes for every inbound
>> write, you have the old code.
>>
>> While this sounds huge, the change will be moderated by the behaviour
>> of SSDs.  Random writes are much more expensive than read and the new
>> logic only lowers the number of reads.  ... and raid-6 is not impacted
>> at all.
Will definitely try this, it seems a pretty simple low-cost, and pretty 
low risk option.
>> The stripe size impacts when the system does can avoid doing a
>> read/modify/write.  If you write a full stripe [ 64K * (n-1) ], and
>> the write is exactly on a stripe boundary, and you get lucky and the
>> background thread does not wake up at just the wrong time, you will do
>> the write with zero reads.  I personally run with very small chunks,
>> but I have code that always writes perfect stripe writes and stock
>> file systems don't act that way.
>>
>> So reducing the chunk size will have minimal impact... but reducing it
>> should still provide some performance boost. Since I'm recreating the array
>> anyway, what size makes the most sense? 16k or go straight to the minimum of
>> 4k? Would a smaller chunk size increase the IOPS because we need to make
>> more (smaller) requests for the same data, potentially from more drives?
>>
>> ie, currently, a single read request for 4k will be done by reading one
>> chunk (64k) from one of the 8 drives (1 IOPS)
>> currently, a single write request for 4k will be done by reading one chunk
>> (64k) from 6 drives, and then writing one chunk (64k) to two drives (8 IOPS)
>> However, a read (or write) 48k request would be identical to the above,
>> while a smaller chunk size (4k) would mean:
>> read request - reading 2 x 4k chunks from 5 disks and 1 x 4k chunk from 2
>> disks (7 IOPS)
>> write request - write 8 x 4k (full stripe) (assuming it is stripe aligned
>> somewhere, but it might not be)
>>                        - read 2 x 4k chunks (the only 2 data chunks that
>> won't be written) + write 6 x 4k chunks
>> Total of 16 IOPS in the best case, worst case is two partial stripe writes +
>> 1 full stripe write in the middle: 8 reads + 16 writes or 24 IOPS.
> You are confused about what chunk size is.  It is not the IO size
> limit.  It is just a layout calculation.  If your chunk is 64K, then
> 64K is written to one disk before the array moves on to the next disk.
> If you read 4K, then only 4K is read.  You never need to read (or
> write) and entire chunk.
>
> Lower chunk sizes are useful if your application does enough long
> writes to reach full stripes.  At 64K x 7 drives, this is 448KB.  If
> you are writing multi-megabytes, then 64K chunks is a good idea.  If
> you are writing 128KB, you might want to go down to 16KB chunks.  The
> problem with little chunks is if you read 64K from and array with 16KB
> chunks, you will cut your IO request into four parts.  This is
> sometimes faster and sometimes slower.  For hard disks, bigger chunks
> seems to be the way to go.  For SSDs, smaller.  I think 16K is
> probably the lowest reasonable limit unless you have tested your
> workload extensively, and over a long period of time, and have looked
> at drive wear issues.;
I'm not sure here.... since my issue seems to be IOPS, wouldn't 
splitting a single IOP (ie, in your example the 64k read) into 4 IOPS (4 
x 16k reads), which would seem to exacerbate the issue (not enough IOPS 
available).

In which case, it could be beneficial to move to larger chunk sizes, so 
even a 128k request can be kept as a single IOP instead of split into 2 
? though there must also be an upper limit on the benefits here too?

At the moment, I'm thinking I will just leave the chunk size the same....
>> Either the above is wrong, or I've just convinced myself that reducing the
>> chunk size is not a good idea...
>>
>> DRBD can saturate GigE without any problem with random 4K writes.  I
>> have a pair of systems here that pushes 110 MB/sec at 4K or 28,000
>> IOPS.  The target arrays needs to keep up, but that is another story.
>> My testing with DRBD is that it starts to peter out at 10Gig, so if
>> you want more bandwidth you need some other approach.  Some vendors
>> use SRP over Infiniband with software raid-1 as a mirror.  iSCSI with
>> iSER should give you similar results with RDMA capable ethernet.
>> Linbit (the people who write DRBD) have a non GPL extension to DRBD
>> that uses RDMA so you can get more bandwidth that way as well.
>>
>> I have 10G ethernet for the crossover between the two servers, and another
>> 10G ethernet to connect off to the "clients". Bandwidth utilisation on
>> either of these is rather low (I think it maxed out at around 15 to 20%)
>> definitely not anywhere near 100%. My thought here was on the latency of the
>> connection, but I really didn't have any ideas on how to measure that, and
>> how to test if it would really help. Also equipment seems a little less
>> common, and complex...
> I know that DRBD will not hit 40G.  I have actually not done that much
> testing at 10G.

My concern is that even if I solve *this* bottleneck (ie, the 530 model 
SSD being too busy), that there will be another bottleneck afterwards 
(well, of course there will be, there is always one piece that is 
limiting performance). How will I know what/where it is (assuming it 
isn't the SSD/raid itself....).
>> The drives report a sector size of 512k, which I guess means the smallest
>> meaningful write that the drive can do is 512k, so should I increase the
>> chunk size to 512k to match? Or does that make it even worse?
>> Finally, the drive reports Host_Writes_32MiB in SMART, does that mean that
>> the drive needs to replace a entire 32MB chunk in order to overwrite a
>> sector? I'm guessing a chunk size of 32M is just crazy though...
>>
>> This is probably not true.  If the drive really had to update 512K at
>> a time, then 4K writes would be 128x wear amplification.  SSDs can be
>> bad, but usually not that bad.
>>
>> Is there a better way to actually measure the different sizes and quantity
>> of read/writes being issued, so that I can make a more accurate decision on
>> chunk size/stripe size/etc... iostat seems to show an average numbers, but
>> not the number of 1k read/write, 4k read/write, 16k read/write etc...
>>
>> The problem is that the FTL of the SSDs are a black box and as the
>> array gets bigger, the slowest drive dictates the array performance.
>> This is why the "big vendors" all map SSDs in the host and avoid or
>> minimize writing randomly.  I know of one vendor install that has 4000
>> VDI seats (using ESXI as compute hosts) from a single HA pair of 24
>> SSD shelves.  The connection to ESXI is FC and the hosts are HA with
>> an IB/SRP raid-1 link between them.  Unfortunately, you need 500K+
>> random write IOPS to pull this off, which I think is impossible with
>> stock parity raid, and very hard with raid-10.
>>
>>
>> My environment is rather small in comparison, it is only around 20 VM's
>> supporting around 80 users. 5 of the VM's are RDP servers.
>>
>>
>> My suspicion is that the actual load is made up of rather small random
>> read/write, because that is the scenario that produced the worst performance
>> results when I was initially setting this up, and seems to be what we are
>> getting in practice.
>>
>> The last option is, what if I moved to RAID10? Would that provide a
>> significant performance boost (completely removes the need to worry about
>> chunk/stripe size because we always just write the exact data we want, no
>> need to read/compute/write)?
>>
>> RAID-10 will be faster, but you pay for this with capacity.  It is
>> also a double-edged sword as SSDs themselves run faster if you leave
>> more free space on them, so RAID-10 absolutely might not be a lot
>> faster than RAID-5 with some space left over.  Also remember that free
>> space on the SSDs only counts if it is actually unallocated.  So you
>> need to trim the SSDs or start with a secure erased drive and then
>> never use the full capacity.  It is best to leave an empty partition
>> that is untouched.
>>
>> Good point, when I initially provisioned the drives, I only used the first
>> 400GB, and left 80GB on each drive unpartitioned. As we ran out of space, I
>> was forced to allocate all of it. The place is to only end up with 960GB of
>> each 1000GB drive in use, so I could again leave a small chunk of
>> un-allocated space.
>>
>> OR, is that read/compute overhead negligible since I'm using SSD and read
>> performance is so quick?
>>
>> The reads, especially with the pre 4.4 code or with raid-6 definitely
>> take their toll.  Most SSDs are also not quite symmetrical in terms of
>> performance.  If your SSD does 50K read IOPS and 50K write IOPS, it
>> will probably not do 25K reads and 25K writes concurrently, but
>> instead stop somewhere around 18K.  But your mileage may vary.  If you
>> have 8 drives that do 20 read/write symmetric, with new raid-5, each
>> 4K write is 2 reads and 2 writes.  8 drives will give you 8*20K = 160K
>> reads and writes or 320K total OPS.  Each 4K write takes 4 OPS, so
>> your data rate ends up maxing out at 80K IOPS.  With the old raid-5
>> logic, you end up with 6 reads plus two writes per "OP", so you tend
>> to max out around 320K/(6+2) = 40K IOPS.  With more than 8 drives,
>> these computations tend to fall apart, so 24 SSD arrays are not 3x
>> faster than 8 SSD arrays, at least with stock code.
>>
>> What if I moved to RAID50 and split my 8 disks into 2 x 4 disk RAID5 and
>> then combined to RAID0 (or linear)? I'd end up with 6TB of usable space (8 x
>> 1TB - 2 parity) though I'm guessing it is better to upgrade to kernel 4.4
>> instead which would basically do the same thing?
>>
>> You also need to consider what raid does to the SSD FTL.  As you
>> chatter a drive, its wear goes up and its performance goes down.
>> Different SSD models can vary wildly, but again the rule of thumb is
>> keep as much free space as possible on the drives.  raid-5 or
>> mirroring is also 2:1 write amplification (ie, you are writing two
>> drives) and raid-6 is 3:1, on top of whatever the FTL write
>> amplification is at the time.
>>
>> Overall drive wear is doing pretty well, it is sitting at around 5% to 8%
>> per year.
>>
>> Tell me I'm crazy, but one option that I considered is using different RAID
>> levels. Right now I have RAID51 in that I have RAID5 on each machine and
>> DRBD (RAID1) between them.
>> What if I used RAID01 with DRBD between the machines doing the RAID1. In
>> this way, each machine has RAID0 (across 8 drives), which should provide
>> maximum performance and storage capacity and DRBD doing RAID1 between the
>> two machines. It feels rather risky, but perhaps it isn't a terrible idea?
>> Slightly better would be RAID10 with DRBD between each pair of drives, and
>> then RAID0 across the DRBD device. It adds another layer of RAID, and more
>> complexity, but better security than RAID01...
> Your 5 to 7% wear per year is pretty safe.  I have a pair of systems
> with proprietary code that is saturating dual 10GigE ports looking at
> wearout at 100+ years.  Then again, the plastic cases of the drives
> will be dust by then.
Yep, I expect that we will outgrow the capacity of the drives before 
they "wear out". I do monitor the drive reported wear values, and alert 
on those (each time it drops 10% I get alerts, until I reset the alert 
level) so that I won't be suddenly surprised when they hit 10% or 
whatever....
> I don't know about you, but I do have SSDs, even from major vendors,
> that fail.  They usually "just fall off the bus" with no warning.  So
> I dislike skipping redundancy.  RAID turned an emergency into a
> mundane task.  It is really a cost issue.  If you can afford RAID-10
> and extra space, that will work best.  I don't think RAID-50 with this
> few drives makes much sense.
>
I'm not sure, but I think I've had one of the 480GB drives fail, and 3 
of the smaller 60GB and 80GB drives fail. So far, only the 480G failure 
was "catastrophic", the others were still operating . All were replaced 
by Intel.

The last one was just reported some large numbers in SMART, so I 
questioned Intel, and their advice was replace under warranty, which I did.
I've had many more spinning disks fail over the years though, so I'm 
pretty sure SSD's are more reliable, but certainly they do still fail, 
and that's one of the reasons for RAID (and backups of course).

Regards,
Adam

Regards,
Adam
