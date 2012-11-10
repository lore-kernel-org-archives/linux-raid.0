From: Gilles Espinasse <g.esp@free.fr>
Subject: [PATCH] Keep track on which kernel the test suite has run
Date: Sat, 10 Nov 2012 10:14:43 +0100
Message-ID: <1352538883-24288-1-git-send-email-g.esp@free.fr>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
Cc: Gilles Espinasse <g.esp@free.fr>
List-Id: linux-raid.ids

Signed-off-by: Gilles Espinasse <g.esp@free.fr>
---
 test |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/test b/test
index 3f8515f..352c1e1 100755
--- a/test
+++ b/test
@@ -21,6 +21,8 @@ logdir="$testdir/logs"
 logsave=0
 exitonerror=1
 
+echo "Testing on linux-$(uname -r) kernel"
+
 # Check whether to run multipath tests
 modprobe multipath 2> /dev/null
 if grep -s 'Personalities : .*multipath' > /dev/null /proc/mdstat ; then
-- 
1.7.2.5

