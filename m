From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/4] Add --preboot argument to mdadm
Date: Mon, 23 Jan 2012 12:18:23 +0100
Message-ID: <1327317505-14782-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1327317505-14782-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1327317505-14782-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

When --preboot is parsed, mdadm will change the first character of
argv[0] to '@'. This is used to signal to systemd that mdadm was
launched from initramfs and should not be shut down before returning
to the initramfs.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 ReadMe.c   |    5 +++++
 mdadm.8.in |   12 ++++++++++++
 mdadm.c    |    9 +++++++++
 mdadm.h    |    1 +
 4 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/ReadMe.c b/ReadMe.c
index 9aa798b..10d6d44 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -111,6 +111,7 @@ struct option long_options[] = {
     {"kill-subarray", 1, 0, KillSubarray},
     {"update-subarray", 1, 0, UpdateSubarray},
     {"udev-rules", 2, 0, UdevRules},
+    {"preboot", 0, 0, PreBootOpt},
 
     /* synonyms */
     {"monitor",   0, 0, 'F'},
@@ -268,6 +269,10 @@ char OptionHelp[] =
 "  --query       -Q   : Display general information about how a\n"
 "                       device relates to the md driver\n"
 "  --auto-detect      : Start arrays auto-detected by the kernel\n"
+"  --preboot          : Set first character of argv[0] to @ to indicate the\n"
+"                       application was launched from initrd/initramfs and\n"
+"                       should not be shutdown by systemd as part of the\n"
+"                       regular shutdown process.\n"
 ;
 /*
 "\n"
diff --git a/mdadm.8.in b/mdadm.8.in
index 27be110..cb92ed6 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -255,6 +255,18 @@ Avoid printing purely informative messages.  With this,
 will be silent unless there is something really important to report.
 
 .TP
+.BR \-\-preboot
+Set first character of argv[0] to @ to indicate mdadm was launched
+from initrd/initramfs and should not be shutdown by systemd as part of
+the regular shutdown process. This option is normally only used by
+the system's initscripts. Please see here for more details on how
+systemd handled argv[0]:
+.IP
+.B http://www.freedesktop.org/wiki/Software/systemd/RootStorageDaemons
+.PP
+
+
+.TP
 .BR \-f ", " \-\-force
 Be more forceful about certain operations.  See the various modes for
 the exact meaning of this option in different contexts.
diff --git a/mdadm.c b/mdadm.c
index f07fac2..6c38064 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -174,6 +174,15 @@ int main(int argc, char *argv[])
 				homehost = optarg;
 			continue;
 
+		/*
+		 * --preboot sets first char of argv[0] to @. This is used
+		 * by systemd to signal that the tast was launched from
+		 * initrd/initramfs and should be preserved during shutdown
+		 */
+		case PreBootOpt:
+			argv[0][0] = '@';
+			continue;
+
 		case ':':
 		case '?':
 			fputs(Usage, stderr);
diff --git a/mdadm.h b/mdadm.h
index 381ef86..10b420f 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -321,6 +321,7 @@ enum special_options {
 	UdevRules,
 	FreezeReshape,
 	Continue,
+	PreBootOpt,
 };
 
 /* structures read from config file */
-- 
1.7.8.3

