From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: RAID1, changed disk, 2nd has errors ...
Date: Fri, 26 Aug 2011 15:51:17 +0200
Message-ID: <4E57A4D5.3070004@xunil.at>
References: <4E5787A1.7080807@xunil.at> <20110826125653.GA13709@cthulhu.home.robinhill.me.uk>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826125653.GA13709@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: robin.hill47@ntlworld.com
List-Id: linux-raid.ids

Am 26.08.2011 14:56, schrieb Robin Hill:

> This would indicate that sdb has been reset as a spare, suggesting 
> that the resync failed so it has left sda alone in the array (as 
> failing it would destroy the array).

oh my ...

So the array is somehow split-brain now? Some sectors good here, some
there??

Why is sda4 now flagged as (S)? Is it a spare or not?
I don't fully understand the current state of the array ...

> I'd suggest stopping the array and using ddrescue to clone sda4 to 
> sdb4. That'll copy everything possible, flagging up any read
> issues. You'll then need to run a "fsck -f" on sdb4 to clear up
> any filesystem damage. You may still be left with damaged/missing
> files, depending on where any read errors occurred. How critical
> this is will depend on what the filesystem is used for (and whether
> you have any backup).

I am rather scared to do so ... as I am ~50kms away from the box now,
and as it seems to be working fine so far (though there are currently
no users working with it).

As mentioned /dev/md2 doesn't contain a filesystem itself, but is the
single PV in a LVM-volumegroup.

This group contains 6 logical volumes ...

As far as I understand it might be possible to spot the defective
sectors and the related LV?

I have backups, yes ...

> If that all works okay, then get sda replaced and give it a
> thorough badblocks and SMART test.
> 
> I'd also advise setting up regular array checks (echo check > 
> /sys/block/mdX/md/sync_action) to make sure the disks are checked 
> and any unreadable blocks repaired/mapped out _before_ they're
> needed for recovery.

re-adding sda4 and starting such a check would be possible?
Or would a re-add damage things?

Should I shutdown the box for safety?

I am really feeling unsafe now, and getting another hdd for swapping
will take me at least until monday.

(I would like to dd-rescue to another new disk to keep sdb, just in case)

Thanks, Stefan

