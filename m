From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: proactive-raid-disk-replacement
Date: Fri, 08 Sep 2006 14:47:31 +0400
Message-ID: <45014A43.2020702@tls.msk.ru>
References: <45012E73.5040900@tls.msk.ru> <Pine.LNX.4.64.0609080215220.32186@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0609080215220.32186@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

dean gaudet wrote:
> On Fri, 8 Sep 2006, Michael Tokarev wrote:
> 
>> Recently Dean Gaudet, in thread titled 'Feature
>> Request/Suggestion - "Drive Linking"', mentioned his
>> document, http://arctic.org/~dean/proactive-raid5-disk-replacement.txt
>>
>> I've read it, and have some umm.. concerns.  Here's why:
>>
>> ....
>>> mdadm -Gb internal --bitmap-chunk=1024 /dev/md4

By the way, don't specify bitmap-chunk for internal bitmap.
It's needed for file-based (external) bitmap.  With internal
bitmap, we have fixed size in superblock for it, so bitmap-chunk
is determined by dividing that size by size of the array.

>>> mdadm /dev/md4 -r /dev/sdh1
>>> mdadm /dev/md4 -f /dev/sde1 -r /dev/sde1
>>> mdadm --build /dev/md5 -ayes --level=1 --raid-devices=2 /dev/sde1 missing
>>> mdadm /dev/md4 --re-add /dev/md5
>>> mdadm /dev/md5 -a /dev/sdh1
>>>
>>> ... wait a few hours for md5 resync...
>> And here's the problem.  While new disk, sdh1, are resynced from
>> old, probably failing disk sde1, chances are high that there will
>> be an unreadable block on sde1.  And this means the whole thing
>> will not work -- md5 initially contained one working drive (sde1)
>> and one spare (sdh1) which is being converted (resynced) to working
>> disk.  But after read error on sde1, md5 will contain one failed
>> drive and one spare -- for raid1 it's fatal combination.
>>
>> While at the same time, it's perfectly easy to reconstruct this
>> failing block from other component devices of md4.
> 
> this statement is an argument for native support for this type of activity 
> in md itself.

Yes, definitely.

>> That to say: this way of replacing disk in a software raid array
>> isn't much better than just removing old drive and adding new one.
> 
> hmm... i'm not sure i agree.  in your proposal you're guaranteed to have 
> no redundancy while you wait for the new disk to sync in the raid5.

It's not a proposal per se, it's just another possible way (used by majority
of users I think, because it's way simpler ;)

> in my proposal the probability that you'll retain redundancy through the 
> entire process is non-zero.  we can debate how non-zero it is, but 
> non-zero is greater than zero.

Yes there will be no redundancy in "my" variant, guaranteed.  And yes,
there is probability to complete the whole "your" process without a glitch.

> i'll admit it depends a heck of a lot on how long you wait to replace your 
> disks, but i prefer to replace mine well before they get to the point 
> where just reading the entire disk is guaranteed to result in problems.
> 
>> And if the drive you're replacing is failing (according to SMART
>> for example), this method is more likely to fail.
> 
> my practice is to run regular SMART long self tests, which tend to find 
> Current_Pending_Sectors (which are generally read errors waiting to 
> happen) and then launch a "repair" sync action... that generally drops the 
> Current_Pending_Sector back to zero.  either through a realloc or just 
> simply rewriting the block.  if it's a realloc then i consider if there's 
> enough of them to warrant replacing the disk...
> 
> so for me the chances of a read error while doing the raid1 thing aren't 
> as high as they could be...

So the whole thing goes this way:
  0) do a SMART selftest ;)
  1) do repair for the whole array
  2) copy data from failing to new drive
    (using temporary superblock-less array)
  2a) if step 2 failed still, probably due to new bad sectors,
      go the "old way", removing the failing drive and adding
      new one.

That's 2x or 3x (or 4x counting the selftest, but that should be
done regardless) more work than just going the "old way" from the
beginning, but still some chances to have it completed flawlessly
in 2 steps, without losing redundancy.

Too complicated and too long for most people I'd say ;)

I can come to yet another way, which is only somewhat possible with
current md code. In 3 variants.

1)  Offline the array, stop it.
    Make a copy of the drive using dd with error=skip (or how it is),
     noticing the bad blocks
    Mark those bad blocks in bitmap as dirty
    Assemble the array with new drive, letting it to resync the blocks
    to new drive which we were unable to copy previously.

This variant does not lose redundancy at all, but requires the array to
be off-line during the whole copy procedure.  What's missing (which has
been discussed on linux-raid@ recently too) is the ability to mark those
"bad" blocks in bitmap.

2)  The same, but not offlining the array.  Hot-remove a drive, make copy
   of it to new drive, flip necessary bitmap bits, and re-add the new drive,
   and let raid code to resync changed (during copy, while the array was
   still active, something might has changed) and missing blocks.

This variant still loses redundancy, but not much of it, provided the bitmap
code works correctly.

3)  The same as your way, with the difference that we tell md to *skip* and
  ignore possible errors during resync (which is also not possible currently).

> but yeah you've convinced me this solution isn't good enough.

But all this, all 5 (so far ;) ways, aren't nice ;)

/mjt
