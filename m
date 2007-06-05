From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: RE:  RAID 6 grow problem
Date: Tue, 5 Jun 2007 16:26:55 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.0706051612400.5806@gheavc.wnzcbav.cig>
References: <2076428235.1181071281354.JavaMail.root@gateway.korstad.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2076428235.1181071281354.JavaMail.root@gateway.korstad.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 5 Jun 2007, Daniel Korstad wrote:

> Sounds like you are well on your way.
>  I am not too surprised on the time to completion.  I probably 
> underestimated/exaggerated a bit when I said after a few hours :)
>  It took me over a day to grow one disk as well.  But my experience 
> was on a system with an older AMD 754 x64 Mother Board with a couple 
> SATA on board and the rest on two PCI cards each with 4 SATA ports.  
> So I have 8 SATA drives on my PCI (33Mhz x 4 bytes (32bits) = 133MB/s) 
> bus of which is saturated basically after three drives.

Related to this question, I have several of my own.

I have an EPoX 570SLI motherboard with 3 SATAII drives, all 320GiB: one 
Hitachi, one Samsung, one Seagate. I built a RAID5 out of a partition 
carved from each. I can issue a 'check' command and the rebuild speed 
hovers around 70MB/s, sometimes up to 73MB/s, and dstat/iostat/whatever 
confirms that each drive is sustaining approximately 70MB/s reads. 
Therefore, 3x70MB/s = 210MB/s which is a bunch more than 133MB/s. lspci 
-v reveals, for one of the interfaces (the others are pretty much the 
same):

00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2) 
(prog-if 85 [Master SecO PriO])
        Subsystem: EPoX Computer Co., Ltd. Unknown device 1026
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 11
        I/O ports at 09f0 [size=8]
        I/O ports at 0bf0 [size=4]
        I/O ports at 0970 [size=8]
        I/O ports at 0b70 [size=4]
        I/O ports at e000 [size=16]
        Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
        Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/2 Enable-
        Capabilities: [cc] HyperTransport: MSI Mapping

which seems to clearly indicate that it is running at 66MHz (meaning 
266MB/s maximum). As I say below, the best I seem to be able to get out 
of it is 133MB/s, give or take. Can somebody explain what some of those 
other items mean, such as 64bit something and different-sized I/O 
ports...)

Each drive identifies with different UDMA levels:

The hitachi:
ata1.00: ATA-7, max UDMA/133, 625142448 sectors: LBA48 NCQ (depth 0/32) 

The samsung:
ata2.00: ATA-8, max UDMA7, 625142448 sectors: LBA48 NCQ (depth 0/32)

The seagate:
ata3.00: ATA-7, max UDMA/133, 625142448 sectors: LBA48 NCQ (depth 0/32)


I'm trying to determine what the limiting factor of my raid is: Is it 
the drives, my CPU (AMD x86_64, dual core, 3600+), my motherboard, 
software, or something else. The best I've been able to get in userland 
is about 133MB/s (no filesystem, raw device reads using dd with 
iflag=direct).  What *should* I be able to get?

--
Jon Nelson 
<jnelson-linux-raid@jamponi.net>
