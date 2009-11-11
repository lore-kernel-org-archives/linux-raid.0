From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: bitmap-chunk sizing on RAID-10?
Date: Wed, 11 Nov 2009 15:32:22 -0800
Message-ID: <babafd2f0911111532u2c8fe9efhc48648fe262ec7e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: robin@robinhill.me.uk, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I didn't want to hijack the thread, so a new one here.

On Wed, Nov 11, 2009 at 2:10 PM, Robin Hill <robin@robinhill.me.uk> wrote:
> It's true for RAID-10, yes.  You can't physically grow the array, but
> you can definitely add/remove the bitmap.

Thanks for clearing that up.  The manpage is a bit unclear to my read.

I've just been reading threads about proper sizing.  Large
bitmap-chunk seems good, larger than "1 million bits" -- not, and an
old bug (resolved?) if bitmap-chunk is smaller than raid10 chunk size.

I've two arrays --

   /dev/md0 (RAID-1, across 4x 160MB partitions)

   /dev/md1 (RAID-10/f2 , across 4x ~1TB partitions, --chunk=256 )

The first array is so small, that resync takes just a few seconds
anyway.  Is there any advantage to still installing an internal
write-intent bitmap on it?

The second array takes a few hours to resync from scratch, and so the
bitmap has performance value.  What's the right size for
--bitmap-chunk for an internal bitmap?  Iiuc, the default that "is
automatically deteremined to make best use of available space" results
in 2x-4x (some say 10%) write-performance slowdowns.  I'd like to
avoid that perf hit, but since I did NOT create the array with bitmap,
getting sizing "right" (i.e., not too big for the superblock space) is
important.

Some threads refere to "the math" for different RAID types, but I
haven't figured out what that math is yet.

How do I get to the "right" bitmap-chunk size?

Thanks

BenDJ
