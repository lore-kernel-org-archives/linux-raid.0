From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] IMSM-orom: make sure, that device list is supported
Date: Fri, 27 Feb 2015 15:45:50 +0100
Message-ID: <20150227144550.9215.35006.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Devices list in PCI Data Structure is supported only in
3 and above revision. Make sure that this is checked.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 platform-intel.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/platform-intel.c b/platform-intel.c
index 37274da..c6a28e8 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -227,6 +227,8 @@ struct pciExpDataStructFormat {
 	__u16 vendorID;
 	__u16 deviceID;
 	__u16 devListOffset;
+	__u16 pciDataStructLen;
+	__u8 pciDataStructRev;
 } __attribute__ ((packed));
 
 static struct orom_entry oroms[SYS_DEV_MAX];
@@ -323,7 +325,8 @@ static int scan(const void *start, const void *end, const void *data)
 
 	const struct imsm_orom *orom = add_orom(imsm_mem);
 
-	if (ptr->devListOffset) {
+	/* only PciDataStructure with revision 3 and above supports devices list. */
+	if (ptr->pciDataStructRev >= 3 && ptr->devListOffset) {
 		const __u16 *dev_list = (void *)ptr + ptr->devListOffset;
 		int i;
 

