From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 38/56] md: add mddev->pers to avoid potential NULL pointer dereference
Date: Sat,  1 Jun 2019 09:25:42 -0400
Message-ID: <20190601132600.27427-38-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yufen Yu <yuyufen@huawei.com>, Xiao Ni <xni@redhat.com>, NeilBrown <neilb@suse.com>, Song Liu <songliubraving@fb.com>, Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Yufen Yu <yuyufen@huawei.com>

[ Upstream commit ee37e62191a59d253fc916b9fc763deb777211e2 ]

When doing re-add, we need to ensure rdev->mddev->pers is not NULL,
which can avoid potential NULL pointer derefence in fallowing
add_bound_rdev().

Fixes: a6da4ef85cef ("md: re-add a failed disk")
Cc: Xiao Ni <xni@redhat.com>
Cc: NeilBrown <neilb@suse.com>
Cc: <stable@vger.kernel.org> # 4.4+
Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 07f307402351b..f71cca28dddac 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2690,8 +2690,10 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			err = 0;
 		}
 	} else if (cmd_match(buf, "re-add")) {
-		if (test_bit(Faulty, &rdev->flags) && (rdev->raid_disk == -1) &&
-			rdev->saved_raid_disk >= 0) {
+		if (!rdev->mddev->pers)
+			err = -EINVAL;
+		else if (test_bit(Faulty, &rdev->flags) && (rdev->raid_disk == -1) &&
+				rdev->saved_raid_disk >= 0) {
 			/* clear_bit is performed _after_ all the devices
 			 * have their local Faulty bit cleared. If any writes
 			 * happen in the meantime in the local node, they
-- 
2.20.1
