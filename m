From: Nix <nix@esperi.org.uk>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Tue, 05 Dec 2017 15:49:30 +0000
Message-ID: <87fu8pdvjp.fsf@esperi.org.uk>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
        <5A267B54.7070408@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A267B54.7070408@youngman.org.uk> (Wols Lists's message of "Tue,
        5 Dec 2017 10:56:20 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Jeremy Graham <jeremy@doghouse.agency>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5 Dec 2017, Wols Lists told this:

> On 05/12/17 09:41, Jeremy Graham wrote:
>> $ mdadm --version
>> mdadm - v3.4 - 28th January 2016
>
> Won't do any harm to try the latest version, but this could well be the
> problem.
>
> https://raid.wiki.kernel.org/index.php/Linux_Raid
>
> That'll tell you where to download the latest mdadm from. This sounds a
> typical problem that people have had, and iirc upgrading mdadm often
> fixes it.

This suggests otherwise:

[69979.933007] md0: detected capacity change from 0 to 12002359508992
[69979.933130] md: reshape of RAID array md0
[69979.933132] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[69979.933134] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for reshape.
[69979.933139] md: using 128k window, over a total of 2930263552k.
[70197.635112] INFO: task md0_reshape:30529 blocked for more than 120 seconds.
[70197.635142]       Not tainted 4.4.0-101-generic #124-Ubuntu
[70197.635161] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[70197.635187] md0_reshape     D ffff88011da37aa8     0 30529      2 0x00000000
[70197.635191]  ffff88011da37aa8 ffff88011da37a78 ffff880214a40e00
ffff880210577000
[70197.635193]  ffff88011da38000 ffff8800d49de424 ffff8800d49de658
ffff8800d49de638
[70197.635194]  ffff8800d49de670 ffff88011da37ac0 ffffffff818406d5
ffff8800d49de400
[70197.635196] Call Trace:
[70197.635202]  [<ffffffff818406d5>] schedule+0x35/0x80
[70197.635206]  [<ffffffffc034045f>]
raid5_get_active_stripe+0x31f/0x700 [raid456]
[70197.635210]  [<ffffffff810c4420>] ? wake_atomic_t_function+0x60/0x60
[70197.635212]  [<ffffffffc0344da4>] reshape_request+0x584/0x950 [raid456]
[70197.635215]  [<ffffffff810a9c6a>] ? finish_task_switch+0x7a/0x220
[70197.635218]  [<ffffffffc034548c>] sync_request+0x31c/0x3a0 [raid456]
[70197.635219]  [<ffffffff81840026>] ? __schedule+0x3b6/0xa30
[70197.635222]  [<ffffffff814102b5>] ? find_next_bit+0x15/0x20
[70197.635225]  [<ffffffff81710bb1>] ? is_mddev_idle+0x9c/0xfa
[70197.635227]  [<ffffffff816adbbc>] md_do_sync+0x89c/0xe60
[70197.635229]  [<ffffffff810c4420>] ? wake_atomic_t_function+0x60/0x60
[70197.635231]  [<ffffffff816aa319>] md_thread+0x139/0x150
[70197.635233]  [<ffffffff810c4420>] ? wake_atomic_t_function+0x60/0x60
[70197.635234]  [<ffffffff816aa1e0>] ? find_pers+0x70/0x70
[70197.635236]  [<ffffffff810a0c75>] kthread+0xe5/0x100
[70197.635237]  [<ffffffff810a0b90>] ? kthread_create_on_node+0x1e0/0x1e0
[70197.635239]  [<ffffffff81844b8f>] ret_from_fork+0x3f/0x70
[70197.635241]  [<ffffffff810a0b90>] ? kthread_create_on_node+0x1e0/0x1e0
[70317.630767] INFO: task md0_reshape:30529 blocked for more than 120 seconds.
[70317.630796]       Not tainted 4.4.0-101-generic #124-Ubuntu
[70317.630815] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.

That's a kernel bug, probably a deadlock. *Definitely* try a newer
kernel, 4.14.3 (the latest) if possible. I bet this is fixed by

6ab2a4b806ae21b6c3e47c5ff1285ec06d505325
RAID5: revert e9e4c377e2f563 to fix a livelock

which fixes a bug which exactly like this: the faulty patch was present
from v4.2 to v4.6. You're in the middle of that range... it might be
worth seeing if the distro kernel you're running has applied that patch,
too.
