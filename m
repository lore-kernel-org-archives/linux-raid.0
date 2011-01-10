From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 07/13] FIX: wrong flags are passed to function
Date: Mon, 10 Jan 2011 12:28:24 +0100
Message-ID: <20110110112823.10776.61675.stgit@gklab-128-013.igk.intel.com>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

flags == 1 are always passed to sysfs_read() due to '||' usage.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 1d0ef12..0efa106 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1788,7 +1788,7 @@ static int reshape_array(char *container, int fd, char *devname,
 	}
 
 	sra = sysfs_read(fd, 0,
-			 GET_COMPONENT|GET_DEVS|GET_OFFSET|GET_STATE||GET_CHUNK|
+			 GET_COMPONENT|GET_DEVS|GET_OFFSET|GET_STATE|GET_CHUNK|
 			 GET_CACHE);
 
 	if (!sra) {

