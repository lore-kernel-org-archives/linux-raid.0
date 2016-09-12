From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Question about commit f9a67b1182e5 ("md/bitmap: clear bitmap if
 bitmap_create failed").
Date: Mon, 12 Sep 2016 21:09:48 +0200
Message-ID: <752ab1d9-412a-149b-a241-e604040ebaff@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm puzzled by commit f9a67b1182e5 ("md/bitmap: clear bitmap if 
bitmap_create failed").

Part of the commit is:

@@ -1865,8 +1866,10 @@ int bitmap_copy_from_slot(struct mddev *mddev, 
int slot,
      struct bitmap_counts *counts;
      struct bitmap *bitmap = bitmap_create(mddev, slot);

-    if (IS_ERR(bitmap))
+    if (IS_ERR(bitmap)) {
+        bitmap_free(bitmap);
          return PTR_ERR(bitmap);
+    }

but if 'bitmap' is an error, I think that bad things will happen in 
'bitmap_free()' when, at the beginning of the function, we will execute:

     if (bitmap->sysfs_can_clear) <-----------------
         sysfs_put(bitmap->sysfs_can_clear);


However, the commit log message is really explicit and adding this call 
to 'bitmap_free' has really been done one purpose. ("If bitmap_create 
returns an error, we need to call either bitmap_destroy or bitmap_free 
to do clean up, ...")


It is also not consistent with the comment before function bitmap_create():

     * if this returns an error, bitmap_destroy must be called to do 
clean up
     * once mddev->bitmap is set


I may have missed something, but I don't see what.

Is this commit correct?


Best regards,
CJ

