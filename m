From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [RFC][PATCH] md: avoid fullsync if a faulty member missed a dirty transition
Date: Tue, 20 May 2008 11:30:24 -0400
Message-ID: <170fa0d20805200830w184709dch221f8b9636f3bc0e@mail.gmail.com>
References: <1207174155-20090-1-git-send-email-snitzer@gmail.com>
	 <18466.39418.578722.92979@notabene.brown>
	 <170fa0d20805081311r6b726762ndc83c5f626f0956c@mail.gmail.com>
	 <18467.43895.220708.254814@notabene.brown>
	 <170fa0d20805082142o61462a7dnce7852a6b7c0d21d@mail.gmail.com>
	 <18467.59565.676987.926988@notabene.brown>
	 <170fa0d20805090800p45654901p36eea51e1ea7e9c7@mail.gmail.com>
	 <18477.30199.992302.271647@notabene.brown>
	 <170fa0d20805182133o46501cc4va81b087fb6b417bf@mail.gmail.com>
	 <18481.4005.570022.160686@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18481.4005.570022.160686@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, paul.clements@steeleye.com
List-Id: linux-raid.ids

On Mon, May 19, 2008 at 1:27 AM, Neil Brown <neilb@suse.de> wrote:
> On Monday May 19, snitzer@gmail.com wrote:
>  >
>  > Hi Neil,
>  >
>  > Sorry about not getting back with you sooner.  Thanks for putting
>  > significant time to chasing this problem.
>  >
>  > I tested your most recent patch and unfortunately still hit the case
>  > where the nbd member becomes degraded yet the array continues to clear
>  > bits (events_cleared of the non-degraded member is higher than the
>  > degraded member).  Is this behavior somehow expected/correct?
>
>  It shouldn't be..... ahhh.
>  There is a delay between noting that the bit can be cleared, and
>  actually writing the zero to disk.  This is obviously intentional
>  in case the bit gets set again quickly.
>  I'm sampling the event count at the latter point instead of the
>  former, and there is time for it to change.
>
>  Maybe this patch on top of what I recently sent out?

Hi Neil,

We're much closer.  The events_cleared is symmetric on both the failed
and active member of the raid1.  But there have been some instances
where the md thread hits a deadlock during my testing.  What follows
is the backtrace and live crash info:

md0_raid1     D 000002c4b6483a7f     0 11249      2 (L-TLB)
 ffff81005747dce0 0000000000000046 0000000000000000 ffff8100454c53c0
 000000000000000a ffff810048fbd0c0 000000000000000a ffff810048fbd0c0
 ffff81007f853840 000000000000148e ffff810048fbd2b0 0000000362c10780
Call Trace:
 [<ffffffff88ba8503>] :md_mod:bitmap_daemon_work+0x249/0x4d3
 [<ffffffff802457a5>] autoremove_wake_function+0x0/0x2e
 [<ffffffff88ba53b3>] :md_mod:md_check_recovery+0x20/0x4a5
 [<ffffffff8044cb5c>] thread_return+0x0/0xf1
 [<ffffffff88bbe0eb>] :raid1:raid1d+0x25/0xd09
 [<ffffffff8023bcd7>] lock_timer_base+0x26/0x4b
 [<ffffffff8023bd4d>] try_to_del_timer_sync+0x51/0x5a
 [<ffffffff8023bd62>] del_timer_sync+0xc/0x16
 [<ffffffff8044d38a>] schedule_timeout+0x92/0xad
 [<ffffffff88ba6c6c>] :md_mod:md_thread+0xeb/0x101
 [<ffffffff802457a5>] autoremove_wake_function+0x0/0x2e
 [<ffffffff88ba6b81>] :md_mod:md_thread+0x0/0x101
 [<ffffffff8024564d>] kthread+0x47/0x76
 [<ffffffff8020aa38>] child_rip+0xa/0x12
 [<ffffffff80245606>] kthread+0x0/0x76
 [<ffffffff8020aa2e>] child_rip+0x0/0x12

crash> bt 11249
PID: 11249  TASK: ffff810048fbd0c0  CPU: 3   COMMAND: "md0_raid1"
 #0 [ffff81005747dbf0] schedule at ffffffff8044cb5c
 #1 [ffff81005747dce8] bitmap_daemon_work at ffffffff88ba8503
 #2 [ffff81005747dd68] md_check_recovery at ffffffff88ba53b3
 #3 [ffff81005747ddb8] raid1d at ffffffff88bbe0eb
 #4 [ffff81005747ded8] md_thread at ffffffff88ba6c6c
 #5 [ffff81005747df28] kthread at ffffffff8024564d
 #6 [ffff81005747df48] kernel_thread at ffffffff8020aa38

0xffffffff88ba84ee <bitmap_daemon_work+0x234>:  callq
0xffffffff802458ec <prepare_to_wait>
0xffffffff88ba84f3 <bitmap_daemon_work+0x239>:  mov    0x18(%rbx),%rax
0xffffffff88ba84f7 <bitmap_daemon_work+0x23d>:  mov    0x28(%rax),%eax
0xffffffff88ba84fa <bitmap_daemon_work+0x240>:  test   $0x2,%al
0xffffffff88ba84fc <bitmap_daemon_work+0x242>:  je
0xffffffff88ba8505 <bitmap_daemon_work+0x24b>
0xffffffff88ba84fe <bitmap_daemon_work+0x244>:  callq
0xffffffff8044c200 <__sched_text_start>
0xffffffff88ba8503 <bitmap_daemon_work+0x249>:  jmp
0xffffffff88ba84d6 <bitmap_daemon_work+0x21c>
0xffffffff88ba8505 <bitmap_daemon_work+0x24b>:  mov    0x18(%rbx),%rdi
0xffffffff88ba8509 <bitmap_daemon_work+0x24f>:  mov    %rbp,%rsi
0xffffffff88ba850c <bitmap_daemon_work+0x252>:  add    $0x200,%rdi
0xffffffff88ba8513 <bitmap_daemon_work+0x259>:  callq
0xffffffff802457f6 <finish_wait>

So running with your latest patches seems to introduce a race in
bitmap_daemon_work's if (unlikely((*bmc & COUNTER_MAX) ==
COUNTER_MAX)) { } block.

Mike
