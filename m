From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Fri, 1 Feb 2013 10:27:57 -0700
Message-ID: <9F0E4AF3-4358-425F-8078-C068D5BB9487@colorremedies.com>
References: <510A4AAE.6000009@evilazrael.de> <20130131113820.GA20536@cthulhu.home.robinhill.me.uk> <510A6E54.5050001@evilazrael.de> <CAF3D534-D907-4A88-AFAF-EA9B97C1D8BF@colorremedies.com> <20130131221007.GA1447@cthulhu.home.robinhill.me.uk> <88758108-9333-4224-9006-8E44E717AB29@colorremedies.com> <20130201133455.GA24375@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130201133455.GA24375@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: Christoph Nelles <evilazrael@evilazrael.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Feb 1, 2013, at 6:34 AM, Robin Hill <robin@robinhill.me.uk> wrote:
> It'd also be useful to know whether sdg has been rewritten at
> all since then (i.e. whether the testing was destructive or not), and
> whether or not the array was written to at all since the failure of sdg.

OP needs to reply back.

Also I'd like to know what model disks these are, if they're AF or not.

>> Yes, if sdg still contains valid array data (and the array wasn't
> written since then) then it would definitely make more sense to recreate
> the array using it, leaving sdj out for now. That'll require more work
> checking mdadm versions and data offset values though. That'll avoid the
> issues with the unreadable blocks on sdj.

Here's an idea. One possibility is to use dd to read the sector on sdg1 that error1.txt reported with the write error, to a file, and see if there's a read error. If not, rewrite that data back to the same sector and see if there's a write error. If not, attempt to force assemble assume clean, get the array up in degraded mode, and do a non-destructive fsck. If that's OK, just take a backup immediately. Then sdj can be destructively written to, to force bad sectors there to be removed for reserves, but still needs a smart extended offline test to confirm; and then possibly reused and rebuilt.

> I prefer badblocks myself - I can see exactly what it's doing and what
> errors are seen. With secure erase you're dependent on the firmware
> internals to tell you what's actually going on (and, depending on the
> nature of the errors you're getting, this may already be suspect).

The firmware is always a go between, you can't actually get around it. Bad sectors are entirely the domain of the drive firmware so for that purpose I don't see an advantage of an external program over secure erase and SMART testing. If it lies on either of those, it'll lie to badblocks.

Where I can see the usefulness of badblocks, maybe not more so than other tools, is it would show non-disk related errors like UDMA/CRC errors related to controller or cable problems. Whereas the entire duration of secure erase and smart testing is strictly internal to the drive.


Chris Murphy