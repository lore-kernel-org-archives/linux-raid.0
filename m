From: David Brown <david.brown@hesbynett.no>
Subject: Re: Safe disk replace
Date: Tue, 04 Sep 2012 12:28:41 +0200
Message-ID: <5045D7D9.9000108@hesbynett.no>
References: <20120904041447.GB14445@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120904041447.GB14445@onthe.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Dunlop <chris@onthe.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/09/2012 06:14, Chris Dunlop wrote:
> G'day,
>
> What is the best way to replace a fully-functional or minimally-failing
> (e.g. occasional bad sectors) disk in a live array whilst maintaining as
> much redundancy as possible during the process?
>
> It seems the standard way to replace a disk is to fail out the unwanted
> disk, add the new disk, then wait for the array to rebuild. However this
> means during the rebuild you've lost some or all of your redundancy,
> depending on the raid level of the array. This can be a significant issue,
> e.g. if you're replacing a 4 TB disk it could mean 10 to 20 hours or much
> more of heightened risk, depending on the rebuild bandwidth available.
>
> Another way would be to add in the new disk and grow the array, wait for
> the rebuild, then fail out and remove the old disk, shrink the array, and
> again wait for the rebuild. However once again you lose (some of) your
> redundancy from the time you've failed the old disk till the rebuild
> completes; again, potentially many hours. Unless there's some way of
> telling md to shrink the array off the unwanted device before removing it,
> and md is smart enough to retain full redundancy during the process?
>
> Another way might be to fail out the old drive, create a raid-1 between
> the old and new drives whilst doing some dance with dd and the original
> raid metadata and the new raid-1 metadata to make it appear the raid-1 was
> the original raid member, "re-add" the raid-1 device to the original raid,
> wait for the rebuild of both the raid-1 and the original raid, fail out
> the raid-1, do a reverse dd dance to make the new disk look like a primary
> member of the original raid, then "re-add" the new disk into the original
> raid. This would mean you only lose redundancy for the windows where the
> original raid has a failed-out member, i.e. seconds, if done properly.
>
> Is this method possible and, if sufficient care is taken, sensible?
>
> If it's possible, is this something that could or should be built into md
> to automate the process and perhaps reduce or completely eliminate the
> window of reduced redundancy?
>
> ...or, indeed, is this something that's already built into md and I need
> to do some significant self-flagellation with the clue bat?
>
> Cheers,
>
> Chris.

It looks like you've thought through most of the possibilities here.

I don't think there is a "best" way to do this sort of replacement, as 
it depends a bit on the circumstances - what sort of array you have from 
before, whether you have a spare disk slot, etc.

The "raid1" copy you mention will one day be possible with "hot replace"
<http://neil.brown.name/blog/20110216044002#2>

I don't know how far along this idea is at the moment.

I know that it is possible to get much of that effect today if you use 
single-disk raid1 "mirrors" as the basis for raid5/6/whatever instead of 
building it directly on disks or partitions.  Then it would be easy to 
add a new disk to a "mirror", wait for it to sync, then remove the old disk.

It is, I believe, possible to turn an existing drive/partition into part 
of a raid1 without metadata, but I am not sure of the details.  But that 
could be used to deal with an existing raid5/6 array.  First, make sure 
you have a write-intent bitmap.  Then remove a disk, make a no-metadata 
raid1 with it, then put it back into the array.  There are a lot of 
details to get right here, so you would want to practice it first!

Bad sectors or read failures in the original disk could quickly cause 
complications here.


If you have a raid5 array and want to replace a disk safely, it is 
relatively easy.  Get another extra disk (and this can be a USB disk, a 
networked disk, etc., if you don't mind the slower speed) and grow your 
array to an asymmetric raid6 (layout "left-symmetric-6", I believe). 
This puts the extra parity on the extra disk, and does not change the 
layout of the rest of the array.  Once the grow/rebuild is complete, you 
can remove the old disk, replace it with the new one, and re-sync. 
Convert back to normal raid5 (which does not need to change the rest of 
the array), and remove the extra disk.

Again, practice this before doing it on live disks - and make sure you 
have a good backup.  Raid can help protect data from disk errors, but 
not from human errors!


