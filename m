From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/4] FIX: Handle has to be closed
Date: Tue, 15 Mar 2011 14:48:40 +0100
Message-ID: <20110315134840.32643.75551.stgit@gklab-128-013.igk.intel.com>
References: <20110315134000.32643.1818.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110315134000.32643.1818.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Handle has to be closed similar to Manage.c:880

One rule should apply to handlers passed to add_to_super().

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Manage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Manage.c b/Manage.c
index f208d15..0349aa3 100644
--- a/Manage.c
+++ b/Manage.c
@@ -813,6 +813,7 @@ int Manage_subdevs(char *devname, int fd,
 					close(dfd);
 					return 1;
 				}
+				close(dfd);
 			} else if (dv->re_add) {
 				/*  this had better be raid1.
 				 * As we are "--re-add"ing we must find a spare slot

