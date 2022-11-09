Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85286C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  9 Nov 2022 06:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiKIGuh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Nov 2022 01:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiKIGug (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Nov 2022 01:50:36 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D507A17423
        for <linux-raid@vger.kernel.org>; Tue,  8 Nov 2022 22:50:34 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id p21so16247336plr.7
        for <linux-raid@vger.kernel.org>; Tue, 08 Nov 2022 22:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oeiQ8rSSRHyinWOvftmO+pjcXP5XBt6bs6wBs6C0nI8=;
        b=MpQx3Gz4vn9mAzlf29Wnc3rUx7F1v6q0bCX8/tkyTkPaaux0bJ3ZQ6GNZD8dIZd+4+
         Axi6XEwNX18lD+GYO/FEhUAdrFoojzo8zXp/RKN1ZDo1B9eYs+KNdsEKBw7X6NpHFih4
         psgpC+6p/0yBA4AyymgmsnneBiUKR8tnsnuKdXDWmESSY2an+c5w95p8Mqixtwfq383Z
         z0/TdI5KwraL5ke0AyVM1yEjZTUIE6aINdB3Qv7D916bC0JYJHZXnoSl9YLSgTykX105
         XVFyTrWt3ZNCagEAQpDxqYyPOSFMQngfE6e3ZtntstwDOrWO3cMOd28u5NSzmsDBODga
         UXFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oeiQ8rSSRHyinWOvftmO+pjcXP5XBt6bs6wBs6C0nI8=;
        b=z6ERoZuCtjjNvHYW8w2NvEPvs6cp4hqqcyBvZwB8vUoftqnGl/7OMKNOP7YgdFcvSY
         8e+Llsyhr7LNumEn0MkHEHY5OFz+KW32BP7EoXpY+Y7NwqYy6FeOtcuoPwkPEsrwdDGx
         6ArlIw1adZ9WokmeF6DLxIN4AYdnrSobl84ZBRETNRHERs4O1nX68RrptQUbBC3PzAPr
         MlCKGV0qVvfFCuMN/Ce1/6GrVFs2jctiBDvHkdeMLWeX3WiBcsuBMYBM++exZsZxitfB
         8Qm+DEbzn0wZonGbwVckpZGG8NlSyS0iULVYzHPmjSfgRYFMv2Sr5C61MfOEMzeISO5K
         n67A==
X-Gm-Message-State: ACrzQf3YEAeWfNMhIZRVL0L2gxtz89TIpt7FEUhj95Ro9DtWZ5lwfIzT
        nkx6k+zx4vonOW0C+FDogfA9ppa5T/c8xDOY1pCIXQ==
X-Google-Smtp-Source: AMsMyM53o7bcN3f21rkHiUm2pmVmGRowHOGFnbmPnpiDVDQ3BeOGL+5YgVctYf0AvNvc8Lxnh/UqMTBnIqQJGqrwK7M=
X-Received: by 2002:a17:902:7590:b0:187:29fe:bdb1 with SMTP id
 j16-20020a170902759000b0018729febdb1mr47866311pll.134.1667976634346; Tue, 08
 Nov 2022 22:50:34 -0800 (PST)
MIME-Version: 1.0
From:   Zhang Tianci <zhangtianci.1997@bytedance.com>
Date:   Wed, 9 Nov 2022 14:50:23 +0800
Message-ID: <CAP4dvsc725oZMso+=gmWSoGRLN9m3Q8D1zhHuz=Q+qfGqTdXCw@mail.gmail.com>
Subject: raid5 deadlock issue
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

I am tracking down a deadlock in Linux-5.4.56.

I end up seeing multiple hung tasks with the following stack trace:

  #0 [ffff9dccdd79f538] __schedule at ffffffffaf993b2d
  #1 [ffff9dccdd79f5c8] schedule at ffffffffaf993eaa
  #2 [ffff9dccdd79f5e0] md_bitmap_startwrite at ffffffffc08eef61 [md_mod]
  #3 [ffff9dccdd79f658] add_stripe_bio at ffffffffc0a4b627 [raid456]
  #4 [ffff9dccdd79f6a8] raid5_make_request at ffffffffc0a508fe [raid456]
  #5 [ffff9dccdd79f788] md_handle_request at ffffffffc08e4920 [md_mod]
  #6 [ffff9dccdd79f7f0] md_make_request at ffffffffc08e4a76 [md_mod]
  #7 [ffff9dccdd79f818] generic_make_request at ffffffffaf5ab4bb
  #8 [ffff9dccdd79f878] submit_bio at ffffffffaf5ab6f8
  #9 [ffff9dccdd79f8e0] ext4_io_submit at ffffffffc0834ab9 [ext4]
  #10 [ffff9dccdd79f8f0] ext4_bio_write_page at ffffffffc0834d7e [ext4]

They are all blocked with md_bitmap_startwrite.

After some debugging, I found there are two kinds of deadlock states,
and I guess the latest Linux has the same problems.

1. If there are two thread's bio belonging to the same stripe_head:
      threadA                                       threadB
raid5_make_request
  raid5_get_active_stripe(stripe count=1)
  add_stripe_bio
    md_bitmap_startwrite(get bitmap count)
  release_stripe_plug
    add this stripe to blk plug
  -------------------
  someone do unplug:
  raid5_unplug
                                                  raid5_make_request
                                              raid5_get_active_stripe(count=2)
    __release_stripe                      add_stripe_bio
      stripe count=1                           md_bitmap_startwrite(blocked)
      return

Because the max bitmap counter is (1<<14 - 1), so only one stripe can
not cause this kind of deadlock, but if there are enough stripe_head
working like above, there would be a "AA" deadlock.

Of course, This kind of deadlock is almost impossible to trigger. And
The deadlock I encountered was not of this kind. But this kind of
action is one component of the next kind of deadlock.

2. The special stripe_head is like the above, but thread A may do
another important thing. Thread A may do
`atomic_inc(&conf->preread_active_stripes);`. And This count will
block raid5d to activate delayed stripes:

```
static void raid5_activate_delayed(struct r5conf *conf)
{
      if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD) {
             while (!list_empty(&conf->delayed_list)) {
                       struct list_head *l = conf->delayed_list.next;
                       struct stripe_head *sh;
                       sh = list_entry(l, struct stripe_head, lru);
                       list_del_init(l);
                       clear_bit(STRIPE_DELAYED, &sh->state);
                       if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
                              atomic_inc(&conf->preread_active_stripes);
                       list_add_tail(&sh->lru, &conf->hold_list);
                       raid5_wakeup_stripe_thread(sh);
             }
       }
}
```
raid5d will only handle delayed stripe_head when
`conf->preread_active_stripes < IO_THRESHOLD` where `IO_THRESHOLD` is
one. So there would be one kind of ABBA deadlock:
many stripe_head got a bitmap count and waiting for
conf->preread_active_stripes.
someone stripe_head got conf->preread_active_stripes and waiting for
the bitmap count.

I guess the deadlock I encountered was the second kind. There is some
information about raid5 I am using:

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md10 : active raid5 nvme9n1p1[9] nvme8n1p1[7] nvme7n1p1[6]
nvme6n1p1[5] nvme5n1p1[4] nvme4n1p1[3] nvme3n1p1[2] nvme2n1p1[1]
nvme1n1p1[0]
      15001927680 blocks super 1.2 level 5, 512k chunk, algorithm 2
[9/9] [UUUUUUUUU]
      [====>................]  check = 21.0% (394239024/1875240960)
finish=1059475.2min speed=23K/sec
      bitmap: 1/14 pages [4KB], 65536KB chunk

$ mdadm -D /dev/md10
/dev/md10:
        Version : 1.2
  Creation Time : Fri Sep 23 11:47:03 2022
     Raid Level : raid5
     Array Size : 15001927680 (14306.95 GiB 15361.97 GB)
  Used Dev Size : 1875240960 (1788.37 GiB 1920.25 GB)
   Raid Devices : 9
  Total Devices : 9
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sun Nov  6 01:29:49 2022
          State : active, checking
 Active Devices : 9
Working Devices : 9
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Check Status : 21% complete

           Name : dc02-pd-t8-n021:10  (local to host dc02-pd-t8-n021)
           UUID : 089300e1:45b54872:31a11457:a41ad66a
         Events : 3968

    Number   Major   Minor   RaidDevice State
       0     259        8        0      active sync   /dev/nvme1n1p1
       1     259        6        1      active sync   /dev/nvme2n1p1
       2     259        7        2      active sync   /dev/nvme3n1p1
       3     259       12        3      active sync   /dev/nvme4n1p1
       4     259       11        4      active sync   /dev/nvme5n1p1
       5     259       14        5      active sync   /dev/nvme6n1p1
       6     259       13        6      active sync   /dev/nvme7n1p1
       7     259       21        7      active sync   /dev/nvme8n1p1
       9     259       20        8      active sync   /dev/nvme9n1p1

And some internal state of the raid5 by crash or sysfs:

$ cat /sys/block/md10/md/stripe_cache_active
4430               # There are so many active stripe_head

crash > foreach UN bt | grep md_bitmap_startwrite | wc -l
48                    # So there are only 48 stripe_head blocked by
the bitmap counter.
crash > list -o stripe_head.lru -s stripe_head.state -O
r5conf.delayed_list -h 0xffff90c1951d5000
.... # There are so many stripe_head, and the number is 4382.

There are 4430 active stripe_head, and 4382 are in delayed_list, the
last 48 blocked by the bitmap counter.
So I guess this is the second deadlock.

Then I reviewed the changelog after the commit 391b5d39faea "md/raid5:
Fix Force reconstruct-write io stuck in degraded raid5" date
2020-07-31, and found no related fixup commit. And I'm not sure my
understanding of raid5 is right. So I wondering if you can help
confirm whether my thoughts are right or not.

And If my thoughts are right, I have one idea to fix up the first problem:

We can add a field `bit_counter` into struct stripe_head, which means
this stripe_head's write counter, only it from 0 become 1, we do
md_bitmap_startwrite, and from 1 becomes 0, we do md_bitmap_endwrite.
So one stripe_head only gets one bitmap counter.

But for the second problem, I think I do not really understand the meaning of
r5conf->preread_active_stripes, So I have no good idea to fix it.

Thanks,

Tianci
