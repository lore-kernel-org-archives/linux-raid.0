From: Phil Turmel <philip@turmel.org>
Subject: Re: High mismatch count on root device - how to best handle?
Date: Tue, 26 Apr 2011 15:38:38 -0400
Message-ID: <4DB71F3E.3040003@turmel.org>
References: <BANLkTikLN6P52tknwD0+D-+2iDUp3sF1fA@mail.gmail.com>	<BANLkTikwv-PRcwknZkMsPY6T+N0p=-uC4w@mail.gmail.com> <BANLkTinS9=v+qHAyewRu19HgGr4iriwjkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinS9=v+qHAyewRu19HgGr4iriwjkw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mark,

On 04/26/2011 01:22 PM, Mark Knecht wrote:
> On Mon, Apr 25, 2011 at 6:30 PM, Mark Knecht <markknecht@gmail.com> wrote:
[trim /]

> OK, I don't know exactly what I'm looking for a problem here. I ran
> the repair, then rebooted. Mismatch count was zero. It seemed the
> repair had worked.
> 
> I then used the system for about 4 hours. After 4 hours I did another
> check and found the mismatch count had increased.
> 
> What I need to get a handle on is:
> 
> 1) Is this serious? (I assume yes)

Maybe.  Are you using a file in this filesystem as swap in lieu of a dedicated swap partition?

I vaguely recall reading that certain code paths in the swap logic can abandon queued writes (due to the data no longer being needed by the VM), such that one or more raid members are left inconsistent.  Supposedly only affecting mirrored raid, and only for swap files/partitions.

I don't know if this was ever fixed.  or even if anyone tried to fix it.

> 2) How do I figure out which drive(s) of the 3 is having trouble?

Don't know.  Failing drives usually give themselves away with warnings in dmesg, and/or ejection from the array.  There's nothing in the kernel or mdadm that'll help here.  You'd have to do three-way voting comparison of all blocks on the member partitions.

> 3) If there is a specific drive, what is the process to swap it out?

mdadm /dev/mdX --fail /dev/sdXY
mdadm /dev/mdX --remove /dev/sdXY

(swap drives)

mdadm /dev/mdX --add /dev/sdZY

HTH,

Phil
