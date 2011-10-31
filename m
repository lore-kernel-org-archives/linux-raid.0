From: Jes.Sorensen@redhat.com
Subject: [PATCH 09/11] policy_add(): Add missing va_end()
Date: Mon, 31 Oct 2011 15:02:37 +0100
Message-ID: <1320069759-13361-10-git-send-email-Jes.Sorensen@redhat.com>
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
 policy.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/policy.c b/policy.c
index 7959c97..1114286 100644
--- a/policy.c
+++ b/policy.c
@@ -510,6 +510,7 @@ void policy_add(char *type, ...)
 	}
 	pr->next = config_rules;
 	config_rules = pr;
+	va_end(ap);
 }
 
 void policy_free(void)
-- 
1.7.6.4

