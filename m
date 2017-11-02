From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] imsm: fix reading scsi serial
Date: Thu,  2 Nov 2017 16:10:57 +0100
Message-ID: <20171102151057.3398-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, neilb@suse.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Improve error detection after SG_IO ioctl. Checking only the return
value and response length is insufficient and leads to anomalies if a
drive does not have a serial number.

Reported-by: NeilBrown <neilb@suse.com>
Tested-by: NeilBrown <neilb@suse.com>
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
Mailing list discussion: https://marc.info/?l=linux-raid&m=150950864700415&w=2

 sg_io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sg_io.c b/sg_io.c
index 42c91e1e..7889a95e 100644
--- a/sg_io.c
+++ b/sg_io.c
@@ -46,6 +46,9 @@ int scsi_get_serial(int fd, void *buf, size_t buf_len)
 	if (rv)
 		return rv;
 
+	if ((io_hdr.info & SG_INFO_OK_MASK) != SG_INFO_OK)
+		return -1;
+
 	rsp_len = rsp_buf[3];
 
 	if (!rsp_len || buf_len < rsp_len)
-- 
2.14.2

