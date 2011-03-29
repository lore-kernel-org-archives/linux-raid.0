From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Tue, 29 Mar 2011 11:53:06 +0200
Message-ID: <201103291153.06495.thomas.jarosch@intra2net.com>
References: <201103251725.21180.thomas.jarosch@intra2net.com> <4D90E580.7020406@intra2net.com> <20110329082503.GI6736@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110329082503.GI6736@htj.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Tuesday, 29. March 2011 10:25:03 Tejun Heo wrote:
> Can you please apply the following patch and see whether it resolves
> the problem and report the boot log?

Ok, I did the following:
- Check out commit e804ac780e2f01cb3b914daca2fd4780d1743db1
  (md: fix and update workqueue usage)
- Apply your patch
- Add small debug output on top of it:

------------------------------
# git diff
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1e6534d..d2ddef4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5899,6 +5899,16 @@ static int md_open(struct block_device *bdev, fmode_t mode)
                                once = true;
                        }
                }
+               /* DEBUG HACK */
+               {
+                   static bool tomj_once = false;
+                   if (!tomj_once)
+                   {
+                               printk("TOMJ %s: md_open(): RT prio, pol=%u p=%d rt_p=%u\n",
+                                      current->comm, current->policy, current->static_prio, current->rt_priority);
+                       tomj_once = true;
+                   }
+               }
                msleep(10);
                /* Wait until bdev->bd_disk is definitely gone */
                flush_workqueue(md_misc_wq);
------------------------------

With your patch applied, it boots!

Here's the dmesg output:

