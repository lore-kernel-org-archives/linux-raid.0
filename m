From: "Chris Evans" <chris1@psyctc.org>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Wed, 03 Mar 2004 22:09:49 -0000
Message-ID: <404657AD.3430.77A6662@localhost>
References: <40460DC4.10744.659B232@localhost>
Return-path: <bounce-debian-user=debian-user=quimby.gnus.org@lists.debian.org>
In-reply-to: <200403031109.17348.jguerin@cso.atmel.com>
Resent-Message-ID: <xVngND.A.lp.dflRAB@murphy>
List-Post: <mailto:debian-user@lists.debian.org>
List-Help: <mailto:debian-user-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-user-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-user-request@lists.debian.org?subject=unsubscribe>
List-Archive: <http://lists.debian.org/debian-user/>
To: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3 Mar 2004 at 11:09, Justin Guerin wrote:

> > So I'm left thinking there's something, perhaps idiosyncratic to
> > some BIOS or HDs or whatever, that means some of us have real
> > problems writing LILO boot instructions to the two drives in a RAID1
> > boot array.
> >
> One question on your kernel hang: are you loading the same kernel
> successfully when you boot directly off /dev/hdc?  If not, do you know
> your kernel is good?
Good questions Justin and I'm increasingly realising that I needed an 
almost forensic attitude to this and to take it much more slowly and 
tap into much more information that was there on the machine.  
However, I have no reason to believe that the kernel wasn't the right 
one but next time I will make sure I check carefully.

> Since one of your disks is larger than the other, you might consider
> using a 20 MB portion of the larger disk as a /boot partition, and
> keeping it out of the raid.  Booting will be very easy in that
> scenario, and you can use the rest of the disk for the raid, and put
> everything else on it.
I am increasingly tempted to do this and there is room there (there's 
936Mb as it happens: I think the first hard disc I looked after for 
anyone was 10Mb and it was the sole hard drive in that XT box!)

My sense is that this would be simpler and I'd feel less scared of it 
but I'd be slightly less robust as there'd be no reserve boot point 
if that failed (though if it did I should be able to rescue from a 
boot floppy or CD I guess).   I think that's not that different from 
continuing to have "boot=/dev/hda" (or "boot=/dev/hdc") in lilo.conf, 
as you note you have, I think that too is givign you a single MBR 
boot record.

I am still being slow about this though.  One thing that's very clear 
now is that if I let lilo (22.2) write its boot to the two drive's 
mbrs with the raid-extra-boot, something goes badly wrong.  As I 
really need to finish this saga, even if I still don't really 
understand what was wrong, I am going to stick with my current lilo 
setting which seems to work which says:
boot=/dev/hda

However, if I do want to use that bit of spare drive to give myself 
the reassuring feeling that the lilo/mbr issues are being kept away 
from the /dev/md0 areas, then is this the right sequence:

a) cfdisk to create bootable, linux type, partition /dev/hdc2
b) reboot
c) mkfs -t ext3 /dev/hdc2
d) rewrite lilo.conf to instruct it to boot from /dev/hdc2, if so, 
does that mean simply writing "boot=/dev/hdc2"?  Surely not as I 
think that means I need some primary boot loader to come out of one 
of the drive mbrs that will then point to the lilo secondary load 
from /dev/hdc2 (sorry, I'm sure this is dumb of me but someone take 
pity here please!)
e) assuming that works and reboots OK
f) init 1
g) stop /dev/md0 (after umount of / ?)  can this be done
h) cfdisk /dev/hda and take bootable off, ditto /dev/hdc
i) reboot and pray
j) ... ugh, no this all sounds wrong

I am continuing to ask (and thanks again to Justin, Chris, Neil and 
Maarten for their inputs) as I do want to feel I understand this and 
get as safe a set up as I can for this machine, but also because I 
will have to return to the issues in the next month or two, hopefully 
while it's still fresh in my mind, to put in a replacement server 
behind this firewall.  

Hence one more question: I had been planning to put at least three 
drives in that in a RAID5 array and boot/root from that, now I'm 
rattled but would still like that redundancy.  How difficult is RAID5 
boot/root cf RAID1?

TIA,

Chris

P.S. I promise to document all of this as some sort of mini-HOWTO or 
whatever to complement the existing ones, and to notify the authors 
of those where I think they might usefully be improved: clearly I owe 
the open source movement at least that much.
PSYCTC: Psychotherapy, Psychology, Psychiatry, Counselling
   and Therapeutic Communities; practice, research, 
   teaching and consultancy.
Chris Evans & Jo-anne Carlyle
http://psyctc.org/ Email: chris@psyctc.org
