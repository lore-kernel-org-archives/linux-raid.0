From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Suboptimal raid6 linear read speed
Date: Tue, 15 Jan 2013 20:48:23 -0600
Message-ID: <50F614F7.20104@hardwarefreak.com>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130115125507.GA12184@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/15/2013 6:55 AM, Peter Rabbitson wrote:
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

It is right.  You're likely confusing the "smarts" of RAID1/10
optimizations.  In that case you have more than one copy of each block
on more than one drive allowing for additional parallelism.  With a 4
drive RAID6 you only have one copy of each block on one drive.  Thus as
Phil states the best performance you can get here is 2 spindles of
throughput, which is why you're seeing a max of ~250MB/s for the array.

Unless you plan to expand this array in the future by adding more drives
and doing a reshape, I'd suggest you switch to RAID10.   It will give
you 3x or more write throughput with greatly reduced latency,
substantially faster rebuild times, and possibly a little extra read
throughput.

With only 4 drives RAID6 doesn't make sense as RAID10 is superior in
every way.

-- 
Stan

