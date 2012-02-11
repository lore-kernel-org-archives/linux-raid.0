From: David Brown <david.brown@hesbynett.no>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Sat, 11 Feb 2012 15:32:51 +0100
Message-ID: <4F367C13.30109@hesbynett.no>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F35E925.6000003@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, CoolCold <coolthecold@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/02/12 05:05, Stan Hoeppner wrote:
> On 2/10/2012 9:17 AM, CoolCold wrote:
>> I've got server with 7 SATA drives ( Hetzner's XS13 to be precise )
>> and created mdadm's raid10 with two near copies, then put LVM on it.
>> Now I'm planning to create xfs filesystem, but a bit confused about
>> stripe width/stripe unit values.
>

Why are you using "near" copies?  raid10,n2 is usually a little faster 
for writes (since there is less head movement between writing the two 
copies), but raid10,f2 (far layout) is a lot faster for reads (better 
striping for larger files, and most reads come from the faster outer 
halves of the disks).  So if you have a read-to-write ratio of more than 
about 2 or 3, you probably want far layout.

> Why use LVM at all?  Snapshots?  The XS13 has no option for more drives
> so it can't be for expansion flexibility.  If you don't 'need' LVM don't
> use it.  It unnecessarily complicates your setup and can degrade
> performance.
>

I agree here.  LVM is wonderful if you have multiple logical partitions 
and filesystems on the array, or if you want to be able to expand the 
array later (growing with LVM is very fast, safe and easily, though 
seldom as optimal in speed as re-shaping the raid array).  However, if 
your array is fixed size and you only have one filesystem, it's 
typically best to keep it simple by omitting the LVM layer.

>> As drives count is 7 and copies count is 2, so simple calculation
>> gives me datadrives count "3.5" which looks ugly. If I understand the
>> whole idea of sunit/swidth right, it should fill (or buffer) the full
>> stripe (sunit * data disks) and then do write, so optimization takes
>> place and all disks will work at once.
>
> Pretty close.  Stripe alignment is only applicable to allocation i.e new
> file creation, and log journal writes, but not file re-write nor read
> ops.  Note that stripe alignment will gain you nothing if your
> allocation workload doesn't match the stripe alignment.  For example
> writing a 32KB file every 20 seconds.  It'll take too long to fill the
> buffer before it's flushed and it's a tiny file, so you'll end up with
> many partial stripe width writes.
>
>> My read load going be near random read ( sending pictures over http )
>> and looks like it doesn't matter how it will be set with sunit/swidth.
>
> ~13TB of "pictures" to serve eh?  Average JPG file size will be
> relatively small, correct?  Less than 1MB?  No, stripe alignment won't
> really help this workload at all, unless you upload a million files in
> one shot to populate the server.  In that case alignment will make the
> process complete more quickly.
>
>>      root@datastor1:~# cat /proc/mdstat
>>      Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
>>      md3 : active raid10 sdg5[6] sdf5[5] sde5[4] sdd5[3] sdc5[2] sdb5[1] sda5[0]
>>            10106943808 blocks super 1.2 64K chunks 2 near-copies [7/7] [UUUUUUU]
>>            [>....................]  resync =  0.8%
>> (81543680/10106943808) finish=886.0min speed=188570K/sec
>>            bitmap: 76/76 pages [304KB], 65536KB chunk
>
>> Almost default mkfs.xfs creating options produced:
>>
>>      root@datastor1:~# mkfs.xfs -l lazy-count=1 /dev/data/db -f
>>      meta-data=/dev/data/db       isize=256    agcount=32, agsize=16777216 blks
>>               =                       sectsz=512   attr=2, projid32bit=0
>>      data     =                       bsize=4096   blocks=536870912, imaxpct=5
>>               =                       sunit=16     swidth=112 blks
>>      naming   =version 2              bsize=4096   ascii-ci=0
>>      log      =internal log           bsize=4096   blocks=262144, version=2
>>               =                       sectsz=512   sunit=16 blks, lazy-count=1
>>      realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>>
>> As I can see, it is created 112/16 = 7 chunks swidth, which correlate
>> with my version b) , and I guess I will leave it this way.
>
> The default mkfs.xfs algorithms don't seem to play well with the
> mdraid10 near/far copy layouts.  The above configuration is doing a 7
> spindle stripe of 64KB, for a 448KB total stripe size.  This doesn't
> seem correct, as I don't believe a 7 drive RAID10 near is giving you 7
> spindles of stripe width.  I'm no expert on the near/far layouts, so I
> could be wrong here.  If a RAID0 stripe would yield a 7 spindle stripe
> width, I don't see how a RAID10/near would also be 7.  A straight RAID10
> with 8 drives would give a 4 spindle stripe width.
>

