From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 5/8] FIX: Cannot load container information
Date: Wed, 12 Jan 2011 14:55:03 +0100
Message-ID: <20110112135503.15045.97311.stgit@gklab-128-013.igk.intel.com>
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

When container is passed to grow_reshape(), load_container() function has to be used to
get all required information from metadata. In such case subarray variable is not set.
This means that currently used condition is wrong.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index c2e84f3..519fbc2 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1356,7 +1356,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		fmt_devname(container_buf, container_dev);
 		container = container_buf;
 
-		if (subarray)
+		if (!subarray)
 			rv = st->ss->load_container(st, cfd, NULL);
 		else
 			rv = st->ss->load_super(st, cfd, NULL);

