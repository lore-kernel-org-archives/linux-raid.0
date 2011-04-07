From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 4-disk raid5 with 2 disks going bad: best way to proceed?
Date: Thu, 7 Apr 2011 09:21:56 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1104070916030.14027@uplift.swm.pp.se>
References: <BC7F2D63-87DF-4402-A42B-00702098AAC4@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BC7F2D63-87DF-4402-A42B-00702098AAC4@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: rob pfile <rpfile@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 6 Apr 2011, rob pfile wrote:

> Hi all,
>
> any collective wisdom on what to do here? i've got a 4-disk raid5, and 
> the most recent checkarray showed several bad blocks caused by 
> uncorrectable read errors on two of the disks in the array. both disks 
> in question show 0 reallocated sectors, but one looks like this:

Generally I'd recommend a "repair" as it would try to read all, if it 
can't read it properly, it'd recalculate from parity and as long as that 
write succeeded, you'd be golden.

To be safe, stop the array, dd_rescue the two bad drives, start the array 
again with the originals in the array, don't mount the filesystem, 
issue repair and see what happens.

This is one reason why I nowadays always run RAID6, then you can fail a 
drive and still have parity for read errors...

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
