From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Thu, 23 Jan 2014 23:13:41 -0600
Message-ID: <52E1F685.3050300@hardwarefreak.com>
References: <20140122174854.GF26014@merlins.org> <52E051A3.3050103@hardwarefreak.com> <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140123210155.GJ10046@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/23/2014 3:01 PM, Marc MERLIN wrote:
> On Thu, Jan 23, 2014 at 06:24:39AM -0600, Stan Hoeppner wrote:
>>> In case you don't believe me, I just switched my drives from the PMP to
>>> directly connected to the motherboard and a marvel card, and my rebuild
>>> speed changed from 19MB/s to 99MB/s.
>>> (I made no other setting changes, but I did try your changes without
>>> saving them before and after the PMP change and will report below)
>>
>> Why would you assume I wouldn't believe you?
>  
> You seemed incredulous that PMPs could make things so slow :)

Well, no, not really.  I know there are some real quality issues with a
lot of cheap PMP JBODs out there.  I was just surprised to see an
experienced Linux sysadmin have bad luck with 3/3 of em.  Most folks
using Silicon Image HBAs with SiI PMPs seem to get good performance.

Personally, I've never used PMPs.  Given the cost ratio between drives
and HBA ports, a quality 4/8 port SAS HBA such as one of the LSIs is a
better solution all around.  4TB drives average $200 each.  A five drive
array is $1000.  An LSI 8 port 12G SAS HBA with guaranteed
compatibility, quality, support, and performance is $300.  A cheap 2
port SATA HBA and 5 port PMP card gives sub optimal performance, iffy
compatibility, and low quality, and is ~$130.  $1300 vs $1130.  Going
with a cheap SATA HBA and PMP makes no sense.

>>> Thanks for that one.
>>> It made no speed difference on the PMP or without, but can't hurt to do anyway.
>>
>> If you're not writing it won't.  The problem here is that you're
>> apparently using a non-destructive resync as a performance benchmark.
>> Don't do that.  It's representative of nothing but read-only resync speed.
>  
> Let me think about this: the resync is done at build array time.
> If all the drives are full of 0's indeed there will be nothing to write.
> Given that, I think you're right.

The initial resync is read-only.  It won't modify anything unless
there's a discrepancy.  So the stripe cache isn't in play.  The larger
stripe cache should indeed increase rebuild rate though.

>> Increasing stripe_cache_size above the default as I suggested will
>> ALWAYS increase write speed, often by a factor of 2-3x or more on modern
>> hardware.  It should speed up destructive resyncs considerably, as well
>> as normal write IO.  Once your array has settled down after the inits
>> and resyncs and what not, run some parallel FIO write tests with the
>> default of 256 and then with 2048.  You can try 4096 as well, but with 5
>> rusty drives 4096 will probably cause a slight tailing off of
>> throughput.  2048 should be your sweet spot.  You can also just time a
>> few large parallel file copies.  You'll be amazed at the gains.
> 
> Will do, thanks.
> 
>> The reason is simply that the default of 256 was selected some ~10 years
>> ago when disks were much slower.  Increasing this default has been a
>> topic of much discussion recently, because bumping it up increases
>> throughput for everyone, substantially, even with 3 disk RAID5 arrays.
> 
> Great to hear that the default may hopefully be increased for all.

It may be a while, or never.  Neil's last note suggests the default
likely won't change, but eventually we may have automated stripe cache
size management.

>>> As you did point out, the array will be faster when I use it because the
>>> encryption will be sharded over my CPUs, but rebuilding is going to create 5 encryption
>>> threads whereas if md5 is first and encryption is on top, rebuilds do
>>> not involve any encryption on CPU.
>>>
>>> So it depends what's more important.
>>
>> Yep.  If you post what CPU you're using I can probably give you a good
>> idea if one core is sufficient for dmcrypt.
> 
> Oh, I did forget to post that.
> 
> That server is a low power-ish dual core with 4 HT units:
...
> model name	: Intel(R) Core(TM) i3-2100T CPU @ 2.50GHz
...
> cache size	: 3072 KB
...

Actually, instead of me making an educated guess, I'd suggest you run

~$ cryptsetup benchmark

This will tell you precisely what your throughput is with various
settings and ciphers.  Depending on what this spits back you may want to
change your setup, assuming we get the IO throughput where it should be.

