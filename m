From: maxin.john@gmail.com
Subject: [PATCH 3/3] monitor.c: Fix build in x32 ABI
Date: Fri, 21 Jul 2017 16:26:00 +0300
Message-ID: <1500643560-21322-3-git-send-email-maxin.john@gmail.com>
References: <1500643560-21322-1-git-send-email-maxin.john@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1500643560-21322-1-git-send-email-maxin.john@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: =?UTF-8?q?An=C3=ADbal=20Lim=C3=B3n?= <anibal.limon@linux.intel.com>, "Maxin B. John" <maxin.john@intel.com>
List-Id: linux-raid.ids

From: Aníbal Limón <anibal.limon@linux.intel.com>

When we try to print time_t values as a long int it causes an error
because time_t data type in x32 ABI is long long int.

Signed-off-by: Maxin B. John <maxin.john@intel.com>
---
 monitor.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/monitor.c b/monitor.c
index 81537ed..7cd9b8a 100644
--- a/monitor.c
+++ b/monitor.c
@@ -447,7 +447,11 @@ static int read_and_act(struct active_array *a, fd_set *fds)
 	}
 
 	gettimeofday(&tv, NULL);
+#if defined(__x86_64__) && defined(__ILP32__)
+	dprintf("(%d): %lld.%06lld state:%s prev:%s action:%s prev: %s start:%llu\n",
+#else
 	dprintf("(%d): %ld.%06ld state:%s prev:%s action:%s prev: %s start:%llu\n",
+#endif
 		a->info.container_member,
 		tv.tv_sec, tv.tv_usec,
 		array_states[a->curr_state],
-- 
2.4.0

