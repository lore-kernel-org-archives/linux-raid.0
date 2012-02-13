From: David Brown <david@westcontrol.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Mon, 13 Feb 2012 09:50:42 +0100
Message-ID: <4F38CEE2.6000701@westcontrol.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: stan@hardwarefreak.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Comments at the bottom, as they are too mixed to put inline.

On 12/02/2012 21:16, CoolCold wrote:
> First of all, Stan, thanks for such detailed answer, I greatly appreciate this!
>
> On Sat, Feb 11, 2012 at 8:05 AM, Stan Hoeppner<stan@hardwarefreak.com>  wrote:
>> On 2/10/2012 9:17 AM, CoolCold wrote:
>>> I've got server with 7 SATA drives ( Hetzner's XS13 to be precise )
>>> and created mdadm's raid10 with two near copies, then put LVM on it.
>>> Now I'm planning to create xfs filesystem, but a bit confused about
>>> stripe width/stripe unit values.
>>
>> Why use LVM at all?  Snapshots?  The XS13 has no option for more drives
>> so it can't be for expansion flexibility.  If you don't 'need' LVM don't
>> use it.  It unnecessarily complicates your setup and can degrade
>> performance.
> There are several reasons for this - 1) I've made decision to use LMV
> for all "data" volumes (those are except /, /boot, /home , etc)  2)
> there will be mysql database which will need backups with snapshots 3)
> I often have several ( 0-3 ) virtual environments (OpenVZ based) which
> are living on ext3/ext4 (because of extensive metadata updates on xfs
> makes it the whole machine slow) filesystem and different LV because
> of this.
>
>>
>>> As drives count is 7 and copies count is 2, so simple calculation
>>> gives me datadrives count "3.5" which looks ugly. If I understand the
>>> whole idea of sunit/swidth right, it should fill (or buffer) the full
>>> stripe (sunit * data disks) and then do write, so optimization takes
>>> place and all disks will work at once.
>>
>> Pretty close.  Stripe alignment is only applicable to allocation i.e new
>> file creation, and log journal writes, but not file re-write nor read
>> ops.  Note that stripe alignment will gain you nothing if your
>> allocation workload doesn't match the stripe alignment.  For example
>> writing a 32KB file every 20 seconds.  It'll take too long to fill the
>> buffer before it's flushed and it's a tiny file, so you'll end up with
>> many partial stripe width writes.
> Okay, got it - I've thinked in similar way.
>>
>>> My read load going be near random read ( sending pictures over http )
>>> and looks like it doesn't matter how it will be set with sunit/swidth.
>>
>> ~13TB of "pictures" to serve eh?  Average JPG file size will be
>> relatively small, correct?  Less than 1MB?  No, stripe alignment won't
>> really help this workload at all, unless you upload a million files in
>> one shot to populate the server.  In that case alignment will make the
>> process complete more quickly.
> Basing on current storage, estimations show (df -h / df -i ) average
> file size is ~200kb . Inodes count is near 15 millions and it will be
> more.
> I've just thought that may be I should change chunk size to 256kb,
> just to let one file be read from one disk, this may increase latency
> and increase throughput too.
>
>>
>>>      root@datastor1:~# cat /proc/mdstat
>>>      Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
>>>      md3 : active raid10 sdg5[6] sdf5[5] sde5[4] sdd5[3] sdc5[2] sdb5[1] sda5[0]
>>>            10106943808 blocks super 1.2 64K chunks 2 near-copies [7/7] [UUUUUUU]
>>>            [>....................]  resync =  0.8%
>>> (81543680/10106943808) finish=886.0min speed=188570K/sec
>>>            bitmap: 76/76 pages [304KB], 65536KB chunk
>>
>>> Almost default mkfs.xfs creating options produced:
>>>
>>>      root@datastor1:~# mkfs.xfs -l lazy-count=1 /dev/data/db -f
>>>      meta-data=/dev/data/db       isize=256    agcount=32, agsize=16777216 blks
>>>               =                       sectsz=512   attr=2, projid32bit=0
>>>      data     =                       bsize=4096   blocks=536870912, imaxpct=5
>>>               =                       sunit=16     swidth=112 blks
>>>      naming   =version 2              bsize=4096   ascii-ci=0
>>>      log      =internal log           bsize=4096   blocks=262144, version=2
>>>               =                       sectsz=512   sunit=16 blks, lazy-count=1
>>>      realtime =none                   extsz=4096   blocks=0, rtextents=0
>>>
>>>
>>> As I can see, it is created 112/16 = 7 chunks swidth, which correlate
>>> with my version b) , and I guess I will leave it this way.
>>
>> The default mkfs.xfs algorithms don't seem to play well with the
>> mdraid10 near/far copy layouts.  The above configuration is doing a 7
>> spindle stripe of 64KB, for a 448KB total stripe size.  This doesn't
>> seem correct, as I don't believe a 7 drive RAID10 near is giving you 7
>> spindles of stripe width.  I'm no expert on the near/far layouts, so I
>> could be wrong here.  If a RAID0 stripe would yield a 7 spindle stripe
>> width, I don't see how a RAID10/near would also be 7.  A straight RAID10
>> with 8 drives would give a 4 spindle stripe width.
>
> I've drawn nice picture from my head in my original post, it was:
>
> A1 A1 A2 A2 A3 A3 A4
> A4 A5 A5 A6 A6 A7 A7
> A8 A8 A9 A9 A10 A10 A11
> A11 ...
>
> So here is A{X} is chunk number on top of 7 disks. As you can see, 7
> chunks write (A1 - A7) will fill two rows. And this will made 2 disk
> head movements to write full stripe, though that moves may be very
> near to each other. Real situation may differ of course, and I'm not
> expert to make a bet too.
>
>>
>>> So, I'll be glad if anyone can review my thoughts and share yours.
>>
>> To provide you with any kind of concrete real world advice we need more
>> details about your write workload/pattern.  In absence of that, and
>> given what you've already stated, that the application is "sending
>> pictures over http", then this seems to be a standard static web server
>> workload.  In that case disk access, especially write throughput, is
>> mostly irrelevant, as memory capacity becomes the performance limiting
>> factor.  Given that you have 12GB of RAM for Apache/nginx/Lighty and
>> buffer cache, how you setup the storage probably isn't going to make a
>> big difference from a performance standpoint.
> Yes, this is standard static webserver workload with nginx as frontend
> with almost only reads.
>
>
>>
>> That said, for this web server workload, you'll be better off it you
>> avoid any kind of striping altogether, especially if using XFS.  You'll
>> be dealing with millions of small picture files I assume, in hundreds or
>> thousands of directories?  In that case play to XFS' strengths.  Here's
>> how you do it:
> Hundreds directories at least, yes.
> After reading you ideas and refinements, I'm making conclusion that I
> need to push others [team members] harder to remove mysql instances
> from the static files serving boxes at all, to free RAM for least
> dcache entries.
>
> About avoiding striping - later in the text.
>
>>
>> 1.  You chose mdraid10/near strictly because you have 7 disks and wanted
>> to use them all.  You must eliminate that mindset.  Redo the array with
>> 6 disks leaving the 7th as a spare (smart thing to do anyway).  What can
>> you really to with 10.5TB that you can't with 9TB?
> Hetzner's guys were pretty fast on chaning failed disks (one - two
> days after claim) so I may try without spares I guess... I just wanna
> use more independent spindles here, but I'll think about your
> suggestion one more time, thanks.
>
>>
>> 2.  Take your 6 disks and create 3 mdraid1 mirror pairs--don't use
>> partitions as these are surely Advanced Format drives.  Now take those 3
>> mdraid mirror devices and create a layered mdraid --linear array of the
>> three.  The result will be a ~9TB mdraid device.
>>
>> 3.  Using a linear concat of 3 mirrors with XFS will yield some
>> advantages over a striped array for this picture serving workload.
>> Format the array with:
>>
>> /$ mkfs.xfs -d agcount=12 /dev/mdx
>>
>> That will give you 12 allocation groups of 750GB each, 4 AGs per
>> effective spindle.  Using too many AGs will cause excessive head seeking
>> under load, especially with a low disk count in the array.  The mkfs.xfs
>> agcount default is 4 for this reason.  As a general rule you want a
>> lower agcount when using low RPM drives (5.9k, 7.2k) and a higher
>> agcount with fast drives (10k, 15k).
> Good to know such details!
>
>>
>> Directories drive XFS parallelism, with each directory being created in
>> a different AG, allowing XFS to write/read 12 files in parallel (far in
>> excess of the IO capabilities of the 3 drives) without having to worry
>> about stripe alignment.  Since your file layout will have many hundreds
>> or thousands of directories and millions of files, you'll get maximum
>> performance from this setup.
>
> So, as I could understand, you are assuming that "internal striping"
> by using AGs of XFS will be better than MD/LVM striping here? Never
> thought of XFS in this way and it is interesting point.
>
>>
>> As I said, if I understand your workload correctly, array/filesystem
>> layout probably don't make much difference.  But if you're after
>> something optimal and less complicated, for piece of mind, etc, this is
>> a better solution than the 7 disk RAID10 near layout with XFS.
>>
>> Oh, and don't forget to mount the XFS filesystem with the inode64 option
>> in any case, lest performance will be much less than optimal, and you
>> may run out of directory inodes as the FS fills up.
> Okay.
>
>>
>> Hope this information was helpful.
> Yes, very helpful and refreshing, thanks for you comments!
>
> P.S. As I've got 2nd server of the same config, may be i'll have time
> and do fast&  dirty tests of stripes vs AGs.
>>
>> --
>> Stan
>

