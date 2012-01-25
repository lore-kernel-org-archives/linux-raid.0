From: Jes.Sorensen@redhat.com
Subject: [PATCH 3/4] Add --offroot argument to mdmon
Date: Wed, 25 Jan 2012 16:18:03 +0100
Message-ID: <1327504684-9219-4-git-send-email-Jes.Sorensen@redhat.com>
References: <1327504684-9219-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1327504684-9219-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 mdmon.8 |   12 +++++++++++-
 mdmon.c |    8 ++++++++
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/mdmon.8 b/mdmon.8
index 8c1ce5f..a9178b6 100644
--- a/mdmon.8
+++ b/mdmon.8
@@ -5,7 +5,7 @@ mdmon \- monitor MD external metadata arrays
 
 .SH SYNOPSIS
 
-.BI mdmon " [--all] [--takeover] CONTAINER"
+.BI mdmon " [--all] [--takeover] [--offroot] CONTAINER"
 
 .SH OVERVIEW
 The 2.6.27 kernel brings the ability to support external metadata arrays.
@@ -165,6 +165,16 @@ argument is over-written with the name of the container.  To allow for
 containers with names longer than 5 characters, this argument can be
 arbitrarily extended, e.g. to
 .BR \-\-all-active-arrays .
+.TP
+.BR \-\-offroot
+Set first character of argv[0] to @ to indicate mdmon was launched
+from initrd/initramfs and should not be shutdown by systemd as part of
+the regular shutdown process. This option is normally only used by
+the system's initscripts. Please see here for more details on how
+systemd handled argv[0]:
+.IP
+.B http://www.freedesktop.org/wiki/Software/systemd/RootStorageDaemons
+.PP
 
 .PP
 Note that
diff --git a/mdmon.c b/mdmon.c
index a65c4a4..2093476 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -272,6 +272,10 @@ void usage(void)
 "  --help        -h   : This message\n"
 "  --all              : All devices\n"
 "  --takeover    -t   : Takeover container\n"
+"  --offroot          : Set first character of argv[0] to @ to indicate the\n"
+"                       application was launched from initrd/initramfs and\n"
+"                       should not be shutdown by systemd as part of the\n"
+"                       regular shutdown process.\n"
 );
 	exit(2);
 }
@@ -291,6 +295,7 @@ int main(int argc, char *argv[])
 		{"all", 0, NULL, 'a'},
 		{"takeover", 0, NULL, 't'},
 		{"help", 0, NULL, 'h'},
+		{"offroot", 0, NULL, OffRootOpt},
 		{NULL, 0, NULL, 0}
 	};
 
@@ -304,6 +309,9 @@ int main(int argc, char *argv[])
 			container_name = optarg;
 			takeover = 1;
 			break;
+		case OffRootOpt:
+			argv[0][0] = '@';
+			break;
 		case 'h':
 		default:
 			usage();
-- 
1.7.8.3

