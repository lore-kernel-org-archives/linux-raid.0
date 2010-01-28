From: Artur Wojcik <artur.wojcik@intel.com>
Subject: [mdadm PATCH] Kill: fix when zeroing busy devices.
Date: Thu, 28 Jan 2010 16:48:44 +0100
Message-ID: <20100128154844.31790.44309.stgit@awojcik-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

mdadm should not wait indefinitely when it trys to reset
superblock on device which is busy (cannot be opened).

Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
---
 Kill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Kill.c b/Kill.c
index 63442a6..a65b865 100644
--- a/Kill.c
+++ b/Kill.c
@@ -46,7 +46,7 @@ int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl)
 			fprintf(stderr, Name ": Couldn't open %s for write - not zeroing\n",
 				dev);
 		close(fd);
-		return 1;
+		return 2;
 	}
 	if (st == NULL)
 		st = guess_super(fd);

