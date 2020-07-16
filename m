From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v6 11/15] md/raid5: support config stripe_size by sysfs entry
Date: Thu, 16 Jul 2020 00:06:57 -0700
Message-ID: <CAPhsuW66oecM0RfGQjvsAnBKrwA7Hxv_Ytf1U-S4Jzirs49N7g@mail.gmail.com>
References: <20200715124257.3175816-1-yuyufen@huawei.com> <20200715124257.3175816-12-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200715124257.3175816-12-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids

On Wed, Jul 15, 2020 at 5:42 AM Yufen Yu <yuyufen@huawei.com> wrote:
>
> Adding a new 'stripe_size' sysfs entry to set and show stripe_size.
> After that, we can adjust stripe_size by writing value into sysfs
> entry, likely, set stripe_size as 16KB:
>
>           echo 16384 > /sys/block/md1/md/stripe_size
>
> Show current stripe_size value:
>
>           cat /sys/block/md1/md/stripe_size
>
> stripe_size should not be bigger than PAGE_SIZE, and it requires to be
> multiple of 4096.
>
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>

For this patch, please consider the following changes:
1) use DEFAULT_STRIPE_SIZE instead of 4096;
2) make the sysfs entry read only for PAGE_SIZE == 4096


diff --git i/drivers/md/raid5.c w/drivers/md/raid5.c
index 735238425c7f3..320fc14bc628c 100644
--- i/drivers/md/raid5.c
+++ w/drivers/md/raid5.c
@@ -6532,6 +6532,8 @@ raid5_show_stripe_size(struct mddev  *mddev, char *page)
        return ret;
 }

+#if PAGE_SIZE != DEFAULT_STRIPE_SIZE
+
 static ssize_t
 raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
 {
@@ -6544,13 +6546,12 @@ raid5_store_stripe_size(struct mddev  *mddev,
const char *page, size_t len)
                return -EINVAL;
        if (kstrtoul(page, 10, &new))
                return -EINVAL;
+
        /*
-        * When PAGE_SZIE is 4096, we don't need to modify stripe_size.
-        * And the value should not be bigger than PAGE_SIZE.
-        * It requires to be multiple of 4096.
+        * The value should not be bigger than PAGE_SIZE. It requires to
+        * be multiple of DEFAULT_STRIPE_SIZE.
         */
-       if (PAGE_SIZE == 4096 || new % 4096 != 0 ||
-                       new > PAGE_SIZE || new == 0)
+       if (new % DEFAULT_STRIPE_SIZE != 0 || new > PAGE_SIZE || new == 0)
                return -EINVAL;

        err = mddev_lock(mddev);
@@ -6612,6 +6613,15 @@ raid5_stripe_size = __ATTR(stripe_size, 0644,
                         raid5_show_stripe_size,
                         raid5_store_stripe_size);

+#else
+
+static struct md_sysfs_entry
+raid5_stripe_size = __ATTR(stripe_size, 0444,
+                        raid5_show_stripe_size,
+                        NULL);
+
+#endif /* PAGE_SIZE != DEFAULT_STRIPE_SIZE */
+
 static ssize_t
 raid5_show_preread_threshold(struct mddev *mddev, char *page)
 {
