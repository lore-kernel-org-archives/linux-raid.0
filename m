From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: RCU detected CPU 1 stall (t=4295904002/751 jiffies) Pid: 902, comm: md1_raid5
Date: Tue, 19 May 2009 00:07:40 +0200
Message-ID: <12a901c9d805$119fef20$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list, Neil,

Somebody can say something about this issue?
I am not surprised, if it is hardware related, but this is on a brand new 
server, so i am looking for a solution... :-)
May 17 23:12:13 gladiator-afth1 kernel: RCU detected CPU 1 stall 
(t=4295904002/751 jiffies)
May 17 23:12:13 gladiator-afth1 kernel: Pid: 902, comm: md1_raid5 Not 
tainted 2.6.28.10 #1
May 17 23:12:13 gladiator-afth1 kernel: Call Trace:
May 17 23:12:13 gladiator-afth1 kernel:  <IRQ>  [<ffffffff80265395>] ? 
get_timestamp+0x9/0xf
May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff8026854f>] 
__rcu_pending+0x64/0x1e2
May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff80268703>] 
rcu_pending+0x36/0x6f
May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff8023f546>] 
update_process_times+0x37/0x5f
May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff802504a7>] 
tick_periodic+0x6e/0x7a
May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff802504d4>] 
tick_handle_periodic+0x21/0x65
May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff8021ad60>] 
smp_apic_timer_interrupt+0x8f/0xad
May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff8020bf1b>] 
apic_timer_interrupt+0x6b/0x70
May 17 23:12:13 gladiator-afth1 kernel:  <EOI>  [<ffffffff80820b8f>] ? 
_spin_unlock_irqrestore+0x13/0x17
May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff80728720>] ? 
bitmap_daemon_work+0x142/0x3b0
May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff80724c58>] ? 
md_check_recovery+0x1b/0x45b
May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff8071976c>] ? 
raid5d+0x5d/0x503
May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff80726533>] ? 
md_thread+0xd5/0xed
May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff80248e4a>] ? 
autoremove_wake_function+0x0/0x38
May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff8072645e>] ? 
md_thread+0x0/0xed
May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff80248d3b>] ? 
kthread+0x49/0x76
May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff8020c169>] ? 
child_rip+0xa/0x11
May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff80248cf2>] ? 
kthread+0x0/0x76
May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff8020c15f>] ? 
child_rip+0x0/0x11

The entire log is here:
http://download.netcenter.hu/bughunt/20090518/messages

The system is on the md1, and working, but slowly.
If i left the server for 1 day,  it will crash without a saved log.

Memtest survived >48 hour.

Thanks,
Janos Haar

