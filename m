From: Dan Christensen <jdc@uwo.ca>
Subject: Re: RAID-5 streaming read performance
Date: Thu, 14 Jul 2005 22:38:47 -0400
Message-ID: <87wtns7pzc.fsf@uwo.ca>
References: <874qb14btr.fsf@uwo.ca>
	<1121220487.5552.34.camel@localhost.localdomain>
	<87mzorfmdx.fsf@uwo.ca>
	<1121257494.5504.4.camel@localhost.localdomain>
	<87eka2g9dp.fsf@uwo.ca>
	<1121259126.5504.14.camel@localhost.localdomain>
	<87vf3eeqe2.fsf@uwo.ca> <42D5573A.6090801@dgreaves.com>
	<87r7e23uo5.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Summary so far:

RAID-5, four SATA hard drives, 2.6.12.2 kernel.  Testing streaming
read speed.  With readahead optimized, I get:

each raw device:        58MB/s
raid device:            78MB/s
3 or 4 parallel reads
from the raw devices:  106MB/s

I'm trying to figure out why the last two numbers differ.

I was afraid that for some reason the kernel was requesting the parity
blocks instead of just the data blocks, but by using iostat it's
pretty clear that the right number of blocks are being requested from
the raw devices.  If I write a dumb program that reads 3 out of every
4 64k chunks of a raw device, the kernel readahead kicks in and chunks
I skip over do contribute to the iostat numbers.  But the raid layer
is correctly avoiding this readahead.

One other theory at this point is that my controller is trying to be
clever and doing some readahead itself.  Even if this is the case, I'd
be surprised if this would cause a problem, since the data won't have
to go over the bus.  But maybe the controller is doing this and is
causing itself to become overloaded?  My controller is a Silicon Image
3114.  Details at the end, for the record.

Second theory:  for contiguous streams from the raw devices, the reads
are done in really big chunks.  But for md layer reads, the biggest
possible chunk is 3 x 64k, if you want to skip parity blocks.  Could
3 x 64k be small enough to cause overhead?  Seems unlikely.

Those are my only guesses.  Any others?

It seems strange that I can beat the md layer in userspace by 33%, by
just reading from three of the devices and using parity to reconstruct
the fourth!

Thanks again for all the help.  I've learned a lot!  And I haven't
even started working on write speed...

Dan


0000:01:0b.0 RAID bus controller: Silicon Image, Inc. (formerly CMD Technology Inc) SiI 3114 [SATALink/SATARaid] Serial ATA Controller (rev 02)
        Subsystem: Silicon Image, Inc. (formerly CMD Technology Inc): Unknown device 6114
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, Cache Line Size: 0x08 (32 bytes)
        Interrupt: pin A routed to IRQ 177
        Region 0: I/O ports at 9400 [size=8]
        Region 1: I/O ports at 9800 [size=4]
        Region 2: I/O ports at 9c00 [size=8]
        Region 3: I/O ports at a000 [size=4]
        Region 4: I/O ports at a400 [size=16]
        Region 5: Memory at e1001000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

