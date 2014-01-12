From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Why 4k native drives haven't arrived
Date: Sat, 11 Jan 2014 21:01:02 -0700
Message-ID: <6AACF77C-5D54-4ABF-AA2D-FC3F4F1E141C@colorremedies.com>
References: <38C8AAEB-811B-442F-BA80-1EFAF00BADB1@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <38C8AAEB-811B-442F-BA80-1EFAF00BADB1@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 9, 2014, at 2:49 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 4Kn drives, i.e. 4096 byte physical and logical sector, drives maybe have been in the wild for some time, ~1 year.
> 
> http://forums.macrumors.com/showpost.php?p=16996220&postcount=189
> "Logical sector size: 4096 bytes"
> 
> And further, the LBA's are clearly 4096 bytes each based on the partition table sector start/end values only adding up to the size column if the (LBA) sectors are 4096 bytes each.
> 
> This drive is found in an enclosure, sold as a backup device, not intended for booting. 

Huh. Two more cases. All three involve USB enclosures. Bug or feature? Is it possible the enclosure's bridge chipset is disabling the drive's 512-byte emulation?

https://bbs.archlinux.org/viewtopic.php?pid=1162795
http://forum.buffalo.nas-central.org/viewtopic.php?f=68&t=25201



Chris Murphy