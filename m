Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339C654F8C
	for <linux-raid@vger.kernel.org>; Wed, 19 Mar 2025 17:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742404267; cv=none; b=pVPtD+cP1YPjk+zs66BQImBjg6PILU9wRjyJsh1+19OVzk/li3k/55jJ/uTAUvtah/RNHRR0qH8c1HKvvKpFhMJvQZtOriE2MtKLQDm/W6ZfUcItZ+DM8koVC/FuIc34gncUIDHLuJyJ8dOUuOoI0AQVZz+4rl2HAFk/UNf1Az8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742404267; c=relaxed/simple;
	bh=dQHWdZnu1FBuS3g0GFCTsOIXJ+VETJOQin36RiNMbyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgqcDfR0K1SbQU/JIWbVvD1FCQKFLz1vkNh3rXP83RGLVP6nehAwjef2YeCRlrJPQcFtUspMFsmlPy4YmtyfPQOrIJWA7R83VLLyQ0SPmZPCQjeHoR0aIyKtgwXgrs09x9v0bzN8fyph3NJnKUjOWeFed7tUA/n0YE0tkBRv5nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aLinoIyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aLinoIyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D72EC4CEE9;
	Wed, 19 Mar 2025 17:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742404267;
	bh=dQHWdZnu1FBuS3g0GFCTsOIXJ+VETJOQin36RiNMbyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLinoIyqXTLKolbdA5d0YhP5IgcOoGbsGYMakxoW0RmMW4wX2usEcVA8UKGzQJudO
	 LsIBf6w9ciaQKr1Zx1JcvRHpWQqfaxGqltH9AxNnXx9TrWECgvdNUcpEwUwrwrKBka
	 kMcspynRhWHxrInfwhD9vIvhOqOF4x9kg6xbXip2vXUxN6TsC76v5BPtgo9QjDI5HK
	 eFWuKYxdd+/OY9hX1b9DOwGZI/Uhd2eG7HXnNZbq08GG4+fennoutWqbiXhuXrjJ8t
	 vYMYQwteylN/QkmNSlCOY3ADaH6xOTqvTeUKu9BciZJXkhoLOTV62REHN4rXrPiYEv
	 mkSdFSxou2JDQ==
From: mtkaczyk@kernel.org
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mtkaczyk@kernel.org>,
	Xiao Ni <xni@redhat.com>,
	Nigel Croxon <ncroxon@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@kernel.org>
Subject: [PATCH v0 1/3] mdadm: Remove klibc and uclibc support
Date: Wed, 19 Mar 2025 18:10:56 +0100
Message-ID: <20250319171058.20052-2-mtkaczyk@kernel.org>
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

Klibc compilation is not working for at least 3 years because of
following error:
mdadm.h:1912:15: error: unknown type name 'sighandler_t'

It will have a conflict with le/be_to_cpu() functions family provided by
asm/byteorder.h which will be included with raid/md_p.h. Therefore we
need to remove support for it. Also, remove uclibc because it is not actively
maintained.

Remove klibc and uclibc targets from Makefile and special klibc code.
Targets can be removed safely because using CC is recommended.

Signed-off-by: Mariusz Tkaczyk <mtkaczyk@kernel.org>
---
 Makefile  | 34 +++-------------------------------
 README.md |  3 ---
 mdadm.h   | 37 +------------------------------------
 3 files changed, 4 insertions(+), 70 deletions(-)

diff --git a/Makefile b/Makefile
index bcd092de50c7..387e4a56f519 100644
--- a/Makefile
+++ b/Makefile
@@ -31,16 +31,6 @@
 # define "CXFLAGS" to give extra flags to CC.
 # e.g.  make CXFLAGS=-O to optimise
 CXFLAGS ?=-O2 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE
-TCC = tcc
-UCLIBC_GCC = $(shell for nm in i386-uclibc-linux-gcc i386-uclibc-gcc; do which $$nm > /dev/null && { echo $$nm ; exit; } ; done; echo false No uclibc found )
-#DIET_GCC = diet gcc
-# sorry, but diet-libc doesn't know about posix_memalign,
-# so we cannot use it any more.
-DIET_GCC = gcc -DHAVE_STDINT_H
-
-KLIBC=/home/src/klibc/klibc-0.77
-
-KLIBC_GCC = gcc -nostdinc -iwithprefix include -I$(KLIBC)/klibc/include -I$(KLIBC)/linux/include -I$(KLIBC)/klibc/arch/i386/include -I$(KLIBC)/klibc/include/bits32
 
 ifdef COVERITY
 COVERITY_FLAGS=-include coverity-gcc-hack.h
@@ -225,8 +215,6 @@ everything: all swap_super test_stripe raid6check \
 	mdadm.Os mdadm.O2 man
 everything-test: all swap_super test_stripe \
 	mdadm.Os mdadm.O2 man
-# mdadm.uclibc doesn't work on x86-64
-# mdadm.tcc doesn't work..
 
 %.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(COVERITY_FLAGS) -o $@ -c $<
@@ -237,13 +225,6 @@ mdadm : $(OBJS) | check_rundir
 mdadm.static : $(OBJS) $(STATICOBJS)
 	$(CC) $(CFLAGS) $(LDFLAGS) -static -o mdadm.static $(OBJS) $(STATICOBJS) $(LDLIBS)
 
