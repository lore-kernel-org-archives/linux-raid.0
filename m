From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH] mdcheck: Log when done
Date: Wed, 13 May 2020 15:16:46 +0200
Message-ID: <20200513131646.16357-1-pmenzel@molgen.mpg.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@gmail.com>
Cc: Donald Buczek <buczek@molgen.mpg.de>, linux-raid@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>
List-Id: linux-raid.ids

From: Donald Buczek <buczek@molgen.mpg.de>

Currently mdcheck (when called with `--duration`) logs only the
beginning of the check, the pausing and the continuation but not the
completion.

So, log the completion, too, so that it can be determined how long the
raid check took.

    2020-05-08T18:00:02+02:00 deadpool root: mdcheck start checking /dev/md0
    2020-05-08T18:00:02+02:00 deadpool root: mdcheck start checking /dev/md1
    2020-05-09T15:32:04+02:00 deadpool root: mdcheck finished checking /dev/md1
    2020-05-09T17:38:04+02:00 deadpool root: mdcheck finished checking /dev/md0

Cc: linux-raid@vger.kernel.org
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 misc/mdcheck | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/misc/mdcheck b/misc/mdcheck
index 42d4094..700c3e2 100644
--- a/misc/mdcheck
+++ b/misc/mdcheck
@@ -125,11 +125,13 @@ do
 	do
 		eval fl=\$MD_${i}_fl
 		eval sys=\$MD_${i}_sys
+		eval dev=\$MD_${i}_dev
 
 		if [ -z "$fl" ]; then continue; fi
 
 		if [ "`cat $sys/md/sync_action`" != 'check' ]
 		then
+			logger -p daemon.info mdcheck finished checking $dev
 			eval MD_${i}_fl=
 			rm -f $fl
 			continue;
-- 
2.26.2
