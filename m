From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: Linux RAID with btrfs stuck and consume 100 % CPU
Date: Wed, 29 Jul 2020 23:06:37 +0200
Message-ID: <a070c45a-0509-e900-e3f3-98d20267c8c9@cloud.ionos.com>
References: <d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Vojtech Myslivec <vojtech@xmyslivec.cz>, linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Michal Moravec <michal.moravec@logicworks.cz>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Hi,

On 7/22/20 10:47 PM, Vojtech Myslivec wrote:
> 1. What should be the cause of this problem?

Just a quick glance based on the stacks which you attached, I guess it 
could be
a deadlock issue of raid5 cache super write.

Maybe the commit 8e018c21da3f ("raid5-cache: fix a deadlock in superblock
write") didn't fix the problem completely.  Cc Song.

And I am curious why md thread is not waked if mddev_trylock fails, you can
give it a try but I can't promise it helps ...

--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1337,8 +1337,10 @@ static void 
r5l_write_super_and_discard_space(struct r5l_log *log,
          */
         set_mask_bits(&mddev->sb_flags, 0,
                 BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
-       if (!mddev_trylock(mddev))
+       if (!mddev_trylock(mddev)) {
+               md_wakeup_thread(mddev->thread);
                 return;
+       }
         md_update_sb(mddev, 1);
         mddev_unlock(mddev);


Thanks,
Guoqing
