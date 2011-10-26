From: Jes.Sorensen@redhat.com
Subject: [PATCH 11/13] Handle malloc() failure in mdopen.c
Date: Wed, 26 Oct 2011 17:30:24 +0200
Message-ID: <1319643026-11501-12-git-send-email-Jes.Sorensen@redhat.com>
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
 mdopen.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mdopen.c b/mdopen.c
index 555ab84..1a795aa 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -65,6 +65,12 @@ void make_parts(char *dev, int cnt)
 	} else
 		   return;
 	name = malloc(nlen);
+	if (!name) {
+		fprintf(stderr, Name ": %s unable to allocate memory\n",
+			__func__);
+		return;
+	}
+
 	for (i=1; i <= cnt ; i++) {
 		struct stat stb2;
 		snprintf(name, nlen, "%s%s%d", dev, dig?"p":"", i);
-- 
1.7.6.4

