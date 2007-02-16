From: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.20: reproducible hard lockup with RAID-5 resync
Date: Fri, 16 Feb 2007 18:59:54 +1100
Message-ID: <17877.25722.404051.470040@notabene.brown>
References: <45D55366.4010904@fatooh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Corey Hickey on Thursday February 15
Sender: linux-raid-owner@vger.kernel.org
To: Corey Hickey <bugfood-ml@fatooh.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 15, bugfood-ml@fatooh.org wrote:
> I think I have found an easily-reproducible bug in Linux 2.6.20. I have
> already applied the "Fix various bugs with aligned reads in RAID5"
> patch, and that had no effect. It appears to be related to the resync
> process, and makes the system lock up, hard.

I'm guessing that the problem is at a lower level than raid.
What IDE/SATA controllers do you have?  Google to see if anyone else
has had problems with them in 2.6.20.
> 
> During the lock up, nothing is printed to the console, and the magic
> SysRQ key has no effect; I have to poke the reset button.

Sound's like interrupts are disabled, but x86_64 always enables the
NMI watchdog which should trigger if interrupts are off for too long. 

Do you have CONFIG_DETECT_SOFTLOCKUP=y in your .config (it is in the
kernel debugging options menu I think).  If not, setting that would be
worth a try.

A raid5 resync across 5 sata drives on a couple of different
silicon-image controllers doesn't lock up for me.

NeilBrown

