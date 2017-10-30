From: wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>
Subject: Pointer compare in md driver
Date: Tue, 31 Oct 2017 07:55:43 +0800
Message-ID: <0D106300-EF8D-45D0-9F7B-392FD9D8E824@mails.ucas.ac.cn>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Sorry for disturbing, but I have consider this problem for several days.
I have a question when reading md driver. Following is the code from
linux/drivers/md/md.c, function md_do_sync():

>                for_each_mddev(mddev2, tmp) {
>                        if (mddev2 == mddev)
>                                continue;
>                        if (!mddev->parallel_resync
>                        &&  mddev2->curr_resync
>                        &&  match_mddev_units(mddev, mddev2)) {
>                                DEFINE_WAIT(wq);
>                                if (mddev < mddev2 && mddev->curr_resync == 2) {
>                                        /* arbitrarily yield */
>                                        mddev->curr_resync = 1;
>                                        wake_up(&resync_wait);
>                                }
>                                if (mddev > mddev2 && mddev->curr_resync == 1)
>                                        /* no need to wait here, we can wait the next
>                                         * time 'round when curr_resync == 2
>                                         */
>                                        continue;
>                                /* We need to wait 'interruptible' so as not to

The type of mddev2 and mddev both are struct mddev *, so what's the
meaning of comparing these two variables?

