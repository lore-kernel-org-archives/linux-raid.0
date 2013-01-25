From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Recovering from an URE on a RAID5 rebuild/resize
Date: Fri, 25 Jan 2013 13:28:06 -0700
Message-ID: <B744BEEF-E703-439A-AD82-94CCFE13A795@colorremedies.com>
References: <20130125171459.5f855c92@natsu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130125171459.5f855c92@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 25, 2013, at 4:14 AM, Roman Mamedov <rm@romanrm.ru> wrote:
> 
> Let's assume only a couple of sectors on that member were unreadable, and then
> their readability was restored (either by drive replacement or by overwriting
> them to making the drive remap), and I would be okay with losing data that was
> in those sectors.
> 
> What would be the best way to proceed from there?

Seems to me if you lose a sector, you've lost a chunk, and if you lost a chunk you've lost a full stripe. So for a 512KB chunk, you've lost a few MB at least. It could be anything, files, directory information, a whole superblock.

I think you'd need a mechanism to ask md to ignore the reconstruction of a stripe containing a bad sector (the URE), and proceed with the next stripe rather than halting. That is, do not replace either data or parity chunks in a stripe which contains a bad sector, simply do not rebuild that full stripe. But, I don't know if "doing nothing" for that stripe is possible, if md can find the next stripe's first chunk and proceed on with the rebuild. Or if the rebuild has sequential dependency.

In any case, you'd have unknown problems above.

What you'd be better off with is a way to reconstruct that 512 bytes, and to do that you'd need to know what's on it. And to do that, well first you need to know the affected LBA (easy), then figure out how to get md to tell you what LBA's are in the affected stripe (no clue how to do this), and then ask the file system what things are stored in those LBAs, and if you can, replace them. Tedious to say the least, you have 1024 LBA's to sift through to find out what's affected by that one sector loss. Because md certainly has no idea what it is. And I bet dollar to donuts you can't look at that one sector (even if the drive let you, which it won't) and know what's there, just the nature of how it's encoded. Maybe you'd have a better chance.

In a way you'd be better off just blowing away that whole stripe, either from the file system level (force the reassemble of the array in degraded mode, and overwrite the affected file system LBAs, which will travel down and zero out that whole stripe and probably then some, and thus "fix" the read error); or if there were a feature in md to just write zeros to a whole stripe (data and parity chunks) affected by a URE. Now you have holes in your file system but maybe there's something to recapture.


Chris Murphy