Here a few general points:

XFS has a unique (AFAIK) feature of spreading allocation groups across 
the (logical) disk, and letting these AG's work almost independently. 
So if you have multiple disks (or raid arrays, such as raid1/raid10 
pairs), and the number of AG's is divisible by the number of disks, then 
a linear concatenation of the disks will work well with XFS.  Each 
access to a file will be handled within one AG, and therefore within one 
disk (or pair).  This means you don't get striping or other 
multiple-spindle benefits for that access - but it also means the access 
is almost entirely independent of other accesses to AG's on other disks. 
  In comparison, if you had a RAID6 setup, a single write would use 
/all/ the disks and mean that every other access is blocked for a bit.

But there are caveats.

Top level directories are spread out among the AG's, so it only works 
well if you have a balanced access through a range of directories, such 
asa /home with a subdirectory per user, or a /var/mail with a 
subdirectory per email account.  If you have a /var/www with two 
subdirectories "main" and "testsite", it will be terrible.  And you must 
also remember that you don't get multi-spindle benefits for large 
streamed reads and writes - you need multiple concurrent access to see 
any benefits.

If you have several filesystems on the same array (via LVM or other 
partitioning), you will lose most of the elegance and benefits of this 
type of XFS arrangement.  You really want to use it on a dedicated array.

It is also far from clear whether a linear concat XFS is better than a 
normal XFS on a raid0 of the same drives (or raid1 pairs).  I think it 
will have lower average latencies on small accesses if you also have big 
reads/writes mixed in, but you will also have lower throughput for 
larger accesses.  For some uses, this sort of XFS arrangement is ideal - 
a particular favourite is for mail servers.  But I suspect in many other 
cases you will stray enough from the ideal access patterns to lose any 
benefits it might have.

Stan is the expert on this, and can give advice on getting the best out 
of XFS.  But personally I don't think a linear concat there is the best 
way to go - especially when you want LVM and multiple filesystems on the 
array.


As another point, since you have mostly read accesses, you should 
probably use raid10,f2 far layout rather than near layout.  It's a bit 
slower for writes, but can be much faster for reads.

mvh.,

David






