From: Mark <grimm26@gmail.com>
Subject: Re: RAID10 scrub
Date: Wed, 2 Oct 2013 13:15:20 -0500
Message-ID: <CA+FAjA_fNs3Rk_omsxGMnyB+VV+hNpBgRswD1BNWTLDQpM8e1A@mail.gmail.com>
References: <CA+FAjA90MPuA4aQUqmKRAzEsxJFMFJ9_UZFeiWJd__QAmS-mBg@mail.gmail.com>
	<20131002075538.GA20005@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131002075538.GA20005@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 2, 2013 at 2:55 AM, Robin Hill <robin@robinhill.me.uk> wrote:
> On Tue Oct 01, 2013 at 03:42:39 -0500, Mark Keisler wrote:
>
>> Is scrub (sync) needed on RAID10?  I've noticed in mdadm monitor logs that
>> it seems to re-allocate data destined for bad blocks on the fly anyway.
>>  Maybe I don't quite understand what the scrub does, though :)
>> I ran it for the first time on my RAID last night anyway to make sure all
>> way well since I am failing out a dying disk for replacement today.
>
> "Scrubbing" will read all the data on all the disks in the array, which
> ensures there's no read errors (as well as correcting any parity/mirror
> mismatches). Any found will then get rewritten (which may cause a bad
> block re-allocation in the background) while the parity/mirrored data is
> still available. If there's too many in a short time then the disk will
> be failed.
>
> Otherwise you'll only find out about read errors if the data happens to
> be read in normal use, or when you're trying to recover a failed disk
> (and unless you have multiple levels of redundancy, you're then
> stuffed).
>
> I'd recommend running it regularly on any software RAID setup (well, any
> with redundancy anyway).
>
> Cheers,
>     Robin

Thanks for the explanation, I like to avoid getting stuffed :)
