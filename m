From: Gordon Henderson <gordon@drogon.net>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sun, 1 Aug 2004 18:18:57 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0408011806110.6442@lion.drogon.net>
References: <Pine.LNX.4.44.0408011724460.7382-100000@uplift.swm.pp.se>
 <200408011633.25028.mrwatts@fast24.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408011633.25028.mrwatts@fast24.co.uk>
To: Mark Watts <mrwatts@fast24.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 1 Aug 2004, Mark Watts wrote:

> I'm going to try using xfs instead of ext3 on Monday too.

I doubt it's a filesystem issue.

Try this - make the array work flat-out - dd into a fil eor something and
look at the process state of 'dd'. See if it's stuck in "D".

Now look at /proc/interrupts...

Look for ERR and MIS counts of non-zero...

I've built some systems in the past that have exhibited similar
performance and what it boiled down to was the motherboard interrupt
controller is basically crap. I "solved" it with one system by
re-arranging the PCI cards and used the on-board IDE controllers (and one
primose plug-in card rather than 2; 4 IDE drives, one per cable) to make
sure everything had it's own interrupt. Eg:

           CPU0       CPU1
  0:  107450604  108441652    IO-APIC-edge  timer
  1:        340        446    IO-APIC-edge  keyboard
  2:          0          0          XT-PIC  cascade
 14:   19756978   19994219    IO-APIC-edge  ide0
 15:   20297959   20492514    IO-APIC-edge  ide1
 16:   21597138   21847832   IO-APIC-level  ide2
 17:   20928098   21157136   IO-APIC-level  ide4
 18:      72819      72311   IO-APIC-level  aic7xxx
 19:  404554707  404245858   IO-APIC-level  aic7xxx, eth0
NMI:          0          0
LOC:  215883196  215883194
ERR:          4
MIS:        395

I still see the occasional MIS interrupt (it's accompanied by an APIC
error - eg:

Jul 14 17:59:25 blue kernel: APIC error on CPU0: 00(02)
Jul 14 17:59:25 blue kernel: APIC error on CPU1: 00(02)

This is a dual Athlon mobo.

Good luck!

Gordon
