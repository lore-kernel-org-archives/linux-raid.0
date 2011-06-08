From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 16/21] FIX: Move buffer to next location
Date: Wed, 08 Jun 2011 18:11:42 +0200
Message-ID: <20110608161142.24327.63214.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When no output file is given save_stripes() should collect amount of stripes
in passed buffer. Currently all stripes are saved in the same area in passed
buffer. This causes that last stripe is returned on buffer begin only.
Increase buffer (buf) pointer when save_stripes() is about switch to next
stripe operation. This allows for proper buffer filling as input parameter
length directs.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---

 restripe.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/restripe.c b/restripe.c
index 1c42b60..79c695d 100644
--- a/restripe.c
+++ b/restripe.c
@@ -652,10 +652,14 @@ int save_stripes(int *source, unsigned long long *offsets,
 						  fdisk[0], fdisk[1], bufs);
 			}
 		}
-		if (dest)
+		if (dest) {
 			for (i = 0; i < nwrites; i++)
 				if (write(dest[i], buf, len) != len)
 					return -1;
+		} else {
+			/* build next stripe in buffer */
+			buf += len;
+		}
 		length -= len;
 		start += len;
 	}

