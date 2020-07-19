From: Zhao Heming <heming.zhao@suse.com>
Subject: [PATCH v4 0/2] md_cluster: bugs fix
Date: Sun, 19 Jul 2020 19:08:38 +0800
Message-ID: <1595156920-31427-1-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Zhao Heming <heming.zhao@suse.com>, neilb@suse.com, jes@trained-monkey.org
List-Id: linux-raid.ids

v4:
- add new patch 'fix rmmod issue when md_cluster convert bitmap to none'
- add cover leter
- modify both patches comments.

v3:
- add restoring path for error case
- modify comments

v2:
- change setting path from location_store to md_setup_cluster
- add restoring path

v1:
- create: fix safemode_delay value when converting to clustered bitmap

Zhao Heming (2):
  md-cluster: fix safemode_delay value when converting to clustered
    bitmap
  md-cluster: fix rmmod issue when md_cluster convert bitmap to none

 drivers/md/md.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
2.25.0
