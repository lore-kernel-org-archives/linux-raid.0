From: Gordon Henderson <gordon@drogon.net>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Thu, 3 Feb 2005 19:36:15 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0502031822160.9028@lion.drogon.net>
References: <200502031743.j13Hha910546@www.watkins-home.com> <42026860.1000409@zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <42026860.1000409@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 3 Feb 2005, H. Peter Anvin wrote:

> Guy wrote:
> > Would you say that the 2.6 Kernel is suitable for storing mission-critical
> > data, then?
>
> Sure.  I'd trust 2.6 over 2.4 at this point.

This is interesting to hear.

> > I ask because I have read about a lot of problems with data corruption and
> > oops on this list and the SCSI list.  But in most or all cases the 2.4
> > Kernel does not have the same problem.
>
> I haven't seen any problems like that, including on kernel.org, which is
> definitely a high demand site.
>
> > Who out there has a RAID6 array that they believe is stable and safe?
> > And please give some details about the array.  Number of disks, sizes, LVM,
> > FS, SCSI, ATA and anything else you can think of?  Also, details about any
> > disk failures and how well recovery went?
>
> The one I have is a 6-disk ATA array (6x250 GB), ext3.  Had one disk
> failure which hasn't been replaced yet; it's successfully running in
> 1-disk degraded mode.
>
> I'll let other people speak for themselves.

I asked this question a couple of weeks ago...

I didn't get many replies that inspired confidence, however, I didn't get
any "don't do it" replies either.

So I went off and built a test server with a bit mis-match of drives,
controllers and whatno, and made the effort to get Debian Woody to use the
2.6.10 kernel (stock, no patces) and played with mdadm and RAID-6.

My test server is an old Asus Twin Xeon 500 MHz board (XG-DLS, I think)
with 2 old 4GB IDE drives, 2 older 18GB SCSI drives (on-board controller,
one on a nice 68-way LVD cable, the other on a 50-way flat ribbon) and 2
Maxtor (I know)  80GB drives on an Highpoint controller.

I was unable to make it crash, or corrupt data (that I could tell) in
about a weeks worth of testing. I only hard-pulled a drive once though,
and it stalled for a short while, then did what it was supposed to do and
carried on. I did lots of tests where I failed a drive (using mdadm), then
failed a 2nd, then started a re-sync, then started a 2nd resync, and
failed a drive after the 1st resync finished, etc., etc., etc.... Nothing
more than RAID-6 and ext3, no LVM, XFS, etc.

So at that point I was reasonably happy with RAID-6 and 2.6.10. My blood
had stopped dripping over the edge, I'm warming to 2.6.10 and thinking
RAID-6 might just be the solution to all my problems...

However, I then got production hardware - Tyan Thunder K8W twin Opteron
board, 4-port SATA on-oboard, 2x2-port SATA in PCI slots (all SII chipset)
and it all went pear-shaped from there. The system locks solid whenever I
try to use the disks off the PCI SATA controllers doing anything much more
than run fdisk on them.  (It just stops, no oops, cursor stops flashing on
the display, it needs a hard-reset to get it going again) I've tried PCI
slot positions, fiddling with mobo jumpers, BIOS options, and so on.  I
can make it work for varying degrees of "work", however blood is currently
flowing over the edge and gathering in a pool at my feet. Even getting it
to boot off the SATA drives was a challenge in itself (which still isn't
solved to my satisfaction)

Anyone using Tyan Thunder K8W motherboards???

I now know, there is a K8S (server?) version of that mobo, but at the time
it was all orderd, I wasn't aware of it - my thoughts are there there is
some sort of PCI/PCI-X problem with either the motherboard or the chipset,
and in all probability the K8S mobo will have the same chipsset and same
problems anyway...

Right now, (to test the PCI SATA cards in PCI-X slots), I have 4 x
dual-port SATA cards in a Dell PCI-X mobo connected to the 8 drives in
their box via 900mm SATA cables, and it's all running quite nicely.  Read
performance on a RAID-0 array was 230MB/sec, write 300MB/sec (!?!), it
falls to 110MB/sec write and 140MB/sec read for RAID-6...) (Processor here
is a single Xeon 2.4GHz)

Gordon
