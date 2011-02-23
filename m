From: David Brown <david@westcontrol.com>
Subject: Re: high throughput storage server?
Date: Wed, 23 Feb 2011 14:56:34 +0100
Message-ID: <ik33nt$fd8$1@dough.gmane.org>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5EFDD6.1020504@hardwarefreak.com> <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se> <4D62DE55.8040705@hardwarefreak.com> <ijvtqg$pke$1@dough.gmane.org> <4D63BC6D.8010209@hardwarefreak.com> <ik0gkm$nn$1@dough.gmane.org> <4D64A082.9000601@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D64A082.9000601@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/02/2011 06:52, Stan Hoeppner wrote:
> David Brown put forth on 2/22/2011 8:18 AM:
>
>> Yes, this is definitely true - RAID10 is less affected by running
>> degraded, and recovering is faster and involves less disk wear.  The
>> disadvantage compared to RAID6 is, of course, if the other half of a
>> disk pair dies during recovery then your raid is gone - with RAID6 you
>> have better worst-case redundancy.
>
> The odds of the mirror partner dying during rebuild are very very long,
> and the odds of suffering a URE are very low.  However, in the case of
> RAID5/6, moreso with RAID5, with modern very large drives (1/2/3TB),
> there is being quite a bit written these days about unrecoverable read
> error rates.  Using a sufficient number of these very large disks will
> at some point guarantee a URE during an array rebuild, which may very
> likely cost you your entire array.  This is because every block of every
> remaining disk (assuming full disk RAID not small partitions on each
> disk) must be read during a RAID5/6 rebuild.  I don't have the equation
> handy but Google should be able to fetch it for you.  IIRC this is one
> of the reasons RAID6 is becoming more popular today.  Not just because
> it can survive an additional disk failure, but that it's more resilient
> to a URE during a rebuild.
>

It is certainly the case that the chance of a second failure when doing 
a RAID5/6 rebuild goes up with the number of disks (since all the disks 
are stressed during the rebuild, and any failures are relevant), while 
with RAID 10 rebuilds the chances of a second failure are restricted to 
the single disk being used.

However, as disks get bigger, the chance of errors on any given disk is 
increasing.  And the fact remains that if you have a failure on a RAID10 
system, you then have a single point of failure during the rebuild 
period - while with RAID6 you still have redundancy (obviously RAID5 is 
far worse here).

> With a RAID10 rebuild, as you're only reading entire contents of a
> single disk, the odds of encountering a URE are much lower than with a
> RAID5 with the same number of drives, simply due to the total number of
> bits read.
>
>> Once md raid has support for bad block lists, hot replace, and non-sync
>> lists, then the differences will be far less clear.  If a disk in a RAID
>> 5/6 set has a few failures (rather than dying completely), then it will
>> run as normal except when bad blocks are accessed.  This means for all
>> but the few bad blocks, the degraded performance will be full speed. And
>
> You're muddying the definition of a "degraded RAID".
>

That could be the case - I'll try to be clearer.  It is certainly 
possible that I'm getting terminology wrong.

>> if you use "hot replace" to replace the partially failed drive, the
>> rebuild will have almost exactly the same characteristics as RAID10
>> rebuilds - apart from the bad blocks, which must be recovered by parity
>> calculations, you have a straight disk-to-disk copy.
>
> Are you saying you'd take a "partially failing" drive in a RAID5/6 and
> simply do a full disk copy onto the spare, except "bad blocks",
> rebuilding those in the normal fashion, simply to approximate the
> recover speed of RAID10?
>
> I think your logic is a tad flawed here.  If a drive is already failing,
> why on earth would you trust it, period?  I think you'd be asking for
> trouble doing this.  This is precisely one of the reasons many hardware
> RAID controllers have historically kicked drives offline after the first
> signs of trouble--if a drive is acting flaky we don't want to trust it,
> but replace it as soon as possible.
>

I don't know if you've followed the recent "md road-map: 2011" thread (I 
can't see any replies from you in the thread), but that is my reference 
point here.

Sometimes disks die suddenly and catastrophically.  When that happens, 
the disk is gone and needs to be kicked offline.

Other times, you have a single-event corruption - for some reason, a 
particular block got corrupted.  And sometimes the disk is wearing out - 
disks have a set of replacement blocks for re-locating known bad blocks, 
and in the end these will run out.  Either you get an URE, or a write 
failure.

(I don't have any idea what the ratio of these sorts of failure modes is.)

If you have a drive with a few failures, then the rest of the data is 
still correct.  You can expect that if the drive returns data 
successfully for a read, then the data is valid - that's what the 
drive's ECC is for.  But you would not want to trust it with new data, 
and you would want to replace it as soon as possible.

The point of md raid's planned "bad block list" is to track which areas 
of the drive should not be used.  And the "hot replace" feature is aimed 
at making a direct copy of a disk - excluding the bad blocks - to make 
replacement of failed drives faster and safer.  Since the failing drive 
is not removed from the array until the hot replace takes over, you 
still have full redundancy for most of the array - just not for stripes 
that contain a bad block.

I can well imagine that hardware RAID controllers don't have this sort 
of flexibility.

> The assumption is that the data on the array is far more valuable than
> the cost of a single drive or the entire hardware for that matter.  In
> most environments this is the case.  Everyone seems fond of the WD20EARS
> drives (which I disdain).  I hear they're loved because Newegg has them
> for less than $100.  What's your 2TB of data on that drive worth?  In
> the case of a MythTV box, to the owner, that $100 is worth more than the
> content.  In a business setting, I'd dare say the data on that drive is
> worth far more than the $100 cost of the drive and the admin $$ time
> required to replace/rebuild it.
>
> In the MythTV case what you propose might be a worthwhile risk.  In a
> business environment, definitely not.
>

I believe it is the value of the data - and the value of keeping as much 
redundancy as you can, and minimising the risky rebuild period, that is 
Neil Brown's motivation behind the bad block list and hot replace.  It 
could well be that I'm not explaining it very well - but this is /not/ 
about saving money by continuing to use a dodgy disk even though you 
know it is failing.  It is about a dodgy disk with most of a data set 
being a lot better than no disk when it comes to rebuild speed and data 
redundancy.


Incidentally, what's your opinion on a RAID1+5 or RAID1+6 setup, where 
you have a RAID5 or RAID6 build from RAID1 pairs?  You get all the 
rebuild benefits of RAID1 or RAID10, such as simple and fast direct 
copies for rebuilds, and little performance degradation.  But you also 
get multiple failure redundancy from the RAID5 or RAID6.  It could be 
that it is excessive - that the extra redundancy is not worth the 
performance cost (you still have poor small write performance).