-mdadm.tcc : $(SRCS) $(INCL)
-	$(TCC) -o mdadm.tcc $(SRCS)
-
-mdadm.klibc : $(SRCS) $(INCL)
-	rm -f $(OBJS)
-	$(CC) -nostdinc -iwithprefix include -I$(KLIBC)/klibc/include -I$(KLIBC)/linux/include -I$(KLIBC)/klibc/arch/i386/include -I$(KLIBC)/klibc/include/bits32 $(CFLAGS) $(SRCS)
-
 mdadm.Os : $(SRCS) $(INCL)
 	$(CC) -o mdadm.Os $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -DHAVE_STDINT_H -Os $(SRCS) $(LDLIBS)
 
@@ -298,15 +279,6 @@ install : install-bin install-man install-udev
 install-static : mdadm.static install-man
 	$(INSTALL) -D $(STRIP) -m 755 mdadm.static $(DESTDIR)$(BINDIR)/mdadm
 
-install-tcc : mdadm.tcc install-man
-	$(INSTALL) -D $(STRIP) -m 755 mdadm.tcc $(DESTDIR)$(BINDIR)/mdadm
-
-install-uclibc : mdadm.uclibc install-man
-	$(INSTALL) -D $(STRIP) -m 755 mdadm.uclibc $(DESTDIR)$(BINDIR)/mdadm
-
-install-klibc : mdadm.klibc install-man
-	$(INSTALL) -D $(STRIP) -m 755 mdadm.klibc $(DESTDIR)$(BINDIR)/mdadm
-
 install-man: mdadm.8 md.4 mdadm.conf.5 mdmon.8
 	$(INSTALL) -D -m 644 mdadm.8 $(DESTDIR)$(MAN8DIR)/mdadm.8
 	$(INSTALL) -D -m 644 mdmon.8 $(DESTDIR)$(MAN8DIR)/mdmon.8
@@ -354,9 +326,9 @@ test: mdadm mdmon test_stripe swap_super raid6check
 
 clean :
 	rm -f mdadm mdmon $(OBJS) $(MON_OBJS) $(STATICOBJS) core *.man \
-	mdadm.tcc mdadm.uclibc mdadm.static *.orig *.porig *.rej *.alt \
-	.merge_file_* mdadm.Os mdadm.O2 mdmon.O2 swap_super init.cpio.gz \
-	mdadm.uclibc.static test_stripe raid6check raid6check.o mdmon mdadm.8
+	mdadm.static *.orig *.porig *.rej *.alt merge_file_* \
+	mdadm.Os mdadm.O2 mdmon.O2 swap_super init.cpio.gz \
+	test_stripe raid6check raid6check.o mdmon mdadm.8
 	rm -rf cov-int
 
 dist : clean
diff --git a/README.md b/README.md
index 0c299a9a26a2..12a26353e7e9 100644
--- a/README.md
+++ b/README.md
@@ -138,9 +138,6 @@ List of installation targets:
 
 The following targets are deprecated and should not be used:
 - `install-static`
-- `install-tcc`
-- `install-uclibc`
-- `install-klibc`
 
 # License
 
diff --git a/mdadm.h b/mdadm.h
index e84c341c3040..0b86e4849d33 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -43,6 +43,7 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #include	<sys/time.h>
 #include	<getopt.h>
 #include	<fcntl.h>
+#include	<ftw.h>
 #include	<stdio.h>
 #include	<errno.h>
 #include	<string.h>
@@ -189,7 +190,6 @@ struct dlm_lksb {
 			     ((x) & 0x00000000ff000000ULL) << 8 |  \
 			     ((x) & 0x000000ff00000000ULL) >> 8)
 
-#if !defined(__KLIBC__)
 #if BYTE_ORDER == LITTLE_ENDIAN
 #define	__cpu_to_le16(_x) (unsigned int)(_x)
 #define __cpu_to_le32(_x) (unsigned int)(_x)
@@ -221,7 +221,6 @@ struct dlm_lksb {
 #else
 #  error "unknown endianness."
 #endif
-#endif /* __KLIBC__ */
 
 /*
  * Partially stolen from include/linux/unaligned/packed_struct.h
@@ -1530,40 +1529,6 @@ extern void sysfsline(char *line);
 struct stat64;
 #endif
 
-#define HAVE_NFTW  we assume
-#define HAVE_FTW
-
-#ifdef __UCLIBC__
-# include <features.h>
-# ifndef __UCLIBC_HAS_LFS__
-#  define lseek64 lseek
-# endif
-# ifndef  __UCLIBC_HAS_FTW__
-#  undef HAVE_FTW
-#  undef HAVE_NFTW
-# endif
-#endif
-
-#ifdef __dietlibc__
-# undef HAVE_NFTW
-#endif
-
-#if defined(__KLIBC__)
-# undef HAVE_NFTW
-# undef HAVE_FTW
-#endif
-
-#ifndef HAVE_NFTW
-# define FTW_PHYS 1
-# ifndef HAVE_FTW
-  struct FTW {};
-# endif
-#endif
-
-#ifdef HAVE_FTW
-# include <ftw.h>
-#endif
-
 extern int add_dev(const char *name, const struct stat *stb, int flag, struct FTW *s);
 
 extern int Manage_ro(char *devname, int fd, int readonly);
-- 
2.43.0

