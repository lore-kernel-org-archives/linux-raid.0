From: Michael Davidson <md@google.com>
Subject: [PATCH 1/7] Makefile, LLVM: add -no-integrated-as to KBUILD_[AC]FLAGS
Date: Thu, 16 Mar 2017 17:15:14 -0700
Message-ID: <20170317001520.85223-2-md@google.com>
References: <20170317001520.85223-1-md@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20170317001520.85223-1-md@google.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Michal Marek <mmarek@suse.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Shaohua Li <shli@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Matthias Kaehlcke <mka@chromium.org>, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org, Michael Davidson <md@google.com>
List-Id: linux-raid.ids

Add -no-integrated-as to KBUILD_AFLAGS and KBUILD_CFLAGS
for clang.

Signed-off-by: Michael Davidson <md@google.com>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index b841fb36beb2..b21fd0ca2946 100644
--- a/Makefile
+++ b/Makefile
@@ -704,6 +704,8 @@ KBUILD_CFLAGS += $(call cc-disable-warning, tautological-compare)
 # See modpost pattern 2
 KBUILD_CFLAGS += $(call cc-option, -mno-global-merge,)
 KBUILD_CFLAGS += $(call cc-option, -fcatch-undefined-behavior)
+KBUILD_CFLAGS += $(call cc-option, -no-integrated-as)
+KBUILD_AFLAGS += $(call cc-option, -no-integrated-as)
 else
 
 # These warnings generated too much noise in a regular build.
-- 
2.12.0.367.g23dc2f6d3c-goog
