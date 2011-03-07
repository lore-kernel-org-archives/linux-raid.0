From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH] fix: generated udev rules does not work due to incorrect
 line format
Date: Mon, 7 Mar 2011 09:56:48 +0000
Message-ID: <66C59AD0932712458090B447266D638C010F8DCE0D@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Problem consists of missing =sign in comparison with SUBSYSTEM and
missing new line character at the end of line. As a result incremental
for hot-plugs of bare disks does not work.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 policy.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/policy.c b/policy.c
index afb640f..2a9fe5c 100644
--- a/policy.c
+++ b/policy.c
@@ -786,14 +786,14 @@ char *find_rule(struct rule *rule, char *rule_type)
 }
 
 #define UDEV_RULE_FORMAT \
-"ACTION==\"add\", SUBSYSTEM=\"block\", " \
+"ACTION==\"add\", SUBSYSTEM==\"block\", " \
 "ENV{DEVTYPE}==\"%s\", ENV{ID_PATH}==\"%s\", " \
-"RUN+=\"/sbin/mdadm --incremental $env{DEVNAME}\", "
+"RUN+=\"/sbin/mdadm --incremental $env{DEVNAME}\""
 
 #define UDEV_RULE_FORMAT_NOTYPE \
-"ACTION==\"add\", SUBSYSTEM=\"block\", " \
+"ACTION==\"add\", SUBSYSTEM==\"block\", " \
 "ENV{ID_PATH}==\"%s\", " \
-"RUN+=\"/sbin/mdadm --incremental $env{DEVNAME}\", "
+"RUN+=\"/sbin/mdadm --incremental $env{DEVNAME}\""
 
 /* Write rule in the rule file. Use format from UDEV_RULE_FORMAT */
 int write_rule(struct rule *rule, int fd, int force_part)
@@ -807,9 +807,9 @@ int write_rule(struct rule *rule, int fd, int force_part)
 	if (force_part)
 		typ = type_part;
 	if (typ)
-		snprintf(line, sizeof(line) - 1, UDEV_RULE_FORMAT, typ, pth);
+		snprintf(line, sizeof(line) - 1, UDEV_RULE_FORMAT "\n", typ, pth);
 	else
-		snprintf(line, sizeof(line) - 1, UDEV_RULE_FORMAT_NOTYPE, pth);
+		snprintf(line, sizeof(line) - 1, UDEV_RULE_FORMAT_NOTYPE "\n", pth);
 	return write(fd, line, strlen(line)) == (int)strlen(line);
 }
 
-- 
1.7.1

