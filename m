From: Chris Murphy <lists@colorremedies.com>
Subject: Re: recovering RAID5 from multiple disk failures
Date: Sat, 2 Feb 2013 17:39:33 -0700
Message-ID: <81724A2E-B6CA-4C6B-BC4E-9F5851F0096A@colorremedies.com>
References: <kegcd6$6dl$1@ger.gmane.org> <510BC173.7070002@turmel.org> <kej2t8$vk8$1@ger.gmane.org> <510D184E.4070106@turmel.org> <B7E27E99-9C89-4FC5-A12D-EFFAB5EDE5EB@colorremedies.com> <kek222$1tf$1@ger.gmane.org> <D0556FFA-7710-47DC-873C-38820439F054@colorremedies.com> <510DAE04.5070709@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <510DAE04.5070709@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Michael Ritzert <ksciplot@gmx.net>, "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 2, 2013, at 5:23 PM, Phil Turmel <philip@turmel.org> wrote:
> 
> I do disagree.
> 
> The above, combined with:
> 
>> I do know where the bad sectors are from the ddrescue report. We are
>> talking about less that 50kB bad data on disk1. Unfortunately, disk3
>> is worse, but there is no sector that is bad on both disks.
> 
> Leads me to recommend "mdadm --create --assume-clean" using the original
> drives, taking care to specify the devices in the proper order (per
> their "Raid Device" number in the --examine reports).  I still haven't
> seen any data that definitively links specific serial numbers to
> specific raid device numbers.  Please do that.
> 
> After re-creating the array, and setting all the drive timeouts to 7.0
> seconds, issue a "check" scrub:
> 
> echo "check" >/sys/block/md0/md/sync_action
> 
> This should clean up the few pending sectors on disk #1 by
> reconstruction from the others, and may very well do the same for disk #3.
> 
> If disk #3 gets kicked out at this point, assemble in degraded mode with
> disk #2, #4, and a fresh copy of disk #1 (picking up the new superblock
> and any fixes during the partial scrub).  Then "--add" a spare (wiped)
> disk and let the array rebuild.
> 
> And grab your data.

OK I understand. This seems reasonable to me as well. It is very important to get *each* drive's SCT ERC's set before starting the check!

So basically disk1 being out of sync in this instance is considered minimal, and worth taking a chance on in order to avoid losing the 50kb of data affected by bad sectors; because they may be all the difference in easily getting the array up, mounted, and the data off the disk.


Chris Murphy