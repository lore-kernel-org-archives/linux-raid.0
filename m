From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: feature suggestion to handle read errors during re-sync of raid5
Date: Sat, 30 Jan 2010 18:51:29 +0100
Message-ID: <4B6471A1.2070407@texsoft.it>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
>
> So, a couple of times I've been having the problem of something going 
> wrong on raid5, drive being kicked, thus has a lower event number, 
> re-add, during the sync a single block on one of the other drives has 
> a read error (surprisingly common on WD20EADS 2TB drives), resync 
> stops, I have to take down the array, ddrescue the whole read error 
> drive to another drive, I lose that block, start up the array 
> degraded, and then add the drive again.
> It would be nice if there was an option that when re-sync:ing a drive 
> which earlier belonged to the array, if there is a read error on 
> another drive, just use the parity from the drive being added (in my 
> case it's highly likely it'll be valid, and if it's not, then I 
> haven't lost anything anyway, because the read error block is gone 
> anyway).

I had similar problem recently and I'm debating on another thread on 
read errors too.
I think that your proposal can be useful to recover from panic 
situation, and surely would have helped me to recover from disaster: my 
failed drive was not 100% dead, and if I could use it to correct read 
errors from the other disk, I would save lot of time, pain and angriness.
But also I think some work must be done on read errors policy for raid, 
to avoid these situations to present, where possible.

Btw, I've a doubt:
You say that these errors are common on these drives.
In another post I read that 'with modern drives it is possible to have 
some failed sector'.

I supposed that modern hard drives' firmware would recover and relocate 
dying sectors by its own (using smart and other techs), and that the OS 
gets read errors only when the drive is actually in very bad shape and 
can't cope with the problem, and it's time to trash it. Having the OS 
recover and rewrite the sectors makes me feel back in the past, when 
under DOS we used PCTools and other utilities to do this recovery stuff 
on ST-506 drives .... and this works well on raid, but in sinlge disk 
configuration, shouldn't these be data loss?

I'm confused... how much are modern disks reliable?

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


