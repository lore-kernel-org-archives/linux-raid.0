From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/3] async_tx: expand async raid6 test to cover ioatdma corner
	case
Date: Tue, 22 Dec 2009 17:26:01 -0700
Message-ID: <20091223002600.32335.55048.stgit@dwillia2-linux.ch.intel.com>
References: <20091223002518.32335.27768.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755625AbZLWA1z@vger.kernel.org>
In-Reply-To: <20091223002518.32335.27768.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: maciej.sosnowski@intel.com, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Add explicit 11 and 12 disks cases to exercise the 0 < src_cnt % 8 < 3
corner case in the ioatdma driver.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 crypto/async_tx/raid6test.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index 3ec27c7..f84f6b4 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -214,6 +214,13 @@ static int raid6_test(void)
 		err += test(4, &tests);
 	if (NDISKS > 5)
 		err += test(5, &tests);
+	/* the 11 and 12 disk cases are special for ioatdma (p-disabled
+	 * q-continuation without extended descriptor)
+	 */
+	if (NDISKS > 12) {
+		err += test(11, &tests);
+		err += test(12, &tests);
+	}
 	err += test(NDISKS, &tests);
 
 	pr("\n");
