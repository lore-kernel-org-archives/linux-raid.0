From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 19/22] FIX: Enable metadata updates for raid0
Date: Thu, 02 Jun 2011 16:50:49 +0200
Message-ID: <20110602145049.27355.66066.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

When raid0 is takeovered to degraded raid4, metadata updates has to be
applied via mdmon (raid4 has to be monitored).
It is not possible due to no update_tail pointer initialization
in supertype structure.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Grow.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 11b2214..25be587 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1847,6 +1847,9 @@ static int reshape_array(char *container, int fd, char *devname,
 			if (!mdmon_running(st->container_dev))
 				start_mdmon(st->container_dev);
 			ping_monitor(container);
+			if (mdmon_running(st->container_dev) &&
+			    st->update_tail == NULL)
+				st->update_tail = &st->updates;
 		}
 	}
 	/* ->reshape_super might have chosen some spares from the
@@ -2264,6 +2267,8 @@ started:
 					": %s: could not set level "
 					"to %s\n", devname, c);
 		}
+		if (info->new_level == 0)
+			st->update_tail = NULL;
 	}
 out:
 	if (forked)

