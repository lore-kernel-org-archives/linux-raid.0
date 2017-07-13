From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] md/raid6: use faster multiplication for ARM NEON delta syndrome
Date: Thu, 13 Jul 2017 18:16:00 +0100
Message-ID: <20170713171601.25440-2-ard.biesheuvel@linaro.org>
References: <20170713171601.25440-1-ard.biesheuvel@linaro.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170713171601.25440-1-ard.biesheuvel@linaro.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, linux-raid@vger.kernel.org
Cc: shli@kernel.org, stockhausen@collogia.de, linux@armlinux.org.uk, will.deacon@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-raid.ids

The P/Q left side optimization in the delta syndrome simply involves
repeatedly multiplying a value by polynomial 'x' in GF(2^8). Given
that 'x * x * x * x' equals 'x^4' even in the polynomial world, we
can accelerate this substantially by performing up to 4 such operations
at once, using the NEON instructions for polynomial multiplication.

Results on a Cortex-A57 running in 64-bit mode:

  Before:
  -------
  raid6: neonx1   xor()  1680 MB/s
  raid6: neonx2   xor()  2286 MB/s
  raid6: neonx4   xor()  3162 MB/s
  raid6: neonx8   xor()  3389 MB/s

  After:
  ------
  raid6: neonx1   xor()  2281 MB/s
  raid6: neonx2   xor()  3362 MB/s
  raid6: neonx4   xor()  3787 MB/s
  raid6: neonx8   xor()  4239 MB/s

While we're at it, simplify MASK() by using a signed shift rather than
a vector compare involving a temp register.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 lib/raid6/neon.uc | 33 ++++++++++++++++++--
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/lib/raid6/neon.uc b/lib/raid6/neon.uc
index 4fa51b761dd0..d5242f544551 100644
--- a/lib/raid6/neon.uc
+++ b/lib/raid6/neon.uc
@@ -46,8 +46,12 @@ static inline unative_t SHLBYTE(unative_t v)
  */
 static inline unative_t MASK(unative_t v)
 {
-	const uint8x16_t temp = NBYTES(0);
-	return (unative_t)vcltq_s8((int8x16_t)v, (int8x16_t)temp);
+	return (unative_t)vshrq_n_s8((int8x16_t)v, 7);
+}
+
+static inline unative_t PMUL(unative_t v, unative_t u)
+{
+	return (unative_t)vmulq_p8((poly8x16_t)v, (poly8x16_t)u);
 }
 
 void raid6_neon$#_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
@@ -110,7 +114,30 @@ void raid6_neon$#_xor_syndrome_real(int disks, int start, int stop,
 			wq$$ = veorq_u8(w1$$, wd$$);
 		}
 		/* P/Q left side optimization */
-		for ( z = start-1 ; z >= 0 ; z-- ) {
+		for ( z = start-1 ; z >= 3 ; z -= 4 ) {
+			w2$$ = vshrq_n_u8(wq$$, 4);
+			w1$$ = vshlq_n_u8(wq$$, 4);
+
+			w2$$ = PMUL(w2$$, x1d);
+			wq$$ = veorq_u8(w1$$, w2$$);
+		}
+
+		switch (z) {
+		case 2:
+			w2$$ = vshrq_n_u8(wq$$, 5);
+			w1$$ = vshlq_n_u8(wq$$, 3);
+
+			w2$$ = PMUL(w2$$, x1d);
+			wq$$ = veorq_u8(w1$$, w2$$);
+			break;
+		case 1:
+			w2$$ = vshrq_n_u8(wq$$, 6);
+			w1$$ = vshlq_n_u8(wq$$, 2);
+
+			w2$$ = PMUL(w2$$, x1d);
+			wq$$ = veorq_u8(w1$$, w2$$);
+			break;
+		case 0:
 			w2$$ = MASK(wq$$);
 			w1$$ = SHLBYTE(wq$$);
 
-- 
2.9.3

