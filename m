From: Jes.Sorensen@redhat.com
Subject: [PATCH 10/11] Write_rules(): Avoid stack corruption if using extremely long udev pathname
Date: Mon, 31 Oct 2011 15:02:38 +0100
Message-ID: <1320069759-13361-11-git-send-email-Jes.Sorensen@redhat.com>
References: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 policy.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/policy.c b/policy.c
index 1114286..cd260c6 100644
--- a/policy.c
+++ b/policy.c
@@ -883,7 +883,8 @@ int Write_rules(char *rule_name)
        char udev_rule_file[PATH_MAX];
 
        if (rule_name) {
-	       strcpy(udev_rule_file, rule_name);
+	       strncpy(udev_rule_file, rule_name, sizeof(udev_rule_file) - 6);
+	       udev_rule_file[sizeof(udev_rule_file) - 6] = '\0';
 	       strcat(udev_rule_file, ".temp");
                fd = creat(udev_rule_file,
                           S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
-- 
1.7.6.4

