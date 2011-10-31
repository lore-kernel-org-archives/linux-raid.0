From: Jes.Sorensen@redhat.com
Subject: [PATCH 03/11] Fix memory leak
Date: Mon, 31 Oct 2011 15:02:31 +0100
Message-ID: <1320069759-13361-4-git-send-email-Jes.Sorensen@redhat.com>
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
 Detail.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Detail.c b/Detail.c
index ca34abe..c564786 100644
--- a/Detail.c
+++ b/Detail.c
@@ -587,6 +587,7 @@ This is pretty boring
 out:
 	close(fd);
 	free(subarray);
+	sysfs_free(sra);
 	return rv;
 }
 
-- 
1.7.6.4

