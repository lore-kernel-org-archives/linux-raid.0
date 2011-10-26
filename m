From: Jes.Sorensen@redhat.com
Subject: [PATCH 12/13] Handle malloc() failure in mdstat.c
Date: Wed, 26 Oct 2011 17:30:25 +0200
Message-ID: <1319643026-11501-13-git-send-email-Jes.Sorensen@redhat.com>
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
 mdstat.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/mdstat.c b/mdstat.c
index abf6bf9..346a1e8 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -104,6 +104,11 @@ static int add_member_devname(struct dev_member **m, char *name)
 		return 0;
 
 	new = malloc(sizeof(*new));
+	if (!new) {
+		fprintf(stderr, Name ": %s unable to allocate memory\n",
+			__func__);
+		return 0;
+	}
 	new->name = strndup(name, t - name);
 	new->next = *m;
 	*m = new;
-- 
1.7.6.4

