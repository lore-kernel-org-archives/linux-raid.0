From: Chris Murphy <lists@colorremedies.com>
Subject: Re: raid1 issue after disk failure: both disks of the array are still active
Date: Thu, 13 Sep 2012 11:02:36 -0600
Message-ID: <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120913103432.GA11764@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 13, 2012, at 4:34 AM, Robin Hill wrote:
> 
> Your best bet now is to do an array check:
>    echo check > /sys/block/md0/md/sync_action
> 
> This will force a read of all disks in the array. This should trigger
> the read error, causing an attempt to re-write the faulty block, in turn
> causing the drive remap the bad sector (assuming the re-write fails).

"check" records errors, no action is taken by the md driver to correct it, although the disk firmware itself may try reallocation. So far, that appears to not be the case. 

"repair" causes the md driver to write correct data (from copy or reconstructed from parity), which should force the disk firmware to reallocate the affected LBAs from bad physical sectors to good ones.

It seems in this case "repair" is indicated.


Chris Murphy