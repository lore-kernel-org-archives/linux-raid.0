From: Jes.Sorensen@redhat.com
Subject: [PATCH 04/12] get_component_size(): Check read() return value for error before using it
Date: Wed,  2 Nov 2011 15:42:09 +0100
Message-ID: <1320244937-9739-5-git-send-email-Jes.Sorensen@redhat.com>
References: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sysfs.c b/sysfs.c
index 10e1597..d501792 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -387,7 +387,7 @@ unsigned long long get_component_size(int fd)
 		return 0;
 	n = read(fd, fname, sizeof(fname));
 	close(fd);
-	if (n == sizeof(fname))
+	if (n < 0 || n == sizeof(fname))
 		return 0;
 	fname[n] = 0;
 	return strtoull(fname, NULL, 10) * 2;
-- 
1.7.6.4

