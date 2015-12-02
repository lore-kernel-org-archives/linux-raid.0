From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 12/17] invoke hot-add policy on "change" events
Date: Tue, 1 Dec 2015 16:25:28 -0800
Message-ID: <1449015933-255689-13-git-send-email-songliubraving@fb.com>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, Dan Williams <djbw@fb.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

From: Dan Williams <djbw@fb.com>

For enclosure managed disks the links identifying the enclosure topology
may not be available until after a change event.  Modify the dynamic
udev rules to run on change events emitted on enclosure attach.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/policy.c b/policy.c
index 0558351..177544a 100644
--- a/policy.c
+++ b/policy.c
@@ -841,12 +841,12 @@ static struct rule *find_path_rule(struct rule *rule)
 }
 
 #define UDEV_RULE_FORMAT \
-"ACTION==\"add\", SUBSYSTEM==\"block\", " \
+"ACTION==\"add|change\", SUBSYSTEM==\"block\", " \
 "ENV{DEVTYPE}==\"%s\", ENV{%s}==\"%s\", " \
 "RUN+=\"" BINDIR "/mdadm --incremental $env{DEVNAME}\"\n"
 
 #define UDEV_RULE_FORMAT_NOTYPE \
-"ACTION==\"add\", SUBSYSTEM==\"block\", " \
+"ACTION==\"add|change\", SUBSYSTEM==\"block\", " \
 "ENV{%s}==\"%s\", " \
 "RUN+=\"" BINDIR "/mdadm --incremental $env{DEVNAME}\"\n"
 
-- 
2.4.6

