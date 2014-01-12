From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: read errors not corrected when doing check on RAID6
Date: Sun, 12 Jan 2014 18:18:55 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1401121816590.20074@uplift.swm.pp.se>
References: <alpine.DEB.2.02.1401120723010.20074@uplift.swm.pp.se> <21202.51095.833898.785557@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21202.51095.833898.785557@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 12 Jan 2014, Peter Grandi wrote:

> [ ... ]
>> So here now in the replace function, md decided to correct the
>> read errors on /dev/sds. Now the pending sectors are down to 7
>> on /dev/sds. There were some more errors which were also
>> corrected, and now the pending count is down to 5. Recovery is
>> still ongoing. [ ... ]  I expected it to correct the read
>> errors on the drive then, but it seems it didn't. [ ... ]
>
> That seems to me a big misunderstanding (or delusion).

Which of it? Pending sectors (which from my understanding is the same as 
UNC when reading) on a component drive in RAID6 wouldn't be re-calculated 
from parity and written to fix the problem?

But from my other email, it seems "pending sector" doesn't mean it always 
gives read errors, but just sometimes. The read errors I got from the 
check doesn't match up with the read errors I got when I did replace, and 
it also seems the read errors didn't always occur.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
