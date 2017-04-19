From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] uapi: fix linux/raid/md_p.h userspace compilation error
Date: Wed, 19 Apr 2017 10:48:06 +0200
Message-ID: <20170419084806.28405-1-artur.paszkiewicz@intel.com>
References: <xr93wpak0xkb.fsf@gthelen.mtv.corp.google.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <xr93wpak0xkb.fsf@gthelen.mtv.corp.google.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, gthelen@google.com, ncroxon@redhat.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Use __le32 and __le64 instead of u32 and u64.

This fixes klibc build error:
  In file included from /klibc/usr/klibc/../include/sys/md.h:30:0,
                   from /klibc/usr/kinit/do_mounts_md.c:19:
  /linux-next/usr/include/linux/raid/md_p.h:414:51: error: 'u32' undeclared here (not in a function)
    (PPL_HEADER_SIZE - PPL_HDR_RESERVED - 4 * sizeof(u32) - sizeof(u64))

Reported-by: Greg Thelen <gthelen@google.com>
Reported-by: Nigel Croxon <ncroxon@redhat.com>
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 include/uapi/linux/raid/md_p.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index d9a1ead867b9..d500bd224979 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -411,7 +411,7 @@ struct ppl_header_entry {
 #define PPL_HEADER_SIZE 4096
 #define PPL_HDR_RESERVED 512
 #define PPL_HDR_ENTRY_SPACE \
-	(PPL_HEADER_SIZE - PPL_HDR_RESERVED - 4 * sizeof(u32) - sizeof(u64))
+	(PPL_HEADER_SIZE - PPL_HDR_RESERVED - 4 * sizeof(__le32) - sizeof(__le64))
 #define PPL_HDR_MAX_ENTRIES \
 	(PPL_HDR_ENTRY_SPACE / sizeof(struct ppl_header_entry))
 
-- 
2.11.0

