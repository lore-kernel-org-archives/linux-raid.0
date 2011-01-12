From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 8/8] FIX: reload metadata for container operation
Date: Wed, 12 Jan 2011 14:55:26 +0100
Message-ID: <20110112135526.15045.99010.stgit@gklab-128-013.igk.intel.com>
References: <20110112132954.15045.41564.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112132954.15045.41564.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When reshape is started metadata tells mdadm that reshape is active via reshape_active variable.
When reshape is finished mdmon updates metadata to end reshape in metadata for current array.
We have reload metadata to get this flag updated and switch to next array (if exists)
for container reshape case. This is indicated by forked flag. Function has to returned
to caller with reloaded metadata information /up to date/.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 519fbc2..3455115 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2021,8 +2021,25 @@ static int reshape_array(char *container, int fd, char *devname,
 					"to %s\n", devname, c);
 		}
 	out:
-		if (forked)
+		if (forked) {
+			if (!rv) {
+				if (container)
+					ping_monitor(container);
+				if (st->ss->external) {
+					/* Re-load the metadata as much
+				 * could have changed
+				 */
+					int cfd = open_dev(st->container_dev);
+					if (cfd >= 0) {
+						st->ss->free_super(st);
+						st->ss->load_container(st, cfd,
+								     container);
+						close(cfd);
+					}
+				}
+			}
 			return 0;
+		}
 		exit(0);
 	case -1:
 		fprintf(stderr, Name ": Cannot run child to monitor reshape: %s\n",

