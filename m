From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: future of raid 6
Date: Mon, 4 Sep 2017 11:53:47 +0200
Message-ID: <20170904095347.GA4187@metamorpher.de>
References: <2811558.CnJCJrJZ21@markus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2811558.CnJCJrJZ21@markus>
Sender: linux-raid-owner@vger.kernel.org
To: Markus <M4rkusXXL@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Sep 03, 2017 at 08:28:15PM +0200, Markus wrote:
> (Rebuilds are likely to hit an unrecoverable error, not to mention the 
> long time it will take to rebuild raids with +10TB per drive.)

Rebuilds are not likely to hit an unrecoverable error at all.
Rebuilds do not take a long time, and it tends to be irrelevant.

A lot of articles make rebuilds out to be some kind of mythological beast 
that breathes fire, spits poison, and devours your drives. It's not true.

The probability of failure during a rebuild is not higher than normal. 
A rebuild is as boring as can be, just a linear read (n-1 drives), 
linear write (1 drive). Reshapes are more interesting but it's still 
just normal reading and writing: there is no magic involved, there is 
absolutely nothing that could possibly cause undue drive failures.

Drives fail randomly, silently. The only way to verify that a drive hasn't 
failed yet is to read everything from start to end. If you don't run these 
read tests regularly, the error will go unnoticed for weeks, months, years.

That's the timeframe we're really looking at: not hours, days it actually 
takes for the rebuild itself to finish, but weeks (for you to order a new 
drive and it actually getting shipped), and months (for you to detect the 
error in the first place and bring yourself to order a replacement and not 
see how it goes first because you feel the pinch of replacement costs).

If you do not monitor and regularly test your drives to cut down this time, 
no amount of redundancy will ever be enough. If you never run any tests, 
the errors will pop up during rebuild. If you never tested and thus allowed 
the rebuild itself to be the first ever test in years, it's not a miracle. 
You can't blame the rebuild for that.

It has nothing to do with bit error rates, timeouts, same batch of drives, 
and all the other shit people come up with to make excuses for their lack 
of monitoring drives properly.

Genuine simultaneous drive failures are *very* rare.

> What is the future for redundant mass storage?

It's still RAID-5 or something similar on a filesystem level.
Simply because it works, and it's cost effective. It doesn't matter 
if the drive has 1000MB, 100GB, 10TB - nothing changed.

Most machines (desktops, nas, rented servers) only have 2-4 drives anyway. 
You need twice as many for RAID-6 to start making any kind of sense, 
and triple parity is even further off, like 20+ drives.

If you're currently running a three drive RAID-6 and need more redundancy, 
you can do it with a four drive RAID-1. Knock yourself out. Nobody does it. 
It's barking mad. The only problem it solves does not really exist.

And regardless of redundancy, you still need backups. If you have backups, 
the zero point something chance of simultaneous failure matters even less.

Regards
Andreas Klauer
