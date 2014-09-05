From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] Create.c: Try few more times to stop array after failed
 creation
Date: Fri, 05 Sep 2014 16:26:13 +0200
Message-ID: <20140905142612.10761.82358.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Sometimes after failure in creation (exp. due to duplicate devices
in create command) newly created empty md array will not be stopped
due to openers>1 (create_mddev will not manage to drop lock).
In this case ioctl() will return error - this needs to be checked
and if occurs - sending STOP_ARRAY should be repeat after delay
to make sure that mddev is stopped correctly.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 Create.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Create.c b/Create.c
index 330c5b4..7c8e53e 100644
--- a/Create.c
+++ b/Create.c
@@ -904,7 +904,12 @@ int Create(struct supertype *st, char *mddev,
 				if (st->ss->add_to_super(st, &inf->disk,
 							 fd, dv->devname,
 							 dv->data_offset)) {
-					ioctl(mdfd, STOP_ARRAY, NULL);
+					int count = 5;
+					while (count &&
+					       (ioctl(mdfd, STOP_ARRAY, NULL) < 0)) {
+						usleep(100000);
+						count--;
+					}
 					goto abort_locked;
 				}
 				st->ss->getinfo_super(st, inf, NULL);

