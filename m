From: Daniel Brahneborg <daniel.com@wtnord.net>
Subject: Status of Promise drivers?
Date: Tue, 30 Dec 2003 20:00:12 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031230200012.C14399@nettis.grimsta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm having serious problems with my Silicon Image SATA card,
and am considering replacing with a (more expensive) Promise
SATA TX2 Plus card.

First I have some questions, to avoid getting into the same
mess as I'm in now.

 1. What is the status of the Promise driver?  Stable for
    everybody? (The SI3112 has problems for some people when
    using the IDE driver, and for some with the SCSI driver.)
    A binary module is ok, a binary bzImage definately is not.

 2. Has anybody used the driver on an Abit KV7 motherboard?

 3. Has anybody used it with *2* network cards?  Bonus
    points for the builtin Via Rhine and an 8139 card.
    (The SCSI driver for the SI3112 kills the machine when a
    second card is activated.)

 4. Has anybody used it together with two other disks on the
    VIA SATA interface on the KV7?

 5. Has anybody used it for a Raid5 setup? (With SI3112 Raid1
    works better than Raid5, since Raid5 gives corrupted files
    all over the place and Raid1 only corrupts them once in
    a while.)

 6. Has anybody used it in a non-root setup, having hda on
    the PATA interface?  (The SI3112 causes lots of problems
    with I/O port and IRQ conflicts, requiring hours of
    tweaking of the boot parameters.)

 7. Do you have DMA enabled?  (SI3112 without DMA works fine,
    but with terrible performance.)

 8. Do you get decent performance? (The 5MB/sec I get without
    DMA on the SI3112 card is _not_ decent.)

The VIA SATA drivers work perfectly with great performance,
so obviously Linux is able to talk SATA.  Unfortunately both
the SI drivers still require some work.

I'm more than happy to help debug and fix the SI driver, but
I don't know enough about the kernel to do it myself.

Lots of thanks.

/Basic

