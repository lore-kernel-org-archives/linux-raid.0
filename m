From: "David Lethe" <david@santools.com>
Subject: RE: [Benchmarks] How do I set the memory invalidate bit for a 3ware 9550SXU-12 controller?
Date: Thu, 8 Jan 2009 09:04:53 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C03413590@34093-C3-EVS3.exchange.rackspace.com>
References: <alpine.DEB.1.10.0901080846430.29454@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757103AbZAHPki@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <alpine.DEB.1.10.0901080846430.29454@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, linux-ide-arrays@lists.math.uh.edu
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Justin Piszcz
> Sent: Thursday, January 08, 2009 8:21 AM
> To: linux-kernel@vger.kernel.org
> Cc: linux-raid@vger.kernel.org; linux-ide-arrays@lists.math.uh.edu
> Subject: [Benchmarks] How do I set the memory invalidate bit for a
> 3ware 9550SXU-12 controller?
> 
> System = RHEL5 x86_64
> Kernel = 2.6.18-53.1.13.el5
> 
> Per: http://makarevitch.org/rant/raid/
> It states: "A potential culprit, at least for slow write operations,
> lies in Q12546. I played with setpci in order to enable this ''Memory
> Write and Invalidate' (lspci now shows that the 3Ware controller 9550
> is in 'MemWINV+' instead of 'MemWINV-' mode), maybe enhancing write
> throughput. The 9650 is in 'MemWINV-' mode. This seems somewhat
> frequent with SuperMicro mainboards, check this with your system
> integrator or SuperMicro support service. This may be somewhat tied to
> the "interleaved memory". With the 9650 my PCI parameters are as
> follows:"
> 
> Links to: http://www.3ware.com/KB/article.aspx?id=12546
> 
> How do I change MemWINV+ to MemWINV- using setpci?
> 
> 03:01.0 RAID bus controller: 3ware Inc 9550SX SATA-RAID
>          Subsystem: 3ware Inc 9550SX SATA-RAID
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>          Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>          Latency: 32 (16000ns min), Cache Line Size: 64 bytes
>          Interrupt: pin A routed to IRQ 177
>          Region 0: Memory at fc000000 (64-bit, prefetchable)
[size=32M]
>          Region 2: Memory at fa100000 (64-bit, non-prefetchable)
> [size=4K]
>          Region 4: I/O ports at 3000 [size=64]
>          [virtual] Expansion ROM at fa120000 [disabled] [size=128K]
>          Capabilities: [e0] PCI-X non-bridge device
>                  Command: DPERE- ERO+ RBC=512 OST=3
>                  Status: Dev=03:01.0 64bit+ 133MHz+ SCD- USC-
DC=simple
> DMMRBC=512 DMOST=3 DMCRS=16 RSCEM- 266MHz- 533MHz-
>          Capabilities: [e8] Power Management version 2
>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-
> ,D2-,D3hot-,D3cold-)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>          Capabilities: [f0] Message Signalled Interrupts: 64bit+
> Queue=0/3 Enable-
>                  Address: 0000000000000000  Data: 0000
> 00: c1 13 03 10 17 00 b0 02 00 00 04 01 10 20 00 00
> 10: 0c 00 00 fc 00 00 00 00 04 00 10 fa 00 00 00 00
> 20: 01 30 00 00 00 00 00 00 00 00 00 00 c1 13 03 10
> 30: 00 00 00 00 e0 00 00 00 00 00 00 00 07 01 40 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 82
> 50: 00 00 00 00 00 00 00 00 00 00 04 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 07 e8 22 00 08 03 03 05 01 f0 02 06 00 00 00 00
> f0: 05 00 86 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> Read performance of 10 disks in a RAID5, reading the block device is
> abysmal,
> at 170MB/s.  Storsave is set to perform, the cache is on and all the
> disks
> are good, I believe it is that bit that is causing such poor
> performance.
> 
> Does anyone know how to set it via setpci?
> So I can change:
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
> to:
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
> 
> The following:
> http://www.rhic.bnl.gov/hepix/talks/041018am/triumf_sr.ppt
> Recommends: /sbin/setpci -d 8086:1048 e6.b=2e
> 
> # /sbin/setpci -d 8086:1048 e6.b=2e
> setpci: Warning: No devices selected for `e6.b=2e'.
> 
> Also tried:
> # setpci -d *:* e6.b=2e
> 
> However, lspci reports it has not changed:
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
> 
> What is the proper way to do this?
> 
> Benchmarks:
> I have been using the same benchmark for a number of years, 3 per
each:
> /usr/bin/time /home/user/app/bin/bonnie++ -u user -d /vol1/test -s
> 16384 -m hostname -n 16:100000:16:64
> 
> 3ware_protect:
>
hostname,16G,46904,95,91486,42,49291,13,52647,93,261947,27,426.0,0,16:1
> 00000:16/64,350,7,22388,99,545,3,2737,55,27411,99,210,1
>
hostname,16G,46584,96,93025,41,49654,13,52919,93,260112,26,424.6,0,16:1
> 00000:16/64,2534,49,28117,99,214,1,4543,99,28059,99,321,2
>
hostname,16G,47323,97,93176,43,49459,13,52650,93,260774,28,447.9,0,16:1
> 00000:16/64,3166,65,21311,98,340,2,4731,99,28453,99,192,1
> 
> 3ware_balance:
>
hostname,16G,47294,96,105964,50,46559,11,52884,93,243519,24,482.1,0,16:
> 100000:16/64,3286,64,21914,99,288,2,4804,99,22362,99,219,1
>
hostname,16G,47017,96,106442,50,47233,12,53728,95,246878,25,451.1,0,16:
> 100000:16/64,3253,70,21532,99,265,2,3539,82,28042,98,231,1
>
hostname,16G,48029,98,105228,48,48414,12,53792,94,247294,25,446.2,0,16:
> 100000:16/64,3209,65,28597,98,231,1,4702,99,28468,99,223,1
> 
> 3ware_perform:
>
hostname,16G,47465,96,100756,47,50470,13,52691,93,268168,28,456.2,0,16:
> 100000:16/64,3388,68,21381,98,374,2,4709,99,27316,99,231,1
>
hostname,16G,46335,95,101715,47,50958,13,54153,95,265766,27,508.4,0,16:
> 100000:16/64,3159,62,21788,99,258,1,4877,96,28789,99,232,1
>
hostname,16G,46230,95,101402,47,46896,12,54178,95,268594,27,443.6,0,16:
> 100000:16/64,3326,66,28244,99,656,4,5096,96,29187,99,229,1
> 
> Never have I seen such poor performance on the sequential reads and
> writes. Are
> the 3ware 9550SXU-12 boards this slow or is it a configuration issue?
> /c0 Model = 9550SXU-12
> 
> I have a 9650SE-16ML at another location with a BBU and get very good
> performance, of course its PCI-e and a newer model, but should this
> model
> be this slow?  Anyone using a 9550SXU-12 know if this is normal
> performance?  With 10 750GB disks it should easily be getting >
> 200MiB/s
> for sequential reads and writes.
> 
> Justin.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Don't worry about setting the memory invalidate bit, I never worried
about it and
got > 250 MB/sec on a 9550SX using RAID5, with bonnie on 64KB seq writes
using XFS and
12 disks.  Nothing else was on the PCI-X bus.  I suggest you step back
and look at following
 - Run in single user mode to eliminate impact of other things in O/S
 - look at PC architecture and make sure that the PCI-X bus isn't
sharing resources with
   Other things that compete for system resources --  like 1Gbit
ethernet cards that are active
 - look carefully at file system, volume manager, take them out of
equation if it is your goal
   to just benchmark the card.  
 - update the firmware if it isn't current.  I have NDA development deal
with 3WARE/AMCC, and
   you really need to keep up with firmware/driver updates.  They are
always tweaking their algorithms
   for improved performance. 

Gut feeling ... your choice of file system and file system settings is
adding a huge amount of 
overhead, so your 3WARE controller is likely doing a great deal of small
block reads/writes in 
addition to your benchmarking traffic.

I got 300MB/sec on same system when I booted to Windows and used NTFS,
BTW.
So it isn't the card, or the memory invalidate bit.  Look elsewhere.

David

 
