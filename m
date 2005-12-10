From: Yanggun <yang.geum.seok@gmail.com>
Subject: Re: raid1 mysteriously switching to read-only
Date: Sat, 10 Dec 2005 16:50:34 +0900
Message-ID: <ee0ae26a0512092350k43b6dc8l@mail.gmail.com>
References: <20051128102824.14498.patches@notabene>
	 <1051127234104.14937@suse.de>
	 <ee0ae26a0512092241v3ee5e445r@mail.gmail.com>
	 <17306.31969.240202.416327@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17306.31969.240202.416327@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am sorry because there is no information very.

I currently ext3 file system.

I composed RAID-1(/dev/md0)  disk array by order such as lower part.

mkfs.ext3 -j /dev/sda1
mkfs.ext3 -j /dev/sda1
mdadm -Cv /dev/md0 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1

	[root@sentry24 root]# cat /proc/mdstat ; cat /proc/mounts
	Personalities : [raid1]
	md0 : active raid1 sda1[0] sdb1[1]
    		244195904 blocks [2/2] [UU]

	unused devices: <none>
	rootfs / rootfs rw 0 0
	/dev/root / ext3 rw,noatime 0 0
	proc /proc proc rw,nodiratime 0 0
	sysfs /sys sysfs rw 0 0
	devpts /dev/pts devpts rw 0 0
	tmpfs /dev/shm tmpfs rw 0 0
	tmpfs /tmp tmpfs rw 0 0
	tmpfs /var tmpfs rw 0 0
	none /proc/bus/usb usbfs rw 0 0
	/dev/md0 /data/disk1 ext3 rw,noatime 0 0

