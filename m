From: Jes.Sorensen@redhat.com
Subject: [PATCH 13/13] Catch malloc() failure
Date: Wed, 26 Oct 2011 17:30:26 +0200
Message-ID: <1319643026-11501-14-git-send-email-Jes.Sorensen@redhat.com>
References: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 policy.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/policy.c b/policy.c
index 7959c97..4908ab6 100644
--- a/policy.c
+++ b/policy.c
@@ -47,6 +47,11 @@ static void pol_new(struct dev_policy **pol, char *name, const char *val,
 	const char *real_metadata = NULL;
 	int i;
 
+	if (!n) {
+		fprintf(stderr, Name ": %s unable to allocate memory\n",
+			__func__);
+		return;
+	}
 	n->name = name;
 	n->value = val;
 
-- 
1.7.6.4

