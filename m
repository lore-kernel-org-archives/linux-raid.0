From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/2] Avoid use after free
Date: Fri, 28 Oct 2011 21:50:50 +0200
Message-ID: <1319831451-26704-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1319831451-26704-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319831451-26704-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

If picking just one spare disk from the container, jump out of the
loop once freeing the list. Otherwise we end up accessing the list
that we just freed.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 util.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/util.c b/util.c
index 2cf617d..1bbd87f 100644
--- a/util.c
+++ b/util.c
@@ -1766,6 +1766,7 @@ struct mdinfo *container_choose_spares(struct supertype *st,
 			if (get_one) {
 				sysfs_free(*dp);
 				d->next = NULL;
+				goto out;
 			}
 		} else {
 			*dp = d->next;
@@ -1773,5 +1774,6 @@ struct mdinfo *container_choose_spares(struct supertype *st,
 			sysfs_free(d);
 		}
 	}
+out:
 	return disks;
 }
-- 
1.7.6.4

