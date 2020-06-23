From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: RAID types & chunks sizes for new NAS drives
Date: Tue, 23 Jun 2020 15:27:35 -0500
Message-ID: <1ba7c1be-4cb1-29a5-d49c-bb26380ceb90@gmail.com>
References: <rco1i8$1l34$1@ciao.gmane.io>
 <24305.24232.459249.386799@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24305.24232.459249.386799@quad.stoffel.home>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/22/20 8:45 PM, John Stoffel wrote:
> This is a terrible idea.  Just think about how there is just one head
> per disk, and it takes a signifigant amount of time to seek from track
> to track, and then add in rotational latecy.  This all adds up.
> 
> So now create multiple seperate RAIDS across all these disks, with
> competing seek patterns, and you're just going to thrash you disks.

Hmm.  Does that answer change if those partition-based RAID devices
(of the same RAID level/settings) are combined into LVM volume groups?

I think it does, as the physical layout of the data on the disks will
end up pretty much identical, so the drive heads won't go unnecessarily
skittering between partitions.

> Sorta kinda maybe... In either case, you only get 1 drive more space
> with RAID 6 vs RAID10.  You can suffer any two disk failure, while
> RAID10 is limited to one half of each pair.  It's a tradeoff.

Yeah.  For some reason I had it in my head that RAID 10 could survive a
double failure.  Not sure how I got that idea.  As you mention, the only
way to get close to that would be to do a 4-drive/partition RAID 10 with
a hot-spare.  Which would actually give me a reason for the partitioned
setup, as I would want to try to avoid a 4TB or 8TB rebuild.  (My new
drives are 8TB Seagate Ironwolfs.)

> Look at the recent Arstechnica article on RAID levels and
> performance.  It's an eye opener.

I assume that you're referring to this?

 
https://arstechnica.com/information-technology/2020/04/understanding-raid-how-performance-scales-from-one-disk-to-eight/

There's nothing really new in there.  Parity RAID sucks.  If you can't
afford 3-legged mirrors, just go home, etc., etc.

> I don't think larger chunk sizes really make all that much difference,
> especially with your plan to use multiple partitions.

 From what I understand about "parity RAID" (RAID-5, RAID-6, and exotic
variants thereof), one wants a smaller stripe size if one is doing
smaller writes (to minimize RMW cycles), but larger chunks increase the
speed of multiple concurrent sequential readers.

> You also don't say how *big* your disks will be, and if your 5 bay NAS
> box can even split like that, and if it has the CPU to handle that.
> Is it an NFS connection to the rest of your systems?

The disks are 8TB Seagate Ironwolf drives.  This is my home NAS, so it
need to handle all sorts of different workloads - everything from media
serving acting as an iSCSI target for test VMs.

It runs NFS, Samba, iSCSI, various media servers, Apache, etc.  The
good news is that there isn't really any performance requirement (other
than my own level of patience).  I basically just want to avoid
handicapping the performance of the NAS with a pathological setting
(such as putting VM root disks on a RAID-6 device with a large chunk
size perhaps?).

> Honestly, I'd just setup two RAID1 mirrors with a single hot spare,
> then use LVM on top to build the volumes you need.  With 8tb disks,
> this only gives you 16Tb of space, but you get performance, quicker
> rebuild speed if there's a problem with a disk, and simpler
> management.

I'm not willing to give up that much space *and* give up tolerance
against double-failures.  Having come to my senses on what RAID-10
can and can't do, I'll probably be doing RAID-6 everywhere, possibly
with a couple of different chunk sizes.

> With only five drives, you are limited in what you can do.  Now if you
> could add a pair of mirror SSDs for caching, then I'd be more into
> building a single large RAID6 backing device for media content, then
> use the mirrored SSDs as a cache for a smaller block of day to day
> storage.

No space for any SSDs unfortunately.

Thanks for the feedback!

-- 
========================================================================
                  In Soviet Russia, Google searches you!
========================================================================
