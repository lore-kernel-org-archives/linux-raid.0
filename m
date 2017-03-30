From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH v1] mdadm/grow: reshape would be stuck from raid1 to raid5
Date: Thu, 30 Mar 2017 15:38:08 +0800
Message-ID: <20170330073808.6176-1-zlliu@suse.com>
References: <wrfjk27aid6n.fsf@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjk27aid6n.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

systemctl doesn't interpret mdadm-grow-continue@.service
correctly due to the wrong argument provided in [service],
it should be corrected %I as %i. Otherwise, if the service
cannot start by systemctl and the reshap progress would be
stuck all time when grows array from raid1 to raid5.

reproduce steps:
./mdadm -CR /dev/md0 -l1 -b internal -n2 /dev/loop[0-1]
./mdadm --grow /dev/md0 -l5 -n3 -a /dev/loop2

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 systemd/mdadm-grow-continue@.service | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/systemd/mdadm-grow-continue@.service b/systemd/mdadm-grow-continue@.service
index 5c667d2..882bc0b 100644
--- a/systemd/mdadm-grow-continue@.service
+++ b/systemd/mdadm-grow-continue@.service
@@ -10,7 +10,7 @@ Description=Manage MD Reshape on /dev/%I
 DefaultDependencies=no
 
 [Service]
-ExecStart=BINDIR/mdadm --grow --continue /dev/%I
+ExecStart=BINDIR/mdadm --grow --continue /dev/%i
 StandardInput=null
 StandardOutput=null
 StandardError=null
-- 
2.10.2

