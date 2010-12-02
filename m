From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 10/10] FIX: wait_backup() sometimes hungs
Date: Thu, 02 Dec 2010 09:19:58 +0100
Message-ID: <20101202081958.4639.17010.stgit@gklab-170-024.igk.intel.com>
References: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Sometimes wait_backup() omits transition from reshape to iddle state and mdadm seams to be hung.
Add 1 sec. timeout wor waiting on select. This allows for wait_backup exit when reshape is ended.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 24c5c39..e16b1ad 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2074,10 +2074,14 @@ static int wait_backup(struct mdinfo *sra,
 		sysfs_set_str(sra, NULL, "sync_action", "reshape");
 	do {
 		char action[20];
+		struct timeval t;
+
+		t.tv_sec = 1;
+		t.tv_usec = 0;
 		fd_set rfds;
 		FD_ZERO(&rfds);
 		FD_SET(fd, &rfds);
-		select(fd+1, NULL, NULL, &rfds, NULL);
+		select(fd+1, NULL, NULL, &rfds, &t);
 		if (sysfs_fd_get_ll(fd, &completed) < 0) {
 			close(fd);
 			return -1;

