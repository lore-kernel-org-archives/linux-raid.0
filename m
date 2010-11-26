From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 03/53] Manage: allow manual control of external raid0 readonly
	flag
Date: Fri, 26 Nov 2010 09:04:15 +0100
Message-ID: <20101126080415.5221.12682.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

mdadm --readwrite <subarray> will clear the external readonly flag ('-'
to '/'), but only for redudant arrays.  Allow raid0 arrays as well so
the user has a simple helper to control this flag.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 Manage.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Manage.c b/Manage.c
index 6e9d4a0..ac9415b 100644
--- a/Manage.c
+++ b/Manage.c
@@ -56,7 +56,6 @@ int Manage_ro(char *devname, int fd, int readonly)
 	mdi = sysfs_read(fd, -1, GET_LEVEL|GET_VERSION);
 	if (mdi &&
 	    mdi->array.major_version == -1 &&
-	    mdi->array.level > 0 &&
 	    is_subarray(mdi->text_version)) {
 		char vers[64];
 		strcpy(vers, "external:");

