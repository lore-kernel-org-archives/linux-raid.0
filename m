From: "Micheal Blue" <mblue@gmx.us>
Subject: core dump on initial sync of raid10 please help
Date: Mon, 14 Dec 2015 14:48:49 +0100
Message-ID: <trinity-c6018f35-ed0d-46be-b418-7799c4874238-1450100929825@3capp-mailcom-bs06>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I noticed my initial sync when making a 4 disk raid10 is really slow. I looked in dmesg and found this.
I do not know what it means. Suggestions please :)

[  600.959945] INFO: task md0_resync:676 blocked for more than 120 seconds.
[  600.959976]       Not tainted 4.3.2-1-ARCH #1
[  600.959994] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  600.960024] md0_resync      D ffff88021fa956c0     0   676      2 0x00000000
[  600.960028]  ffff8800ca143b40 0000000000000046 ffff880216659b80 ffff8800377244c0
[  600.960030]  ffff8800ca144000 ffff88003765a000 ffff8800ca143b68 ffff88003765a100
[  600.960032]  ffff88003765a000 ffff8800ca143b58 ffffffff8157f92a ffff88003765a0dc
[  600.960034] Call Trace:
[  600.960040]  [<ffffffff8157f92a>] schedule+0x3a/0x90
[  600.960044]  [<ffffffffa0548f52>] raise_barrier+0x122/0x190 [raid10]
[  600.960049]  [<ffffffff810b5dc0>] ? wake_atomic_t_function+0x60/0x60
[  600.960051]  [<ffffffffa054eea1>] sync_request+0x731/0x19b0 [raid10]
[  600.960055]  [<ffffffffa0390637>] ? is_mddev_idle+0x118/0x13e [md_mod]
[  600.960058]  [<ffffffffa0384ee7>] md_do_sync+0x897/0xf00 [md_mod]
[  600.960061]  [<ffffffff810b5dc0>] ? wake_atomic_t_function+0x60/0x60
[  600.960065]  [<ffffffff810809fe>] ? kernel_sigaction+0x7e/0xe0
[  600.960068]  [<ffffffffa0380fe0>] md_thread+0x130/0x140 [md_mod]
[  600.960069]  [<ffffffff8157f1d0>] ? __schedule+0x340/0xa60
[  600.960072]  [<ffffffffa0380eb0>] ? md_wait_for_blocked_rdev+0x130/0x130 [md_mod]
[  600.960075]  [<ffffffff81092e68>] kthread+0xd8/0xf0
[  600.960077]  [<ffffffff81092d90>] ? kthread_worker_fn+0x170/0x170
[  600.960078]  [<ffffffff8158375f>] ret_from_fork+0x3f/0x70
[  600.960080]  [<ffffffff81092d90>] ? kthread_worker_fn+0x170/0x170
[  721.067472] INFO: task md0_resync:676 blocked for more than 120 seconds.
[  721.067500]       Not tainted 4.3.2-1-ARCH #1
[  721.067517] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  721.067545] md0_resync      D ffff88021fa956c0     0   676      2 0x00000000
[  721.067548]  ffff8800ca143b40 0000000000000046 ffff880216659b80 ffff8800377244c0
[  721.067551]  ffff8800ca144000 ffff88003765a000 ffff8800ca143b68 ffff88003765a100
[  721.067553]  ffff88003765a000 ffff8800ca143b58 ffffffff8157f92a ffff88003765a0dc
[  721.067555] Call Trace:
[  721.067561]  [<ffffffff8157f92a>] schedule+0x3a/0x90
[  721.067565]  [<ffffffffa0548f52>] raise_barrier+0x122/0x190 [raid10]
[  721.067569]  [<ffffffff810b5dc0>] ? wake_atomic_t_function+0x60/0x60
[  721.067572]  [<ffffffffa054eea1>] sync_request+0x731/0x19b0 [raid10]
[  721.067575]  [<ffffffffa0390637>] ? is_mddev_idle+0x118/0x13e [md_mod]
[  721.067578]  [<ffffffffa0384ee7>] md_do_sync+0x897/0xf00 [md_mod]
[  721.067581]  [<ffffffff810b5dc0>] ? wake_atomic_t_function+0x60/0x60
[  721.067585]  [<ffffffff810809fe>] ? kernel_sigaction+0x7e/0xe0
[  721.067588]  [<ffffffffa0380fe0>] md_thread+0x130/0x140 [md_mod]
[  721.067590]  [<ffffffff8157f1d0>] ? __schedule+0x340/0xa60
[  721.067592]  [<ffffffffa0380eb0>] ? md_wait_for_blocked_rdev+0x130/0x130 [md_mod]
[  721.067595]  [<ffffffff81092e68>] kthread+0xd8/0xf0
[  721.067597]  [<ffffffff81092d90>] ? kthread_worker_fn+0x170/0x170
[  721.067599]  [<ffffffff8158375f>] ret_from_fork+0x3f/0x70
[  721.067600]  [<ffffffff81092d90>] ? kthread_worker_fn+0x170/0x170
[  841.176298] INFO: task md0_resync:676 blocked for more than 120 seconds.
[  841.176326]       Not tainted 4.3.2-1-ARCH #1
[  841.176342] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  841.176370] md0_resync      D ffff88021fa956c0     0   676      2 0x00000000
[  841.176374]  ffff8800ca143b40 0000000000000046 ffff880216659b80 ffff8800377244c0
[  841.176376]  ffff8800ca144000 ffff88003765a000 ffff8800ca143b68 ffff88003765a100
[  841.176378]  ffff88003765a000 ffff8800ca143b58 ffffffff8157f92a ffff88003765a0dc
[  841.176380] Call Trace:
[  841.176386]  [<ffffffff8157f92a>] schedule+0x3a/0x90
[  841.176390]  [<ffffffffa0548f52>] raise_barrier+0x122/0x190 [raid10]
[  841.176395]  [<ffffffff810b5dc0>] ? wake_atomic_t_function+0x60/0x60
[  841.176397]  [<ffffffffa054eea1>] sync_request+0x731/0x19b0 [raid10]
[  841.176400]  [<ffffffffa0390637>] ? is_mddev_idle+0x118/0x13e [md_mod]
[  841.176403]  [<ffffffffa0384ee7>] md_do_sync+0x897/0xf00 [md_mod]
[  841.176406]  [<ffffffff810b5dc0>] ? wake_atomic_t_function+0x60/0x60
[  841.176409]  [<ffffffff810809fe>] ? kernel_sigaction+0x7e/0xe0
[  841.176412]  [<ffffffffa0380fe0>] md_thread+0x130/0x140 [md_mod]
[  841.176414]  [<ffffffff8157f1d0>] ? __schedule+0x340/0xa60
[  841.176416]  [<ffffffffa0380eb0>] ? md_wait_for_blocked_rdev+0x130/0x130 [md_mod]
[  841.176419]  [<ffffffff81092e68>] kthread+0xd8/0xf0
[  841.176421]  [<ffffffff81092d90>] ? kthread_worker_fn+0x170/0x170
[  841.176423]  [<ffffffff8158375f>] ret_from_fork+0x3f/0x70
[  841.176424]  [<ffffffff81092d90>] ? kthread_worker_fn+0x170/0x170
[  961.285635] INFO: task md0_resync:676 blocked for more than 120 seconds.
[  961.285653]       Not tainted 4.3.2-1-ARCH #1
[  961.285662] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  961.285678] md0_resync      D ffff88021fa956c0     0   676      2 0x00000000
[  961.285681]  ffff8800ca143b40 0000000000000046 ffff880216659b80 ffff8800377244c0
[  961.285682]  ffff8800ca144000 ffff88003765a000 ffff8800ca143b68 ffff88003765a100
[  961.285684]  ffff88003765a000 ffff8800ca143b58 ffffffff8157f92a ffff88003765a0dc
[  961.285685] Call Trace:
[  961.285690]  [<ffffffff8157f92a>] schedule+0x3a/0x90
[  961.285694]  [<ffffffffa0548f52>] raise_barrier+0x122/0x190 [raid10]
[  961.285697]  [<ffffffff810b5dc0>] ? wake_atomic_t_function+0x60/0x60
[  961.285699]  [<ffffffffa054eea1>] sync_request+0x731/0x19b0 [raid10]
[  961.285702]  [<ffffffffa0390637>] ? is_mddev_idle+0x118/0x13e [md_mod]
[  961.285704]  [<ffffffffa0384ee7>] md_do_sync+0x897/0xf00 [md_mod]
[  961.285706]  [<ffffffff810b5dc0>] ? wake_atomic_t_function+0x60/0x60
[  961.285709]  [<ffffffff810809fe>] ? kernel_sigaction+0x7e/0xe0
[  961.285711]  [<ffffffffa0380fe0>] md_thread+0x130/0x140 [md_mod]
[  961.285712]  [<ffffffff8157f1d0>] ? __schedule+0x340/0xa60
[  961.285714]  [<ffffffffa0380eb0>] ? md_wait_for_blocked_rdev+0x130/0x130 [md_mod]
[  961.285716]  [<ffffffff81092e68>] kthread+0xd8/0xf0
[  961.285717]  [<ffffffff81092d90>] ? kthread_worker_fn+0x170/0x170
[  961.285719]  [<ffffffff8158375f>] ret_from_fork+0x3f/0x70
[  961.285720]  [<ffffffff81092d90>] ? kthread_worker_fn+0x170/0x170
