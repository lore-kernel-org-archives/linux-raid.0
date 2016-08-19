From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Rewrite md raid1 member
Date: Fri, 19 Aug 2016 10:10:23 -0600
Message-ID: <CAJCQCtQs+z6rso4pc7CgRSia4tM5KK=T8ckh93X9HiDHytkcrw@mail.gmail.com>
References: <20160818030451.GA17225@onthe.net.au> <2dca8e1f-8e80-408f-900e-36f9b1dd6f95@fnarfbargle.com>
 <20160818040151.GA21256@onthe.net.au> <57B6F2F5.8090800@youngman.org.uk> <20160819124615.GA23247@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160819124615.GA23247@onthe.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Dunlop <chris@onthe.net.au>
Cc: Wols Lists <antlists@youngman.org.uk>, Brad Campbell <lists2009@fnarfbargle.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Aug 19, 2016 at 6:46 AM, Chris Dunlop <chris@onthe.net.au> wrote:
> On Fri, Aug 19, 2016 at 12:52:21PM +0100, Wols Lists wrote:
>> On 18/08/16 05:01, Chris Dunlop wrote:
>>> I'm interested to see if there's a way of essentially doing the above on a
>>> live system, assuming there's appropriate care taken to not trash any
>>> existing data (including superblocks).
>>>
>>> I.e. is it *theoretically* possible to write the same data back to the whole
>>> disk safely. E.g. using 'dd' from/to the same disk is almost there, but, as
>>> described, there's a window of opportunity where you could get stale data on
>>> the disk and a raid repair could then copy that stale data to the good disk.
>>
>> There is something called "scrub". My superficial knowledge of raid
>> doesn't let me know what it is, but as far as I can make out it forces a
>> whole-disk-write or somesuch. Explicitly to flush out such problems. If
>> someone else can tell you how to scrub your disks, I'd try that.
>
> A scrub will read the RAID members to check that both sides match (raid 1,
> 10), or that the checksum is correct (raid 4,5,6).
>
> To initiate a scrub of md0:
>
> echo repair > /sys/block/md0/md/sync_action
>
> You can watch it using /proc/mdstat, e.g.:
>
> watch cat /proc/mdstat
>
> It won't write anything if it doesn't detect any errors.
>
> In my case, I want it to write everything.
>
> If I do my 'dd' to write everything as previously described, with the window
> of opportunity for stale data to end up on the written disk, one option
> would to run a scrub / repair to check the data is the same - but if I'm
> unlucky with my dd and the data isn't the same for some sector[s], I want to
> ensure the correct data is copied over the stale data and not the other way
> around, e.g. to specify "in the event of a mismatch, use the data from sda
> and overwrite the data on sdb".
>
> Unfortunately I don't know how that can be done.
>
> Does anyone know?

Basically you want what Btrfs balance does, except simpler: rather
than relocating extents into new allocation groups, you just want to
read and rewrite everything as it is.

You definitely can't do this with dd when md + mounted file system,
that's inevitably going to result in the file system making changes
after this operation has done a read, and therefore its write will
clobber the file system's modifications. It'll be data loss at a
minimum, and if it's file system metadata, it'll be worse in that
it'll make the file system inconsistent. Further it's a problem
overwriting good data, not accounting for the possibility of a crash
or power failure. You'd really want this operation to be CoW, so that
the good data is effectively duplicated somewhere else and only once
that operation is on stable media would it be pointed to, and the
original data turned to free space.

I'm not really understanding the use case of why you'd want to do
this. At a fundamental level it sounds like you don't trust the
devices the data resides on. If that's true, then there are related
concerns that aren't mitigated by this rewrite feature alone.

-- 
Chris Murphy
