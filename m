From: Jes.Sorensen@redhat.com
Subject: [PATCH 08/11] Avoid memory leak
Date: Mon, 31 Oct 2011 15:02:36 +0100
Message-ID: <1320069759-13361-9-git-send-email-Jes.Sorensen@redhat.com>
References: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

In case of second posix_memalign() failing, release memory allocated
in first posix_memalign() call.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super-intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 3525dae..1caee70 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4200,6 +4200,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 				__func__);
 			free(super->buf);
 			free(super);
+			free(mpb_new);
 			return 0;
 		}
 		memcpy(mpb_new, mpb, size_old);
-- 
1.7.6.4

