From: Jes.Sorensen@redhat.com
Subject: [PATCH 07/11] Add missing return in case of trying to grow sub-array
Date: Mon, 31 Oct 2011 15:02:35 +0100
Message-ID: <1320069759-13361-8-git-send-email-Jes.Sorensen@redhat.com>
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
 Grow.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 05350dd..4ac24a1 100644
--- a/Grow.c
+++ b/Grow.c
@@ -134,6 +134,7 @@ int Grow_Add_device(char *devname, int fd, char *newdev)
 		fprintf(stderr, Name ": Cannot grow linear sub-arrays yet\n");
 		free(subarray);
 		free(st);
+		return 1;
 	}
 
 	nfd = open(newdev, O_RDWR|O_EXCL|O_DIRECT);
-- 
1.7.6.4

