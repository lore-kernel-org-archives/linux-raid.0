Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C54257D
	for <linux-raid@vger.kernel.org>; Wed, 19 Mar 2025 17:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742404271; cv=none; b=cp2SvaV0Xh2+P4D2casAkt9iGVoxDLFB6SwXy6JQ/2trqwp0JKC4l9WkwYs31W2TI7hLSdQWVCx9WWnUH8JNhVKs5g0vd9YuXSG/b5twyoHjpXYcaPABUukIrAHdJdfl3h0E3OC55rlr3iipZ1uQv2FCR0tzzgWYbuKAd0JJDrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742404271; c=relaxed/simple;
	bh=sDRvsgWCkzPZiy3mglRrCWuo9FDmTPox8NF1WQ75DSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcasL+f7EhTNCQQC7cdcK0xIkFb4m7jP4C3NfBTvsDcPERH6PhQgjAf/LmgwGLHsbU4P7mnOJ0oDA4KxNPtA4ZrEwxVzi/v7TS1L7M7Q6c8lDesB1vMN8pJaa4WezrYJKo69tSH2D1K+0vHZXi5HLmhPL43Mxmw8996qOhV16BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bN5aMuju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bN5aMuju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23062C4CEE8;
	Wed, 19 Mar 2025 17:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742404269;
	bh=sDRvsgWCkzPZiy3mglRrCWuo9FDmTPox8NF1WQ75DSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bN5aMuju+h9xzhbXb/jUcwb5T+wQTbL5qkoDujb4YFRZjpGAS8E3fHDGjuMCGabuz
	 oIQsmpu11GUa22ktf1XdL5TFbOchIpWy24tO/VRS5vg+xg6nh8cVOfjhQycuMJs9/1
	 QVas6tqnMdrJT7qei4CJYfopSjZGecqkGYezrlruhIzOYVElrfIEj9Su7S9GYvveYT
	 zdrYt8MERsC865TnbQ8gRu+iDa1Cz1XmmRQZaK1Kr05mItvjoKKxlPw3QJOerm304k
	 6MscccCNulIeUCPWLpz2BitHTf1T5B5/OCKEZ/A23o9bQQODjyrY6V5tYxLFmLiXj+
	 xmKBGlcvyMG6g==
From: mtkaczyk@kernel.org
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mtkaczyk@kernel.org>,
	Xiao Ni <xni@redhat.com>,
	Nigel Croxon <ncroxon@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@kernel.org>
Subject: [PATCH v0 2/3] mdadm: include asm/byteorder.h
Date: Wed, 19 Mar 2025 18:10:57 +0100
Message-ID: <20250319171058.20052-3-mtkaczyk@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250319171058.20052-1-mtkaczyk@kernel.org>
References: <20250319171058.20052-1-mtkaczyk@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mariusz Tkaczyk <mtkaczyk@kernel.org>

It will be included by raid/md_p.h anyway. Include it directly and
remove custom functions. It is not a problem now.

Signed-off-by: Mariusz Tkaczyk <mtkaczyk@kernel.org>
---
 mdadm.h | 55 +------------------------------------------------------
 1 file changed, 1 insertion(+), 54 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 0b86e4849d33..d2c2a4dac11b 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -34,6 +34,7 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #endif
 
 #include	<assert.h>
+#include	<asm/byteorder.h>
 #include	<sys/types.h>
 #include	<sys/stat.h>
 #include	<stdarg.h>
@@ -85,7 +86,6 @@ struct dlm_lksb {
 #endif
 
 #include	<linux/kdev_t.h>
-/*#include	<linux/fs.h> */
 #include	<sys/mount.h>
 #include	<asm/types.h>
 #include	<sys/ioctl.h>
@@ -169,59 +169,6 @@ struct dlm_lksb {
 #include	"msg.h"
 #include	"mdadm_status.h"
 
-#include <endian.h>
-/* Redhat don't like to #include <asm/byteorder.h>, and
- * some time include <linux/byteorder/xxx_endian.h> isn't enough,
- * and there is no standard conversion function so... */
-/* And dietlibc doesn't think byteswap is ok, so.. */
-/*  #include <byteswap.h> */
-#define __mdadm_bswap_16(x) (((x) & 0x00ffU) << 8 | \
-			     ((x) & 0xff00U) >> 8)
-#define __mdadm_bswap_32(x) (((x) & 0x000000ffU) << 24 | \
-			     ((x) & 0xff000000U) >> 24 | \
-			     ((x) & 0x0000ff00U) << 8  | \
-			     ((x) & 0x00ff0000U) >> 8)
-#define __mdadm_bswap_64(x) (((x) & 0x00000000000000ffULL) << 56 | \
-			     ((x) & 0xff00000000000000ULL) >> 56 | \
-			     ((x) & 0x000000000000ff00ULL) << 40 | \
-			     ((x) & 0x00ff000000000000ULL) >> 40 | \
-			     ((x) & 0x0000000000ff0000ULL) << 24 | \
-			     ((x) & 0x0000ff0000000000ULL) >> 24 | \
-			     ((x) & 0x00000000ff000000ULL) << 8 |  \
-			     ((x) & 0x000000ff00000000ULL) >> 8)
-
-#if BYTE_ORDER == LITTLE_ENDIAN
-#define	__cpu_to_le16(_x) (unsigned int)(_x)
-#define __cpu_to_le32(_x) (unsigned int)(_x)
-#define __cpu_to_le64(_x) (unsigned long long)(_x)
-#define	__le16_to_cpu(_x) (unsigned int)(_x)
-#define __le32_to_cpu(_x) (unsigned int)(_x)
-#define __le64_to_cpu(_x) (unsigned long long)(_x)
-
-#define	__cpu_to_be16(_x) __mdadm_bswap_16(_x)
-#define __cpu_to_be32(_x) __mdadm_bswap_32(_x)
-#define __cpu_to_be64(_x) __mdadm_bswap_64(_x)
-#define	__be16_to_cpu(_x) __mdadm_bswap_16(_x)
-#define __be32_to_cpu(_x) __mdadm_bswap_32(_x)
-#define __be64_to_cpu(_x) __mdadm_bswap_64(_x)
-#elif BYTE_ORDER == BIG_ENDIAN
-#define	__cpu_to_le16(_x) __mdadm_bswap_16(_x)
-#define __cpu_to_le32(_x) __mdadm_bswap_32(_x)
-#define __cpu_to_le64(_x) __mdadm_bswap_64(_x)
-#define	__le16_to_cpu(_x) __mdadm_bswap_16(_x)
-#define __le32_to_cpu(_x) __mdadm_bswap_32(_x)
-#define __le64_to_cpu(_x) __mdadm_bswap_64(_x)
-
-#define	__cpu_to_be16(_x) (unsigned int)(_x)
-#define __cpu_to_be32(_x) (unsigned int)(_x)
-#define __cpu_to_be64(_x) (unsigned long long)(_x)
-#define	__be16_to_cpu(_x) (unsigned int)(_x)
-#define __be32_to_cpu(_x) (unsigned int)(_x)
-#define __be64_to_cpu(_x) (unsigned long long)(_x)
-#else
-#  error "unknown endianness."
-#endif
-
 /*
  * Partially stolen from include/linux/unaligned/packed_struct.h
  */
-- 
2.43.0

