From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 04/13] FIX: load anchor to get all information
Date: Mon, 10 Jan 2011 12:27:58 +0100
Message-ID: <20110110112758.10776.44079.stgit@gklab-128-013.igk.intel.com>
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

When reshape_super() puts updated metadata to array, mdadm should reload it,
to get all information that are changed during update operation.
To avoid (follow curent implementation) reload operation mdadm should update metadata 2 times.
One time for mdmon, second for internal mdadm purposes. Both updates has to update whole
array information (not disks only) to know everything about reshape process.
Local/mdadm update ie. for imsm should contain:
- reshape_active field update
- second map update
- migration state update
....
- and most important during disk add metadata anchor should be reallocated
  to make space for new/greater disks number,
  and then metadata contents has to be copied to new area ...

This makes also problem with keeping in sync both those updates, so I'm resending
patches for reloading metadata after update (this one)
and removing anchor modifications in mdadm (next patch)

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 4cbe427..1d0ef12 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2159,6 +2159,7 @@ int reshape_container(char *container, int cfd, char *devname,
 
 		sysfs_free(cc);
 
+		st->ss->load_container(st, cfd, NULL);
 		cc = st->ss->container_content(st, NULL);
 
 		for (content = cc; content ; content = content->next) {

