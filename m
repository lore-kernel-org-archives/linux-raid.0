From: Ian Young <ian@duffrecords.com>
Subject: Re: not enough operational mirrors
Date: Mon, 22 Sep 2014 17:55:16 -0700
Message-ID: <CANs+QMyuNDsxRVLbR_4-ki79x8OHRCwwMGOmbPkLRwM38ZBAaA@mail.gmail.com>
References: <CANs+QMzWWqh-5MemOrbguaq7fNzJPDaYUH66K0rgGrnaXY7FNA@mail.gmail.com>
	<20140922154717.6cd3cab2@notabene.brown>
	<CANs+QMxHe3SBAk=VaUQuwOSGyv9p8dJjFsxPT+hvf+c20T23=g@mail.gmail.com>
	<20140923095328.0e6ed347@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140923095328.0e6ed347@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It's XFS.  I'm running:

 xfs_repair -n /dev/mapper/vg_raid10-srv

I expect it will take hours or days as this volume is 8.15 TiB.

On Mon, Sep 22, 2014 at 4:53 PM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 22 Sep 2014 10:17:46 -0700 Ian Young <ian@duffrecords.com> wrote:
>
>> I forced the three good disks and the one that was behind by two
>> events to assemble:
>>
>> mdadm --assemble --force /dev/md0 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sde2
>>
>> Then I added the other two disks and let it sync overnight:
>>
>> mdadm --add --force /dev/md0 /dev/sdd2
>> mdadm --add --force /dev/md0 /dev/sdf2
>>
>> I rebooted the system in recovery mode and the root filesystem is
>> back!  However, / is read-only and my /srv partition, which is the
>> largest and has most of my data, can't mount.  When I try to examine
>> the array, it says "no md superblock detected on /dev/md0."  On top of
>> the software RAID, I have four logical volumes.  Here is the full LVM
>> configuration:
>>
>> http://pastebin.com/gzdZq5DL
>>
>> How do I recover the superblock?
>
> What sort of filesystem is it?  ext4??
>
> Try "fsck -n" and see if it finds anything.
>
> The fact that LVM found everything suggests that the array is mostly
> working.  Maybe just one superblock got corrupted somehow.  If 'fsck' doesn't
> get you anywhere you might need to ask on a forum dedicated to the particular
> filesystem.
>
> NeilBrown
>
>
>>
>> On Sun, Sep 21, 2014 at 10:47 PM, NeilBrown <neilb@suse.de> wrote:
>> > On Sun, 21 Sep 2014 22:32:19 -0700 Ian Young <ian@duffrecords.com> wrote:
>> >
>> >> My 6-drive software RAID 10 array failed.  The individual drives
>> >> failed one at a time over the past few months but it's been an
>> >> extremely busy summer and I didn't have the free time to RMA the
>> >> drives and rebuild the array.  Now I'm wishing I had acted sooner
>> >> because three of the drives are marked as removed and the array
>> >> doesn't have enough mirrors to start.  I followed the recovery
>> >> instructions at raid.wiki.kernel.org and, before making things any
>> >> worse, saved the status using mdadm --examine and consulted this
>> >> mailing list.  Here's the status:
>> >>
>> >> http://pastebin.com/KkV8e8Gq
>> >>
>> >> I can see that the event counts on sdd2 and sdf2 are significantly far
>> >> behind, so we can consider that data too old.  sdc2 is only behind by
>> >> two events, so any data loss there should be minimal.  If I can make
>> >> the array start with sd[abce]2 I think that will be enough to mount
>> >> the filesystem, back up my data, and start replacing drives.  How do I
>> >> do that?
>> >
>> > Use the "--force" option with "--assemble".
>> >
>> > NeilBrown
>
