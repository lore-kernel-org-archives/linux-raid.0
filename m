From: Phil Turmel <philip@turmel.org>
Subject: Re: Suboptimal raid6 linear read speed
Date: Tue, 15 Jan 2013 18:17:16 -0500
Message-ID: <50F5E37C.3060103@turmel.org>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130115125507.GA12184@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/15/2013 07:55 AM, Peter Rabbitson wrote:
> On Tue, Jan 15, 2013 at 07:49:10AM -0500, Phil Turmel wrote:
>> You are neglecting each drive's need to skip over parity blocks.  If the
>> array's chunk size is small, the drives won't have to seek, just wait
>> for the platter spin.  Larger chunks might need a seek.
> 
>> Either way, you
>> won't get better than (single drive rate) * (n-2) where "n" is the
>> number of drives in your array. (Large sequential reads.)
> 
> This can't be right. As far as I know the md layer is smarter than that, and
> includes various anticipatory codepaths specifically to leverage multiple
> drives in this fashion. Fwiw raid5 does give me the near-expected speed
> (n * single drive).

Please look at the chunk layout for raid6.  There's parity P and Q
chunks evenly distributed amongst all drives.

http://en.wikipedia.org/wiki/Standard_RAID_levels

When not degraded, reading many chunks worth of sequential data from the
array, MD's requests to the drives will omit those parity blocks.  The
drive, if it was reading ahead, will have to discard that data, or if
not reading ahead, will have to seek past it.  This happens every N-2
chunks per drive.

Your test reads from the individual disks read contiguous sequential
blocks.  Sequential reads from a raid6 array will generate short
sequential reads on each drive, separated by skips over the unneeded
parity chunks.  This is true for raid5 as well, but only skipping one
chunk instead of two.

MD doesn't have any secret sauce that'll let it magically avoid those
skips.  If you can't see that, I can't help you further.

Phil
