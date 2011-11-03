From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/2] FIX: Do not continue container reshape when mdmon is
	absent
Date: Thu, 03 Nov 2011 17:55:41 +0100
Message-ID: <20111103165541.8864.66189.stgit@gklab-128-013.igk.intel.com>
References: <20111103165532.8864.80753.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111103165532.8864.80753.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When mdmon is absent metadata is not updated, and container_reshape()
can fall in to endless loop. This can cause user data corruption.

In case when mdmon is absent do not continue container reshape process.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index e7fd7c4..184a973 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2562,6 +2562,12 @@ int reshape_container(char *container, char *devname,
 		restart = 0;
 		if (rv)
 			break;
+		rv = !mdmon_running(devname2devnum(container));
+		if (rv) {
+			printf(Name ": Mdmon is not found. "
+			       "Cannot continue container reshape.\n");
+			break;
+		}
 	}
 	if (!rv)
 		unfreeze(st);

