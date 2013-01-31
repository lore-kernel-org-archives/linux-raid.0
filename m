From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Thu, 31 Jan 2013 15:40:00 -0700
Message-ID: <88758108-9333-4224-9006-8E44E717AB29@colorremedies.com>
References: <510A4AAE.6000009@evilazrael.de> <20130131113820.GA20536@cthulhu.home.robinhill.me.uk> <510A6E54.5050001@evilazrael.de> <CAF3D534-D907-4A88-AFAF-EA9B97C1D8BF@colorremedies.com> <20130131221007.GA1447@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130131221007.GA1447@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: Christoph Nelles <evilazrael@evilazrael.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 31, 2013, at 3:10 PM, Robin Hill <robin@robinhill.me.uk> wrote:

> If there is a read error
> further back then I'd blame it on timeout issues, with the drive still
> trying to complete the read operation while the kernel's timed out and
> trying to send a write.

I think we need the whole log for the time before the start of the error1.txt file provided previously. And also I'd like to know which /dev/ device was the first to have a problem, that instigated the rebuild. And if during the rebuild if the file system was mounted rw, and if any writes were done at all. If so, that probably nixes --assume-clean. If it was rebuilding and not written to from the file system, the disk being rebuilt shouldn't actually be out of sync with the array state.

The disk that needs spot sector repairs is the one with UREs, I think that's sdj1. If that disk is dd'd to another disk, the new disk won't produce UREs for sectors missing data, and the chunks comprised of those sectors won't get rebuilt by md.

So the disk to possibly dd to another is the one with the write error, sdg1. But only if the idea is to not use --assume-clean. That way a reassemble can rebuild, and not encounter another write error on that drive.

> Not a chance I'd use it if it's actually failing to remap bad sectors,
> no. Only had that with one drive so far though (out of several hundred),
> most get failed out after getting more than a handful of remapped
> sectors.

I think I see a use case for badblocks destructive writes if the disk doesn't support enhanced secure erase (which writes a pattern not just zeros). Of on laptops where it's not possible to get a disk to reset on sleep, allowing it to be unfrozen for the purposes of using secure erase. But if available, secure erase is faster and wipes all sectors even those without LBAs. For sure with SSDs it's what should be used.


Chris Murphy