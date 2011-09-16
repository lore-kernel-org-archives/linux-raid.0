From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 14/14] Manual update for --continue option
Date: Fri, 16 Sep 2011 13:55:34 +0200
Message-ID: <20110916115533.5201.217.stgit@gklab-128-013.igk.intel.com>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

Patch adds to mdadm man the following information:

--continue
  This  is  needed when --grow operation is interrupted and it is not
  restarted automatically during array assembly or array cannot
  be disassembled and assembled again. Option --continue has to be used
  together with -G , ( --grow ) command and device that it should be
  executed on.  All parameters required for reshape continuation will
  be read from array metadata.   If  initial  --grow  command  had
  required --backup-file= option to be set, continuation option will
  require to have exactly the same backup file pointed to also.

  Any other parameter passed together with --continue option will
  be ignored.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm.8.in |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index e22fde4..e677be4 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -733,6 +733,30 @@ The file must be stored on a separate device, not on the RAID array
 being reshaped.
 
 .TP
+.BR \-\-continue
+This is needed when
+.B \-\-grow
+operation is interrupted and it is not restarted automatically during array
+assembly or array cannot be disassembled and assembled again. Option
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

