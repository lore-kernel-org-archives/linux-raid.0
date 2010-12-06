From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 01/27] FIX: wait_backup() sometimes hangs
Date: Mon, 06 Dec 2010 14:20:53 +0100
Message-ID: <20101206132053.21125.10643.stgit@gklab-170-024.igk.intel.com>
References: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

mdadm cannot be compiled - just reminder

Sometimes wait_backup() omits transition from reshape to idle state and mdadm seams to be hung.
Add 1 sec. timeout for waiting on select.
This allows for wait_backup exit when reshape is ended.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 99807b4..ecaeb39 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2065,6 +2065,10 @@ static int wait_backup(struct mdinfo *sra,
 	}
 	while (completed < offset + blocks) {
 		char action[20];
+		struct timeval t;
+
+		t.tv_sec = 1;
+		t.tv_usec = 0;
 		fd_set rfds;
 		FD_ZERO(&rfds);
 		FD_SET(fd, &rfds);

