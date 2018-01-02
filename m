From: Sean Fu <fxinrong@gmail.com>
Subject: [PATCH 2/3] fs/ntfs: Make ntfs to support circular buffer list.
Date: Tue,  2 Jan 2018 14:54:48 +0800
Message-ID: <0393df685af6e5f9ae36d5583c49a485cf401dec.1514867850.git.fxinrong@gmail.com>
References: <cover.1514867850.git.fxinrong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1514867850.git.fxinrong@gmail.com>
In-Reply-To: <cover.1514867850.git.fxinrong@gmail.com>
References: <cover.1514867850.git.fxinrong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: shli@kernel.org, viro@zeniv.linux.org.uk, anton@tuxera.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, Sean Fu <fxinrong@gmail.com>
List-Id: linux-raid.ids

Modify mark_ntfs_record_dirty to support circular buffer list.
alloc_page_buffers created circular buffer list. So the circular list
linking in ntfs_sync_mft_mirror is unnecessary.

Signed-off-by: Sean Fu <fxinrong@gmail.com>
---
 fs/ntfs/aops.c | 6 ++----
 fs/ntfs/mft.c  | 4 ----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index 3a2e509..4e69577 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -1746,10 +1746,8 @@ void mark_ntfs_record_dirty(struct page *page, const unsigned int ofs) {
 
 			do {
 				set_buffer_uptodate(bh);
-				tail = bh;
 				bh = bh->b_this_page;
-			} while (bh);
-			tail->b_this_page = head;
+			} while (bh != head);
 			attach_page_buffers(page, head);
 		} else
 			buffers_to_free = bh;
@@ -1771,7 +1769,7 @@ void mark_ntfs_record_dirty(struct page *page, const unsigned int ofs) {
 			bh = buffers_to_free->b_this_page;
 			free_buffer_head(buffers_to_free);
 			buffers_to_free = bh;
-		} while (buffers_to_free);
+		} while (buffers_to_free != head);
 	}
 }
 
diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index ee8392a..26ba4f6 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -505,15 +505,11 @@ int ntfs_sync_mft_mirror(ntfs_volume *vol, const unsigned long mft_no,
 	memcpy(kmirr, m, vol->mft_record_size);
 	/* Create uptodate buffers if not present. */
 	if (unlikely(!page_has_buffers(page))) {
-		struct buffer_head *tail;
-
 		bh = head = alloc_page_buffers(page, blocksize, true);
 		do {
 			set_buffer_uptodate(bh);
-			tail = bh;
 			bh = bh->b_this_page;
 		} while (bh);
-		tail->b_this_page = head;
 		attach_page_buffers(page, head);
 	}
 	bh = head = page_buffers(page);
-- 
2.6.2
