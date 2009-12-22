From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 03/13] imsm: fix spare promotion
Date: Tue, 22 Dec 2009 16:59:34 -0700
Message-ID: <20091222235934.31628.11493.stgit@dwillia2-linux.ch.intel.com>
References: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

When associating a spare take on the target's metadata version number to
satisfy future compare_super checks.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 super-intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 4372ab4..39a2985 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1566,6 +1566,7 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst)
 		first->anchor->num_raid_devs = sec->anchor->num_raid_devs;
 		first->anchor->orig_family_num = sec->anchor->orig_family_num;
 		first->anchor->family_num = sec->anchor->family_num;
+		memcpy(first->anchor->sig, sec->anchor->sig, MAX_SIGNATURE_LENGTH);
 		for (i = 0; i < sec->anchor->num_raid_devs; i++)
 			imsm_copy_dev(get_imsm_dev(first, i), get_imsm_dev(sec, i));
 	}

