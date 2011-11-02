From: Jes.Sorensen@redhat.com
Subject: [PATCH 08/12] ahci_enumerate_ports(): Don't close fd that failed to open
Date: Wed,  2 Nov 2011 15:42:13 +0100
Message-ID: <1320244937-9739-9-git-send-email-Jes.Sorensen@redhat.com>
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
 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0193fe7..b583b35 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1572,8 +1572,8 @@ static int ahci_enumerate_ports(const char *hba_path, int port_count, int host_b
 				printf(" (%.*s)\n", MAX_RAID_SERIAL_LEN, buf);
 			else
 				printf(" ()\n");
+			close(fd);
 		}
-		close(fd);
 		free(path);
 		path = NULL;
 	}
-- 
1.7.6.4

