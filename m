From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Idea for new RAID type - background extended recovery information
Date: Wed, 9 Dec 2009 16:45:47 -0800
Message-ID: <4877c76c0912091645w449cb652k73b2958e9159d77b@mail.gmail.com>
References: <4877c76c0912090106i684924edn7915c6609ab574f5@mail.gmail.com>
	 <alpine.DEB.1.10.0912091143350.23464@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0912091143350.23464@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 9, 2009 at 2:53 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> Generally, my experience has been that total disk failures are fairly rare,
> instead with the much larger disks today, I get single block/sector
> failures, meaning 512 bytes (or 4 k, I don't remember) can't be read. Is
> there any data to support this?
>

I agree with this failure mode.  I've seen occasional disk failures;
usually on single drive systems, far more often are either single
failures; or in the case of laptops (and possibly also hard drives
running in more seismically active areas) occasional runs of
head-crashes.  In the case of a head-crash it would be a _VERY_ good
idea to copy the data off first then recover it, but one would expect
only a moderate volume of poison data.  Having a layer to identify
which data is suspect, and potentially provide recovery information
would be a great idea.  In my use cases I'd probably dedicate an
entire stripe for every 64 that are backed by it.  Changing any
information within that 64 stripe section would result in a change to
the parity data, but that layer needn't be updated constantly, during
idle periods would be a sufficient safety net, so long as it was
automated; the list of checksums would of course be updated with the
same operation.

So there would be three basic functions:

1) Determine if chunks are the expected checksum.
2) Determine if chunks are the correct version (to provide upper
layers with atomic storage).
3) Provide low-density recovery data.  Not enough to protect against a
disk loss, but whatever scale of safety net between 0 and 100% of a
drive is desired.
