From: Phil Turmel <philip@turmel.org>
Subject: Re: 9 second recovery when re-adding a drive that got kicked out?
Date: Mon, 5 Jun 2017 22:58:31 -0400
Message-ID: <e70502a2-8bef-f771-6063-df0b0accc090@turmel.org>
References: <20170604223817.ntxlvafgfa2umww2@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170604223817.ntxlvafgfa2umww2@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/04/2017 06:38 PM, Marc MERLIN wrote:
> Howdy,
> 
> Can you confirm that I understand how the write intent bitmap works, and
> that it doesn't cover the entire array, but only a part of it, and once
> you overflow it, syncing reverts to syncing the entire array?

There's no overflow.  The size correlation between bits in the bitmap
and areas in the array is adjusted so the whole array can be
represented.  One bit can be many multiples of a page, iirc.

> I had a raid5 array with 5 6TB drives.
> 
> /dev/sdl1 got kicked out due to a bus disk error of some kind.
> The drive is fine, it was a cabling issue, so I fixed the cabling,
> re-added it, and did
> 
> gargamel:~# mdadm -a /dev/md6 /dev/sdl1
> 
> Then I saw this:
> [ 1001.728134] md: recovery of RAID array md6
> [ 1010.975255] md: md6: recovery done.

> So let's say I have 64MB chuncks, each take 16 bits.
> The whole array is 22,892,144MiB
> That's 357,689 chunks, or about 700KB (16 bits per chunk) to keep all the
> state, but there is 44 pages of 4KB, or 176KB of write intent
> state.

So each bit in the bitmap represents two 4k pages.

Nine seconds to re-add after a short disconnect is perfectly normal.
For lightly loaded arrays, it can be virtually instant.

Phil
