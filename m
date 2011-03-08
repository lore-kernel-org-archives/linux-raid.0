From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 01/14] probe_roms: allow to probe expansion ROMs using
 vendor and device id.
Date: Tue, 8 Mar 2011 15:20:28 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC8A@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From fb619d78b270e0533fa3d2d57ad777f66ded4f41 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Thu, 3 Mar 2011 13:44:37 +0100
Subject: [PATCH 01/14] probe_roms: allow to probe expansion ROMs using vendor and device id.

Adds data offset to PCI expansion ROM Data Structure in resource
describing Expansion ROMs. This allows AHCI OROM scanning function
to identify AHCI OROM by device id 0x2822 and vendor id 0x8086.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 platform-intel.c |   21 +++++++++++++++++++--
 probe_roms.c     |   29 ++++++++++++++++++++++++++---
 probe_roms.h     |    2 +-
 3 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/platform-intel.c b/platform-intel.c
index 3516a1b..0dc90b7 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -166,13 +166,31 @@ static int platform_has_intel_devices(void)
 	return 0;
 }
 
+/*
+ * PCI Expansion ROM Data Structure Format
+ */
+struct pciExpDataStructFormat {
+	__u8  ver[4];
+	__u16 vendorID;
+	__u16 deviceID;
+} __attribute__ ((packed));
+
 static struct imsm_orom imsm_orom;
-static int scan(const void *start, const void *end)
+static int scan(const void *start, const void *end, const void *data)
 {
 	int offset;
 	const struct imsm_orom *imsm_mem;
 	int len = (end - start);
+	struct pciExpDataStructFormat *ptr= (struct pciExpDataStructFormat *)data;
 
+	dprintf("ptr->vendorID: %lx __le16_to_cpu(ptr->deviceID): %lx \n",
+		(ulong) __le16_to_cpu(ptr->vendorID),
+		(ulong) __le16_to_cpu(ptr->deviceID));
+
+	if (!((__le16_to_cpu(ptr->vendorID) == 0x8086) &&
+	      (__le16_to_cpu(ptr->deviceID) == 0x2822)))
+		return 0;
+	
 	for (offset = 0; offset < len; offset += 4) {
 		imsm_mem = start + offset;
 		if (memcmp(imsm_mem->signature, "$VER", 4) == 0) {
@@ -180,7 +198,6 @@ static int scan(const void *start, const void *end)
 			return 1;
 		}
 	}
-
 	return 0;
 }
 
diff --git a/probe_roms.c b/probe_roms.c
index a8e3a58..93c707c 100644
--- a/probe_roms.c
+++ b/probe_roms.c
@@ -20,6 +20,7 @@
  */
 
 #include "probe_roms.h"
+#include "mdadm.h"
 #include <unistd.h>
 #include <signal.h>
 #include <fcntl.h>
@@ -130,50 +131,60 @@ static void *isa_bus_to_virt(unsigned long addr)
 struct resource {
 	unsigned long start;
 	unsigned long end;
-	const char *name;
+	unsigned long data;
+  	const char *name;
 };
 
 static struct resource system_rom_resource = {
 	.name	= "System ROM",
 	.start	= 0xf0000,
+	.data   = 0,
 	.end	= 0xfffff,
 };
 
 static struct resource extension_rom_resource = {
 	.name	= "Extension ROM",
 	.start	= 0xe0000,
+	.data   = 0,
 	.end	= 0xeffff,
 };
 
 static struct resource adapter_rom_resources[] = { {
 	.name 	= "Adapter ROM",
 	.start	= 0xc8000,
+	.data   = 0,
 	.end	= 0,
 }, {
 	.name 	= "Adapter ROM",
 	.start	= 0,
+	.data   = 0,
 	.end	= 0,
 }, {
 	.name 	= "Adapter ROM",
 	.start	= 0,
+	.data   = 0,
 	.end	= 0,
 }, {
 	.name 	= "Adapter ROM",
 	.start	= 0,
+	.data   = 0,
 	.end	= 0,
 }, {
 	.name 	= "Adapter ROM",
 	.start	= 0,
+	.data   = 0,
 	.end	= 0,
 }, {
 	.name 	= "Adapter ROM",
 	.start	= 0,
+	.data   = 0,
 	.end	= 0,
 } };
 
 static struct resource video_rom_resource = {
 	.name 	= "Video ROM",
 	.start	= 0xc0000,
+	.data   = 0,
 	.end	= 0xc7fff,
 };
 
@@ -211,8 +222,9 @@ int scan_adapter_roms(scan_fn fn)
 
 		if (res->start) {
 			found = fn(isa_bus_to_virt(res->start),
-				   isa_bus_to_virt(res->end));
-			if (found)
+				   isa_bus_to_virt(res->end),
+				   isa_bus_to_virt(res->data));
+			if (found) 
 				break;
 		} else
 			break;
@@ -232,6 +244,7 @@ void probe_roms(void)
 	unsigned long start, length, upper;
 	unsigned char c;
 	unsigned int i;
+	__u16 val=0;
 
 	if (rom_fd < 0)
 		return;
@@ -284,11 +297,21 @@ void probe_roms(void)
 		/* 0 < length <= 0x7f * 512, historically */
 		length = c * 512;
 
+		/* Retrieve 16-bit pointer to PCI Data Structure (offset 18h-19h)
+		 * The data can be within 64KB forward of the first location
+		 * of this code image. The pointer is in little-endian order
+		 */
+		
+		if (probe_address16(rom + 0x18, &val) != 0)
+			continue;
+		val = __le16_to_cpu(val);
+
 		/* but accept any length that fits if checksum okay */
 		if (!length || start + length > upper || !romchecksum(rom, length))
 			continue;
 
 		adapter_rom_resources[i].start = start;
+		adapter_rom_resources[i].data = start + (unsigned long) val;
 		adapter_rom_resources[i].end = start + length - 1;
 
 		start = adapter_rom_resources[i++].end & ~(rom_align - 1);
diff --git a/probe_roms.h b/probe_roms.h
index a1e291a..6d70411 100644
--- a/probe_roms.h
+++ b/probe_roms.h
@@ -19,6 +19,6 @@
 
 void probe_roms_exit(void);
 int probe_roms_init(unsigned long align);
-typedef int (*scan_fn)(const void *start, const void *end);
+typedef int (*scan_fn)(const void *start, const void *end, const void *data);
 int scan_adapter_roms(scan_fn fn);
 void probe_roms(void);
-- 
1.6.4.2

