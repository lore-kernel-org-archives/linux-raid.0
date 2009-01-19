From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Raid6 write performance
Date: Mon, 19 Jan 2009 11:37:11 +0100
Message-ID: <497457D7.90101@rabbit.us>
References: <49742E74.9090502@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49742E74.9090502@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Hi,
> 
> I am experimenting with raid6 on 4 drives on 2.6.27.11. The problem I am
> having is that no matter what chunk size I use, the write benchmark
> always comes out at single drive speed, although I should be seeing
> double drive speed (read speed is at near 4x as expected). 

Please disregard this, I appear to be having some sort of weird hardware
congestion. Can someone explain what could be going on?


Standalone read speed:
--------------------------------
root@Arzamas:~# for i in b c d e ; do dd if=/dev/sd${i}2 of=/dev/null
bs=32M count=32 ; done
32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 10.4133 s, 103 MB/s
32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 10.4781 s, 102 MB/s
32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 10.4317 s, 103 MB/s
32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 10.1242 s, 106 MB/s
root@Arzamas:~#


Combined read speed - limited by the width of a 32bit 66mhz PCI (dev
02:04.0 below)
--------------------------------
root@Arzamas:~# for i in b c d e ; do dd if=/dev/sd${i}2 of=/dev/null
bs=32M count=32 & done
[1] 19491
[2] 19492
[3] 19493
[4] 19494
root@Arzamas:~# 32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 17.8422 s, 60.2 MB/s
32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 18.2496 s, 58.8 MB/s
32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 18.5542 s, 57.9 MB/s
32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 19.0774 s, 56.3 MB/s


Standalone write:
-------------------------------
root@Arzamas:~# for i in b c d e ; do dd if=/dev/zero of=/dev/sd${i}2
bs=32M count=32 ; done
32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 10.7629 s, 99.8 MB/s
32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 10.753 s, 99.9 MB/s
32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 12.1836 s, 88.1 MB/s
32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 10.2433 s, 105 MB/s
root@Arzamas:~#


Combined write - half of the read speed???:
-------------------------------
root@Arzamas:~# for i in b c d e ; do dd if=/dev/zero of=/dev/sd${i}2
bs=32M count=32 & done
[1] 19506
[2] 19507
[3] 19508
[4] 19509
root@Arzamas:~# 32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 40.1631 s, 26.7 MB/s
32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 40.2603 s, 26.7 MB/s
32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 40.2862 s, 26.7 MB/s
32+0 records in
32+0 records out
1073741824 bytes (1.1 GB) copied, 40.3178 s, 26.6 MB/s


Hardware:
---------------------------

root@Arzamas:~# lspci
00:00.0 Host bridge: Intel Corporation 82875P/E7210 Memory Controller
Hub (rev 02)
00:03.0 PCI bridge: Intel Corporation 82875P/E7210 Processor to PCI to
CSA Bridge (rev 02)
00:06.0 System peripheral: Intel Corporation 82875P/E7210 Processor to
I/O Memory Interface (rev 02)
00:1c.0 PCI bridge: Intel Corporation 6300ESB 64-bit PCI-X Bridge (rev 02)
00:1d.0 USB Controller: Intel Corporation 6300ESB USB Universal Host
Controller (rev 02)
00:1d.1 USB Controller: Intel Corporation 6300ESB USB Universal Host
Controller (rev 02)
00:1d.4 System peripheral: Intel Corporation 6300ESB Watchdog Timer (rev 02)
00:1d.5 PIC: Intel Corporation 6300ESB I/O Advanced Programmable
Interrupt Controller (rev 02)
00:1d.7 USB Controller: Intel Corporation 6300ESB USB2 Enhanced Host
Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 0a)
00:1f.0 ISA bridge: Intel Corporation 6300ESB LPC Interface Controller
(rev 02)
00:1f.1 IDE interface: Intel Corporation 6300ESB PATA Storage Controller
(rev 02)
00:1f.3 SMBus: Intel Corporation 6300ESB SMBus Controller (rev 02)
01:01.0 Ethernet controller: Intel Corporation 82547GI Gigabit Ethernet
Controller
02:01.0 SCSI storage controller: Adaptec AIC-7901 U320 (rev 10)
02:02.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5701
Gigabit Ethernet (rev 15)
02:03.0 Mass storage controller: Silicon Image, Inc. SiI 3124 PCI-X
Serial ATA Controller (rev 02)
02:04.0 Ethernet controller: Intel Corporation 82541PI Gigabit Ethernet
Controller (rev 05)
03:00.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
03:01.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet
Pro 100 (rev 10)
03:02.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado]
(rev 78)
root@Arzamas:~#


