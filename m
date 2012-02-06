From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: [PATCH] getinfo_super1: when deciding whether the array is clean or
 dirty, compare sb->resync_offset against MaxSector and not against sb->size
Date: Mon, 6 Feb 2012 13:25:19 +0200
Message-ID: <CAGRgLy6W4pJWQwuEwBWkjUq6+TzNaVs59RzLu6zLs7N2w69_MA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From c1bc75c72f62c6583f17caa2d02a09dc72fbac74 Mon Sep 17 00:00:00 2001
From: Alex Lyakas <alex@zadarastorage.com>
Date: Mon, 6 Feb 2012 13:24:15 +0200
Subject: [PATCH] getinfo_super1: when deciding whether the array is clean or
 dirty, compare sb->resync_offset against MaxSector and not
 against sb->size

With RAID6 resyncing and subsequent drive failures, it is possible to
reach the case, in which sb->resync_offset==sb->size. This happens
when resync is aborted due to drive failures, a

diff --git a/super1.c b/super1.c
index 867aa58..c643bd3 100644
--- a/super1.c
+++ b/super1.c
@@ -573,7 +573,7 @@ static void getinfo_super1(struct supertype *st,
struct mdinfo *info, char *map)
        info->array.utime = __le64_to_cpu(sb->utime);
        info->array.chunk_size = __le32_to_cpu(sb->chunksize)*512;
        info->array.state =
-               (__le64_to_cpu(sb->resync_offset) >= __le64_to_cpu(sb->size))
+               (__le64_to_cpu(sb->resync_offset) != MaxSector)
                ? 1 : 0;

        info->data_offset = __le64_to_cpu(sb->data_offset);
