From: Jes.Sorensen@redhat.com
Subject: [PATCH 04/19] sysfs_unique_holder(): Check read() return value before using as buffer index
Date: Tue,  1 Nov 2011 16:09:20 +0100
Message-ID: <1320160175-18976-5-git-send-email-Jes.Sorensen@redhat.com>
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
 sysfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sysfs.c b/sysfs.c
index 05f0118..10e1597 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -804,6 +804,8 @@ int sysfs_unique_holder(int devnum, long rdev)
 		}
 		n = read(fd, buf, sizeof(buf)-1);
 		close(fd);
+		if (n < 0)
+			continue;
 		buf[n] = 0;
 		if (sscanf(buf, "%d:%d%c", &mj, &mn, &c) != 3 ||
 		    c != '\n') {
-- 
1.7.6.4

