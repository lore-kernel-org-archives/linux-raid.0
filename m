From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/4] Remove freeze() call from Grow_continue()
Date: Mon, 03 Oct 2011 18:14:01 +0200
Message-ID: <20111003161401.18410.23483.stgit@gklab-128-013.igk.intel.com>
References: <20111003160839.18410.33275.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111003160839.18410.33275.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Grow_continue() for external metadata should be executed on blocked
from monitoring array(s)/container.
Additional call to freeze() is not necessary in such case.
It produces meaningless error message only.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index ae0d112..0b58d5e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3807,7 +3807,6 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
 	if (st->ss->external) {
 		fmt_devname(buf, st->container_dev);
 		container = buf;
-		freeze(st);
 
 		if (!mdmon_running(st->container_dev))
 			start_mdmon(st->container_dev);

