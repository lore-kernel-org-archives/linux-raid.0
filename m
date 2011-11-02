From: Jes.Sorensen@redhat.com
Subject: [PATCH 01/12] mdadm: add missing break for UpdateSubarray
Date: Wed,  2 Nov 2011 15:42:06 +0100
Message-ID: <1320244937-9739-2-git-send-email-Jes.Sorensen@redhat.com>
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
 mdadm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index 56de7b7..2fe12e7 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -237,6 +237,7 @@ int main(int argc, char *argv[])
 				}
 				subarray = optarg;
 			}
+			break;
 		case UdevRules:
 		case 'K': if (!mode) newmode = MISC; break;
 		case NoSharing: newmode = MONITOR; break;
-- 
1.7.6.4

