From: Xiao Ni <xni@redhat.com>
Subject: [PATCH 1/1] Remove the legacy whitespace
Date: Tue, 11 Feb 2020 21:44:15 +0800
Message-ID: <1581428655-12316-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: ptoscano@redhat.com, ncroxon@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The whitespace between Environment= and the true value causes confusion.
To avoid confusing other people in future, remove the whitespace to keep
it a simple, unambiguous syntax

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 systemd/mdcheck_continue.service  | 2 +-
 systemd/mdcheck_start.service     | 2 +-
 systemd/mdmonitor-oneshot.service | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/systemd/mdcheck_continue.service b/systemd/mdcheck_continue.service
index aa02dde..854317f 100644
--- a/systemd/mdcheck_continue.service
+++ b/systemd/mdcheck_continue.service
@@ -11,7 +11,7 @@ ConditionPathExistsGlob = /var/lib/mdcheck/MD_UUID_*
 
 [Service]
 Type=oneshot
-Environment= "MDADM_CHECK_DURATION=6 hours"
+Environment="MDADM_CHECK_DURATION=6 hours"
 EnvironmentFile=-/run/sysconfig/mdadm
 ExecStartPre=-/usr/lib/mdadm/mdadm_env.sh
 ExecStart=/usr/share/mdadm/mdcheck --continue --duration ${MDADM_CHECK_DURATION}
diff --git a/systemd/mdcheck_start.service b/systemd/mdcheck_start.service
index da62d5f..3bb3d13 100644
--- a/systemd/mdcheck_start.service
+++ b/systemd/mdcheck_start.service
@@ -11,7 +11,7 @@ Wants=mdcheck_continue.timer
 
 [Service]
 Type=oneshot
-Environment= "MDADM_CHECK_DURATION=6 hours"
+Environment="MDADM_CHECK_DURATION=6 hours"
 EnvironmentFile=-/run/sysconfig/mdadm
 ExecStartPre=-/usr/lib/mdadm/mdadm_env.sh
 ExecStart=/usr/share/mdadm/mdcheck --duration ${MDADM_CHECK_DURATION}
diff --git a/systemd/mdmonitor-oneshot.service b/systemd/mdmonitor-oneshot.service
index fd469b1..373955a 100644
--- a/systemd/mdmonitor-oneshot.service
+++ b/systemd/mdmonitor-oneshot.service
@@ -9,7 +9,7 @@
 Description=Reminder for degraded MD arrays
 
 [Service]
-Environment=  MDADM_MONITOR_ARGS=--scan
+Environment=MDADM_MONITOR_ARGS=--scan
 EnvironmentFile=-/run/sysconfig/mdadm
 ExecStartPre=-/usr/lib/mdadm/mdadm_env.sh
 ExecStart=BINDIR/mdadm --monitor --oneshot $MDADM_MONITOR_ARGS
-- 
2.7.5
