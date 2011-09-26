From: David Brown <david.brown@hesbynett.no>
Subject: Re:
Date: Mon, 26 Sep 2011 21:56:50 +0200
Message-ID: <j5qle2$tkq$1@dough.gmane.org>
References: <09f356fa46129bd08dd45752c0f736de.squirrel@www.maxstr.com>    <20110926145248.6ffc5f02@notabene.brown>    <c3985537eaf1fc639fa8bfb7c8d0aa21.squirrel@www.maxstr.com>    <20110926180401.29b9a6bd@notabene.brown> <33a40b3d7b23e719d77e6d091064c285.squirrel@www.maxstr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <33a40b3d7b23e719d77e6d091064c285.squirrel@www.maxstr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/09/11 20:04, Kenn wrote:
>> On Mon, 26 Sep 2011 00:42:23 -0700 "Kenn"<kenn@kenn.us>  wrote:
>>
>>> Replying.  I realize and I apologize I didn't create a subject.  I hope
>>> this doesn't confuse majordomo.
>>>
>>>> On Sun, 25 Sep 2011 21:23:31 -0700 "Kenn"<kenn@kenn.us>  wrote:
>>>>
>>>>> I have a raid5 array that had a drive drop out, and resilvered the
>>> wrong
>>>>> drive when I put it back in, corrupting and destroying the raid.  I
>>>>> stopped the array at less than 1% resilvering and I'm in the process
>>> of
>>>>> making a dd-copy of the drive to recover the files.
>>>>
>>>> I don't know what you mean by "resilvered".
>>>
>>> Resilvering -- Rebuilding the array.  Lesser used term, sorry!
>>
>> I see..
>>
>> I guess that looking-glass mirrors have a silver backing and when it
>> becomes
>> tarnished you might re-silver the mirror to make it better again.
>> So the name works as a poor pun for RAID1.  But I don't see how it applies
>> to RAID5....
>> No matter.
>>
>> Basically you have messed up badly.
>> Recreating arrays should only be done as a last-ditch attempt to get data
>> back, and preferably with expert advice...
>>
>> When you created the array with all devices present it effectively started
>> copying the corruption that you had deliberately (why??) placed on device
>> 2
>> (sde) onto device 4 (counting from 0).
>> So now you have two devices that are corrupt in the early blocks.
>> There is not much you can do to fix that.
>>
>> There is some chance that 'fsck' could find a backup superblock somewhere
>> and
>> try to put the pieces back together.  But the 'mkfs' probably made a
>> substantial mess of important data structures so I don't consider you
>> chances
>> very high.
>> Keeping sde out and just working with the remaining 4 is certainly your
>> best
>> bet.
>>
>> What made you think it would be a good idea to re-create the array when
>> all
>> you wanted to do was trigger a resync/recovery??
>>
>> NeilBrown
>
> Originally I had failed&  removed sde from the array and then added it
> back in, but no resilvering happened, it was just placed as raid device #
> 5 as an active (faulty?) spare, no rebuilding.  So I thought I'd have to
> recreate the array to get it to rebuild.
>
> Because my sde disk was only questionably healthy, if the problem was the
> loose cable, I wanted to test the sde disk by having a complete rebuild
> put onto it.   I was confident in all the other drives because when I
> mounted the array without sde, I ran a complete md5sum scan and
> everything's checksum was correct.  So I wanted to force a complete
> rebuilding of the array on sde and the --zero-superblock was supposed to
> render sde "new" to the array to force the rebuild onto sde.  I just did
> the fsck and mkfs for good measure instead of spending the time of using
> dd to zero every byte on the drive.  At the time because I thought if
> --zero-superblock went wrong, md would reject a blank drive as a data
> source for rebuilding and prevent resilvering.
>
> So that brings up another point -- I've been reading through your blog,
> and I acknowledge your thoughts on not having much benefit to checksums on
> every block (http://neil.brown.name/blog/20110227114201), but sometimes
> people like to having that extra lock on their door even though it takes
> more effort to go in and out of their home.  In my five-drive array, if
> the last five words were the checksums of the blocks on every drive, the
> checksums off each drive could vote on trusting the blocks of every other
> drive during the rebuild process, and prevent an idiot (me) from killing
> his data.  It would force wasteful sectors on the drive, perhaps harm
> performance by squeezing 2+n bytes out of each sector, but if someone
> wants to protect their data as much as possible, it would be a welcome
> option where performance is not a priority.
>
> Also, the checksums do provide some protection: first, against against
> partial media failure, which is a major flaw in raid 456 design according
> to http://www.miracleas.com/BAARF/RAID5_versus_RAID10.txt , and checksum
> voting could protect against the Atomicity/write-in-place flaw outlined in
> http://en.wikipedia.org/wiki/RAID#Problems_with_RAID .
>
> What do you think?
>
> Kenn

/raid/ protects against partial media flaws.  If one disk in a raid5 
stripe has a bad sector, that sector will be ignored and the missing 
data will be re-created from the other disks using the raid recovery 
algorithm.  If you want to have such protection even when doing a resync 
(as many people do), then use raid6 - it has two parity blocks.

As Neil points out in his blog, it is impossible to fully recover from a 
failure part way through a write - checksum voting or majority voting 
/may/ give you the right answer, but it may not.  If you need protection 
against that, you have to have filesystem level control (data logging 
and journalling as well as metafile journalling), or perhaps use raid 
systems with battery backed write caches.