------------------------------
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:12.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 5120k freed
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
type=2000 audit(1301389498.428:1): initialized
highmem bounce pool size: 64 pages
msgmni has been set to 1730
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:0b.0: ACPI _OSC control granted for 0x1d
pcieport 0000:00:0b.0: setting latency timer to 64
pcieport 0000:00:0b.0: irq 40 for MSI/MSI-X
pcieport 0000:00:0c.0: ACPI _OSC control granted for 0x1d
pcieport 0000:00:0c.0: setting latency timer to 64
pcieport 0000:00:0c.0: irq 41 for MSI/MSI-X
pcieport 0000:00:0d.0: ACPI _OSC control granted for 0x1d
pcieport 0000:00:0d.0: setting latency timer to 64
pcieport 0000:00:0d.0: irq 42 for MSI/MSI-X
pcieport 0000:00:0e.0: ACPI _OSC control granted for 0x1d
pcieport 0000:00:0e.0: setting latency timer to 64
pcieport 0000:00:0e.0: irq 43 for MSI/MSI-X
pcieport 0000:00:0f.0: ACPI _OSC control granted for 0x1d
pcieport 0000:00:0f.0: setting latency timer to 64
pcieport 0000:00:0f.0: irq 44 for MSI/MSI-X
pcieport 0000:00:10.0: ACPI _OSC control granted for 0x1d
pcieport 0000:00:10.0: setting latency timer to 64
pcieport 0000:00:10.0: irq 45 for MSI/MSI-X
pcieport 0000:00:11.0: ACPI _OSC control granted for 0x1d
pcieport 0000:00:11.0: setting latency timer to 64
pcieport 0000:00:11.0: irq 46 for MSI/MSI-X
ACPI: acpi_idle registered with cpuidle
Non-volatile memory driver v1.3
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:04: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
loop: module loaded
Uniform Multi-Platform E-IDE driver
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 23
ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
ehci_hcd 0000:00:02.1: irq 23, io mem 0xfe8fec00
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ACPI: PCI Interrupt Link [UB12] enabled at IRQ 22
ehci_hcd 0000:00:04.1: PCI INT B -> Link[UB12] -> GSI 22 (level, low) -> IRQ 22
ehci_hcd 0000:00:04.1: setting latency timer to 64
ehci_hcd 0000:00:04.1: EHCI Host Controller
ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:04.1: debug port 1
ehci_hcd 0000:00:04.1: cache line size of 64 is not supported
ehci_hcd 0000:00:04.1: irq 22, io mem 0xfe8fe800
ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 21
ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 21 (level, low) -> IRQ 21
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.0: irq 21, io mem 0xfe8ff000
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 6 ports detected
ACPI: PCI Interrupt Link [UB11] enabled at IRQ 20
ohci_hcd 0000:00:04.0: PCI INT A -> Link[UB11] -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:04.0: setting latency timer to 64
ohci_hcd 0000:00:04.0: OHCI Host Controller
ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:04.0: irq 20, io mem 0xfe8fd000
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver ftdi_sio
ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input0
md: raid1 personality registered for level 1
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
NET: Registered protocol family 17
Using IPI No-Shortcut mode
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Freeing unused kernel memory: 408k freed
Write protecting the kernel text: 2896k
Write protecting the kernel read-only data: 1108k
dracut: dracut-004-6.i2n
device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
dracut: rd_NO_MDIMSM: no MD RAID for imsm/isw raids
udev: starting version 145
udevd (582): /proc/582/oom_adj is deprecated, please use /proc/582/oom_score_adj instead.
dracut: Telling kernel to auto-detect RAID arrays
libata version 3.00 loaded.
ahci 0000:00:09.0: version 3.0
ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
ahci 0000:00:09.0: PCI INT A -> Link[LSA0] -> GSI 23 (level, low) -> IRQ 23
ahci 0000:00:09.0: controller can't do PMP, turning off CAP_PMP
ahci 0000:00:09.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl IDE mode
ahci 0000:00:09.0: flags: 64bit ncq sntf led clo pio 
ahci 0000:00:09.0: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 23
ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 23
ata3: SATA max UDMA/133 abar m8192@0xfe8f6000 port 0xfe8f6200 irq 23
ata4: SATA max UDMA/133 abar m8192@0xfe8f6000 port 0xfe8f6280 irq 23
usb 4-1: new low speed USB device using ohci_hcd and address 2
ata4: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
input: USB CAT5 as /devices/pci0000:00/0000:00:04.0/usb4/4-1/4-1:1.0/input/input1
generic-usb 0003:0D3D:0040.0001: input: USB HID v1.00 Keyboard [USB CAT5] on usb-0000:00:04.0-1/input0
input: USB CAT5 as /devices/pci0000:00/0000:00:04.0/usb4/4-1/4-1:1.1/input/input2
generic-usb 0003:0D3D:0040.0002: input: USB HID v1.00 Mouse [USB CAT5] on usb-0000:00:04.0-1/input1
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
usb 4-2: new full speed USB device using ohci_hcd and address 3
ata2.00: ATA-7: ST3160215AS, 3.AAD, max UDMA/133
ata2.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ATA-7: ST3160215AS, 3.AAD, max UDMA/133
ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST3160215AS      3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
scsi 1:0:0:0: Direct-Access     ATA      ST3160215AS      3.AA PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 < sdb5 sdb6 sdb7 sdb8 sdb9 >
sd 1:0:0:0: [sdb] Attached SCSI disk
ftdi_sio 4-2:1.0: FTDI USB Serial Device converter detected
usb 4-2: Detected FT232BM
usb 4-2: Number of endpoints 2
usb 4-2: Endpoint 1 MaxPacketSize 64
usb 4-2: Endpoint 2 MaxPacketSize 64
usb 4-2: Setting MaxPacketSize 64
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk
usb 4-2: FTDI USB Serial Device converter now attached to ttyUSB0
console [ttyUSB0] enabled
usb 4-4: new full speed USB device using ohci_hcd and address 4
TOMJ blkid: md_open(): RT prio, pol=0 p=118 rt_p=0
md: Autodetecting RAID arrays.
md: Scanned 12 and added 12 devices.
md: autorun ...
md: considering sda9 ...
md:  adding sda9 ...
md: sda8 has different UUID to sda9
md: sda7 has different UUID to sda9
md: sda6 has different UUID to sda9
md: sda5 has different UUID to sda9
md: sda1 has different UUID to sda9
md:  adding sdb9 ...
md: sdb8 has different UUID to sda9
md: sdb7 has different UUID to sda9
md: sdb6 has different UUID to sda9
md: sdb5 has different UUID to sda9
md: sdb1 has different UUID to sda9
md: created md5
md: bind<sdb9>
md: bind<sda9>
md: running: <sda9><sdb9>
md/raid1:md5: active with 2 out of 2 mirrors
md5: detected capacity change from 0 to 147446235136
 md5: unknown partition table
