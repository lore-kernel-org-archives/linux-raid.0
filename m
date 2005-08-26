From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: RAID 5 write performance advice
Date: Fri, 26 Aug 2005 10:26:33 -0400
Message-ID: <1125066393.5549.22.camel@localhost.localdomain>
References: <430C2EA6.2050103@web.de>
	 <1124887589.5550.27.camel@localhost.localdomain>	<430C798B.1030107@web.de>
	 <17164.59261.540591.841830@cse.unsw.edu.au>  <430DF416.1070101@web.de>
	 <1124988876.5552.59.camel@localhost.localdomain>  <430ECA18.10405@web.de>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <430ECA18.10405@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mirko Benz <mirko.benz@web.de>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

seems i need to change the mail thread to 

"why my RAID0 write speed so slow!" :P

i also use a Marvell 8 port PCI-X card. 8 SATA DISK RAID0, each single
disk can give me around 55MB/s, but the RAID0 can only give me 203MB/s.
I tried different io scheduler, all lead to same write speed at my side.

02:01.0 SCSI storage controller: Marvell MV88SX5081 8-port SATA I PCI-X
Controller (rev 03)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, Cache Line Size 08
        Interrupt: pin A routed to IRQ 24
        Region 0: Memory at fa000000 (64-bit, non-prefetchable)
        Capabilities: [40] Power Management version 2
                Flags: PMEClk+ DSI- D1- D2- AuxCurrent=0mA PME
(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [60] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=0 OST=3
                Status: Bus=2 Dev=1 Func=0 64bit+ 133MHz+ SCD- USC-,
DC=simple, DMMRBC=0, DMOST=3, DMCRS=0, RSCEM-


On Fri, 2005-08-26 at 09:51 +0200, Mirko Benz wrote:
> Hello,
> 
> We have created a RAID 0 for the same environment:
> Personalities : [raid0] [raid5]
> md0 : active raid0 sdi[7] sdh[6] sdg[5] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
>       1250326528 blocks 64k chunks
> 

Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6]
[raid10] [faulty]
md0 : active raid0 sdh[7] sdg[6] sdf[5] sde[4] sdd[3] sdc[2] sdb[1] sda
[0]
      3125690368 blocks 64k chunks


SCSI disks: 400GB SATA

host: scsi11 Channel: 00 Id: 00 Lun: 00
  Vendor: Hitachi  Model: HDS724040KLSA80  Rev: KFAO
  Type:   Direct-Access                    ANSI SCSI revision: 03



> *** dd TEST ***
> 
> time dd if=/dev/zero of=/dev/md0 bs=1M
> 14967373824 bytes transferred in 32,060497 seconds (466847843 bytes/sec)
> 
> iostat 5 output:
> avg-cpu:  %user   %nice    %sys %iowait   %idle
>            0,00    0,00   89,60    9,50    0,90
> 
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> hda               0,00         0,00         0,00          0          0
> sda               0,00         0,00         0,00          0          0
> sdb             455,31         0,00    116559,52          0     581632
> sdc             455,51         0,00    116540,28          0     581536
> sdd             450,10         0,00    116545,09          0     581560
> sde             454,11         0,00    116559,52          0     581632
> sdf             452,30         0,00    116559,52          0     581632
> sdg             454,71         0,00    116553,11          0     581600
> sdh             453,31         0,00    116533,87          0     581504
> sdi             453,91         0,00    116556,31          0     581616
> sdj               0,00         0,00         0,00          0          0
> sdk               0,00         0,00         0,00          0          0
> sdl               0,00         0,00         0,00          0          0
> sdm               0,00         0,00         0,00          0          0
> sdn               0,00         0,00         0,00          0          0
> md0           116556,11         0,00    932448,90          0    4652920
> 
> Comments: 466 MB / 8 = 58,25 MB/s which is about the same as a dd to a 
> single disk (58,5 MB/s). So the controller + I/O subsystem is not the 
> bottleneck.
> 
> Regards,
> Mirko
> 

