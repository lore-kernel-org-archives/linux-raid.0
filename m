From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 8/9] util: allow regular files through test_partition()
Date: Thu, 25 Aug 2011 19:14:40 -0700
Message-ID: <20110826021440.28015.6602.stgit@localhost6.localdomain6>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

When using the --dump capability the resulting files cannot be read
unless test_partition allows regular files.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/util.c b/util.c
index ce03239..5d573bc 100644
--- a/util.c
+++ b/util.c
@@ -279,6 +279,12 @@ int test_partition(int fd)
 	 */
 	struct blkpg_ioctl_arg a;
 	struct blkpg_partition p;
+	struct stat st;
+
+	/* ignore regular files */
+	if (fstat(fd, &st) != -1 && S_ISREG(st.st_mode))
+		return 0;
+
 	a.op = BLKPG_DEL_PARTITION;
 	a.data = (void*)&p;
 	a.datalen = sizeof(p);

