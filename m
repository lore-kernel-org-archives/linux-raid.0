From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Thu, 31 Jan 2013 10:46:17 -0700
Message-ID: <CAF3D534-D907-4A88-AFAF-EA9B97C1D8BF@colorremedies.com>
References: <510A4AAE.6000009@evilazrael.de> <20130131113820.GA20536@cthulhu.home.robinhill.me.uk> <510A6E54.5050001@evilazrael.de>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <510A6E54.5050001@evilazrael.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 31, 2013, at 6:15 AM, Christoph Nelles <evilazrael@evilazrael.de> wrote:

> All drives are available again. And the seecond failed device reports
> UREs. I will run badblocks on that device before continuing.
> I attached the kernel logs of the first error and of the second error. I
> hope i filtered them reasonably.

This looks like a write error, resulting in md immediately booting the drive. There's little point in using this drive again.

Jan 28 00:23:36 router kernel: Write(16): 8a 00 00 00 00 01 36 b2 55 50 00 00 00 30 00 00
Jan 28 00:23:36 router kernel: end_request: I/O error, dev sdg, sector 5212624208

What does smartctl -a return for this drive?


> Exactly. I am running badblocks on that device. SMART reports one
> "Pending Sector Count" :(

I'm unclear on the efficacy of badblocks for testing. I'd use smartctl -t long and then -a to see if there are sector problems and at what LBA; and for removing bad blocks (force a remap) I'd use either dd zeros with e.g. bs=1M, or I'd use ATA Secure Erase which is faster.

If you use the badblocks map when formatting a drive, e.g. using mkfs.ext4 -c, then it would allow you to use this disk but not in RAID. On top of raid, md gets the write error before the file system does, and boots the drive out of the array. Or on read error attempts to correct it. And even as a standalone drive do you really want to use a drive that can't remap future bad sectors?

Chris Murphy