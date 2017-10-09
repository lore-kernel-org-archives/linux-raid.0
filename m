From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] bcache: mark expected switch fall-throughs in STRTO_H
Date: Mon, 9 Oct 2017 16:54:25 -0500
Message-ID: <20171009215425.GA21563@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-raid.ids

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: linux-bcache@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/md/bcache/util.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index 176d3c2..da9194b 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -32,20 +32,27 @@ int bch_ ## name ## _h(const char *cp, type *res)		\
 	case 'y':						\
 	case 'z':						\
 		u++;						\
+		/* fall through */				\
 	case 'e':						\
 		u++;						\
+		/* fall through */				\
 	case 'p':						\
 		u++;						\
+		/* fall through */				\
 	case 't':						\
 		u++;						\
+		/* fall through */				\
 	case 'g':						\
 		u++;						\
+		/* fall through */				\
 	case 'm':						\
 		u++;						\
+		/* fall through */				\
 	case 'k':						\
 		u++;						\
 		if (e++ == cp)					\
 			return -EINVAL;				\
+		/* fall through */				\
 	case '\n':						\
 	case '\0':						\
 		if (*e == '\n')					\
-- 
2.7.4