>> I'll also reiterate that encrypting a 16TB array device is silly when
>> you can simply carve off an LV for files that need to be encrypted, and
>> run dmcrypt only against that LV.  You can always expand an LV.  This is
>> a huge performance win for all other files, such your media collections,
>> which don't need to be encrypted.
> 
> I use btrfs for LV management, so it's easier to encrypt the entire pool. I
> also encrypt any data on any drive at this point, kind of like I wash my
> hands. I'm not saying it's the right thing to do for all, but it's my
> personal choice. I've seen too many drives end up on ebay with data, and I
> don't want to have to worry about this later, or even erasing my own drives
> before sending them back to warranty, especially in cases where maybe I
> can't erase them, but the manufacturer can read them anyway.
> You get the idea...

So be it.  Now let's work to see if we can squeeze every ounce of
performance out of it.

...
>>>> Question #2:
>>>> In order to copy data from a working system, I connected the drives via an external
>>>> enclosure which uses a SATA PMP. As a result, things are slow:
>>>>
>>>> md5 : active raid5 dm-7[5] dm-6[3] dm-5[2] dm-4[1] dm-2[0]
>>>>       15627526144 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] [UUUU_]
>>>>       [>....................]  recovery =  0.9% (35709052/3906881536) finish=3406.6min speed=18939K/sec
>>>>       bitmap: 0/30 pages [0KB], 65536KB chunk
>>>>
>>>> 2.5 days for an init or rebuild is going to be painful.
>>
>> With stripe_cache_size=2048 this should drop from 2.5 days to less than
>> a day.
> 
> It didn't since it PMP limited, but I made that change for the other reasons
> you suggested.

You said you had pulled the PMP and connected direct to an HBA, bumping
from 19MB/s to 99MB/s.  Did you switch back to the PMP and are now
getting 100MB/s through the PMP?  We should be able to get much higher
if it's 3/6G SATA, a little higher if it's 1/5G.

>>> Still curious on this: if the drives are brand new, is it safe to assume
>>> t> hey're full of 0's and tell mdadm to skip the re-init?
>>> (parity of X x 0 = 0)
>>
>> No, for a few reasons:
>>
>> 1.  Because not all bits are always 0 out of the factory.
>> 2.  Bad sectors may exist and need to be discovered/remapped
>> 3.  With the increased stripe_cache_size, and if your CPU turns out to
>> be fast enough for dmcrypt in front of md, resync speed won't be as much
>> of an issue, eliminating your motivation for skipping the init.

I shouldn't have included #3 here as it doesn't affect initial resync,
only rebuild.

> All fair points, thanks for explaining.
> For now, I put dmcrypt on top of md5, I get 100MB/s raw block write speed (actually
> just writing a big file in btrfs and going through all the layers) even
> though it's only using one CPU thread for encryption instead of 2 or more if
> each disk were encrypted under the md5 layer.

100MB/s sequential read throughput is very poor for a 5 drive RAID5,
especially with new 4TB drives which can stream well over 130MB/s each.

> Since 100MB/s was also the resync speed I was getting without encryption
> involved, looks like a single CPU thread can keep up with the raw IO of the
> array, so I guess I'll leave things that way.

100MB/s is leaving big performance on the table.  And 100 isn't the peak
array throughput of your current configuration.

> As another test
> gargamel:/mnt/btrfs_pool1# dd if=/dev/md5 of=/dev/null bs=1M count=1024
> 1073741824 bytes (1.1 GB) copied, 9.78191 s, 110 MB/s

dd single stream copies are not a valid test of array throughput.  This
tells you only the -minimum- throughput of the array.

> So it looks like 100-110MB/s is the read and write speed limit of that array.
> The drives are rated for 150MB/s each so I'm not too sure which limit I'm
> hitting, but 100MB/s is fast enough for my intended use.

To test real maximum throughput install fio, save and run this job file,
and post your results.  Monitor CPU burn of dmcrypt, using top is fine,
while running the job to see if it eats all of one core.  The job runs
in multiple steps, first creating the eight 1GB test files, then running
the read/write tests against those files.

[global]
directory=/some/directory
zero_buffers
numjobs=4
group_reporting
blocksize=1024k
ioengine=libaio
iodepth=16
direct=1
size=1g

[read]
rw=read
stonewall

[write]
rw=write
stonewall

> Thanks for you answers again,

You're welcome.  If you wish to wring maximum possible performance from
this rig I'll stick with ya until we get there.  You're not far.  Just
takes some testing and tweaking unless you have a real hardware
limitation, not a driver setting or firmware issue.

BTW, I don't recall you mentioning which HBA and PMP you're using at the
moment, and whether the PMP is an Addonics card or integrated in a JBOD.
 Nor if you're 1.5/3/6G from HBA through PMP to each drive.

Post your dmesg output showing the drive link speeds if you would, i.e.
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)


-- 
Stan
