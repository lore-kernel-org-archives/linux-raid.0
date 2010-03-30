From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Array 'freezes' for some time after large writes?
Date: Tue, 30 Mar 2010 11:05:45 -0700
Message-ID: <5bdc1c8b1003301105o131b73aaj176c7679be20eada@mail.gmail.com>
References: <dead81ad1003301007h4015ac57x99f36d232bb705b6@mail.gmail.com>
	 <5bdc1c8b1003301018j73f2d928x3e2624bac9c1ee94@mail.gmail.com>
	 <dead81ad1003301047t6be7b3b4r5bf70ad6317f9d1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dead81ad1003301047t6be7b3b4r5bf70ad6317f9d1e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Duchek <jim.duchek@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 30, 2010 at 10:47 AM, Jim Duchek <jim.duchek@gmail.com> wro=
te:
<SNIP>
> =C2=A0You're having this happen even if the disk in question is not i=
n an
> array? =C2=A0If so perhaps it's an SATA issue and not a RAID one, and=
 we
> should move this discussion accordingly.

Yes, in my case the delays are so long - sometimes 2 or 3 minutes -
that when I tried to build the system using RAID1 I got this kernel
bug in dmesg. It's jsut info - not a real failure - but because it's
talking about long delays I gave up on RAID and tried a standard
single drive build. Turns out that it has (I think...) nothing to do
with RAID at all. you'll not that there are instructions for turning
the message off but I've not tried them. I intend to do a parallel
RAID1 build on this machine and be able to test both RAID vs non-RAID.

- Mark

INFO: task kjournald:17466 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
kjournald     D ffff8800280bbe00     0 17466      2 0x00000000
 ffff8801adf9d890 0000000000000046 0000000000000000 0000000000000000
 ffff8801adcbde44 0000000000004000 000000000000fe00 000000000000c878
 0000000800000050 ffff88017a99aa40 ffff8801af90a150 ffff8801adf9db08
Call Trace:
 [<ffffffff812dd063>] ? md_make_request+0xb6/0xf1
 [<ffffffff8109c248>] ? sync_buffer+0x0/0x40
 [<ffffffff8137a4fc>] ? io_schedule+0x2d/0x3a
 [<ffffffff8109c283>] ? sync_buffer+0x3b/0x40
 [<ffffffff8137a879>] ? __wait_on_bit+0x41/0x70
 [<ffffffff8109c248>] ? sync_buffer+0x0/0x40
 [<ffffffff8137a913>] ? out_of_line_wait_on_bit+0x6b/0x77
 [<ffffffff810438b2>] ? wake_bit_function+0x0/0x23
 [<ffffffff8109c637>] ? sync_dirty_buffer+0x72/0xaa
 [<ffffffff81131b8e>] ? journal_commit_transaction+0xa74/0xde2
 [<ffffffff8103abcc>] ? lock_timer_base+0x26/0x4b
 [<ffffffff81043884>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff81134804>] ? kjournald+0xe3/0x206
 [<ffffffff81043884>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff81134721>] ? kjournald+0x0/0x206
 [<ffffffff81043591>] ? kthread+0x8b/0x93
 [<ffffffff8100bd3a>] ? child_rip+0xa/0x20
 [<ffffffff81043506>] ? kthread+0x0/0x93
 [<ffffffff8100bd30>] ? child_rip+0x0/0x20
livecd ~ #
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
