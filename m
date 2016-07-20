From: "Vaughan" <cxt9401@163.com>
Subject: Re: How does md gurantee not miss to free an active stripe_head when md stops?
Date: Wed, 20 Jul 2016 18:53:41 +0800
Message-ID: <004e01d1e274$faa33a20$efe9ae60$@163.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: zh-cn
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I'm using v3.10 md code for develop. Recently I encounter a problem where an
read IO usually returned from physical disk after md has been stopped.
I reviewed the code and find when md stops, it unregister raid5d
unconditionally and call shrink_stripes() to free only the *inactive*
stripes.
I know before stop, it uses O_EXCL open the md, but that won't stop others
open it and send IO to it.
So I think it's possible that some active stripes will be still running.

And I also found
commit 5aa61f427e4979be733e4847b9199ff9cc48a47e
Author: NeilBrown <neilb@suse.de>
Date:   Mon Dec 15 12:56:57 2014 +1100
    md: split detach operation out from ->stop.

add calling a quiesce before unregister raid5d in __md_stop, which not
exists there before.
Does this fix the hole when md stop?


In my case, an OOPS usually happens like below:
I keep calling mdadm -stop to stop a md, but lsof shows it's opened by
systemd-udevd, so "still is inuse".
30s later, udev  reports timeout and be kicked with SIGKILL.
systemd-udevd: worker [19335]/devices/virtual/block/md41 timeout; kill it.

Then md stop process is able to continue and go passed the free_conf(). But
there is an active_stripe left.

kernel:
shrink_stripes:conf(ffff880004affc00)->md(ffff8802d95b4000,md41)active_strip
es=1     <== this is my debug print.
kernel: md41: detected capacity change from 3409128980480 to 0
mdadm: stopped /dev/md41

After md is stopped, an read IO from underlying returned and OOPS.

[190830.867371] md: unbind<dm-64>
[190830.876345] md: export_rdev(dm-64)
[190831.201619] BUG: unable to handle kernel [190831.202875] paging request
at 0000000000002050 [190831.204101] IP: [<ffffffffa089a349>]
raid5_end_read_request+0xf9/0xdc0[raid456]

I found this returned bio is caused by a user read page, which is caused by
a fput to kill_bdev.
PID: 21345  TASK: ffff8803e5a916c0  CPU: 1   COMMAND: "mdadm"
#0 [ffff88016f777b88] __schedule at ffffffff815f513d
#1 [ffff88016f777bf0] io_schedule at ffffffff815f599d
#2 [ffff88016f777c08] sleep_on_page at ffffffff81155f1e
#3 [ffff88016f777c18] __wait_on_bit_lock at ffffffff815f38ab
#4 [ffff88016f777c58] __lock_page at ffffffff81156038
#5 [ffff88016f777cb0] truncate_inode_pages_range at ffffffff8116645e
#6 [ffff88016f777e00] truncate_inode_pages at ffffffff811664b5
#7 [ffff88016f777e10] kill_bdev at ffffffff811ffaef
#8 [ffff88016f777e28] __blkdev_put at ffffffff81201124
#9 [ffff88016f777e68] blkdev_put at ffffffff81201bae
#10 [ffff88016f777e98] blkdev_close at ffffffff81201d55
#11 [ffff88016f777ea8] __fput at ffffffff811c81b9
#12 [ffff88016f777ef0] ____fput at ffffffff811c847e
#13 [ffff88016f777f00] task_work_run at ffffffff81093b37
#14 [ffff88016f777f30] do_notify_resume at ffffffff81013b0c
#15 [ffff88016f777f50] int_signal at ffffffff8160049d




