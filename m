From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 02/12] imsm: kill close() of component device
Date: Tue, 13 Oct 2009 19:10:26 -0700
Message-ID: <20091014021026.31570.69803.stgit@dwillia2-linux.ch.intel.com>
References: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, krzysztof.wojcik@intel.com, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

None of the other formats close the passed in fd at load, and this
becomes a problem when trying to support --update where we need O_EXCL
protection across the entire operation.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-intel.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 9f57a68..80cd6c5 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1685,10 +1685,8 @@ load_imsm_disk(int fd, struct intel_super *super, char *devname, int keep_fd)
 		serialcpy(dl->serial, serial);
 		dl->index = -2;
 		dl->e = NULL;
-	} else if (keep_fd) {
-		close(dl->fd);
+	} else if (keep_fd)
 		dl->fd = fd;
-	}
 
 	/* look up this disk's index in the current anchor */
 	for (i = 0; i < super->anchor->num_disks; i++) {

