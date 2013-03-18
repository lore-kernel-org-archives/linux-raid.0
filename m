From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: Persistent failures with simple md setup
Date: Mon, 18 Mar 2013 12:20:57 +0100
Message-ID: <2777026.gm19DAWULs@xrated>
References: <1565063.1kpR7lz4Ph@xrated> <20130313115235.01492c21@notabene.brown> <1407824.2kxT8nEo5d@xrated>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1407824.2kxT8nEo5d@xrated>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am Freitag, 15. M=E4rz 2013, 23:43:31 schrieb Hans-Peter Jansen:
> Am Mittwoch, 13. M=E4rz 2013, 11:52:35 schrieben Sie:
> > hi,
> >=20
> >  wonder if you could try one more test for me.
> >  With the other (echo BEFORE / echo AFTER etc) tracing still there,=
 change
> >=20
> > the /sbin/udevadm settle --timeout=3D$MDADM_DEVICE_TIMEOUT
> >=20
> >  to
> > =20
> >    /sbin/udevadm --debug settle --timeout=3D$MDADM_DEVICE_TIMEOUT >
> >    /dev/kmsg
> >=20
> > 2>&1
> >=20
> >  I found there is a case where "udevadm settle" can exit before the=
 queue
> >  is
> >=20
> > empty.  It seems like a very unlikely scenario, but it seems clear =
that
> > something "unlikely" is happening.
> >=20
> >  I'm hoping to see
> > =20
> >     timeout waiting for udev queue
> > =20
> >  appear in the logs when this runs.
> > =20
> >  If you could add that and post the 'dmesg' output if you ever get =
that
> >  message - or maybe even if you don't - that would be very helpful.
>=20
> Did that right now and disabled the sleep 10 in front, that provision=
ally
> "solved" this issue BTW. Now waiting for another md issue to occur.

