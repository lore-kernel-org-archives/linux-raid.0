From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 01/16] FIX: Add spares to raid0 in mdadm
Date: Mon, 13 Dec 2010 15:44:56 +0100
Message-ID: <20101213144456.4384.78444.stgit@gklab-170-024.igk.intel.com>
References: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Add accidentally removed code.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---

 Manage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Manage.c b/Manage.c
index f8dcaaf..6562a59 100644
--- a/Manage.c
+++ b/Manage.c
@@ -860,6 +860,7 @@ int Manage_subdevs(char *devname, int fd,
 					sysfs_free(sra);
 					return 1;
 				}
+				ping_monitor(devnum2devname(devnum));
 				sysfs_free(sra);
 				close(container_fd);
 			} else if (ioctl(fd, ADD_NEW_DISK, &disc)) {

