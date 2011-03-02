From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/9] FIX: Do not configure and start, already started reshape
Date: Wed, 02 Mar 2011 14:29:04 +0100
Message-ID: <20110302132904.24771.65588.stgit@gklab-128-013.igk.intel.com>
References: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When Grow_continue() calls reshape_array(), reshape is configured
and it is started with array. We cannot start reshape again,
when reshape is in progress.
/it in fact waits due to array_state == 'readonly'/

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/Grow.c b/Grow.c
index e321a39..d25b71d 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1641,6 +1641,7 @@ static int reshape_array(char *container, int fd, char *devname,
 	unsigned long long array_size;
 	int done;
 	struct mdinfo *sra = NULL;
+	int already_running;
 
 	msg = analyse_change(info, &reshape);
 	if (msg) {
@@ -1995,10 +1996,15 @@ started:
 		}
 	}
 
-	err = start_reshape(sra, (info->reshape_active && !st->ss->external));
+	already_running = info->reshape_active &&
+		restart ? restart : !st->ss->external;
+	dprintf("Reshape will be %s\n",
+		already_running ? "continued" : "started");
+	err = start_reshape(sra, already_running);
 	if (err) {
-		fprintf(stderr, Name ": Cannot start reshape for %s\n",
-			devname);
+		fprintf(stderr, Name ": Cannot %s reshape for %s\n",
+				already_running ? "continue" : "start",
+				devname);
 		goto release;
 	}
 	if (restart)

