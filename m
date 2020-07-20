From: Zhao Heming <heming.zhao@suse.com>
Subject: [PATCH v5 0/2] md_cluster: bugs fix
Date: Tue, 21 Jul 2020 02:08:51 +0800
Message-ID: <1595268533-7040-1-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Zhao Heming <heming.zhao@suse.com>, neilb@suse.com, song@kernel.org
List-Id: linux-raid.ids

v5:
- change safemode_delay patch code by neil's comments.
- modify safemode_delay patch comments:
  - remove useless analysis
  - limit line in 75 chars
- add neil's reviewd info in rmmod patch.

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

 drivers/md/md.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

-- 
2.25.0
