From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 05/13] util: fix devnum2devname for devnum == 0
Date: Tue, 22 Dec 2009 16:59:45 -0700
Message-ID: <20091222235945.31628.1713.stgit@dwillia2-linux.ch.intel.com>
References: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

devnum 0 is md0 no md_d-1

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/util.c b/util.c
index a0e4bcf..d49a4ed 100644
--- a/util.c
+++ b/util.c
@@ -1210,7 +1210,7 @@ int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info)
 char *devnum2devname(int num)
 {
 	char name[100];
-	if (num > 0)
+	if (num >= 0)
 		sprintf(name, "md%d", num);
 	else
 		sprintf(name, "md_d%d", -1-num);

