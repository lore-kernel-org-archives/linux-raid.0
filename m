From: David Brown <david.brown@hesbynett.no>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 14:02:06 +0100
Message-ID: <58D1244E.3040204@hesbynett.no>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net> <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au> <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com> <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, Jeff Allison <jeff.allison@allygray.2y.net>, Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/03/17 10:54, Reindl Harald wrote:
> 
> 
> Am 21.03.2017 um 03:33 schrieb Jeff Allison:
>> I don't have a spare SATA slot I do however have a spare USB carrier,
>> is that fast enough to be used temporarily?
> 
> USB3 yes, USB2 don't make fun because the speed of the array depends on
> the slowest disk in the spindle

When you are turning your RAID5 into RAID6, you can use a non-standard
layout with the external drive being the second parity.  That way you
don't need to re-write the data on the existing drives, and the access
to the external drive will all be writes of the Q parity - the system
will not read from that drive unless it has to recover from a two drive
failure.  This will reduce stress on all the disks, and make the limited
USB2 bandwidth less of an issue.

If you have to use two USB carriers for the whole process, try to make
sure they are connected to separate root hubs so that they don't share
the bandwidth.  This is not always just a matter of using two USB ports
- sometimes two adjacent USB ports on a PC share an internal hub.

> 
> and about RAID5/RAID6 versus RAID10: both RAID5 and RAID6 suffer from
> the same problems - due rebuild you have a lot of random-IO load on all
> remaining disks which leads in bad performance and make it more likely
> that before the rebuild is finished another disk fails, RAID6 produces
> even more random IO because of the double parity and if you have a
> Unrecoverable-Read-Error on RAID5 you are dead, RAID6 is not much better
> here and the probability of a URE becomes more likely with larger disks

Rebuilds are done using streamed linear access - the only random access
is the mix of rebuild transfers with normal usage of the array.  This
applies to RAID5 and RAID6 as well as RAID1 or RAID10.

With RAID5 or two-disk RAID1, if you get an URE on a read then you can
recover the data without loss.  This is the case for normal
(non-degraded) use, or if you are using "replace" to duplicate an
existing disk before replacement.  If you have failed a drive (manually,
or due to a serious disk failure), then any single URE means lost data
in that stripe.

With RAID6 (or three-disk RAID1), you can tolerate /two/ URE's on the
same stripe.  If you have failed a disk for replacement, you can
tolerate one URE.

Note that to cause failure in non-degraded RAID5 (or degraded RAID6),
your two URE's need to be on the same stripe in order to cause data
loss.  The chances of getting an URE somewhere on the disk are roughly
proportional to the size of the disk - but the chance of getting an URE
on the same stripe as another URE on another disk are basically
independent of the disk size, and it is extraordinarily small.

> 
> RAID10: less to zero performance impact due rebuild and no random-IO
> caused by the rebuild, it's just "read a disk from start to end and
> write the data on another disk linear" while the only head moves on your
> disks is the normal workload on the array

RAID1 (and RAID0) rebuilds are a little more efficient than RAID5 or
RAID6 rebuilds - but not hugely so.  Depending on factors such as IO
structures, cpu speed and loading, number of disks in the array,
concurrent access to other data, etc., they can be something like 25% to
50% faster.  They do not involve noticeably more or less linear access
than a RAID5/RAID6 rebuild, but they avoid heavy access to disks other
than those in the RAID1 pair being rebuilt.

> 
> with disks 2 TB or larger you can make the conclusion "do not use
> RAID5/6 anymore and when you do be prepared that you won't survive a
> rebuild caused by a failed disk"

No, you cannot.  Your conclusion here is based on several totally
incorrect assumptions:

1. You think that RAID5/RAID6 recovery is more stressful, because the
parity is "all over the place".  This is wrong.

2. You think that random IO has higher chance of getting an URE than
linear IO.  This is wrong.

3. You think that getting an URE on one disk, then getting an URE on a
second disk, counts as a double failure that will break an single-parity
redundancy (RAID5, RAID1, RAID6 in degraded mode).  This is wrong - it
is only a problem if the two UREs are in the same stripe, which is quite
literally a one in a million chance.


There are certainly good reasons to prefer RAID10 systems to RAID5/RAID6
- for some types of loads, it can be significantly faster, and even
though the rebuild time is not as much faster as you think, it is still
faster.  Linux supports a range of different RAID types for good reason
- it is not a "one size fits all" problem.  But you should learn the
differences and make your choices and recommendations based on facts,
rather than articles written by people trying to sell their own "solutions".

mvh.,

David


> 
>> On 21 March 2017 at 01:59, Adam Goryachev
>> <mailinglists@websitemanagers.com.au> wrote:
>>>
>>>
>>> On 20/3/17 23:47, Jeff Allison wrote:
>>>>
>>>> Hi all I’ve had a poke around but am yet to find something definitive.
>>>>
>>>> I have a raid 5 array of 4 disks amounting to approx 5.5tb. Now this
>>>> disks
>>>> are getting a bit long in the tooth so before I get into problems I’ve
>>>> bought 4 new disks to replace them.
>>>>
>>>> I have a backup so if it all goes west I’m covered. So I’m looking for
>>>> suggestions.
>>>>
>>>> My current plan is just to replace the 2tb drives with the new 3tb
>>>> drives
>>>> and move on, I’d like to do it on line with out having to trash the
>>>> array
>>>> and start again, so does anyone have a game plan for doing that.
>>>
>>> Yes, do not fail a disk and then replace it, use the newer replace
>>> method
>>> (it keeps redundancy in the array).
>>> Even better would be to add a disk, and convert to RAID6, then add a
>>> second
>>> disk (using replace), and so on, then remove the last disk, grow the
>>> array
>>> to fill the 3TB, and then reduce the number of disks in the raid.
>>> This way, you end up with RAID6...
>>>>
>>>> Or is a 9tb raid 5 array the wrong thing to be doing and should I be
>>>> doing
>>>> something else 6tb raid 10 or something I’m open to suggestions.
>>>
>>> I'd feel safer with RAID6, but it depends on your requirements.
>>> RAID10 is
>>> also a nice option, but, it depends...
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

