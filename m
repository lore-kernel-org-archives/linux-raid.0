From: Gordon Henderson <gordon@drogon.net>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Fri, 4 Feb 2005 11:19:36 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0502041031470.29133@lion.drogon.net>
References: <200502031743.j13Hha910546@www.watkins-home.com> <42026860.1000409@zytor.com>
 <Pine.LNX.4.56.0502031822160.9028@lion.drogon.net> <200502040904.38264.andrew@walrond.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <200502040904.38264.andrew@walrond.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 4 Feb 2005, Andrew Walrond wrote:

> Hi Gordon,
>
> > Anyone using Tyan Thunder K8W motherboards???
>
> I'm using K8W's here with a combo od raid0/1 on on-board SATA, and its been
> rock solid for months (2.6.10). Looks like your problems are all with the PCI
> cards, but I can't help there. Since you are using vanilla 2.6.10, Jeff
> Garzik (SATA maintainer) should be interested/helpful on LKML if you want to
> pursue this.

The on-board stuff was solid for me too. Great with in JBOD mode with 4
disks under Linux s/w RAID. I didn't enable it's own RAID system. The
problems came when I added 2 x 2-port SATA PCI cards to get it to access
all 8 SATA disks I have in the box.

> What was the booting problem? I have no problems  here in that regard.

When you add extra PCI cards, depending on where you add the cards and on
what order you have the PCI scan in the BIOS, depends on what disk it
really wants to boot from. I could boot OK from the on-board controller, I
had problems when I added PCI SATA cards.

To build it, I had to add an IDE disk and do the install on that, then
copy it over to the SATA drives - this is something I've done in the past
- Debian Woody uses 2.4.18 to start with, and doesn't have any SATA
drivers. I've done this in the past without incident - I actually have an
IDE drive which I use for such installs, and although it's a bit of a
fiddle, I get the system I want reasonably quickly.

Bizarrely it seems to work better when booting off an IDE drive, so
putting in 2 IDE drives (mirrored) to boot off is an option, as is putting
in a IDE/Flash card.... (Which I've used in the past)

What I wanted was an 8-way RAID-1 for the boot partition (all of /, in
reality) and I've done this many times in the past on other 2-5 way
systems without issue. So I do the stuff I've done in the past, and theres
nothing really new to me in that respect. (I'm using LILO) So when I try
to get it to boot off the md device, it boots and says LIL and then
nothing more. (Lilo diagnostics interpret this as a media failure, or
geometry mismatch) If I make it boot off /dev/sda1 then it would work.
(ie. boot off /dev/sda1, root on /dev/md1, an 8-way RAID-1) I tried many
combinations of old (Debian woody) & new Lilo (compiled from the latest
source), I even tried GRUB at one point with no luck either. It was more
frustrating as the turn-around time is several minutes by the time you go
through the BIOS to change the boot device, then reboot, change lilo.conf,
then try again )-:

> > I now know, there is a K8S (server?) version of that mobo, but at the time
> > it was all orderd, I wasn't aware of it - my thoughts are there there is
> > some sort of PCI/PCI-X problem with either the motherboard or the chipset,
> > and in all probability the K8S mobo will have the same chipsset and same
> > problems anyway...
>
> Right; very similar, no AGP but additional on-board scsi.
>
> >
> > Right now, (to test the PCI SATA cards in PCI-X slots), I have 4 x
> > dual-port SATA cards in a Dell PCI-X mobo connected to the 8 drives in
> > their box via 900mm SATA cables, and it's all running quite nicely.  Read
> > performance on a RAID-0 array was 230MB/sec, write 300MB/sec (!?!), it
> > falls to 110MB/sec write and 140MB/sec read for RAID-6...) (Processor here
> > is a single Xeon 2.4GHz)
>
> I wonder if it's the onboard/pci combination that causes the problem on
> K8W...

Thats what I'm thinking - there are various jumpers to put the PCI-X slots
into PCI mode and lots of BIOS options to control speed, etc, none of
which made any difference. I did try a different brand of SATA PCI card
and that worked slightly better, but I could still force a total lock-up
with lots of access to the SATA drives on the PCI cards. (Mobo & PCI cards
are all SII 3114/3112 chipsets)

I have had a private email from someone who has experienced similar
lock-ups with twin Opteron systems and PCI cards, so from that point of
view it doesn't bode well.

I have some quad Opterons running too, and they seem fine, although they
are pure compute servers with just a local IDE drive. (and they are
running SuSE 64-bit which is what the application demands)

It seemed more stable with just one PCI card in, so I have a 4-port card
on order as a last ditch attempt to make it work - I did try re-flashing
the BIOS on one board, (I have 2) as it seemed to be about a year old and
there are several updates on the Tyan web-site, however that resulted in
wiping out the BIOS - it seemed to be going just fine, then it went beep
and was silent forever more )-: Anyone in the SW have a flash
programmer/copier handy???

> BTW There is a new K8W just out; pci express replaces agp and I think it
> supports dual core opterons (when they appear) so check it out before you
> place any big orders for the old one :)

Maybe, or maybe we just move to an Intel system, although power
dissipation was a consideration and the Opterons are attractive in that
aspect... The case has a 600W PSU before anyone asks..

Cheers,

Gordon
