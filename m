From: Jes.Sorensen@redhat.com
Subject: [PATCH 03/12] mdstat_read(): Check return value of dup() before using file descriptor
Date: Wed,  2 Nov 2011 15:42:08 +0100
Message-ID: <1320244937-9739-4-git-send-email-Jes.Sorensen@redhat.com>
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
 mdstat.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/mdstat.c b/mdstat.c
index abf6bf9..6ead24c 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -131,10 +131,15 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 	FILE *f;
 	struct mdstat_ent *all, *rv, **end, **insert_here;
 	char *line;
+	int fd;
 
 	if (hold && mdstat_fd != -1) {
 		lseek(mdstat_fd, 0L, 0);
-		f = fdopen(dup(mdstat_fd), "r");
+		fd = dup(mdstat_fd);
+		if (fd >= 0)
+			f = fdopen(fd, "r");
+		else
+			return NULL;
 	} else
 		f = fopen("/proc/mdstat", "r");
 	if (f == NULL)
-- 
1.7.6.4

