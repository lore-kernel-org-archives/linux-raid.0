From: Jes.Sorensen@redhat.com
Subject: [PATCH 13/19] IncrementalScan(): Fix memory leak
Date: Tue,  1 Nov 2011 16:09:29 +0100
Message-ID: <1320160175-18976-14-git-send-email-Jes.Sorensen@redhat.com>
References: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Incremental.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index bc5e9d0..c2c9051 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1329,6 +1329,7 @@ int IncrementalScan(int verbose)
 					strerror(errno));
 				rv = 1;
 			}
+			sysfs_free(sra);
 		}
 	}
 	return rv;
-- 
1.7.6.4

