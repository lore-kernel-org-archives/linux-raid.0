From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: mdadm: one question about the readonly and readwrite feature
Date: Thu, 23 Mar 2017 10:26:45 +0800
Message-ID: <58D33265.2000907@suse.com>
References: <774691e9-6b1e-5141-bc37-6e768c1c8fdc@suse.com>
 <87zigdt1r1.fsf@notabene.neil.brown.name> <58D32AE2.1030303@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58D32AE2.1030303@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Zhilong Liu <zlliu@suse.com>, Jes Sorensen <jes.sorensen@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 03/23/2017 09:54 AM, Guoqing Jiang wrote:
>
>
> On 03/23/2017 05:55 AM, NeilBrown wrote:
>> On Wed, Mar 22 2017, Zhilong Liu wrote:
>>
>>> Hi, Neil;
>>>
>>>     Excuse me, according to read 'mdadm/tests/ToTest', I'm a little
>>> confused about "readonly"
>>> and "readwrite" feature, and I've no idea how to fix it. Thus I report
>>> this question and I'm sorry
>>> for this long description email.
>>>
>>> relevant linux/driver/md commit: 
>>> 260fa034ef7a4ff8b73068b48ac497edd5217491
>>>
>>>     My question: If the array has been set the MD_CLOSING flag, 
>>> although
>>> hasn't removed the sysfs
>>> folder because sysfs_remove_group() wasn't invoked, and now, how should
>>> mdadm continue to
>>> control this 'readonly' array?
>> MD_CLOSING should only be set for a short period or time to avoid
>> certain races.  After the operation that set it completes, it should be
>> cleared.
>> It looks like this is a bug that was introduced in
>> Commit: af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag")
>> when MD_STILL_CLOSED was renamed to MD_CLOSING.
>
> I guess it is because we set MD_CLOSING for STOP_ARRAY_RO cmd, then 
> commit
> af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag") did below changes:
>
> @@ -7075,9 +7073,13 @@ static int md_open(struct block_device *bdev, 
> fmode_t mode)
>         if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
>                 goto out;
>
> +       if (test_bit(MD_CLOSING, &mddev->flags)) {
> +               mutex_unlock(&mddev->open_mutex);
> +               return -ENODEV;
> +       }
>
> Maybe we need to differentiate "STOP_ARRAY" and "STOP_ARRAY_RO", or 
> revert above
> changes.

Or maybe something like below (only compile test).

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 42e68b2e0b41..c40e863fe191 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -65,6 +65,7 @@
  #include <linux/raid/md_p.h>
  #include <linux/raid/md_u.h>
  #include <linux/slab.h>
+#include <linux/genhd.h>
  #include <trace/events/block.h>
  #include "md.h"
  #include "bitmap.h"
@@ -7237,7 +7238,7 @@ static int md_open(struct block_device *bdev, 
fmode_t mode)
         if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
                 goto out;

-       if (test_bit(MD_CLOSING, &mddev->flags)) {
+       if (!get_disk_ro(mddev->gendisk) && test_bit(MD_CLOSING, 
&mddev->flags)) {
                 mutex_unlock(&mddev->open_mutex);
                 err = -ENODEV;
                 goto out;

Thanks,
Guoqing
