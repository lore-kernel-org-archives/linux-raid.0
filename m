From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 338/542] raid6/test: fix a compilation warning
Date: Fri, 14 Feb 2020 10:45:30 -0500
Message-ID: <20200214154854.6746-338-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Zhengyuan Liu <liuzhengyuan@kylinos.cn>, Song Liu <songliubraving@fb.com>, Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>

[ Upstream commit 5e5ac01c2b8802921fee680518a986011cb59820 ]

The compilation warning is redefination showed as following:

        In file included from tables.c:2:
        ../../../include/linux/export.h:180: warning: "EXPORT_SYMBOL" redefined
         #define EXPORT_SYMBOL(sym)  __EXPORT_SYMBOL(sym, "")

        In file included from tables.c:1:
        ../../../include/linux/raid/pq.h:61: note: this is the location of the previous definition
         #define EXPORT_SYMBOL(sym)

Fixes: 69a94abb82ee ("export.h, genksyms: do not make genksyms calculate CRC of trimmed symbols")
Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/raid/pq.h | 2 ++
 lib/raid6/mktables.c    | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 0b6e7ad9cd2a8..e0ddb47f44020 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -58,7 +58,9 @@ extern const char raid6_empty_zero_page[PAGE_SIZE];
 #define enable_kernel_altivec()
 #define disable_kernel_altivec()
 
+#undef	EXPORT_SYMBOL
 #define EXPORT_SYMBOL(sym)
+#undef	EXPORT_SYMBOL_GPL
 #define EXPORT_SYMBOL_GPL(sym)
 #define MODULE_LICENSE(licence)
 #define MODULE_DESCRIPTION(desc)
diff --git a/lib/raid6/mktables.c b/lib/raid6/mktables.c
index 9c485df1308fb..f02e10fa62381 100644
--- a/lib/raid6/mktables.c
+++ b/lib/raid6/mktables.c
@@ -56,8 +56,8 @@ int main(int argc, char *argv[])
 	uint8_t v;
 	uint8_t exptbl[256], invtbl[256];
 
-	printf("#include <linux/raid/pq.h>\n");
 	printf("#include <linux/export.h>\n");
+	printf("#include <linux/raid/pq.h>\n");
 
 	/* Compute multiplication table */
 	printf("\nconst u8  __attribute__((aligned(256)))\n"
-- 
2.20.1
