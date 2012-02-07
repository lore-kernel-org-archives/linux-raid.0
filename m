From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 05/12] Fix: Sometimes mdmon throws core dump during reshape
Date: Tue, 07 Feb 2012 15:03:35 +0100
Message-ID: <20120207140335.20627.12131.stgit@gklab-128-013.igk.intel.com>
References: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

Problem was found during reshaping 2 volumes /raid0 and raid5/ in container.
Sometimes mdmon throws core dump due to NULL pointer exception.

Problem occurs in scenario:
- managemon: is about spare activation (degraded raid4 volume == raid0 under takeover)
- managemon: detect level change and signals monitor (manage_member() calls replace_array())
- monitor: detects transition raid4/5->raid0 and sets a->container to NULL
           to indicate array deactivation
- managemon : continues his work and tries to activate spare (a->check_degraded is set).
              NULL pointer is passed to metadata handler activate_spare()
              Core dump is generated.

To resolve this situation managemon (after monitor kick) checks again
a->container pointer to learn if current array is not to be deactivated.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 managemon.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/managemon.c b/managemon.c
index cde0d8b..6c21ecb 100644
--- a/managemon.c
+++ b/managemon.c
@@ -486,6 +486,12 @@ static void manage_member(struct mdstat_ent *mdstat,
 		}
 	}
 
+	/* we are after monitor kick,
+	 * so container field can be cleared - check it again
+	 */
+	if (a->container == NULL)
+		return;
+
 	/* We don't check the array while any update is pending, as it
 	 * might container a change (such as a spare assignment) which
 	 * could affect our decisions.