md: considering sda8 ...
md:  adding sda8 ...
md: sda7 has different UUID to sda8
md: sda6 has different UUID to sda8
md: sda5 has different UUID to sda8
md: sda1 has different UUID to sda8
md:  adding sdb8 ...
md: sdb7 has different UUID to sda8
md: sdb6 has different UUID to sda8
md: sdb5 has different UUID to sda8
md: sdb1 has different UUID to sda8
md: created md4
md: bind<sdb8>
md: bind<sda8>
md: running: <sda8><sdb8>
md/raid1:md4: active with 2 out of 2 mirrors
md4: detected capacity change from 0 to 2097348608
 md4: unknown partition table
md: considering sda7 ...
md:  adding sda7 ...
md: sda6 has different UUID to sda7
md: sda5 has different UUID to sda7
md: sda1 has different UUID to sda7
md:  adding sdb7 ...
md: sdb6 has different UUID to sda7
md: sdb5 has different UUID to sda7
md: sdb1 has different UUID to sda7
md: created md3
md: bind<sdb7>
md: bind<sda7>
md: running: <sda7><sdb7>
md/raid1:md3: active with 2 out of 2 mirrors
md3: detected capacity change from 0 to 2623733760
 md3: unknown partition table
md: considering sda6 ...
md:  adding sda6 ...
md: sda5 has different UUID to sda6
md: sda1 has different UUID to sda6
md:  adding sdb6 ...
md: sdb5 has different UUID to sda6
md: sdb1 has different UUID to sda6
md: created md2
md: bind<sdb6>
md: bind<sda6>
md: running: <sda6><sdb6>
md/raid1:md2: active with 2 out of 2 mirrors
md2: detected capacity change from 0 to 2623733760
md: considering sda5 ...
md:  adding sda5 ...
md: sda1 has different UUID to sda5
md:  adding sdb5 ...
md: sdb1 has different UUID to sda5
md: created md1
md: bind<sdb5>
md: bind<sda5>
md: running: <sda5><sdb5>
md/raid1:md1: active with 2 out of 2 mirrors
md1: detected capacity change from 0 to 2623733760
 md1: unknown partition table
md: considering sda1 ...
md:  adding sda1 ...
md:  adding sdb1 ...
md: created md0
md: bind<sdb1>
md: bind<sda1>
md: running: <sda1><sdb1>
md/raid1:md0: active with 2 out of 2 mirrors
md0: detected capacity change from 0 to 2623733760
md: ... autorun DONE.
 md0: unknown partition table
md5: detected capacity change from 0 to 147446235136
 md5: unknown partition table
md3: detected capacity change from 0 to 2623733760
 md3: unknown partition table
md2: detected capacity change from 0 to 2623733760
 md2: unknown partition table
md1: detected capacity change from 0 to 2623733760
md4: detected capacity change from 0 to 2097348608
 md4: unknown partition table
 md1: unknown partition table
usb 4-4: usbfs: interface 0 claimed by usbfs while 'display' sets config #1
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (md0): mounted filesystem with ordered data mode
dracut: Remounting /dev/md0 with -o ro,defaults,noatime
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (md0): mounted filesystem with ordered data mode
dracut: Mounted root filesystem /dev/md0
dracut: Switching root
------------------------------

As you can see, your printk() is not triggered(). I just
copied your printk and made it print once unconditionally.

So probably the msleep(10); does the trick. Something
seems very racy to me as other boxes with software RAID
can boot the exact same kernel + dracut version just fine.

I'll put the box in a reboot loop over the lunch break.

Cheers,
Thomas
