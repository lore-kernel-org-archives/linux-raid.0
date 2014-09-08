From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Fwd: raid1 data corruption during resync
Date: Mon, 8 Sep 2014 10:52:49 -0500
Message-ID: <CEEAB94E-18F3-4087-A866-B412582F7B8D@redhat.com>
References: <D4FE2D75-4208-48C9-A4D0-432F092E5AE9@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids



Begin forwarded message:

> From: Brassow Jonathan <jbrassow@redhat.com>
> Date: September 4, 2014 9:01:58 AM CDT
> To: NeilBrown <neilb@suse.de>
> Cc: Eivind Sarto <eivindsarto@gmail.com>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
> Subject: Re: raid1 data corruption during resync
> 
> 
> On Sep 4, 2014, at 12:28 AM, NeilBrown wrote:
> 
>> 
>> Neither of these explain the hang you are seeing.
>> I note that the "md0-resync" thread isn't listed.  I don't suppose you know
>> what it was doing (stack trace)??
>> Also, had  "md: md0: sync done" appeared in syslog yet?
> 
> The sync has not yet completed (no message).  I'm not sure why the resync thread didn't automatically report, but I've grabbed the entire trace from the machine ('echo t > /proc/sysrq-trigger') and it appears there.  The traces are attached.  (Would you rather have something so large posted in-line?)

I didn't see this message come through yet.  I am resending it with only the trace you requested from the mdX_resync thread.  If you need the entire list of traces, I can try resending that.

 brassow

Sep  4 08:52:00 bp-01 kernel: mdX_resync      D 0000000000000008     0 12374      2 0x00000080
Sep  4 08:52:00 bp-01 kernel: ffff880207a5bb38 0000000000000046 0000000000000296 ffff88021727efc0
Sep  4 08:52:00 bp-01 kernel: ffff880207a58010 0000000000012bc0 0000000000012bc0 ffff880214de0f40
Sep  4 08:52:00 bp-01 kernel: ffff880207a5bb60 ffff88040171e178 ffff88040171e100 ffff880207a5bb58
Sep  4 08:52:00 bp-01 kernel: Call Trace:
Sep  4 08:52:00 bp-01 kernel: [<ffffffff81580549>] schedule+0x29/0x70
Sep  4 08:52:00 bp-01 kernel: [<ffffffffa038a122>] raise_barrier+0xe2/0x160 [raid1]
Sep  4 08:52:00 bp-01 kernel: [<ffffffff8108eb00>] ? bit_waitqueue+0xe0/0xe0
Sep  4 08:52:00 bp-01 kernel: [<ffffffffa038b701>] sync_request+0x161/0x9e0 [raid1]
Sep  4 08:52:00 bp-01 kernel: [<ffffffff8108ee13>] ? __wake_up+0x53/0x70
Sep  4 08:52:00 bp-01 kernel: [<ffffffff81460009>] md_do_sync+0x849/0xd40
Sep  4 08:52:00 bp-01 kernel: [<ffffffff8108847f>] ? put_prev_entity+0x2f/0x400
Sep  4 08:52:00 bp-01 kernel: [<ffffffff81460816>] md_thread+0x116/0x150
Sep  4 08:52:00 bp-01 kernel: [<ffffffff8158006e>] ? __schedule+0x34e/0x6e0
Sep  4 08:52:00 bp-01 kernel: [<ffffffff81460700>] ? md_rdev_init+0x110/0x110
Sep  4 08:52:00 bp-01 kernel: [<ffffffff8107083e>] kthread+0xce/0xf0
Sep  4 08:52:00 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70
Sep  4 08:52:00 bp-01 kernel: [<ffffffff8158412c>] ret_from_fork+0x7c/0xb0
Sep  4 08:52:00 bp-01 kernel: [<ffffffff81070770>] ? kthread_freezable_should_stop+0x70/0x70

