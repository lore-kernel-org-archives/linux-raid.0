From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/1] mdmon: Add missing option documentation to --help output
Date: Thu, 25 Apr 2013 17:24:36 +0200
Message-ID: <1366903476-30039-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1366903476-30039-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1366903476-30039-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Document that -a is equivalent to --all, as well as --foreground / -F

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 mdmon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mdmon.c b/mdmon.c
index fd136e5..23cd7e2 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -271,7 +271,8 @@ void usage(void)
 "\n"
 "Options are:\n"
 "  --help        -h   : This message\n"
-"  --all              : All devices\n"
+"  --all         -a   : All devices\n"
+"  --foreground  -F   : Run in foreground (do not fork)\n"
 "  --takeover    -t   : Takeover container\n"
 );
 	exit(2);
-- 
1.8.1.4

