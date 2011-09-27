From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 7/8] Manual update for --continue option
Date: Tue, 27 Sep 2011 14:05:30 +0200
Message-ID: <20110927120530.4890.87835.stgit@gklab-128-013.igk.intel.com>
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

--freeze-reshape
  Option  is  intended  to  be used in start-up scripts during initrd boot
  phase.  When array under reshape is assembled during initrd phase,
  this option stops reshape after reshape critical section is being
  restored. This happens before file system pivot operation and avoids lost
  of file system context.  Loosing file system context would cause
  reshape to be broken.

  Reshape can be continued later using -continue option for grow command.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm.8.in |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 039f3d4..3e2f99e 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1096,6 +1096,19 @@ option can be used when an array has an internal bitmap which is
 corrupt in some way so that assembling the array normally fails.  It
 will cause any internal bitmap to be ignored.
 
+.TP
+.BR \-\-freeze\-reshape
+Option is intended to be used in start-up scripts during initrd boot phase.
+When array under reshape is assembled during initrd phase, this option
+stops reshape after reshape critical section is being restored. This happens
+before file system pivot operation and avoids lost of file system context.
+Loosing file system context would cause reshape to be broken.
+
+Reshape can be continued later using
+.B\-\-continue
+option for grow command.
+
+
 .SH For Manage mode:
 
 .TP

