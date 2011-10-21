From: Jes.Sorensen@redhat.com
Subject: [PATCH 3/3] Hold the map lock while performing Assemble to avoid races with udev
Date: Fri, 21 Oct 2011 15:33:20 +0200
Message-ID: <1319204000-6661-4-git-send-email-Jes.Sorensen@redhat.com>
References: <1319204000-6661-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319204000-6661-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, lukasz.dorau@intel.com, adam.kwolek@intel.com, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 mdadm.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index ebf1c46..56de7b7 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1279,6 +1279,7 @@ int main(int argc, char *argv[])
 		} else {
 			struct mddev_ident *a, *array_list =  conf_get_ident(NULL);
 			struct mddev_dev *devlist = conf_get_devs();
+			struct map_ent *map = NULL;
 			int cnt = 0;
 			int failures, successes;
 			if (devlist == NULL) {
@@ -1298,6 +1299,10 @@ int main(int argc, char *argv[])
 				if (a->autof == 0)
 					a->autof = autof;
 			}
+			if (map_lock(&map))
+				fprintf(stderr, Name " %s: failed to get "
+					"exclusive lock on mapfile\n",
+					__func__);
 			do {
 				failures = 0;
 				successes = 0;
@@ -1364,6 +1369,7 @@ int main(int argc, char *argv[])
 				fprintf(stderr, Name ": No arrays found in config file\n");
 				rv = 1;
 			}
+			map_unlock(&map);
 		}
 		break;
 	case BUILD:
-- 
1.7.4.4

