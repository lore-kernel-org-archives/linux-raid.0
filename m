From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/1] mdmon: Document that -a is equivalent to --all in --help output
Date: Wed, 24 Apr 2013 17:00:16 +0200
Message-ID: <1366815616-28045-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1366815616-28045-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1366815616-28045-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 mdmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdmon.c b/mdmon.c
index fd136e5..6e8ec34 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -271,7 +271,7 @@ void usage(void)
 "\n"
 "Options are:\n"
 "  --help        -h   : This message\n"
-"  --all              : All devices\n"
+"  --all         -a   : All devices\n"
 "  --takeover    -t   : Takeover container\n"
 );
 	exit(2);
-- 
1.8.1.4

