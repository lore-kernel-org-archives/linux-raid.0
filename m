From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Software RAID5, promise IDE and system freeze...
Date: Mon, 30 Aug 2004 10:26:39 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0408301016460.31813@lion.drogon.net>
References: <4132E76F.7090209@cg.cs.tu-bs.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4132E76F.7090209@cg.cs.tu-bs.de>
To: Lars Schimmer <schimmer@cg.cs.tu-bs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 30 Aug 2004, Lars Schimmer wrote:

> Does ANYONE have any hints?
> Or does anyone uses a RAID over 2 or more Promise PCI Cards?

I have a couple of system with Promise cards PCI cards - PATA rather than
SATA though.

I don't know the mobo type offhand, but they are dual Athlons.

One system: " PCI cards, one on-board unit.

    Unknown mass storage controller: Promise Technology, Inc. 20269
	 (rev 2).

    Unknown mass storage controller: Promise Technology, Inc. 20269 (#2)
	(rev 2).

    RAID bus controller: Promise Technology, Inc. PDC20276 IDE (rev 1).


The other system is has 2 PCI cards and doesn't use the on-board.

Both systems debian woody with 2.4.26.

They work!

But problems I had were to do with the crappy interrupt controller on the
motherboard. I "solved" it by trying to move the PCI cards into different
slots to make sure every device gets its own interrupt.

/proc/interrupts on one box: (4 drives)

           CPU0       CPU1
  0:  230964376  232599896    IO-APIC-edge  timer
  1:        342        446    IO-APIC-edge  keyboard
  2:          0          0          XT-PIC  cascade
 14:   44802784   45276480    IO-APIC-edge  ide0
 15:   46082474   46467144    IO-APIC-edge  ide1
 16:   48909448   49416438   IO-APIC-level  ide2
 17:   47418987   47872232   IO-APIC-level  ide4
 18:      72851      72345   IO-APIC-level  aic7xxx
 19:  768810149  768019180   IO-APIC-level  aic7xxx, eth0
NMI:          0          0
LOC:  463544904  463544903
ERR:          6
MIS:        753

Not the ERR and MIS interrupts.

The other box (5 drives)

           CPU0       CPU1
  0:  319788706  319895418    IO-APIC-edge  timer
  1:          6          4    IO-APIC-edge  keyboard
  2:          0          0          XT-PIC  cascade
 16:  714216926  714017185   IO-APIC-level  aic7xxx, eth0
 17:   70304223   69973598   IO-APIC-level  ide2, ide3
 18:   68103824   67951706   IO-APIC-level  ide4, ide5, ide6
NMI:          0          0
LOC:  639711160  639711159
ERR:        206
MIS:     245234

No matter what I tried on this box I couldn't separate the interrupts.

Both these boxes seem to work just fine, (heavy duty NSF/Samba servers)
uptime noswis 74 days on both. After I did the PCI card and drive
shuffling (only one drive per card, even though it has 2 controllers) but
before that I had performance problems and the occasional DMA timeout from
the drives.

The times I'd get a full crash were when doing a full fsck on the drives -
that was my go/no-go test. The system would just stop. No OOPS, nothing.
Just a total lock-up. If the raid partition survived a full fsck then it
was as good a test as any as far as I was concerned.. (I wish I knew how
fsck accessed the drives, but it must be doing it in some way to trigger
some timing/interrupt crash problem).

One of these systems has a known bug in the interrupt controller that
requires a mouse to beplugged in. You'll have to google for this though, I
don't have the references to-hand about this "feature".

Not sure if this is of any help to you though!

Gordon
