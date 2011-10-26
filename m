From: Jes.Sorensen@redhat.com
Subject: [PATCH 05/13] Handle malloc() failure in Examine.c
Date: Wed, 26 Oct 2011 17:30:18 +0200
Message-ID: <1319643026-11501-6-git-send-email-Jes.Sorensen@redhat.com>
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
 Examine.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Examine.c b/Examine.c
index 5d71e53..74b5f80 100644
--- a/Examine.c
+++ b/Examine.c
@@ -131,6 +131,11 @@ int Examine(struct mddev_dev *devlist, int brief, int export, int scan,
 			}
 			if (!ap) {
 				ap = malloc(sizeof(*ap));
+				if (!ap) {
+					fprintf(stderr, Name ": %s unable to "
+						"allocate memory\n", __func__);
+					return -ENOMEM;
+				}
 				ap->devs = dl_head();
 				ap->next = arrays;
 				ap->spares = 0;
-- 
1.7.6.4

