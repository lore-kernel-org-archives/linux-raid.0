From: maarten <maarten@ultratux.net>
Subject: Re: combining two raid systems
Date: Fri, 14 Jan 2005 02:01:28 +0100
Message-ID: <200501140201.28392.maarten@ultratux.net>
References: <200501132017.16910.maarten@ultratux.net> <41E7084D.2040607@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41E7084D.2040607@verizon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 14 January 2005 00:46, berk walker wrote:
> Maarten, why not just leave them as they are, and mount the secondary FS
> on the primary FS?

Can't.  That secondary server runs an app which doesn't play well with a newer 
kernel. I need that kernel for SATA support, so I'm stuck.
Therefore I decided to move all drives to my current fileserver.  That is no 
problem at all for the PSU and physical space; I went out and bought a huge 
tower and a 480 Watt quality PSU.

Besides, I want them together, because that actually _saves_ electricity.
My AC power consumtion meter says the machine uses 160 VA now.
That's a far cry from 480 watts, but I'm very glad it is :-)
(it is normal for a PSU to be rather over-dimensioned)

> Less drag on the power supply, and fewer eggs in the basket.  If you
> can't see the added array, it might be that, even in this great day of
> standardisation, some boxes write to the disk differently, esp. in the
> 1st cyl.

Nope, I fixed that already.  There were two arrays that claimed to be md0, and 
that -presumably- clashes. When I disabled the 'other' md0[-drives], the 
first one magically appeared.  So that's sorted out already.

No, I'm two or three stages further now; I had transmit timeouts on my NIC, a 
Gbit intel (e1000) so I upgraded the kernel _and_ ran lilo.  However, lilo 
being a biatch, that yielded an unbootable system (L 99 99 99 ...) :-((
I should have known better, but NOT re-running lilo is worse still. ;)

So I booted using rescue CD, and installed grub but that did not work out 
either. The problem is that my BIOS thinks differently about what the boot 
drive is as my OS. The pri onboard channel drive gets, according to the 
kernel, listed way at the end, after all the PCI (S)ATA controllers and there 
are 3 of them.  So what would've been hda gets to be hdq (!!). Other drives 
also get swapped around, because the grub shell from rescue media believes 
(hd2,0) is my first accessible drive, and when booted it is (hd1,0).  
It's a huge mess but I guess it goes with the (ATA) territory (?)

During all this my root fs on md0 got degraded, so I want to hotadd the two 
missing devices (to make sure the grub config on all 3 is at least 
consistent).  But alas, my BIG array got degraded too(*) so it did hotadd the 
spare drive.  That will takes 120 minutes!  Grrr.  I tried to find a way to 
stop that resync but I found no solution to that. At least stopping the md 
device was impossible.  Failing the spare would've been possible but at this 
point I DON'T want to fail an active drive by mistake, so I left that alone.
So I'll have to wait two hours before my md0 rootdrive gets synced, and only 
then I can re-try if grub finds its files. (And I'm not even sure of that.)

Brrr.  Life can be hard on poor sysdamins like us...  ;-|
 
(*) there was no other way as I needed one ATA channel for the rescue CDRom. I 
forgot / omitted to remove more drives (to make the array too degraded to 
start). That wouldn't have been helpful; I'm trying to fix my bootloader so 
removing drives isn't too smart then; I might well remove a boot drive, or 
mess with the boot-order so that grub gets even more confused, later on.

But people, getting a system to boot (again) if it has 10 (ten) ATA drives is 
something that you _really_ will want to avoid at all cost...! 
Take my word for it  :-((

Maarten

