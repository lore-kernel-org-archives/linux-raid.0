From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/3] systemd .service files for launching mdmon via systemctl
Date: Mon, 21 Jan 2013 14:22:57 +0100
Message-ID: <1358774578-2183-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1358774578-2183-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1358774578-2183-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 systemd/mdmon-offroot@.service | 19 +++++++++++++++++++
 systemd/mdmon@.service         | 13 +++++++++++++
 2 files changed, 32 insertions(+)
 create mode 100644 systemd/mdmon-offroot@.service
 create mode 100644 systemd/mdmon@.service

diff --git a/systemd/mdmon-offroot@.service b/systemd/mdmon-offroot@.service
new file mode 100644
index 0000000..77bb04b
--- /dev/null
+++ b/systemd/mdmon-offroot@.service
@@ -0,0 +1,19 @@
+#  This file is part of mdadm.
+#
+#  mdadm is free software; you can redistribute it and/or modify it
+#  under the terms of the GNU General Public License as published by
+#  the Free Software Foundation; either version 2 of the License, or
+#  (at your option) any later version.
+
+[Unit]
+Description=MD Metadata Monitor on /dev/%I
+DefaultDependencies=no
+Before=initrd-switch-root.target
+ConditionPathExists=/etc/initrd-release
+
+[Service]
+ExecStart=/usr/sbin/mdmon --offroot %I
+StandardInput=null
+StandardOutput=null
+StandardError=null
+KillMode=none
diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
new file mode 100644
index 0000000..49d04ec
--- /dev/null
+++ b/systemd/mdmon@.service
@@ -0,0 +1,13 @@
+#  This file is part of mdadm.
+#
+#  mdadm is free software; you can redistribute it and/or modify it
+#  under the terms of the GNU General Public License as published by
+#  the Free Software Foundation; either version 2 of the License, or
+#  (at your option) any later version.
+
+[Unit]
+Description=MD Metadata Monitor on /dev/%I
+DefaultDependencies=no
+
+[Service]
+ExecStart=/usr/sbin/mdmon %I
-- 
1.7.11.7