The key points about Linux madmin raid10 is that it works with any 
number of disks, and you /do/ get stripes across all spindles.  In 
particular, with raid10,far you get better read performance than with 
raid0 (especially for large streamed reads).

So dedicating one drive as a hot spare will reduce the throughput a 
little - but I'd agree with you that it is probably a good idea.

If the system is serving multiple concurrent small files, then  your 
suggestion of 3 pairs linearly concat'ed to XFS is not bad.  But I 
suspect performance would still be better with the 6 (or maybe 7) drives 
raid10,far, especially for read-heavy applications.


>> So, I'll be glad if anyone can review my thoughts and share yours.
>
> To provide you with any kind of concrete real world advice we need more
> details about your write workload/pattern.  In absence of that, and
> given what you've already stated, that the application is "sending
> pictures over http", then this seems to be a standard static web server
> workload.  In that case disk access, especially write throughput, is
> mostly irrelevant, as memory capacity becomes the performance limiting
> factor.  Given that you have 12GB of RAM for Apache/nginx/Lighty and
> buffer cache, how you setup the storage probably isn't going to make a
> big difference from a performance standpoint.
>
> That said, for this web server workload, you'll be better off it you
> avoid any kind of striping altogether, especially if using XFS.  You'll
> be dealing with millions of small picture files I assume, in hundreds or
> thousands of directories?  In that case play to XFS' strengths.  Here's
> how you do it:
>
> 1.  You chose mdraid10/near strictly because you have 7 disks and wanted
> to use them all.  You must eliminate that mindset.  Redo the array with
> 6 disks leaving the 7th as a spare (smart thing to do anyway).  What can
> you really to with 10.5TB that you can't with 9TB?
>
> 2.  Take your 6 disks and create 3 mdraid1 mirror pairs--don't use
> partitions as these are surely Advanced Format drives.  Now take those 3
> mdraid mirror devices and create a layered mdraid --linear array of the
> three.  The result will be a ~9TB mdraid device.
>
> 3.  Using a linear concat of 3 mirrors with XFS will yield some
> advantages over a striped array for this picture serving workload.
> Format the array with:
>
> /$ mkfs.xfs -d agcount=12 /dev/mdx
>
> That will give you 12 allocation groups of 750GB each, 4 AGs per
> effective spindle.  Using too many AGs will cause excessive head seeking
> under load, especially with a low disk count in the array.  The mkfs.xfs
> agcount default is 4 for this reason.  As a general rule you want a
> lower agcount when using low RPM drives (5.9k, 7.2k) and a higher
> agcount with fast drives (10k, 15k).
>
> Directories drive XFS parallelism, with each directory being created in
> a different AG, allowing XFS to write/read 12 files in parallel (far in
> excess of the IO capabilities of the 3 drives) without having to worry
> about stripe alignment.  Since your file layout will have many hundreds
> or thousands of directories and millions of files, you'll get maximum
> performance from this setup.
>
> As I said, if I understand your workload correctly, array/filesystem
> layout probably don't make much difference.  But if you're after
> something optimal and less complicated, for piece of mind, etc, this is
> a better solution than the 7 disk RAID10 near layout with XFS.
>
> Oh, and don't forget to mount the XFS filesystem with the inode64 option
> in any case, lest performance will be much less than optimal, and you
> may run out of directory inodes as the FS fills up.
>
> Hope this information was helpful.
>

