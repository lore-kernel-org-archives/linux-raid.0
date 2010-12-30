From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: New raid level suggestion.
Date: Thu, 30 Dec 2010 09:24:32 -0500
Message-ID: <AANLkTinJCQsaOuzQub9A7qU_HjGhUuXpp1oq+=5hTb3E@mail.gmail.com>
References: <20101230082356.GC2986@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101230082356.GC2986@bitwizard.nl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 30, 2010 at 3:23 AM, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
> So I was thinking.... He's resigned himself to a configuration where
> he pays for 4x the disk space and only gets 2x the available space.
>
> So he could run his array in RAID10 mode, however when a drive fails,
> a fallback to raid5 would be in order. In this case, after the resync
> a single-drive-failure tolerance is again obtained.
>
> In practise scaling down to raid5 is not easy/possible. RAID4 however
> should be doable.
>
> In fact this can almost be implemented entirely in userspace. Just
> remove the mirror drive from the underlying raid0, and reinitialize as
> raid4. If you do this correctly the data will still be there....
>
> Although doing this with an active filesystem running on these drives
> is probably impossible due to "device is in use" error messages....

Paying for 4x the disk space and only getting 2x is about performance.
You can't just view disks by the raw space they provide.

Even if the scenario of converting RAID10 to RAID4 was possible you
now have no redundancy during the conversion. The chance of a disk
failing is greater than just running the RAID10 until you can replace
the faulty disk. Not to mention the performance penalty of the resync
parity calculation. RAID10 when degraded has minor hit to performance
compared to a RAID level with parity.

All you need to do is purchase 5 disks if you want 4 in RAID10. Have
the cold spare ready when one fails. This reduces the replacement time
as you don't have to wait for a drive to be ordered.

Ryan
