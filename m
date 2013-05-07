From: Phil Turmel <philip@turmel.org>
Subject: Re: Failed during rebuild (raid5)
Date: Mon, 06 May 2013 20:39:37 -0400
Message-ID: <51884D49.3090602@turmel.org>
References: <51839E4F.7050102@midgaard.us> <CANU9nTneT2CRWJhdN=d87Hb7W9M+apQH+fRE-S+sieZ-W6+hjg@mail.gmail.com> <51866602.8000704@midgaard.us> <518693EF.6090802@midgaard.us> <518721CD.2040108@turmel.org> <51878BD0.9010809@midgaard.us> <5187A3D2.6060109@turmel.org> <5188189D.1060806@midgaard.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5188189D.1060806@midgaard.us>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Boman <aboman@midgaard.us>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/06/2013 04:54 PM, Andreas Boman wrote:
> On 05/06/2013 08:36 AM, Phil Turmel wrote:

[trim /]

>> Current versions of MD raid in the kernel allow multiple read errors per
>> hour before kicking out a drive.  What kernel and mdadm versions are
>> involved here?
> kernel 2.6.32-5-amd64, mdadm 3.1.4 (debian 6.0.7)

Ok.  Missing some neat features, but not a crisis.

>>> Disk was sda at the time, sdb now don't ask why it reorders at times, I
>>> don't know. Sometimes the on board boot disk is sda, sometimes it is the
>>> last disk it seems.
>>
>> You need to document the device names vs. drive S/Ns so you don't mess
>> up any "--create" operations.  This is one of the reasons "--create
>> --assume-clean" is so dangerous. I recommend my own "lsdrv" @
>> github.com/pturmel.  But an excerpt from
>> "ls -l /dev/disk/by-id/" will do.
>>
>> Use of LABEL= and UUID= syntax in fstab and during boot is intended to
>> mitigate the fact that the kernel cannot guarantee the order it finds
>> devices during boot.
>>
> Noted, I'll look into this.

Thanks to smartctl, we now have an index of drive names to serial
numbers.  Whenever you create an array, document what drive is what
role, just in case.

[trim /]

>>> I'm guessing its some kind of user error that prevents me from copying
>>> that superblock.
>>
>> Yes, something destroyed it.
> The superblock is available on the original drive, I can do mdadm -E
> /dev/sdb all day long. It just hasn't transferred to the new disk.

Hmmm.  v0.90 is at the end of the member device.  Does your partition go
all the way to the end?  Please show your partition tables:

fdisk -lu /dev/sd[bcdefg]

>>> I'm still trying to determine if bringing the array up (--assemble
>>> --force) using this disk with the missing data will be just bad or very
>>> bad? I've been told that mdadm doesn't care, but what will it do when
>>> data is missing in a chunk on this disk?
>>
>> Presuming you mean while using the ddrescued copy, then any bad data
>> will show up in the array's files.  There's no help for that.
> Right, but the array will come up and fdisk (xfs_repair) should be able
> to get it going again with most data avalable? mdadm won't get wonky
> when expected parity data isn't there for example?

Yes, xfs_repair will fix what's fixable.  It might not notice file
contents that are no longer correct.

[trim /]

>> /dev/sdb has six pending sectors--unrecoverable read errors that won't
>> be resolved until those sectors are rewritten.  They might be normal
>> transient errors that'll be fine after rewrite.  Or they might be
>> unwritable, and the drive will have to re-allocate them.  You need
>> regular "check" scrubs in a non-degraded array to catch these early and
>> fix them.
> I have smartd run daily 'short self test' and weekly 'long self test', I
> guess that wasn't enough.

No.  Each drive by itself cannot fix its own errors.  It needs its bad
data *rewritten* by an upper layer.  MD will do this when it encounters
read errors in a non-degraded array.  And it will test-read everything
to trigger these corrections during a "check" scrub.  See the "Scrubbing
and Mismatches" section of the "md" man-page.

As long as these errors aren't bunched together so much that MD exceeds
its internal read error limits, the drives with these errors are fixed
and stay on online.  More on this below, though.

>> Since ddrescue is struggling with this disk starting at 884471083, close
>> to the point where MD kicked it, you might have a large damage area that
>> can't be rewritten.
>>
>>> I have been wondering about that, it would be difficult to do (not to
>>> mention I'd have to buy a bunch of large disks to backup to), but I have
>>> (am) considered it.
>>
>> Be careful selecting drives.  The Samsung drive has ERC--you really want
>> to pick drives that have it.
> Noted, I'll look into what that is and hope that my new disks have it as
> well.

Your /dev/sdb {SAMSUNG HD154UI S1Y6J1LZ100168} has ERC, and it is set to
the typical 7.0 seconds for RAID duty:

> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)

Your /dev/sdc {SAMSUNG HD154UI S1XWJX0D300206} also has ERC, but it is
disabled:

> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled

Fortunately, it has no pending sectors (yet).

Your /dev/sdd {SAMSUNG HD154UI S1XWJX0B900500} and /dev/sde {SAMSUNG
HD154UI S1XWJ1KS813588} also have ERC, and are also disabled.

If ERC is available, but disabled, it can be enabled by a suitable
script in /etc/local.d/ or in /etc/rc.local (Enterprise drives enable it
by default, desktop disks do not.), like so:

# smartctl -l scterc,70,70 /dev/sdc

Now for the bad news:

Your /dev/sdf {ST3000DM001-1CH166 W1F1LTQY} and /dev/sdg
{ST3000DM001-1CH166 W1F1LTQY} do not have ERC at all.  Modern "green"
drives generally don't:

> Warning: device does not support SCT Error Recovery Control command

Since these cannot be set to a short error timeout, the linux driver's
timeout must be changed to tolerate 2+ minutes of error recovery.  I
recommend 180 seconds.  This must be put in /etc/local.d/ or
/etc/rc.local like so:

# echo 180 >/sys/block/sdf/device/timeout

If you don't do this, "check" scrubbing will fail.  And by fail, I mean
any ordinary URE will kick drives out instead of fixing them.  Search
the archives for "scterc" and you'll find more detailed explanations
(attached to horror stories).

>> If I understand correctly, your current plan is to ddrescue sdb, then
>> assemble degraded (with --force).  I agree with this plan, and I think
>> you should not need to use "--create --assume-clean".  You will need to
>> fsck the filesystem before you mount, and accept that some data will be
>> lost.  Be sure to remove sdb from the system after you've duplicated it,
>> as two drives with identical metadata will cause problems for MD.

> Correct, that is the plan: Assemble degraded with the 3 'good' disks and
> the ddrescued copy, xfs_repair and add the 5th disk back. Allow it to
> resynch the array. Then reshape to raid 6. Allow that to finish, then
> add another disk and grow the array/lvm/filesystem. Looking at a lot of
> beating on the disks reshaping so much, but after that I should be fine
> for a while. I'll probably add a hot spare as well.

I would encourage you to take your backups of critical files as soon as
the array is running, before you add a fifth disk.  Then you can add two
disks and recover/reshape simultaneously.

Phil

