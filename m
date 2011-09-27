From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 8/8] Manual update for --continue option
Date: Tue, 27 Sep 2011 14:05:39 +0200
Message-ID: <20110927120539.4890.87894.stgit@gklab-128-013.igk.intel.com>
References: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110927115845.4890.49289.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Patch adds to mdadm man the following information:

 --continue
   This option is complementary pair to assembly --freeze-reshape option.
   It is needed when --grow operation is interrupted and it is not restarted
   automatically due to --freeze-reshape usage during array assembly.
   Option --continue has to be used together with -G , ( --grow ) command
   and device that it should be executed on.  All parameters required for
   reshape continuation will be read from array metadata.  If initial
   --grow command had required --backup-file= option to be set,
   continuation option will require to  have  exactly the same backup
   file pointed to also.

   Any other parameter passed together with --continue option will be ignored.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm.8.in |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 3e2f99e..6b0af55 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -734,6 +734,33 @@ The file must be stored on a separate device, not on the RAID array
 being reshaped.
 
 .TP
+.BR \-\-continue
+This option is complementary pair to assembly
+.B \-\-freeze-reshape
+option. It is needed when
+.B \-\-grow
+operation is interrupted and it is not restarted automatically due to
+.B \-\-freeze-reshape
+usage during array assembly. Option
+.BR \-\-continue
+has to be used together with
+.BR \-G
+, (
+.BR \-\-grow
+) command and device that it should be executed on.
+All parameters required for reshape continuation will be read from array metadata.
+If initial
+.BR \-\-grow
+command had required
+.BR \-\-backup\-file=
+option to be set, continuation option will require to have exactly the same
+backup file pointed to also.
+.IP
+Any other parameter passed together with
+.BR \-\-continue
+option will be ignored.
+
+.TP
 .BR \-N ", " \-\-name=
 Set a
 .B name

