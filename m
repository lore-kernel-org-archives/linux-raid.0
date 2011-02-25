From: David Brown <david@westcontrol.com>
Subject: Re: high throughput storage server?
Date: Fri, 25 Feb 2011 09:20:41 +0100
Message-ID: <ik7oq8$dao$1@dough.gmane.org>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5EFDD6.1020504@hardwarefreak.com> <Pine.GSO.4.64.1102211116030.7398@montezuma.acc.umu.se> <4D62DE55.8040705@hardwarefreak.com> <ijvtqg$pke$1@dough.gmane.org> <4D63BC6D.8010209@hardwarefreak.com> <ik0gkm$nn$1@dough.gmane.org> <4D64A082.9000601@hardwarefreak.com> <ik33nt$fd8$1@dough.gmane.org> <4D6577E4.2080305@hardwarefreak.com> <ik5f7j$kuk$1@dough.gmane.org> <4D66EA1B.7010801@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D66EA1B.7010801@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/02/2011 00:30, Stan Hoeppner wrote:
> David Brown put forth on 2/24/2011 5:24 AM:
>
>> My understanding of RAID controllers (software or hardware) is that they
>> consider a drive to be either "good" or "bad".  So if you get an URE,
>> the controller considers the drive "bad" and ejects it from the array.
>> It doesn't matter if it is an URE or a total disk death.
>>
>> Maybe hardware RAID controllers do something else here - you know far
>> more about them than I do.
>
> Most HBA and SAN RAID firmware I've dealt with kicks drives offline
> pretty quickly at any sign of an unrecoverable error.  I've also seen
> drives kicked simply because the RAID firmware didn't like the drive
> firmware.  I have a fond (sarcasm) memory of DAC960s kicking ST118202
> 18GB Cheetahs offline left and right in the late 90s.  The fact I still
> recall that Seagate drive# after 10+ years should be informative
> regarding the severity of that issue.  :(
>
>> The idea of the md raid "bad block list" is that there is a medium
>> ground - you can have disks that are "mostly good".
>
> Everything I've read and seen in the last few years regarding hard disk
> technology says that platter manufacturing quality and tolerance are so
> high on modern drives that media defects are rarely, if ever, seen by
> the customer, as they're mapped out at the factory.  The platters don't
> suffer wear effects, but the rest of the moving parts do.  From what
> I've read/seen, "media" errors observed in the wild today are actually
> caused by mechanical failures due to physical wear on various moving
> parts:  VC actuator pivot bearing/race, spindle bearings, etc.
> Mechanical failures tend to show mild "media errors" in the beginning
> and get worse with time as moving parts go further out of alignment.
> Thus, as I see it, any UREs on a modern drive represent a "Don't trust
> me--Replace me NOW" flag.  I could be all wrong here, but this is what
> I've read, and seen in manufacturer videos from WD and Seagate.
>

That's very useful information to know - I don't go through nearly 
enough disks myself to be able to judge these things (and while I read 
lots of stuff on the web, I don't see /everything/ !).  Thanks.

However, this still sounds to me like a drive with UREs is dying but not 
dead yet.  Assuming you are correct here (and I've no reason to doubt 
that - unless someone else disagrees), it means that a disk with UREs 
will be dying quickly rather than dying slowly.  But if the non-URE data 
on the disk can be used to make a rebuild faster and safer, then surely 
that is worth doing?

It may be that when a disk has had an URE and therefore an entry in the 
bad block list, then it should be marked read-only and only used for 
data recovery and "hot replace" rebuilds.  But until it completely 
croaks, it is still better than no disk at all while the rebuild is in 
progress.


>> Supposing you have a RAID6 array, and one disk has died completely.  It
>> gets replaced by a hot spare, and rebuild begins.  As the rebuild
>> progresses, disk 1 gets an URE.  Traditional handling would mean disk 1
>> is ejected, and now you have a double-degraded RAID6 to rebuilt.  When
>> you later get an URE on disk 2, you have lost data for that stripe - and
>> the whole raid is gone.
>>
>> But with bad block lists, the URE on disk 1 leads to a bad block entry
>> on disk 1, and the rebuild continues.  When you later get an URE on disk
>> 2, it's no problem - you use data from disk 1 and the other disks. URE's
>> are no longer a killer unless your set has no redundancy.
>
> They're not a killer with RAID 6 anyway, are they?.  You can be
> rebuilding one failed drive and suffer UREs left and right, as long as
> you don't get two of them on two drives simultaneously in the same
> stripe block read.  I think that's right.  Please correct me if not.
>

That's true as long as UREs do not cause that disk to be kicked out of 
the array.  With bad block support in md raid, a disk suffering an URE 
will /not/ be kicked out.  But my understanding (from what you wrote 
above) was that with hardware raid controllers, an URE /would/ cause a 
disk to be kicked out.  Or am I mixing something up again?

>> URE's are also what I worry about with RAID1 (including RAID10)
>> rebuilds.  If a disk has failed, you are right in saying that the
>> chances of the second disk in the pair failing completely are tiny.  But
>> the chances of getting an URE on the second disk during the rebuild are
>> not negligible - they are small, but growing with each new jump in disk
>> size.
>
> I touched on this in my other reply, somewhat tongue-in-cheek mentioning
> 3 leg and 4 leg RAID10.  At current capacities and URE ratings I'm not
> worried about it with mirror pairs.  If URE ratings haven't increased
> substantially by the time our avg drive capacity hits 10GB I'll start to
> worry.
>
> Somewhat related to this, does any else here build their arrays from the
> smallest cap drives they can get away with, preferably single platter
> models when possible?  I adopted this strategy quite some time ago,
> mostly to keep rebuild times to a minimum, keep rotational mass low to
> consume the least energy since using more drives, but also with the URE
> issue in the back of my mind.  Anecdotal evidence tends to point to the
> trend of OPs going with fewer gargantuan drives instead of many smaller
> ones.  Maybe that's just members of this list, whose criteria may be
> quite different from the typical enterprise data center.
>
>> With md raid's future bad block lists and hot replace features, then an
>> URE on the second disk during rebuilds is only a problem if the first
>> disk has died completely - if it only had a small problem, then the "hot
>> replace" rebuild will be able to use both disks to find the data.
>
> What happens when you have multiple drives at the same or similar bad
> block count?
>

You replace them all.  Once a drive reaches a certain number of bad 
blocks (and that threshold may be just 1, or it may be more), you should 
replace it.  There isn't any reason not to do hot replace builds on 
multiple drives simultaneously, if you've got the drives and drive bays 
on hand - apart from at the bad blocks, they replacement is just a 
straight disk to disk copy.

>> I know you are more interested in hardware raid than software raid, but
>> I'm sure you'll find some interesting points in Neil's writings.  If you
>> don't want to read through the thread, at least read his blog post.
>>
>> <http://neil.brown.name/blog/20110216044002>
>
> Will catch up.  Thanks for the blog link.
>


