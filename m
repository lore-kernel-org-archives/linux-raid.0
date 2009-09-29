From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: BUG: soft lockup in [md4_raid5:21137]
Date: Tue, 29 Sep 2009 09:24:42 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0909290914330.24558@praktifix.dwd.de>
References: <Pine.LNX.4.64.0909181255380.21814@diagnostix.dwd.de>
 <e9c3a7c20909181055u5d66086chd199f48453c476d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="646811178-635646620-1254216282=:24558"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20909181055u5d66086chd199f48453c476d8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--646811178-635646620-1254216282=:24558
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 18 Sep 2009, Dan Williams wrote:

> On Fri, Sep 18, 2009 at 6:05 AM, Holger Kiehl <Holger.Kiehl@dwd.de> wrote:
>> Hello
>>
>> I am using kernel.org kernel 2.6.31 and see the following errors in
>> /var/log/messages:
>>
>>   Sep 18 03:49:06 hermes kernel: BUG: soft lockup - CPU#0 stuck for 61s!
>> [md4_raid5:21137]
>>   Sep 18 03:49:06 hermes kernel: Modules linked in: coretemp ipmi_devintf
>> ipmi_si ipmi_msghandler bonding nf_conntrack_ftp binfmt_misc usbhid i2c_i801
>> i2c_core sg i5000_edac ehci_hcd uhci_hcd i5k_amb usbcore [last unloaded:
>> microcode]
>>   Sep 18 03:49:06 hermes kernel: CPU 0:
>>   Sep 18 03:49:06 hermes kernel: Modules linked in: coretemp ipmi_devintf
>> ipmi_si ipmi_msghandler bonding nf_conntrack_ftp binfmt_misc usbhid i2c_i801
>> i2c_core sg i5000_edac ehci_hcd uhci_hcd i5k_amb usbcore [last unloaded:
>> microcode]
>>   Sep 18 03:49:06 hermes kernel: Pid: 21137, comm: md4_raid5 Not tainted
>> 2.6.31 #1 PRIMERGY RX300 S4
>>   Sep 18 03:49:06 hermes kernel: RIP: 0010:[<ffffffff8135a668>]
>>  [<ffffffff8135a668>] raid6_sse24_gen_syndrome+0xf9/0x251
>>   Sep 18 03:49:06 hermes kernel: RSP: 0018:ffff88080d46bb50  EFLAGS:
>> 00000246
>>   Sep 18 03:49:06 hermes kernel: RAX: 0000000000000e80 RBX: ffff88080d46bb90
>> RCX: ffff8807e49e8000
>>   Sep 18 03:49:06 hermes kernel: RDX: 0000000000000000 RSI: 0000000000000e80
>> RDI: ffff8807e49e9ea0
>>   Sep 18 03:49:06 hermes kernel: RBP: ffffffff8102c66e R08: ffff8807e49e9e80
>> R09: 0000000000000ea0
>>   Sep 18 03:49:06 hermes kernel: R10: 0000160000000000 R11: 6db6db6db6db6db7
>> R12: ffff88080d46bb40
>>   Sep 18 03:49:06 hermes kernel: R13: ffffffff8102c4ce R14: 0000000000000c31
>> R15: 00000000812c6623
>>   Sep 18 03:49:06 hermes kernel: FS:  0000000000000000(0000)
>> GS:ffff880028035000(0000) knlGS:0000000000000000
>>   Sep 18 03:49:06 hermes kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
>> 0000000080050033
>>   Sep 18 03:49:06 hermes kernel: CR2: 000000000042e3a7 CR3: 0000000001001000
>> CR4: 00000000000426f0
>>   Sep 18 03:49:06 hermes kernel: DR0: 0000000000000000 DR1: 0000000000000000
>> DR2: 0000000000000000
>>   Sep 18 03:49:06 hermes kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0
>> DR7: 0000000000000400
>>   Sep 18 03:49:06 hermes kernel: Call Trace:
>>   Sep 18 03:49:06 hermes kernel: [<ffffffff8135d575>] ?
>> compute_parity6+0x2d9/0x376
>>   Sep 18 03:49:06 hermes kernel: [<ffffffff8135d783>] ?
>> compute_block_1+0x171/0x1c6
>>   Sep 18 03:49:06 hermes kernel: [<ffffffff8135f738>] ?
>> handle_stripe+0xa85/0x1c24
>>   Sep 18 03:49:06 hermes kernel: [<ffffffff81360cbd>] ? raid5d+0x3e6/0x439
>>   Sep 18 03:49:06 hermes kernel: [<ffffffff8136aee5>] ? md_thread+0xfb/0x12d
>>   Sep 18 03:49:06 hermes kernel: [<ffffffff8107fbdb>] ?
>> autoremove_wake_function+0x0/0x5a
>>   Sep 18 03:49:06 hermes kernel: [<ffffffff8136adea>] ? md_thread+0x0/0x12d
>>   Sep 18 03:49:06 hermes kernel: [<ffffffff8107f7b7>] ? kthread+0x9b/0xa3
>>   Sep 18 03:49:06 hermes kernel: [<ffffffff8102cbaa>] ? child_rip+0xa/0x20
>>   Sep 18 03:49:06 hermes kernel: [<ffffffff8107f71c>] ? kthread+0x0/0xa3
>>   Sep 18 03:49:06 hermes kernel: [<ffffffff8102cba0>] ? child_rip+0x0/0x20
>>
>> This happens on fedora 11 on a data-check of RAID array md4. I get several
>> of these, but the system keeps on running.
>
> Yes, these are harmless.  When resyncing/checking raid6 arrays there
> is a probability that when the soft lockup checker fires it frequently
> sees the raid thread "stuck" in the parity generation routines.  The
> change below should address this, and is on its way upstream for
> 2.6.32:
>
It does not seem to be in 2.6.32-rc1 because I still get soft lockup BUG
when stress testing the system:

    Sep 29 08:56:32 apollo kernel: BUG: soft lockup - CPU#0 stuck for 61s! [md4_raid6:901]
    Sep 29 08:56:32 apollo kernel: Modules linked in: coretemp ipmi_devintf ipmi_si ipmi_msghandler bonding nf_conntrack_ftp binfmt_misc usbhid i2c_i801 i5000_edac uhci_hcd ehci_hcd i2c_core sg i5k_amb usbcore [last unloaded: microcode]
    Sep 29 08:56:32 apollo kernel: CPU 0:
    Sep 29 08:56:32 apollo kernel: Modules linked in: coretemp ipmi_devintf ipmi_si ipmi_msghandler bonding nf_conntrack_ftp binfmt_misc usbhid i2c_i801 i5000_edac uhci_hcd ehci_hcd i2c_core sg i5k_amb usbcore [last unloaded: microcode]
    Sep 29 08:56:32 apollo kernel: Pid: 901, comm: md4_raid6 Tainted: G        W  2.6.32-rc1 #3 PRIMERGY RX300 S4
    Sep 29 08:56:32 apollo kernel: RIP: 0010:[<ffffffff81446b68>]  [<ffffffff81446b68>] _spin_unlock_irqrestore+0x21/0x3c
    Sep 29 08:56:32 apollo kernel: RSP: 0018:ffff88083ae41cc0  EFLAGS: 00000246
    Sep 29 08:56:32 apollo kernel: RAX: 0000000000000000 RBX: ffff88083ae41cd0 RCX: ffffffff814542c0
    Sep 29 08:56:32 apollo kernel: RDX: ffffffff8165f960 RSI: 0000000000000246 RDI: 0000000000000246
    Sep 29 08:56:32 apollo kernel: RBP: ffffffff8102ee2e R08: 0000000000000000 R09: 0000000000000001
    Sep 29 08:56:32 apollo kernel: R10: 00000020af5f093c R11: 0000000096ff9169 R12: 0000000000000003
    Sep 29 08:56:32 apollo kernel: R13: 0000000000000001 R14: 0000000000000000 R15: 0000000096ff9169
    Sep 29 08:56:32 apollo kernel: FS:  0000000000000000(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
    Sep 29 08:56:32 apollo kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
    Sep 29 08:56:32 apollo kernel: CR2: 0000003bc4cd7420 CR3: 000000082c4ec000 CR4: 00000000000426f0
    Sep 29 08:56:32 apollo kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    Sep 29 08:56:32 apollo kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Sep 29 08:56:32 apollo kernel: Call Trace:
    Sep 29 08:56:32 apollo kernel: [<ffffffff8105d7b0>] ? __wake_up+0x4e/0x6b
    Sep 29 08:56:32 apollo kernel: [<ffffffff8108ad40>] ? __async_schedule+0x10e/0x130
    Sep 29 08:56:32 apollo kernel: [<ffffffff8108ad7e>] ? async_schedule_domain+0x1c/0x32
    Sep 29 08:56:32 apollo kernel: [<ffffffff81379852>] ? raid5d+0x3f8/0x44c
    Sep 29 08:56:32 apollo kernel: [<ffffffff81446b68>] ? _spin_unlock_irqrestore+0x21/0x3c
    Sep 29 08:56:32 apollo kernel: [<ffffffff81383db1>] ? md_thread+0x100/0x132
    Sep 29 08:56:32 apollo kernel: [<ffffffff81084113>] ? autoremove_wake_function+0x0/0x5a
    Sep 29 08:56:32 apollo kernel: [<ffffffff81383cb1>] ? md_thread+0x0/0x132
    Sep 29 08:56:32 apollo kernel: [<ffffffff81083d04>] ? kthread+0x89/0x91
    Sep 29 08:56:32 apollo kernel: [<ffffffff8102f36a>] ? child_rip+0xa/0x20
    Sep 29 08:56:32 apollo kernel: [<ffffffff81083c7b>] ? kthread+0x0/0x91
    Sep 29 08:56:32 apollo kernel: [<ffffffff8102f360>] ? child_rip+0x0/0x20
    Sep 29 09:02:15 apollo kernel: BUG: soft lockup - CPU#1 stuck for 61s! [md4_raid6:901]
    Sep 29 09:02:15 apollo kernel: Modules linked in: coretemp ipmi_devintf ipmi_si ipmi_msghandler bonding nf_conntrack_ftp binfmt_misc usbhid i2c_i801 i5000_edac uhci_hcd ehci_hcd i2c_core sg i5k_amb usbcore [last unloaded: microcode]
    Sep 29 09:02:15 apollo kernel: CPU 1:
    Sep 29 09:02:15 apollo kernel: Modules linked in: coretemp ipmi_devintf ipmi_si ipmi_msghandler bonding nf_conntrack_ftp binfmt_misc usbhid i2c_i801 i5000_edac uhci_hcd ehci_hcd i2c_core sg i5k_amb usbcore [last unloaded: microcode]
    Sep 29 09:02:15 apollo kernel: Pid: 901, comm: md4_raid6 Tainted: G        W  2.6.32-rc1 #3 PRIMERGY RX300 S4
    Sep 29 09:02:15 apollo kernel: RIP: 0010:[<ffffffff81446b68>]  [<ffffffff81446b68>] _spin_unlock_irqrestore+0x21/0x3c
    Sep 29 09:02:15 apollo kernel: RSP: 0018:ffff88083ae41cc0  EFLAGS: 00000246
    Sep 29 09:02:15 apollo kernel: RAX: 0000000000000000 RBX: ffff88083ae41cd0 RCX: ffffffff814542c0
    Sep 29 09:02:15 apollo kernel: RDX: ffffffff8165f960 RSI: 0000000000000246 RDI: 0000000000000246
    Sep 29 09:02:15 apollo kernel: RBP: ffffffff8102ee2e R08: 0000000000000000 R09: 0000000000000000
    Sep 29 09:02:15 apollo kernel: R10: 0000005bc98d81e2 R11: 0000000096ff9169 R12: 0000000000000003
    Sep 29 09:02:15 apollo kernel: R13: 0000000000000001 R14: 0000000000000001 R15: 0000000096ff9169
    Sep 29 09:02:15 apollo kernel: FS:  0000000000000000(0000) GS:ffff880028240000(0000) knlGS:0000000000000000
    Sep 29 09:02:15 apollo kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
    Sep 29 09:02:15 apollo kernel: CR2: 00007f4634dc53b0 CR3: 0000000001001000 CR4: 00000000000426e0
    Sep 29 09:02:15 apollo kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    Sep 29 09:02:15 apollo kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Sep 29 09:02:15 apollo kernel: Call Trace:
    Sep 29 09:02:15 apollo kernel: [<ffffffff8105d7b0>] ? __wake_up+0x4e/0x6b
    Sep 29 09:02:15 apollo kernel: [<ffffffff8108ad40>] ? __async_schedule+0x10e/0x130
    Sep 29 09:02:15 apollo kernel: [<ffffffff8108ad7e>] ? async_schedule_domain+0x1c/0x32
    Sep 29 09:02:15 apollo kernel: [<ffffffff81379852>] ? raid5d+0x3f8/0x44c
    Sep 29 09:02:15 apollo kernel: [<ffffffff81446b68>] ? _spin_unlock_irqrestore+0x21/0x3c
    Sep 29 09:02:15 apollo kernel: [<ffffffff81383db1>] ? md_thread+0x100/0x132
    Sep 29 09:02:15 apollo kernel: [<ffffffff81084113>] ? autoremove_wake_function+0x0/0x5a
    Sep 29 09:02:15 apollo kernel: [<ffffffff81383cb1>] ? md_thread+0x0/0x132
    Sep 29 09:02:15 apollo kernel: [<ffffffff81083d04>] ? kthread+0x89/0x91
    Sep 29 09:02:15 apollo kernel: [<ffffffff8102f36a>] ? child_rip+0xa/0x20
    Sep 29 09:02:15 apollo kernel: [<ffffffff81083c7b>] ? kthread+0x0/0x91
    Sep 29 09:02:15 apollo kernel: [<ffffffff8102f360>] ? child_rip+0x0/0x20

The system also becomes very unresponsive. How can I fix this since it
looks your patch does not apply to 2.6.32-rc1. Or is this another bug,
since I have enabled CONFIG_MULTICORE_RAID456.

Thanks,
Holger
--646811178-635646620-1254216282=:24558--
