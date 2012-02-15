From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: Re: mdadm dropped disk, won't re-add
Date: Thu, 16 Feb 2012 00:01:26 +0100
Message-ID: <E7B5E9EB-B341-459D-9C4E-C6E964DCAF6F@physik.fu-berlin.de>
References: <1329314322.3574.16.camel@z6> <20120215144536.GC18336@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120215144536.GC18336@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Feb 15, 2012, at 3:45 PM, Robin Hill wrote:

>> I have tried re-adding sdc1 with the --re-add command, but mdadm again
>> refuses to re-add the drive.
>> 
> That's a safety measure. If it can't actually re-add the drive then it
> fails, rather than changing to do an --add instead (as older mdadm
> versions did), potentially losing data.

Aha, thanks for clarifying.

>> My primary question is whether mdadm actually deletes any important data
>> on the remaining disks (sd{b,c,d}1) while rebuilding or whether it just
>> writes data to the newly added disk sde1.
>> 
> It just writes data/checksums to the newly added disk. The only writes
> to the remaining disks will be if other applications are writing to the
> array during the rebuild process.

Great :). I was hoping so.

>> Can anyone give further advise?
>> 
> What errors does dmesg give about why sdc1 was failed? You'll need to
> fix that before you try recovering the array. If it's a drive error then
> using ddrescue to clone it (or as much of it as possible) to sde1 would
> probably be your best bet, then get a replacement drive.

Those were errors related to the cable, the SATA link failed, the disk is ok,
smart log is clean.

> Once you've fixed that issue then you should be able to force assemble
> the array (mdadm -S /dev/md0; mdadm -Af /dev/md0) and continue/restart
> the recovery process. I'd recommend doing a fsck on the filesystem
> afterwards as well, especially if you've replaced sdc.

It did work, the raid is now rebuilding. I had actually had a friend who has
more expertise (he is a casual kernel hacker himself) have a look at it and
he fixed everything.

Basically, he reassembled the array from sd{b,c,d}1 with the --force option,
corrected the partitioning on the sde disk (I created a partition larger than
on the other disks accidentally, so he just copied the partition table from
one of the other disks in the array) and then added sde1 as a new disk.

Raid is no rebuilding and will be finished in 4 hours.

Thanks a lot for your quick help!

Adrian