After compose RAID-1 disk array, subordinate did serious disk I/O by
order such as lower part.

	scp -r root@192.168.0.24:/data/disk3/*.avi /data/disk1/

It became mount by to readonly while copy file at 30 minutes.

	[root@root root]# cat /proc/mdstat ; cat /proc/mounts
	Personalities : [raid1]
	md0 : active raid1 sda1[0] sdb1[1]
     		 244195904 blocks [2/2] [UU]

	unused devices: <none>
	rootfs / rootfs rw 0 0
	/dev/root / ext3 rw,noatime 0 0
	proc /proc proc rw,nodiratime 0 0
	sysfs /sys sysfs rw 0 0
	devpts /dev/pts devpts rw 0 0
	tmpfs /dev/shm tmpfs rw 0 0
	tmpfs /tmp tmpfs rw 0 0
	tmpfs /var tmpfs rw 0 0
	none /proc/bus/usb usbfs rw 0 0
	/dev/md0 /data/disk3 ext3 ro,noatime 0 0       <------------- changed readonly

	[root@rootroot]# ls -l /data/disk3/dvr
	total 0

	[root@rootroot]# vmstat 1
	procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
 	r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 	5  0    128   6592 299528  32676    0    0   386     2 1328  1268 35 64  1  1
 	2  0    128   6468 299528  32676    0    0     0     0 1346  6578 52 48  0  0
 	2  0    128   6468 299528  32676    0    0     0     0 1344  7606 28 72  0  0

       [root@sentry24 root]# tail -f /var/log/kern.log
       Dec 10 01:36:32 kernel: [   48.647619] EXT3 FS on hda1, internal journal
       Dec 10 01:36:32 kernel: [   52.516666] SCSI subsystem initialized
       Dec 10 01:36:32 kernel: [   52.551594] PROMISE SATA-II 150/300
Series Linux Driver v1.01.0.20
       Dec 10 01:36:32 kernel: [   52.553736] ACPI: PCI Interrupt
0000:01:05.0[A] -> GSI 16 (level, low) -> IRQ 177
       Dec 10 01:36:32 kernel: [   52.693131] ulsata2:[info] Drive
1/0: WDC WD2500JS-22MHB0    488397167s 250059MB  UDMA6
       Dec 10 01:36:32 kernel: [   52.807338] ulsata2:[info] Drive
3/0: WDC WD2500JS-22MHB0    488397167s 250059MB  UDMA6
       Dec 10 01:36:32 kernel: [   52.809447] scsi0 : ulsata2
       Dec 10 01:36:32 kernel: [   52.823914]   Vendor:          
Model: WDC WD2500JS-22M  Rev:
       Dec 10 01:36:32 kernel: [   52.826003]   Type:   Direct-Access 
                    ANSI SCSI revision: 02
       Dec 10 01:36:32 kernel: [   52.852253]   Vendor:          
Model: WDC WD2500JS-22M  Rev:
       Dec 10 01:36:32 kernel: [   52.854580]   Type:   Direct-Access 
                    ANSI SCSI revision: 02
       Dec 10 01:36:32 kernel: [   52.942756] SCSI device sda:
488397168 512-byte hdwr sectors (250059 MB)
       Dec 10 01:36:32 kernel: [   52.944896] sda: got wrong page
       Dec 10 01:36:32 kernel: [   52.946855] sda: assuming drive
cache: write through
       Dec 10 01:36:32 kernel: [   52.961355] SCSI device sda:
488397168 512-byte hdwr sectors (250059 MB)
       Dec 10 01:36:32 kernel: [   52.963487] sda: got wrong page
       Dec 10 01:36:32 kernel: [   52.965451] sda: assuming drive
cache: write through
       Dec 10 01:36:32 kernel: [   52.967431]  sda: sda1
       Dec 10 01:36:32 kernel: [   52.989793] Attached scsi disk sda
at scsi0, channel 0, id 0, lun 0
       Dec 10 01:36:32 kernel: [   52.991983] SCSI device sdb:
488397168 512-byte hdwr sectors (250059 MB)
       Dec 10 01:36:32 kernel: [   52.994016] sdb: got wrong page
       Dec 10 01:36:32 kernel: [   52.996018] sdb: assuming drive
cache: write through
       Dec 10 01:36:32 kernel: [   53.004583] SCSI device sdb:
488397168 512-byte hdwr sectors (250059 MB)
       Dec 10 01:36:32 kernel: [   53.006722] sdb: got wrong page
       Dec 10 01:36:32 kernel: [   53.008714] sdb: assuming drive
cache: write through
       Dec 10 01:36:32 kernel: [   53.010803]  sdb: sdb1
       Dec 10 01:36:32 kernel: [   53.038174] Attached scsi disk sdb
at scsi0, channel 0, id 2, lun 0
       Dec 10 01:36:32 kernel: [   53.195957] Intel(R) PRO/1000
Network Driver - version 6.0.60-k2
       Dec 10 01:36:32 kernel: [   53.198108] Copyright (c) 1999-2005
Intel Corporation.
       Dec 10 01:36:32 kernel: [   53.212695] ACPI: PCI Interrupt
0000:01:03.0[A] -> GSI 21 (level, low) -> IRQ 185
       Dec 10 01:36:32 kernel: [   53.682839] e1000: eth0:
e1000_probe: Intel(R) PRO/1000 Network Connection
       Dec 10 01:36:32 kernel: [   53.999922] usbcore: registered new
driver usbfs
       Dec 10 01:36:32 kernel: [   54.014605] usbcore: registered new driver hub
       Dec 10 01:36:32 kernel: [   54.059477] ACPI: PCI Interrupt
0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 193
       Dec 10 01:36:32 kernel: [   54.061754] PCI: Setting latency
timer of device 0000:00:1d.7 to 64
       Dec 10 01:36:32 kernel: [   54.061761] ehci_hcd 0000:00:1d.7:
Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller
       Dec 10 01:36:32 kernel: [   54.078687] ehci_hcd 0000:00:1d.7:
new USB bus registered, assigned bus number 1
       Dec 10 01:36:32 kernel: [   54.081030] ehci_hcd 0000:00:1d.7:
irq 193, io mem 0xe8180000
       Dec 10 01:36:32 kernel: [   54.087181] PCI: cache line size of
128 is not supported by device 0000:00:1d.7
       Dec 10 01:36:32 kernel: [   54.087189] ehci_hcd 0000:00:1d.7:
USB 2.0 initialized, EHCI 1.00, driver 10 Dec 2004
       Dec 10 01:36:32 kernel: [   54.116718] hub 1-0:1.0: USB hub found
       Dec 10 01:36:32 kernel: [   54.119049] hub 1-0:1.0: 6 ports detected
       Dec 10 01:36:32 kernel: [   54.675098] md: md driver 0.90.2
MAX_MD_DEVS=256, MD_SB_DISKS=27
       Dec 10 01:36:32 kernel: [   54.677398] md: bitmap version 3.38
       Dec 10 01:36:32 kernel: [   54.694205] md: raid1 personality
registered as nr 3
       Dec 10 01:36:32 kernel: [   54.868492] USB Universal Host
Controller Interface driver v2.3
       Dec 10 01:36:32 kernel: [   54.883020] ACPI: PCI Interrupt
0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 177
       Dec 10 01:36:32 kernel: [   54.885145] PCI: Setting latency
timer of device 0000:00:1d.0 to 64
       Dec 10 01:36:32 kernel: [   54.885151] uhci_hcd 0000:00:1d.0:
Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI
Controller #1
       Dec 10 01:36:32 kernel: [   54.901825] uhci_hcd 0000:00:1d.0:
new USB bus registered, assigned bus number 2
       Dec 10 01:36:32 kernel: [   54.904054] uhci_hcd 0000:00:1d.0:
irq 177, io base 0x0000e200
       Dec 10 01:36:32 kernel: [   55.034027] hub 2-0:1.0: USB hub found
       Dec 10 01:36:32 kernel: [   55.036202] hub 2-0:1.0: 2 ports detected
       Dec 10 01:36:32 kernel: [   55.362260] ACPI: PCI Interrupt
0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 201
       Dec 10 01:36:32 kernel: [   55.364448] PCI: Setting latency
timer of device 0000:00:1d.1 to 64
       Dec 10 01:36:32 kernel: [   55.364454] uhci_hcd 0000:00:1d.1:
Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI
Controller #2
       Dec 10 01:36:32 kernel: [   55.381310] uhci_hcd 0000:00:1d.1:
new USB bus registered, assigned bus number 3
       Dec 10 01:36:32 kernel: [   55.383568] uhci_hcd 0000:00:1d.1:
irq 201, io base 0x0000e000
       Dec 10 01:36:32 kernel: [   55.434004] hub 3-0:1.0: USB hub found
       Dec 10 01:36:32 kernel: [   55.436192] hub 3-0:1.0: 2 ports detected
       Dec 10 01:36:32 kernel: [   55.457925] ACPI: PCI Interrupt
0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 169
       Dec 10 01:36:32 kernel: [   55.460171] PCI: Setting latency
timer of device 0000:00:1d.2 to 64
       Dec 10 01:36:32 kernel: [   55.460177] uhci_hcd 0000:00:1d.2:
Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI
Controller #3
       Dec 10 01:36:32 kernel: [   55.477009] uhci_hcd 0000:00:1d.2:
new USB bus registered, assigned bus number 4
       Dec 10 01:36:32 kernel: [   55.479289] uhci_hcd 0000:00:1d.2:
irq 169, io base 0x0000e100
       Dec 10 01:36:32 kernel: [   55.503270] hub 4-0:1.0: USB hub found
       Dec 10 01:36:32 kernel: [   55.505478] hub 4-0:1.0: 2 ports detected
       Dec 10 01:36:32 kernel: [   56.429056] Initializing USB Mass
Storage driver...
       Dec 10 01:36:32 kernel: [   56.597725] usb 4-2: new full speed
USB device using uhci_hcd and address 2
       Dec 10 01:36:32 kernel: [   58.327192] usbcore: registered new
driver usb-storage
       Dec 10 01:36:32 kernel: [   58.329386] USB Mass Storage support
registered.
       Dec 10 01:36:32 kernel: [   58.382477] usbcore: registered new
driver usbserial
       Dec 10 01:36:32 kernel: [   58.397053]
drivers/usb/serial/usb-serial.c: USB Serial support registered for
Generic
       Dec 10 01:36:32 kernel: [   58.411747] usbcore: registered new
driver usbserial_generic
       Dec 10 01:36:32 kernel: [   58.633823]
drivers/usb/serial/usb-serial.c: USB Serial Driver core v2.0
       Dec 10 01:36:32 kernel: [   58.760438] usbcore: registered new
driver hiddev
       Dec 10 01:36:32 kernel: [   58.778876] input: USB HID v1.00
Device [Burr-Brown from TI               USB Audio CODEC ] on
usb-0000:00:1d.2-2
       Dec 10 01:36:32 kernel: [   58.783803] usbcore: registered new
driver usbhid
       Dec 10 01:36:32 kernel: [   58.786300]
drivers/usb/input/hid-core.c: v2.01:USB HID core driver
       Dec 10 01:36:32 kernel: [   58.894333]
drivers/usb/serial/usb-serial.c: USB Serial support registered for
PL-2303
       Dec 10 01:36:32 kernel: [   58.909269] usbcore: registered new
driver pl2303
       Dec 10 01:36:32 kernel: [   58.911796]
drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor
driver v0.12
       Dec 10 01:36:32 kernel: [   59.014389] ieee1394: Initialized
config rom entry `ip1394'
       Dec 10 01:36:32 kernel: [   59.078076] usbcore: registered new
driver snd-usb-audio
       Dec 10 01:36:32 kernel: [   59.199443] sbp2: $Rev: 1306 $ Ben
Collins <bcollins@debian.org>
       Dec 10 01:36:32 kernel: [   59.232766] ACPI: Power Button (FF) [PWRF]
       Dec 10 01:36:32 kernel: [   59.235234] ACPI: Power Button (CM) [PWRB]
       Dec 10 01:36:32 kernel: [   59.526876] odcap_driver.c:910:
odcap: driver registered for major 97.
       Dec 10 01:36:32 kernel: [   59.541867] odcap_driver.c:278:
odcap0: device found.
       Dec 10 01:36:32 kernel: [   59.544359] ACPI: PCI Interrupt
0000:01:06.0[A] -> GSI 17 (level, low) -> IRQ 209
       Dec 10 01:36:32 kernel: [   59.546836] PCI: Setting latency
timer of device 0000:01:06.0 to 64
       Dec 10 01:36:32 kernel: [   59.546847] kernel_api.c:251:
odcap0: (240b rev 0) at 0000:01:06.0, irq:209, latency:0
       Dec 10 01:36:32 kernel: [   59.549297] kernel_api.c:267:
odcap0: port_addr:0x0000d300 port_len:0x00000004
       Dec 10 01:36:32 kernel: [   59.551750] kernel_api.c:292:
odcap0: io_mem:0xe002a000 (mmio:0xe8080000, len:0x1000)
       Dec 10 01:36:32 kernel: [   61.224923] ACPI: PCI Interrupt
0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 177
       Dec 10 01:36:32 kernel: [   61.226432] mtrr:
0xe0000000,0x8000000 overlaps existing 0xe0000000,0x400000
       Dec 10 01:36:32 kernel: [   61.240403] [drm] Initialized i830
1.3.2 20021108 on minor 0: Intel Corporation 82845G/GL[Brookdale-G]/GE
Chipset Integrated Graphics Device
       Dec 10 01:36:32 kernel: [   61.420124] Attached scsi generic
sg0 at scsi0, channel 0, id 0, lun 0,  type 0
       Dec 10 01:36:32 kernel: [   61.435944] Attached scsi generic
sg1 at scsi0, channel 0, id 2, lun 0,  type 0
       Dec 10 01:36:32 kernel: [   65.656940] e1000: eth0:
e1000_watchdog_task: NIC Link is Up 100 Mbps Full Duplex
       Dec 10 01:36:32 kernel: [   66.997072] lp: driver loaded but no
devices found
       Dec 10 01:36:35 kernel: [   69.496288] apm: BIOS version 1.2
Flags 0x07 (Driver version 1.16ac)
       Dec 10 01:36:35 kernel: [   69.496295] apm: overridden by ACPI.
       Dec 10 01:36:35 kernel: [   69.937106] mtrr:
0xe0000000,0x8000000 overlaps existing 0xe0000000,0x400000
       Dec 10 01:36:41 kernel: [   75.979540] e1000: eth0:
e1000_watchdog_task: NIC Link is Up 100 Mbps Full Duplex
       Dec 10 01:36:45 kernel: Kernel logging (proc) stopped.
       Dec 10 01:36:45 kernel: Kernel log daemon terminating.
       Dec 10 01:36:46 kernel: klogd 1.4.1#10, log source = /proc/kmsg started.
       Dec 10 01:36:46 kernel: Inspecting /boot/System.map-2.6.13.2
       Dec 10 01:36:46 kernel: Loaded 28981 symbols from
/boot/System.map-2.6.13.2.
       Dec 10 01:36:46 kernel: Symbols match kernel version 2.6.13.
       Dec 10 01:36:46 kernel: No module symbols loaded - kernel
modules not enabled.
       Dec 10 01:36:50 kernel: [   84.661743] md: bind<sda1>
       Dec 10 01:36:50 kernel: [   84.661911] md: bind<sdb1>
       Dec 10 01:36:50 kernel: [   84.662081] raid1: raid set md0
active with 2 out of 2 mirrors
       Dec 10 01:36:50 kernel: [   84.663584] md: syncing RAID array md0
       Dec 10 01:36:50 kernel: [   84.663789] md: minimum _guaranteed_
reconstruction speed: 1000 KB/sec/disc.
       Dec 10 01:36:50 kernel: [   84.663923] md: using maximum
available idle IO bandwith (but not more than 200000 KB/sec) for
reconstruction.
       Dec 10 01:36:50 kernel: [   84.664062] md: using 128k window,
over a total of 244195904 blocks.
       Dec 10 01:36:50 kernel: [   84.733296] kjournald starting. 
Commit interval 5 seconds
       Dec 10 01:36:50 kernel: [   84.740243] EXT3 FS on md0, internal journal
       Nov 17 01:36:50 kernel: [   84.740347] EXT3-fs: mounted
filesystem with ordered data mode.

Yanggun

2005/12/10, Neil Brown <neilb@suse.de>:
> On Saturday December 10, yang.geum.seok@gmail.com wrote:
> > Hi Brown.
> >
> > I have raid arrays, raid1 called md0. Basically they run fine, but
> > something is switching md0 readonly during write to disk(cp, mv);
> >
> > Is changed by that RAID readonly in what case? let me know, describe
> > number of case?
> >
> > I am very anxious  about it very. Please, can you inform to me?  Does
> > this patch solve it? Can not you do to do not become by readonly?
>
> You will need to give more details about what is happening.  Lots more.
>
> What makes you say the array is 'read-only'  - what are the messages
>      you get - exactly?
> What filesystem are you using?
> What messages are there in the kernel log ('dmesg' might show these)?
> What does 'cat /proc/mdstat' show?
>
> NeilBrown
>
