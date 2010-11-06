From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Determining which spindle is out of order
Date: Sat, 6 Nov 2010 12:23:54 -0800 (AKDT)
Message-ID: <alpine.LNX.2.01.1011061220050.11296@filesrv1.baby-dragons.com>
References: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com> <4CD57048.4020107@turmel.org> <4CD57867.4010207@anonymous.org.uk> <4CD57C17.8020303@turmel.org> <4CD58640.2010606@computer.org> <4CD5AEDE.50501@turmel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD5AEDE.50501@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Jan Ceuleers <jan.ceuleers@computer.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 	Hello Phil ,

On Sat, 6 Nov 2010, Phil Turmel wrote:
> On 11/06/2010 12:45 PM, Jan Ceuleers wrote:
>> On 06/11/10 17:02, Phil Turmel wrote:
>>> Indeed.  The sysfs layout changed since kernel 2.6.18.  I'm guessing the use of
>>> CONFIG_SYSFS_DEPRECATED and/or CONFIG_SYSFS_DEPRECATED_V2 will interfere with my
>>> script in current kernels.
>>
>> Nice.
>>
>> Output on one of my machines is however not as expected:
>>
>> Controller device @ pci0000:00/0000:00:1c.1/0000:02:00.0 [ahci]
>>   SATA controller: JMicron Technology Corp. JMB360 AHCI Controller (rev 02)
>>     host4: [Empty]
>> Controller device @ pci0000:00/0000:00:1f.2 [ata_piix]
>>   IDE interface: Intel Corporation 5 Series/3400 Series Chipset 4 port SATA IDE Controller (rev 06)
>>     host0: /dev/sda ATA WDC WD20EADS-00R {SN: WD-WCAVY4080404}
>>     host1: /dev/sdb ATA ST3500418AS {SN: 9VMK33L9}
>>     host1: /dev/sdc ATA ST3500418AS {SN: 9VMM6EY4}
>> Controller device @ pci0000:00/0000:00:1f.5 [ata_piix]
>>   IDE interface: Intel Corporation 5 Series/3400 Series Chipset 2 port SATA IDE Controller (rev 06)
>>     host2: [Empty]
>>     host3: [Empty]
>>
>> This machine has seven SATA ports: one provided by the JMicron chip, the other six by the Intel H55 south bridge. Only three ports are currently used, but I had expected another [Empty] entry.
>>
>> Here's what's in /sys/devices:
>>
>> root@zotac:~# find /sys/devices/ -name scsi_host
>> /sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/host4/scsi_host
>> /sys/devices/pci0000:00/0000:00:1f.2/host0/scsi_host
>> /sys/devices/pci0000:00/0000:00:1f.2/host1/scsi_host
>> /sys/devices/pci0000:00/0000:00:1f.5/host2/scsi_host
>> /sys/devices/pci0000:00/0000:00:1f.5/host3/scsi_host
>>
>> Not sure what to make of that...
>
> I'm guessing it's an artifact of IDE compatibility mode.  You can see host1 
reports two drives, and my script is only expecting one.  Master vs. slave 
emulation, perhaps?  Can you check your BIOS for legacy IDE vs. AHCI mode 
setting?
>
> I suspect my script will have similar problems with port multipliers.
>
> Phil
 	Can someone running near to Linux 2.6.30.6 or slightly less post 
(privately) their .config file so I can see what option I am missing as I 
definately have scsi devices & hosts ,  But there are no 'scsi_host' entries in 
the /sys file system .

fe: ....

  root@filesrv1:~ # for XXX in `lspci | grep -i scsi | awk '{print $1}'` ; do lspci -v -v -v -v -v -s ${XXX} ; done
00:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 66MHz  Ultra3 SCSI Adapter (rev 01)
         Subsystem: LSI Logic / Symbios Logic LSI53C1000/1000R/1010R/1010-66 PCI to Ultra160 SCSI Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 72 (4250ns min, 4500ns max), cache line size 08
         Interrupt: pin A routed to IRQ 29
         Region 0: I/O ports at c400 [size=256]
         Region 1: Memory at fe9ff800 (64-bit, non-prefetchable) [size=1K]
         Region 3: Memory at fe9f6000 (64-bit, non-prefetchable) [size=8K]
         Expansion ROM at fe9f0000 [disabled] [size=16K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 66MHz  Ultra3 SCSI Adapter (rev 01)
         Subsystem: LSI Logic / Symbios Logic LSI53C1000/1000R/1010R/1010-66 PCI to Ultra160 SCSI Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 72 (4250ns min, 4500ns max), cache line size 08
         Interrupt: pin B routed to IRQ 28
         Region 0: I/O ports at c800 [size=256]
         Region 1: Memory at fe9ffc00 (64-bit, non-prefetchable) [size=1K]
         Region 3: Memory at fe9fc000 (64-bit, non-prefetchable) [size=8K]
         Expansion ROM at fe9f8000 [disabled] [size=16K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

  root@filesrv1:~ # find /sys/devices/ -name scsi_host

 		Tia ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
