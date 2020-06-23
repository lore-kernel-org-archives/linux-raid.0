From: "John Stoffel" <john@stoffel.org>
Subject: Re: RAID types & chunks sizes for new NAS drives
Date: Tue, 23 Jun 2020 17:30:09 -0400
Message-ID: <24306.29793.40893.422618@quad.stoffel.home>
References: <rco1i8$1l34$1@ciao.gmane.io>
        <24305.24232.459249.386799@quad.stoffel.home>
        <1ba7c1be-4cb1-29a5-d49c-bb26380ceb90@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1ba7c1be-4cb1-29a5-d49c-bb26380ceb90@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Ian" == Ian Pilcher <arequipeno@gmail.com> writes:

Ian> On 6/22/20 8:45 PM, John Stoffel wrote:
>> This is a terrible idea.  Just think about how there is just one head
>> per disk, and it takes a signifigant amount of time to seek from track
>> to track, and then add in rotational latecy.  This all adds up.
>> 
>> So now create multiple seperate RAIDS across all these disks, with
>> competing seek patterns, and you're just going to thrash you disks.

Ian> Hmm.  Does that answer change if those partition-based RAID
Ian> devices (of the same RAID level/settings) are combined into LVM
Ian> volume groups?

Yeah, it does change, as you add LVM groups, you can still lead to
thrashing of the heads.  As you add layers, its harder and harder for
different filesystems to coordinate disk access.

But to me another big reason is KISS, Keep It Simple Stupid, so that
when things go wrong, it's not as hard to fix.  

Ian> I think it does, as the physical layout of the data on the disks
Ian> will end up pretty much identical, so the drive heads won't go
Ian> unnecessarily skittering between partitions.

Well, as you add LVM volumes to a VG, I don't honestly know offhand if
the areas are pre-allocated, or not, I think they are pre-allocated,
but if you add/remove/resize LVs, you can start to get fragmentation,
which will hurt performance.

And note, I'm talking about harddisks here, with one read/write head.
SSDs are a different beast.  

>> Sorta kinda maybe... In either case, you only get 1 drive more space
>> with RAID 6 vs RAID10.  You can suffer any two disk failure, while
>> RAID10 is limited to one half of each pair.  It's a tradeoff.

Ian> Yeah.  For some reason I had it in my head that RAID 10 could
Ian> survive a double failure.  Not sure how I got that idea.  As you
Ian> mention, the only way to get close to that would be to do a
Ian> 4-drive/partition RAID 10 with a hot-spare.  Which would actually
Ian> give me a reason for the partitioned setup, as I would want to
Ian> try to avoid a 4TB or 8TB rebuild.  (My new drives are 8TB
Ian> Seagate Ironwolfs.)

No, you still do not want the partitioned setup, becuase if you lose a
disk, you want to rebuild it entirely, all at once.  Personally, 5 x
8Tb disks setup in RAID10 with a hot spare sounds just fine to me.
You can survive a two disk failure if it doesn't hit both halves of
the mirror.  But the hot spare should help protect you.

One thing I really like to do is mix vendors in my array, just so I
dont' get caught by a bad batch.  And the RAID10 performance advantage
over RAID6 is big.  You'd only get 8Tb (only! :-) more space, but much
worse interactive response.  

>> Look at the recent Arstechnica article on RAID levels and
>> performance.  It's an eye opener.

Ian> I assume that you're referring to this?

 
Ian> https://arstechnica.com/information-technology/2020/04/understanding-raid-how-performance-scales-from-one-disk-to-eight/

Yup.  

Ian> There's nothing really new in there.  Parity RAID sucks.  If you can't
Ian> afford 3-legged mirrors, just go home, etc., etc.

Physics sucks, don't it?  :-)

>> I don't think larger chunk sizes really make all that much difference,
>> especially with your plan to use multiple partitions.

Ian>  From what I understand about "parity RAID" (RAID-5, RAID-6, and exotic
Ian> variants thereof), one wants a smaller stripe size if one is doing
Ian> smaller writes (to minimize RMW cycles), but larger chunks increase the
Ian> speed of multiple concurrent sequential readers.

It's all about tradeoffs.  

>> You also don't say how *big* your disks will be, and if your 5 bay NAS
>> box can even split like that, and if it has the CPU to handle that.
>> Is it an NFS connection to the rest of your systems?

Ian> The disks are 8TB Seagate Ironwolf drives.  This is my home NAS, so it
Ian> need to handle all sorts of different workloads - everything from media
Ian> serving acting as an iSCSI target for test VMs.

So that to me would tend to make me want to go with RAID10 to get the
best performance.  You could even go three disk RAID5 and a single
RAID10 to mix up the workloads, but then you lose the hot spare.  

Ian> It runs NFS, Samba, iSCSI, various media servers, Apache, etc.  The
Ian> good news is that there isn't really any performance requirement (other
Ian> than my own level of patience).  I basically just want to avoid
Ian> handicapping the performance of the NAS with a pathological setting
Ian> (such as putting VM root disks on a RAID-6 device with a large chunk
Ian> size perhaps?).

What I do is have a pair of mirrored SSDs setup to cache my RAID1
arrays, to give me more performance.  Not really sure if it's helping
or hurting really.  dm-cache isn't really great at reporting stats,
and I never bothered to test it hard.

My main box is an old AMD Phenom(tm) II X4 945 Processor, which is now
something like 10 years old.  It's fast enough for what I do.  I'm
more concerned with data loss than I am performance.  

>> Honestly, I'd just setup two RAID1 mirrors with a single hot spare,
>> then use LVM on top to build the volumes you need.  With 8tb disks,
>> this only gives you 16Tb of space, but you get performance, quicker
>> rebuild speed if there's a problem with a disk, and simpler
>> management.

Ian> I'm not willing to give up that much space *and* give up tolerance
Ian> against double-failures.  Having come to my senses on what RAID-10
Ian> can and can't do, I'll probably be doing RAID-6 everywhere, possibly
Ian> with a couple of different chunk sizes.

Sure, go for it.

>> With only five drives, you are limited in what you can do.  Now if you
>> could add a pair of mirror SSDs for caching, then I'd be more into
>> building a single large RAID6 backing device for media content, then
>> use the mirrored SSDs as a cache for a smaller block of day to day
>> storage.

Ian> No space for any SSDs unfortunately.

Get a bigger case then.  :-)  
