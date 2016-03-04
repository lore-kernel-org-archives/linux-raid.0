From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: use after free bug in b98043a2f8e7bb5b1918e2e02778f822f9dd4d3a
Date: Fri, 04 Mar 2016 16:19:16 -0500
Message-ID: <wrfjy49yym97.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Goldwyn Rodrigues <rgoldwyn@suse.com>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi,

I was looking at ExamineBitmap() and noticed that your patch below,
seems to introduce a use after free bug.

commit b98043a2f8e7bb5b1918e2e02778f822f9dd4d3a
Author: Guoqing Jiang <gqjiang@suse.com>
Date:   Wed Jun 10 13:42:07 2015 +0800

    Show all bitmaps while examining bitmap
    
    This adds capability of exmining bitmaps corresponding to all
    nodes/slots on the device.
    
    Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
    Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

Line 284 does a close(fd), but further down the code your patch
introduces:

+       } else {
+               printf("   Cluster nodes : %d\n", sb->nodes);
+               printf("    Cluster name : %64s\n", sb->cluster_name);
+               for (i = 0; i < (int)sb->nodes; i++) {
+                       if (i) {
+                               free(info);
+                               info = bitmap_fd_read(fd, brief);
+                               sb = &info->sb;
+                       }

It's not totally obvious to me here what the intention is for clustered
md here. Are you intending to use the same fd as was used at the top of
ExamineBitmap() or is it meant to open a new fd based on each clustered
entry?

In either case, the code as it is right now is certainly not going to
work :(

Cheers,
Jes
