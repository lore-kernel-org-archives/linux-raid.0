From: Steven Dake <sdake@mvista.com>
Subject: PDC 20276 RAID support in 2.4.18
Date: Fri, 26 Jul 2002 04:13:25 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D412ED5.7000209@mvista.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020703060200060208030108"
Return-path: <linux-raid-owner@vger.kernel.org>
To: arjanv@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020703060200060208030108
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Arjan and others,

I have added support for the PDC 20276 used on Gigabyte GA-8IHXP (and 
possibly other motherboards) to the ATARAID feature of the linux 2.4.18 
kernel.  I have tested that the pdcraid.c code works with this device.

I suspect you can drive this patch into the mainline kernel, but if you 
know of a better person, please advise.

Thanks!
-steve

--------------020703060200060208030108
Content-Type: text/plain;
 name="linux-pdc20276.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-pdc20276.patch"

Binary files linux/arch/i386/boot/vmlinuz-pdc and linux-pdc20276/arch/i386/boot/vmlinuz-pdc differ
diff -uNr linux/drivers/ide/ide-pci.c linux-pdc20276/drivers/ide/ide-pci.c
--- linux/drivers/ide/ide-pci.c	Thu Oct 25 20:53:47 2001
+++ linux-pdc20276/drivers/ide/ide-pci.c	Wed Jul 24 18:20:02 2002
@@ -47,6 +47,7 @@
 #define DEVID_PDC20267	((ide_pci_devid_t){PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20267})
 #define DEVID_PDC20268  ((ide_pci_devid_t){PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20268})
 #define DEVID_PDC20268R ((ide_pci_devid_t){PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20268R})
+#define DEVID_PDC20276	((ide_pci_devid_t){PCI_VENDOR_ID_PROMISE, PCI_DEVICE_ID_PROMISE_20276})
 #define DEVID_RZ1000	((ide_pci_devid_t){PCI_VENDOR_ID_PCTECH,  PCI_DEVICE_ID_PCTECH_RZ1000})
 #define DEVID_RZ1001	((ide_pci_devid_t){PCI_VENDOR_ID_PCTECH,  PCI_DEVICE_ID_PCTECH_RZ1001})
 #define DEVID_SAMURAI	((ide_pci_devid_t){PCI_VENDOR_ID_PCTECH,  PCI_DEVICE_ID_PCTECH_SAMURAI_IDE})
@@ -406,6 +407,7 @@
 	   prevent Linux detecting it and using our own raid code. We want to detect
 	   it for the ataraid drivers, so we have to list both here.. */
 	{DEVID_PDC20268R,"PDC20268",	PCI_PDC202XX,	ATA66_PDC202XX,	INIT_PDC202XX,	NULL,		{{0x00,0x00,0x00}, {0x00,0x00,0x00}},	OFF_BOARD,	16 },
+	{DEVID_PDC20276,"PDC20276",	PCI_PDC202XX,	ATA66_PDC202XX,	INIT_PDC202XX,	NULL,		{{0x00,0x00,0x00}, {0x00,0x00,0x00}},	OFF_BOARD,	16 },
 	{DEVID_RZ1000,	"RZ1000",	NULL,		NULL,		INIT_RZ1000,	NULL,		{{0x00,0x00,0x00}, {0x00,0x00,0x00}}, 	ON_BOARD,	0 },
 	{DEVID_RZ1001,	"RZ1001",	NULL,		NULL,		INIT_RZ1000,	NULL,		{{0x00,0x00,0x00}, {0x00,0x00,0x00}}, 	ON_BOARD,	0 },
 	{DEVID_SAMURAI,	"SAMURAI",	NULL,		NULL,		INIT_SAMURAI,	NULL,		{{0x00,0x00,0x00}, {0x00,0x00,0x00}},	ON_BOARD,	0 },
diff -uNr linux/include/linux/pci_ids.h linux-pdc20276/include/linux/pci_ids.h
--- linux/include/linux/pci_ids.h	Mon Feb 25 19:38:13 2002
+++ linux-pdc20276/include/linux/pci_ids.h	Wed Jul 24 18:17:36 2002
@@ -606,6 +606,7 @@
 #define PCI_DEVICE_ID_PROMISE_20268R	0x6268
 #define PCI_DEVICE_ID_PROMISE_20269	0x4d69
 #define PCI_DEVICE_ID_PROMISE_20275	0x1275
+#define PCI_DEVICE_ID_PROMISE_20276	0x5275
 #define PCI_DEVICE_ID_PROMISE_5300	0x5300
 
 #define PCI_VENDOR_ID_N9		0x105d

--------------020703060200060208030108--