root@Arzamas:~# lspci -v -s 02:
02:01.0 SCSI storage controller: Adaptec AIC-7901 U320 (rev 10)
	Subsystem: Intel Corporation Device 342f
	Flags: bus master, 66MHz, slow devsel, latency 64, IRQ 27
	I/O ports at b800 [disabled] [size=256]
	Memory at fc5fe000 (64-bit, non-prefetchable) [size=8K]
	I/O ports at b400 [disabled] [size=256]
	Expansion ROM at fc500000 [disabled] [size=512K]
	Capabilities: [dc] Power Management version 2
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1
Enable-
	Capabilities: [94] PCI-X non-bridge device
	Kernel driver in use: aic79xx

02:02.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5701
Gigabit Ethernet (rev 15)
	Subsystem: Compaq Computer Corporation NC7770 Gigabit Server Adapter
(PCI-X, 10/100/1000-T)
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 24
	Memory at fc5e0000 (64-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at fc5d0000 [disabled] [size=64K]
	Capabilities: [40] PCI-X non-bridge device
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Vital Product Data <?>
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3
Enable-
	Kernel driver in use: tg3

02:03.0 Mass storage controller: Silicon Image, Inc. SiI 3124 PCI-X
Serial ATA Controller (rev 02)  <----- where the 4 drives are attached to
	Subsystem: Silicon Image, Inc. SiI 3124 PCI-X Serial ATA Controller
	Flags: bus master, stepping, 66MHz, medium devsel, latency 64, IRQ 25
	Memory at fc5fd800 (64-bit, non-prefetchable) [size=128]
	Memory at fc5f0000 (64-bit, non-prefetchable) [size=32K]
	I/O ports at bc00 [size=16]
	Expansion ROM at fc480000 [disabled] [size=512K]
	Capabilities: [64] Power Management version 2
	Capabilities: [40] PCI-X non-bridge device
	Capabilities: [54] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
	Kernel driver in use: sata_sil24

02:04.0 Ethernet controller: Intel Corporation 82541PI Gigabit Ethernet
Controller (rev 05)
	Subsystem: Intel Corporation PRO/1000 GT Desktop Adapter
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 26
	Memory at fc5a0000 (32-bit, non-prefetchable) [size=128K]
	Memory at fc580000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at b000 [size=64]
	Expansion ROM at fc460000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
	Capabilities: [e4] PCI-X non-bridge device
	Kernel driver in use: e1000

root@Arzamas:~#

root@Arzamas:~# cat /proc/interrupts
           CPU0       CPU1
  0:        127          0   IO-APIC-edge      timer
  1:          8          0   IO-APIC-edge      i8042
  6:          3          0   IO-APIC-edge      floppy
  8:          2          0   IO-APIC-edge      rtc
 10:          0          0   IO-APIC-fasteoi   acpi
 12:        105          0   IO-APIC-edge      i8042
 14:        100          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:     245660          0   IO-APIC-fasteoi   uhci_hcd:usb2, wan_a
 17:       5967          0   IO-APIC-fasteoi   lan_untr
 18:      92684          0   IO-APIC-fasteoi   lan_main
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 23:          2          0   IO-APIC-fasteoi   ehci_hcd:usb1
 24:      73850          0   IO-APIC-fasteoi   wan_b
 25:    1032325          0   IO-APIC-fasteoi   sata_sil24
 26:       5494          0   IO-APIC-fasteoi   lan_srv
 27:         22          0   IO-APIC-fasteoi   aic79xx
NMI:          0          0   Non-maskable interrupts
LOC:    1383148    1381673   Local timer interrupts
RES:      52448      46803   Rescheduling interrupts
CAL:       2552       1883   function call interrupts
TLB:       8035      16978   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0
root@Arzamas:~#