Here we go: (not censored in any way, and I hope to get the "window" ri=
ght:
md0 was affected this time.

Mar 18 09:02:20 zaphkiel kernel: [   10.153098] sd 6:0:0:0: [sdc] 77414=
40 512-byte logical blocks: (3.96 GB/3.69 GiB)
Mar 18 09:02:20 zaphkiel kernel: [   10.202222] sd 6:0:0:0: [sdc] Write=
 Protect is off
Mar 18 09:02:20 zaphkiel kernel: [   10.230965] sd 6:0:0:0: [sdc] Mode =
Sense: 03 00 00 00
Mar 18 09:02:20 zaphkiel kernel: [   10.234226] sd 6:0:0:0: [sdc] No Ca=
ching mode page present
Mar 18 09:02:20 zaphkiel kernel: [   10.267155] sd 6:0:0:0: [sdc] Assum=
ing drive cache: write through
Mar 18 09:02:20 zaphkiel kernel: [   10.309225] sd 6:0:0:0: [sdc] No Ca=
ching mode page present
Mar 18 09:02:20 zaphkiel kernel: [   10.342135] sd 6:0:0:0: [sdc] Assum=
ing drive cache: write through
Mar 18 09:02:20 zaphkiel kernel: [   10.379763]  sdc: sdc1
Mar 18 09:02:20 zaphkiel kernel: [   10.400224] sd 6:0:0:0: [sdc] No Ca=
ching mode page present
Mar 18 09:02:20 zaphkiel kernel: [   10.433138] sd 6:0:0:0: [sdc] Assum=
ing drive cache: write through
Mar 18 09:02:20 zaphkiel kernel: [   10.469953] sd 6:0:0:0: [sdc] Attac=
hed SCSI removable disk
Mar 18 09:02:20 zaphkiel kernel: [   10.502901] Freeing unused kernel m=
emory: 488k freed
Mar 18 09:02:20 zaphkiel kernel: [   10.532672] usb 2-4: device descrip=
tor read/64, error -71
Mar 18 09:02:20 zaphkiel kernel: [   10.565302] Write protecting the ke=
rnel text: 5204k
Mar 18 09:02:20 zaphkiel kernel: [   10.594587] Write protecting the ke=
rnel read-only data: 3540k
Mar 18 09:02:20 zaphkiel kernel: [   10.629070] NX-protecting the kerne=
l data: 5036k
Mar 18 09:02:20 zaphkiel kernel: [   10.699772] ACPI: acpi_idle registe=
red with cpuidle
Mar 18 09:02:20 zaphkiel kernel: [   10.735081] SGI XFS with ACLs, secu=
rity attributes, realtime, large block/inode numbers, no debug enabled
Mar 18 09:02:20 zaphkiel kernel: [   10.792858] SGI XFS Quota Managemen=
t subsystem
Mar 18 09:02:20 zaphkiel kernel: [   10.821500] md: raid1 personality r=
egistered for level 1
Mar 18 09:02:20 zaphkiel kernel: [   10.853390] usb 2-4: new high speed=
 USB device number 5 using ehci_hcd
Mar 18 09:02:20 zaphkiel kernel: [   10.894261] BIOS EDD facility v0.16=
 2004-Jun-25, 3 devices found
Mar 18 09:02:20 zaphkiel kernel: [   11.157034] usb 2-4: device descrip=
tor read/64, error -71
Mar 18 09:02:20 zaphkiel kernel: [   11.385910] md: bind<sda3>
Mar 18 09:02:20 zaphkiel kernel: [   11.407964] md: bind<sdb3>
Mar 18 09:02:20 zaphkiel kernel: [   11.427609] bio: create slab <bio-1=
> at 1
Mar 18 09:02:20 zaphkiel kernel: [   11.451733] md/raid1:md124: active =
with 2 out of 2 mirrors
Mar 18 09:02:20 zaphkiel kernel: [   11.484761] created bitmap (200 pag=
es) for device md124
Mar 18 09:02:20 zaphkiel kernel: [   11.527745] md124: bitmap initializ=
ed from disk: read 13/13 pages, set 0 of 409595 bits
Mar 18 09:02:20 zaphkiel kernel: [   11.589866] md124: detected capacit=
y change from 0 to 107372728320
Mar 18 09:02:20 zaphkiel kernel: [   11.628729]  md124: unknown partiti=
on table
Mar 18 09:02:20 zaphkiel kernel: [   11.705023] usb 2-4: device descrip=
tor read/64, error -71
Mar 18 09:02:20 zaphkiel kernel: [   11.940026] usb 2-4: new high speed=
 USB device number 6 using ehci_hcd
Mar 18 09:02:20 zaphkiel kernel: [   12.443021] usb 2-4: device not acc=
epting address 6, error -71
Mar 18 09:02:20 zaphkiel kernel: [   12.579024] usb 2-4: new high speed=
 USB device number 7 using ehci_hcd
Mar 18 09:02:20 zaphkiel kernel: [   13.082029] usb 2-4: device not acc=
epting address 7, error -71
Mar 18 09:02:20 zaphkiel kernel: [   13.117018] hub 2-0:1.0: unable to =
enumerate USB device on port 4
Mar 18 09:02:20 zaphkiel kernel: [   13.385793] md: raid0 personality r=
egistered for level 0
Mar 18 09:02:20 zaphkiel kernel: [   13.424034] usb 4-2: new low speed =
USB device number 2 using ohci_hcd
Mar 18 09:02:20 zaphkiel kernel: [   13.471246] md: raid10 personality =
registered for level 10
Mar 18 09:02:20 zaphkiel kernel: [   13.517387] async_tx: api initializ=
ed (async)
Mar 18 09:02:20 zaphkiel kernel: [   13.544243] xor: automatically usin=
g best checksumming function: pIII_sse
Mar 18 09:02:20 zaphkiel kernel: [   13.590008]    pIII_sse  :  7224.00=
0 MB/sec
Mar 18 09:02:20 zaphkiel kernel: [   13.615137] xor: using function: pI=
II_sse (7224.000 MB/sec)
Mar 18 09:02:20 zaphkiel kernel: [   13.666017] raid6: int32x1    996 M=
B/s
Mar 18 09:02:20 zaphkiel kernel: [   13.705044] raid6: int32x2   1101 M=
B/s
Mar 18 09:02:20 zaphkiel kernel: [   13.744041] raid6: int32x4    789 M=
B/s
Mar 18 09:02:20 zaphkiel kernel: [   13.783015] raid6: int32x8    878 M=
B/s
Mar 18 09:02:20 zaphkiel kernel: [   13.822041] raid6: mmxx1     1972 M=
B/s
Mar 18 09:02:20 zaphkiel kernel: [   13.861017] raid6: mmxx2     3632 M=
B/s
Mar 18 09:02:20 zaphkiel kernel: [   13.883514] usb 4-2: New USB device=
 found, idVendor=3D093a, idProduct=3D2510
Mar 18 09:02:20 zaphkiel kernel: [   13.940023] raid6: sse1x1    2007 M=
B/s
Mar 18 09:02:20 zaphkiel kernel: [   13.962555] usb 4-2: New USB device=
 strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
Mar 18 09:02:20 zaphkiel kernel: [   14.022017] raid6: sse1x2    3406 M=
B/s
Mar 18 09:02:20 zaphkiel kernel: [   14.061017] usb 4-2: Product: USB O=
PTICAL MOUSE
Mar 18 09:02:20 zaphkiel kernel: [   14.088224] raid6: sse2x1    3433 M=
B/s
Mar 18 09:02:20 zaphkiel kernel: [   14.110741] usb 4-2: Manufacturer: =
PIXART
Mar 18 09:02:20 zaphkiel kernel: [   14.152588] raid6: sse2x2    4511 M=
B/s
Mar 18 09:02:20 zaphkiel kernel: [   14.175186] raid6: using algorithm =
sse2x2 (4511 MB/s)
Mar 18 09:02:20 zaphkiel kernel: [   14.207849] md: raid6 personality r=
egistered for level 6
Mar 18 09:02:20 zaphkiel kernel: [   14.239745] md: raid5 personality r=
egistered for level 5
Mar 18 09:02:20 zaphkiel kernel: [   14.272105] input: PIXART USB OPTIC=
AL MOUSE as /devices/pci0000:00/0000:00:04.0/usb4/4-2/4-2:1.0/input/inp=
ut1
Mar 18 09:02:20 zaphkiel kernel: [   14.334075] md: raid4 personality r=
egistered for level 4
Mar 18 09:02:20 zaphkiel kernel: [   14.371117] generic-usb 0003:093A:2=
510.0001: input,hidraw0: USB HID v1.11 Mouse [PIXART USB OPTICAL MOUSE]=
 on usb-0000:00:04.0-2/input0
Mar 18 09:02:20 zaphkiel kernel: [   14.485966] XFS (md124): Mounting F=
ilesystem
Mar 18 09:02:20 zaphkiel kernel: [   14.701101] XFS (md124): Ending cle=
an mount
Mar 18 09:02:20 zaphkiel kernel: [   14.731718] usb 4-4: new full speed=
 USB device number 3 using ohci_hcd
Mar 18 09:02:20 zaphkiel kernel: [   14.959749] usb 4-4: not running at=
 top speed; connect to a high speed hub
Mar 18 09:02:20 zaphkiel kernel: [   15.020945] usb 4-4: New USB device=
 found, idVendor=3D05e3, idProduct=3D0760
Mar 18 09:02:20 zaphkiel kernel: [   15.066896] usb 4-4: New USB device=
 strings: Mfr=3D0, Product=3D3, SerialNumber=3D4
Mar 18 09:02:20 zaphkiel kernel: [   15.109742] usb 4-4: Product: Flash=
 Reader
Mar 18 09:02:20 zaphkiel kernel: [   15.134328] usb 4-4: SerialNumber: =
03570
Mar 18 09:02:20 zaphkiel kernel: [   15.159828] scsi7 : usb-storage 4-4=
:1.0
Mar 18 09:02:20 zaphkiel kernel: [   16.191763] scsi 7:0:0:0: Direct-Ac=
cess     Generic  STORAGE DEVICE   0125 PQ: 0 ANSI: 0
Mar 18 09:02:20 zaphkiel kernel: [   16.256768] scsi 7:0:0:1: Direct-Ac=
cess     Generic  STORAGE DEVICE   0125 PQ: 0 ANSI: 0
Mar 18 09:02:20 zaphkiel kernel: [   16.332762] scsi 7:0:0:2: Direct-Ac=
cess     Generic  STORAGE DEVICE   0125 PQ: 0 ANSI: 0
Mar 18 09:02:20 zaphkiel kernel: [   16.401753] sd 7:0:0:0: [sdd] Attac=
hed SCSI removable disk
Mar 18 09:02:20 zaphkiel kernel: [   16.450765] scsi 7:0:0:3: Direct-Ac=
cess     Generic  STORAGE DEVICE   0125 PQ: 0 ANSI: 0
Mar 18 09:02:20 zaphkiel kernel: [   16.508754] sd 7:0:0:1: [sde] Attac=
hed SCSI removable disk
Mar 18 09:02:20 zaphkiel kernel: [   16.572754] sd 7:0:0:2: [sdf] Attac=
hed SCSI removable disk
Mar 18 09:02:20 zaphkiel kernel: [   16.625754] sd 7:0:0:3: [sdg] Attac=
hed SCSI removable disk
Mar 18 09:02:20 zaphkiel kernel: [   20.412626] forcedeth: Reverse Engi=
neered nForce ethernet driver. Version 0.64.
Mar 18 09:02:20 zaphkiel kernel: [   20.460450] ACPI: PCI Interrupt Lin=
k [LMAC] enabled at IRQ 22
Mar 18 09:02:20 zaphkiel kernel: [   20.502526] forcedeth 0000:00:0a.0:=
 PCI INT A -> Link[LMAC] -> GSI 22 (level, low) -> IRQ 22
Mar 18 09:02:20 zaphkiel kernel: [   20.555583] forcedeth 0000:00:0a.0:=
 setting latency timer to 64
Mar 18 09:02:20 zaphkiel kernel: [   20.608180] forcedeth 0000:00:0a.0:=
 ifname eth0, PHY OUI 0x732 @ 3, addr 00:23:54:2b:d2:58
Mar 18 09:02:20 zaphkiel kernel: [   20.661808] forcedeth 0000:00:0a.0:=
 highdma csum pwrctl mgmt gbit lnktim msi desc-v3
Mar 18 09:02:20 zaphkiel kernel: [   21.514743] 8139too: 8139too Fast E=
thernet driver 0.9.28
Mar 18 09:02:20 zaphkiel kernel: [   21.661650] ACPI: PCI Interrupt Lin=
k [LNKA] enabled at IRQ 16
Mar 18 09:02:20 zaphkiel kernel: [   21.745044] 8139too 0000:01:06.0: P=
CI INT A -> Link[LNKA] -> GSI 16 (level, low) -> IRQ 16
Mar 18 09:02:20 zaphkiel kernel: [   21.853853] 8139too 0000:01:06.0: e=
th1: RealTek RTL8139 at 0xf7a32c00, 00:08:54:0a:9b:53, IRQ 16
Mar 18 09:02:20 zaphkiel kernel: [   22.792962] BEFORE udevadm settle -=
-timeout=3D60
Mar 18 09:02:20 zaphkiel kernel: [   22.879311] main:=20
Mar 18 09:02:20 zaphkiel kernel: [   22.935601] runtime dir '/run/udev'
Mar 18 09:02:20 zaphkiel kernel: [   22.962183] run_command:=20
Mar 18 09:02:20 zaphkiel kernel: [   23.021385] calling: settle
Mar 18 09:02:20 zaphkiel kernel: [   26.373950] i2c i2c-0: nForce2 SMBu=
s adapter at 0x600
Mar 18 09:02:20 zaphkiel kernel: [   26.439755] WARNING! power/level is=
 deprecated; use power/control instead
Mar 18 09:02:20 zaphkiel kernel: [   26.482815] ACPI: resource nForce2_=
smbus [io  0x0700-0x073f] conflicts with ACPI region SM00 [io 0x700-0x7=
3f]
Mar 18 09:02:20 zaphkiel kernel: [   26.579063] ACPI: If an ACPI driver=
 is available for this device, you should use it instead of the native =
driver
Mar 18 09:02:20 zaphkiel kernel: [   26.649433] firewire_ohci 0000:04:0=
0.0: PCI INT A -> Link[LN3A] -> GSI 17 (level, low) -> IRQ 17
Mar 18 09:02:20 zaphkiel kernel: [   26.739746] input: Power Button as =
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
Mar 18 09:02:20 zaphkiel kernel: [   26.796477] firewire_ohci 0000:04:0=
0.0: setting latency timer to 64
Mar 18 09:02:20 zaphkiel kernel: [   26.801886] Linux video capture int=
erface: v2.00
Mar 18 09:02:20 zaphkiel kernel: [   26.849080] firewire_ohci: Added fw=
-ohci device 0000:04:00.0, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x1=
0
Mar 18 09:02:20 zaphkiel kernel: [   26.966186] pata_amd 0000:00:06.0: =
version 0.4.1
Mar 18 09:02:20 zaphkiel kernel: [   26.966229] pata_amd 0000:00:06.0: =
setting latency timer to 64
Mar 18 09:02:20 zaphkiel kernel: [   26.968773] scsi8 : pata_amd
Mar 18 09:02:20 zaphkiel kernel: [   26.992242] sd 0:0:0:0: Attached sc=
si generic sg0 type 0
Mar 18 09:02:20 zaphkiel kernel: [   27.031690] scsi9 : pata_amd
Mar 18 09:02:20 zaphkiel kernel: [   27.064347] ata7: PATA max UDMA/133=
 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
Mar 18 09:02:20 zaphkiel kernel: [   27.152035] ata8: PATA max UDMA/133=
 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
Mar 18 09:02:20 zaphkiel kernel: [   27.207504] IT8712 SuperIO detected=
=2E
Mar 18 09:02:20 zaphkiel kernel: [   27.248861] k8temp 0000:00:18.3: Te=
mperature readouts might be wrong - check erratum #141
Mar 18 09:02:20 zaphkiel kernel: [   27.358729] parport_pc 00:04: repor=
ted by Plug and Play ACPI
Mar 18 09:02:20 zaphkiel kernel: [   27.396357] sd 1:0:0:0: Attached sc=
si generic sg1 type 0
Mar 18 09:02:20 zaphkiel kernel: [   27.435502] ata7.00: ATAPI: HL-DT-S=
T DVDRAM GSA-4167B, DL12, max UDMA/33
Mar 18 09:02:20 zaphkiel kernel: [   27.479017] firewire_core: created =
device fw0: GUID 001e8c00018b93c2, S400
Mar 18 09:02:20 zaphkiel kernel: [   27.522961] ACPI: Power Button [PWR=
B]
Mar 18 09:02:20 zaphkiel kernel: [   27.547160] parport0: PC-style at 0=
x378
Mar 18 09:02:20 zaphkiel kernel: [   27.569182] ata7: nv_mode_filter: 0=
x739f&0x739f->0x739f, BIOS=3D0x7000 (0xc0000000) ACPI=3D0x701f (60:900:=
0x11)
Mar 18 09:02:20 zaphkiel kernel: [   27.572162] input: Power Button as =
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
Mar 18 09:02:20 zaphkiel kernel: [   27.619485] nvidia: module license =
'NVIDIA' taints kernel.
Mar 18 09:02:20 zaphkiel kernel: [   27.652780] ata7.00: configured for=
 UDMA/33
Mar 18 09:02:20 zaphkiel kernel: [   27.681871] sd 6:0:0:0: Attached sc=
si generic sg2 type 0
Mar 18 09:02:20 zaphkiel kernel: [   27.720249] scsi 8:0:0:0: CD-ROM   =
         HL-DT-ST DVDRAM GSA-4167B DL12 PQ: 0 ANSI: 5
Mar 18 09:02:20 zaphkiel kernel: [   27.773178] , irq 7
Mar 18 09:02:20 zaphkiel kernel: [   27.785284] Disabling lock debuggin=
g due to kernel taint
Mar 18 09:02:20 zaphkiel kernel: [   27.818744]  [
Mar 18 09:02:20 zaphkiel kernel: [   27.827966] sd 7:0:0:0: Attached sc=
si generic sg3 type 0
Mar 18 09:02:20 zaphkiel kernel: [   27.862615] PCSPP
Mar 18 09:02:20 zaphkiel kernel: [   27.873974] ACPI: Power Button [PWR=
=46]
Mar 18 09:02:20 zaphkiel kernel: [   27.903194] input: PC Speaker as /d=
evices/platform/pcspkr/input/input4
Mar 18 09:02:20 zaphkiel kernel: [   27.947382] ,TRISTATE]
Mar 18 09:02:20 zaphkiel kernel: [   27.967591] wmi: Mapper loaded
Mar 18 09:02:20 zaphkiel kernel: [   28.019498] sd 7:0:0:1: Attached sc=
si generic sg4 type 0
Mar 18 09:02:20 zaphkiel kernel: [   28.086333] ppdev: user-space paral=
lel port driver
Mar 18 09:02:20 zaphkiel kernel: [   28.145165] sd 7:0:0:2: Attached sc=
si generic sg5 type 0
Mar 18 09:02:20 zaphkiel kernel: [   28.219780] sd 7:0:0:3: Attached sc=
si generic sg6 type 0
Mar 18 09:02:20 zaphkiel kernel: [   28.294832] scsi 8:0:0:0: Attached =
scsi generic sg7 type 5
Mar 18 09:02:20 zaphkiel kernel: [   28.359838] ata8: port disabled--ig=
noring
Mar 18 09:02:20 zaphkiel kernel: [   28.377526] snd_hda_intel 0000:00:0=
7.0: power state changed by ACPI to D0
Mar 18 09:02:20 zaphkiel kernel: [   28.460047] snd_hda_intel 0000:00:0=
7.0: power state changed by ACPI to D0
Mar 18 09:02:20 zaphkiel kernel: [   28.544146] ACPI: PCI Interrupt Lin=
k [LAZA] enabled at IRQ 21
Mar 18 09:02:20 zaphkiel kernel: [   28.616023] snd_hda_intel 0000:00:0=
7.0: PCI INT A -> Link[LAZA] -> GSI 21 (level, low) -> IRQ 21
Mar 18 09:02:20 zaphkiel kernel: [   28.725762] hda_intel: Disabling MS=
I
Mar 18 09:02:20 zaphkiel kernel: [   28.749946] bttv: driver version 0.=
9.19 loaded
Mar 18 09:02:20 zaphkiel kernel: [   28.776705] snd_hda_intel 0000:00:0=
7.0: setting latency timer to 64
Mar 18 09:02:20 zaphkiel kernel: [   28.787103] ALSA hda_intel.c:1454 E=
nable delay in RIRB handling
Mar 18 09:02:20 zaphkiel kernel: [   28.804531] bttv: using 8 buffers w=
ith 2080k (520 pages) each for capture
Mar 18 09:02:20 zaphkiel kernel: [   28.864408] IR NEC protocol handler=
 initialized
Mar 18 09:02:20 zaphkiel kernel: [   28.960457] IR RC5(x) protocol hand=
ler initialized
Mar 18 09:02:20 zaphkiel kernel: [   29.004015] bttv: Bt8xx card found =
(0).
Mar 18 09:02:20 zaphkiel kernel: [   29.088643] ACPI: PCI Interrupt Lin=
k [LNKB] enabled at IRQ 19
Mar 18 09:02:20 zaphkiel kernel: [   29.123158] bttv 0000:01:07.0: PCI =
INT A -> Link[LNKB] -> GSI 19 (level, low) -> IRQ 19
Mar 18 09:02:20 zaphkiel kernel: [   29.180972] IR RC6 protocol handler=
 initialized
Mar 18 09:02:20 zaphkiel kernel: [   29.250091] bttv0: Bt878 (rev 17) a=
t 0000:01:07.0,=20
Mar 18 09:02:20 zaphkiel kernel: [   29.278950] IR JVC protocol handler=
 initialized
Mar 18 09:02:20 zaphkiel kernel: [   29.339358] irq: 19, latency: 64, m=
mio: 0xcfffe000
Mar 18 09:02:20 zaphkiel kernel: [   29.400761] bttv0: detected: Hauppa=
uge WinTV [card=3D10], PCI subsystem ID is 0070:13eb
Mar 18 09:02:20 zaphkiel kernel: [   29.447978] IR Sony protocol handle=
r initialized
Mar 18 09:02:20 zaphkiel kernel: [   29.521989] IR MCE Keyboard/mouse p=
rotocol handler initialized
Mar 18 09:02:20 zaphkiel kernel: [   29.562022] bttv0: using: Hauppauge=
 (bt878) [card=3D10,autodetected]
Mar 18 09:02:20 zaphkiel kernel: [   29.636072] lirc_dev: IR Remote Con=
trol driver registered, major 250=20
Mar 18 09:02:20 zaphkiel kernel: [   29.679569] bttv0: gpio: en=3D00000=
000, out=3D00000000 in=3D00ffffdb [init]
Mar 18 09:02:20 zaphkiel kernel: [   29.683413] bttv0: Hauppauge/Voodoo=
 msp34xx: reset line init [5]
Mar 18 09:02:20 zaphkiel kernel: [   29.725031] ALSA patch_realtek.c:12=
28 SKU: Nid=3D0x1d sku_cfg=3D0x4015e601
Mar 18 09:02:20 zaphkiel kernel: [   29.725035] ALSA patch_realtek.c:12=
30 SKU: port_connectivity=3D0x1
Mar 18 09:02:20 zaphkiel kernel: [   29.725038] ALSA patch_realtek.c:12=
31 SKU: enable_pcbeep=3D0x1
Mar 18 09:02:20 zaphkiel kernel: [   29.725040] ALSA patch_realtek.c:12=
32 SKU: check_sum=3D0x00000005
Mar 18 09:02:20 zaphkiel kernel: [   29.725042] ALSA patch_realtek.c:12=
33 SKU: customization=3D0x000000e6
Mar 18 09:02:20 zaphkiel kernel: [   29.725045] ALSA patch_realtek.c:12=
34 SKU: external_amp=3D0x0
Mar 18 09:02:20 zaphkiel kernel: [   29.725047] ALSA patch_realtek.c:12=
35 SKU: platform_type=3D0x0
Mar 18 09:02:20 zaphkiel kernel: [   29.725049] ALSA patch_realtek.c:12=
36 SKU: swap=3D0x0
Mar 18 09:02:20 zaphkiel kernel: [   29.725051] ALSA patch_realtek.c:12=
37 SKU: override=3D0x1
Mar 18 09:02:20 zaphkiel kernel: [   29.742390] md: bind<sdb4>
Mar 18 09:02:20 zaphkiel kernel: [   29.779377] IR LIRC bridge handler =
initialized
Mar 18 09:02:20 zaphkiel kernel: [   29.857738] tveeprom 1-0050: Hauppa=
uge model 44354, rev C142, serial# 2295831
Mar 18 09:02:20 zaphkiel kernel: [   29.921654] md: bind<sda1>
Mar 18 09:02:20 zaphkiel kernel: [   29.946033] tveeprom 1-0050: tuner =
model is Temic 4009FR5 (idx 42, type 20)
Mar 18 09:02:20 zaphkiel kernel: [   30.020132] sr0: scsi3-mmc drive: 4=
8x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Mar 18 09:02:20 zaphkiel kernel: [   30.065051] tveeprom 1-0050: TV sta=
ndards PAL(B/G) (eeprom 0x04)
Mar 18 09:02:20 zaphkiel kernel: [   30.103013] tveeprom 1-0050: audio =
processor is MSP3415 (idx 6)
Mar 18 09:02:20 zaphkiel kernel: [   30.145378] md: bind<sda2>
Mar 18 09:02:20 zaphkiel kernel: [   30.174031] tveeprom 1-0050: has ra=
dio
Mar 18 09:02:20 zaphkiel kernel: [   30.221049] bttv0: Hauppauge eeprom=
 indicates model#44354
Mar 18 09:02:20 zaphkiel kernel: [   30.269011] cdrom: Uniform CD-ROM d=
river Revision: 3.20
Mar 18 09:02:20 zaphkiel kernel: [   30.300405] bttv0: tuner type=3D20
Mar 18 09:02:20 zaphkiel kernel: [   30.337486] sr 8:0:0:0: Attached sc=
si CD-ROM sr0
Mar 18 09:02:20 zaphkiel kernel: [   30.340058] nvidia 0000:02:00.0: PC=
I INT A -> Link[LN0A] -> GSI 19 (level, low) -> IRQ 19
Mar 18 09:02:20 zaphkiel kernel: [   30.389781] i2c-core: driver [msp34=
00] using legacy suspend method
Mar 18 09:02:20 zaphkiel kernel: [   30.427379] md: bind<sda4>
Mar 18 09:02:20 zaphkiel kernel: [   30.447871] i2c-core: driver [msp34=
00] using legacy resume method
Mar 18 09:02:20 zaphkiel kernel: [   30.486398] nvidia 0000:02:00.0: se=
tting latency timer to 64
Mar 18 09:02:20 zaphkiel kernel: [   30.486403] vgaarb: device changed =
decodes: PCI:0000:02:00.0,olddecodes=3Dio+mem,decodes=3Dnone:owns=3Dio+=
mem
Mar 18 09:02:20 zaphkiel kernel: [   30.552124] msp3400 1-0040: MSP3415=
D-B3 found @ 0x80 (bt878 #0 [sw])
Mar 18 09:02:20 zaphkiel kernel: [   30.591822] NVRM: loading NVIDIA UN=
IX x86 Kernel Module  304.64  Tue Oct 30 11:09:29 PDT 2012
Mar 18 09:02:20 zaphkiel kernel: [   30.641940] msp3400 1-0040: msp3400=
 supports nicam, mode is autodetect
Mar 18 09:02:20 zaphkiel kernel: [   30.683731]=20
Mar 18 09:02:20 zaphkiel kernel: [   30.728574] i2c-core: driver [tuner=
] using legacy suspend method
Mar 18 09:02:20 zaphkiel kernel: [   30.767893] i2c-core: driver [tuner=
] using legacy resume method
Mar 18 09:02:20 zaphkiel kernel: [   30.811881] tuner 1-0061: Tuner -1 =
found with type(s) Radio TV.
Mar 18 09:02:20 zaphkiel kernel: [   30.847964] md/raid1:md3: active wi=
th 2 out of 2 mirrors
Mar 18 09:02:20 zaphkiel kernel: [   30.881959] created bitmap (415 pag=
es) for device md3
Mar 18 09:02:20 zaphkiel kernel: [   30.990096] input: HDA Digital PCBe=
ep as /devices/pci0000:00/0000:00:07.0/input/input5
Mar 18 09:02:20 zaphkiel kernel: [   31.038390] tuner-simple 1-0061: cr=
eating new instance
Mar 18 09:02:20 zaphkiel kernel: [   31.084560] tuner-simple 1-0061: ty=
pe set to 20 (Temic PAL_BG (4009 FR5) or PAL_I (4069 FR5))
Mar 18 09:02:20 zaphkiel kernel: [   31.140892] bttv0: registered devic=
e video0
Mar 18 09:02:20 zaphkiel kernel: [   31.167942] bttv0: registered devic=
e vbi0
Mar 18 09:02:20 zaphkiel kernel: [   31.192924] bttv0: registered devic=
e radio0
Mar 18 09:02:20 zaphkiel kernel: [   31.223065] bttv0: PLL: 28636363 =3D=
> 35468950 .. ok
Mar 18 09:02:20 zaphkiel kernel: [   31.312236] AFTER udevadm settle --=
timeout=3D60
Mar 18 09:02:20 zaphkiel kernel: [   31.437261] md3: bitmap initialized=
 from disk: read 26/26 pages, set 1464 of 849320 bits
Mar 18 09:02:20 zaphkiel kernel: [   31.536642] BEFORE mdadm -IRs
Mar 18 09:02:20 zaphkiel kernel: [   31.562744] md3: detected capacity =
change from 0 to 890575601664
Mar 18 09:02:20 zaphkiel kernel: [   31.645517] md/raid1:md0: active wi=
th 1 out of 2 mirrors
Mar 18 09:02:20 zaphkiel kernel: [   31.709880]  md3: unknown partition=
 table
Mar 18 09:02:20 zaphkiel kernel: [   31.734035] md: bind<sdb2>
Mar 18 09:02:20 zaphkiel kernel: [   31.753744] created bitmap (6 pages=
) for device md0
Mar 18 09:02:20 zaphkiel kernel: [   31.793486] md0: bitmap initialized=
 from disk: read 1/1 pages, set 0 of 12047 bits
Mar 18 09:02:20 zaphkiel kernel: [   31.874934] md/raid1:md1: active wi=
th 2 out of 2 mirrors
Mar 18 09:02:20 zaphkiel kernel: [   31.907025] md0: detected capacity =
change from 0 to 98689024
Mar 18 09:02:20 zaphkiel kernel: [   32.004102] created bitmap (8 pages=
) for device md1
Mar 18 09:02:20 zaphkiel kernel: [   32.078506] md1: bitmap initialized=
 from disk: read 1/1 pages, set 0 of 16379 bits
Mar 18 09:02:20 zaphkiel kernel: [   32.146550]  md0: unknown partition=
 table
Mar 18 09:02:20 zaphkiel kernel: [   32.170680] md1: detected capacity =
change from 0 to 2146783232
Mar 18 09:02:20 zaphkiel kernel: [   32.209513] AFTER mdadm -IRs
Mar 18 09:02:20 zaphkiel kernel: [   32.452210]  md1: unknown partition=
 table
Mar 18 09:02:20 zaphkiel kernel: [   32.783780] Adding 2096464k swap on=
 /dev/md1.  Priority:-1 extents:1 across:2096464k=20
Mar 18 09:02:20 zaphkiel kernel: [   34.746669] AFTER mdadm -Asc
Mar 18 09:02:20 zaphkiel kernel: [   36.399439] XFS (md3): Mounting Fil=
esystem
Mar 18 09:02:20 zaphkiel kernel: [   36.943112] EXT4-fs (md0): mounting=
 ext2 file system using the ext4 subsystem
Mar 18 09:02:20 zaphkiel kernel: [   37.014070] XFS (md3): Ending clean=
 mount
Mar 18 09:02:20 zaphkiel kernel: [   37.257681] EXT4-fs (md0): mounted =
filesystem without journal. Opts: acl,user_xattr

Thanks,
Pete
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
