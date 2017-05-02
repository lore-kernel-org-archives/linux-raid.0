From: Marc Smith <marc.smith@mcc.edu>
Subject: Re: md-cluster Oops 4.9.13
Date: Tue, 2 May 2017 14:30:24 -0400
Message-ID: <CAHkw+LfStCAZcyULSWM9g3iKMncnHCJgHgR5tSKak-hDUcU5Kw@mail.gmail.com>
References: <CAHkw+Lcr1+sWsQPK_ijfTHwG+zxRYT+iNhWGdpYTNxVuQi8TOw@mail.gmail.com>
 <58E45E0C.6030705@gmail.com> <CAHkw+Ld=yv=LoBKFUxNO6dEocOKzq-pFR=Tfk50OULXJ8NN9eQ@mail.gmail.com>
 <58ED83B0.6080209@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58ED83B0.6080209@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I was finally able to test this, and I modified the original patch to
apply cleanly against 4.9.13. I tried several times to reproduce this
oops, and wasn't successful, so it looks good. Here is the modified
patch:

diff -Naur a/drivers/md/bitmap.c b/drivers/md/bitmap.c
--- a/drivers/md/bitmap.c       2017-02-26 05:11:18.000000000 -0500
+++ b/drivers/md/bitmap.c       2017-04-14 11:22:18.325093619 -0400
@@ -1734,6 +1734,20 @@
        kfree(bitmap);
 }

+void bitmap_wait_behind_writes(struct mddev *mddev)
+{
+       struct bitmap *bitmap = mddev->bitmap;
+
+       /* wait for behind writes to complete */
+       if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
+               pr_debug("md:%s: behind writes in progress - waiting
to stop.\n",
+                        mdname(mddev));
+               /* need to kick something here to make sure I/O goes? */
+               wait_event(bitmap->behind_wait,
+                          atomic_read(&bitmap->behind_writes) == 0);
+       }
+}
+
 void bitmap_destroy(struct mddev *mddev)
 {
        struct bitmap *bitmap = mddev->bitmap;
@@ -1741,6 +1755,8 @@
        if (!bitmap) /* there was no bitmap */
                return;

+       bitmap_wait_behind_writes(mddev);
+
        mutex_lock(&mddev->bitmap_info.mutex);
        spin_lock(&mddev->lock);
        mddev->bitmap = NULL; /* disconnect from the md device */
diff -Naur a/drivers/md/bitmap.h b/drivers/md/bitmap.h
--- a/drivers/md/bitmap.h       2017-02-26 05:11:18.000000000 -0500
+++ b/drivers/md/bitmap.h       2017-04-14 10:49:03.999868295 -0400
@@ -269,6 +269,7 @@
                  int chunksize, int init);
 int bitmap_copy_from_slot(struct mddev *mddev, int slot,
                                sector_t *lo, sector_t *hi, bool clear_bits);
+void bitmap_wait_behind_writes(struct mddev *mddev);
 #endif

 #endif
