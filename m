From: Michael Robinton <michael@insulin-pumpers.org>
Subject: Re: RAID5 crash and burn
Date: Sun, 31 Oct 2004 11:05:35 -0800 (PST)
Message-ID: <Pine.LNX.4.33.0410311103000.27599-100000@pandora.is.bizsystems.com>
References: <1430.63.204.219.3.1099198742.squirrel@63.204.219.3>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1430.63.204.219.3.1099198742.squirrel@63.204.219.3>
Sender: linux-raid-owner@vger.kernel.org
To: coreyfro@coreyfro.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 30 Oct 2004 coreyfro@coreyfro.com wrote:

> Its that time of the year again.  My biannual RAID5 crash.  Yippie!
>
> I had a drive die yesterday, and, while raid 5 can handle that, the kernel
> couldn't handle the swap on that drive going poof.  My system crashed, so
> I rebooted, thinking that the system would be able to figure out that the
> swap was dead and not to start it.
>
> RAID5 started rebuilding, services started loading, started loading swap,
> system crashed again.
>
> Now, my raid is down.  I have tried using mdadm, the old raidtools, and
> kicking the machine, but nothing has worked.
>
> Here is all the info I can think to muster, let me know if i need to add
> anything else.
>
> Thanks,
> Coreyfro
>
You need to add an additional raid1 partition the size of your swap and
use that so you don't have the same situation arise again.

my raid5 disks all have an extra "work" partition the size of swap (3
drives) the spares are allocated

2 - mdN for swap
1 - maintenance

if you have more drives in your raid, you can allocate additional pairs
for swap and cut down on the partition size overall.

Michael