diff -Naur a/drivers/md/md.c b/drivers/md/md.c
--- a/drivers/md/md.c   2017-02-26 05:11:18.000000000 -0500
+++ b/drivers/md/md.c   2017-04-14 10:57:52.344539569 -0400
@@ -5513,15 +5513,7 @@

 static void mddev_detach(struct mddev *mddev)
 {
-       struct bitmap *bitmap = mddev->bitmap;
-       /* wait for behind writes to complete */
-       if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
-               printk(KERN_INFO "md:%s: behind writes in progress -
waiting to stop.\n",
-                      mdname(mddev));
-               /* need to kick something here to make sure I/O goes? */
-               wait_event(bitmap->behind_wait,
-                          atomic_read(&bitmap->behind_writes) == 0);
-       }
+       bitmap_wait_behind_writes(mddev);
        if (mddev->pers && mddev->pers->quiesce) {
                mddev->pers->quiesce(mddev, 1);
                mddev->pers->quiesce(mddev, 0);
@@ -5534,6 +5526,7 @@
 static void __md_stop(struct mddev *mddev)
 {
        struct md_personality *pers = mddev->pers;
+       bitmap_destroy(mddev);
        mddev_detach(mddev);
        /* Ensure ->event_work is done */
        flush_workqueue(md_misc_wq);
@@ -5554,7 +5547,6 @@
         * This is called from dm-raid
         */
        __md_stop(mddev);
-       bitmap_destroy(mddev);
        if (mddev->bio_set)
                bioset_free(mddev->bio_set);
 }
@@ -5692,7 +5684,6 @@
        if (mode == 0) {
                printk(KERN_INFO "md: %s stopped.\n", mdname(mddev));

-               bitmap_destroy(mddev);
                if (mddev->bitmap_info.file) {
                        struct file *f = mddev->bitmap_info.file;
                        spin_lock(&mddev->lock);


--Marc


On Tue, Apr 11, 2017 at 9:32 PM, Guoqing Jiang <gqjiang@suse.com> wrote:
>
>
> On 04/10/2017 09:25 PM, Marc Smith wrote:
>>
>> Hi,
>>
>> Sorry for the delay... I was hoping to cherry-pick this and test
>> against 4.9.x, but it didn't apply cleanly, although it looks trivial
>> to do it by hand. Is it recommended/okay to test this patch against
>> 4.9.x? Will the fix eventually be merged into 4.9.x?
>
>
> I think you can have a try with the patch then see what will happen, the
> better
> way is try with the latest code though people don't like always update
> kernel,
> but it is not a material for stable 4.9.x from my understanding.
>
> Thanks,
> Guoqing
>
>
>>
>>
>> --Marc
>>
>> On Tue, Apr 4, 2017 at 11:01 PM, Guoqing Jiang <jgq516@gmail.com> wrote:
>>>
>>>
>>> On 04/04/2017 10:06 PM, Marc Smith wrote:
>>>>
>>>> Hi,
>>>>
>>>> I encountered an oops this morning when stopping a MD array
>>>> (md-cluster)... there were 4 md-cluster array started, and they were
>>>> in the middle of a rebuild. I stopped the first one and then stopped
>>>> the second one immediately after and got the oops, here is a
>>>> transcript of what was on my terminal session:
>>>>
>>>> [root@brimstone-1b ~]# mdadm --stop /dev/md/array1
>>>> mdadm: stopped /dev/md/array1
>>>> [root@brimstone-1b ~]# mdadm --stop /dev/md/array2
>>>>
>>>> Message from syslogd@brimstone-1b at Tue Apr  4 09:54:40 2017 ...
>>>> brimstone-1b kernel: [649162.174685] BUG: unable to handle kernel NULL
>>>> pointer dereference at 0000000000000098
>>>>
>>>> Using Linux 4.9.13 and here is the output from the kernel messages:
>>>>
>>>> --snip--
>>>> [649158.014731] dlm: 5b3b8f94-7875-b323-5bb8-29fa6866f4a8: leaving the
>>>> lockspace group...
>>>> [649158.015233] dlm: 5b3b8f94-7875-b323-5bb8-29fa6866f4a8: group event
>>>> done 0 0
>>>> [649158.015303] dlm: 5b3b8f94-7875-b323-5bb8-29fa6866f4a8:
>>>> release_lockspace final free
>>>> [649158.015331] md: unbind<nvme0n1p1>
>>>> [649158.042540] md: export_rdev(nvme0n1p1)
>>>> [649158.042546] md: unbind<nvme1n1p1>
>>>> [649158.048501] md: export_rdev(nvme1n1p1)
>>>> [649161.759022] md127: detected capacity change from 1000068874240 to 0
>>>> [649161.759025] md: md127 stopped.
>>>> [649162.174685] BUG: unable to handle kernel NULL pointer dereference
>>>> at 0000000000000098
>>>> [649162.174727] IP: [<ffffffff81868b40>] recv_daemon+0x1e9/0x373
>>>
>>>
>>> Looks like the recv_daemon is still running after stop array, commit
>>> 48df498 "md: move bitmap_destroy to the beginning of __md_stop"
>>> ensure it won't happen.
>>>
>>>
>>> [snip]
>>>
>>>> Perhaps this is already fixed in later versions? Let me know if you
>>>> need any additional information.
>>>
>>>
>>> Could you pls try with the latest version? Please let me know if you
>>> still see it, thanks.
>>>
>>> Regards,
>>> Guoqing
>>>
>
