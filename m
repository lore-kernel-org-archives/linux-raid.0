From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: BUG: soft lockup in [md4_raid5:21137]
Date: Fri, 18 Sep 2009 10:55:55 -0700
Message-ID: <e9c3a7c20909181055u5d66086chd199f48453c476d8@mail.gmail.com>
References: <Pine.LNX.4.64.0909181255380.21814@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0909181255380.21814@diagnostix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Sep 18, 2009 at 6:05 AM, Holger Kiehl <Holger.Kiehl@dwd.de> wro=
te:
> Hello
>
> I am using kernel.org kernel 2.6.31 and see the following errors in
> /var/log/messages:
>
> =A0 Sep 18 03:49:06 hermes kernel: BUG: soft lockup - CPU#0 stuck for=
 61s!
> [md4_raid5:21137]
> =A0 Sep 18 03:49:06 hermes kernel: Modules linked in: coretemp ipmi_d=
evintf
> ipmi_si ipmi_msghandler bonding nf_conntrack_ftp binfmt_misc usbhid i=
2c_i801
> i2c_core sg i5000_edac ehci_hcd uhci_hcd i5k_amb usbcore [last unload=
ed:
> microcode]
> =A0 Sep 18 03:49:06 hermes kernel: CPU 0:
> =A0 Sep 18 03:49:06 hermes kernel: Modules linked in: coretemp ipmi_d=
evintf
> ipmi_si ipmi_msghandler bonding nf_conntrack_ftp binfmt_misc usbhid i=
2c_i801
> i2c_core sg i5000_edac ehci_hcd uhci_hcd i5k_amb usbcore [last unload=
ed:
> microcode]
> =A0 Sep 18 03:49:06 hermes kernel: Pid: 21137, comm: md4_raid5 Not ta=
inted
> 2.6.31 #1 PRIMERGY RX300 S4
> =A0 Sep 18 03:49:06 hermes kernel: RIP: 0010:[<ffffffff8135a668>]
> =A0[<ffffffff8135a668>] raid6_sse24_gen_syndrome+0xf9/0x251
> =A0 Sep 18 03:49:06 hermes kernel: RSP: 0018:ffff88080d46bb50 =A0EFLA=
GS:
> 00000246
> =A0 Sep 18 03:49:06 hermes kernel: RAX: 0000000000000e80 RBX: ffff880=
80d46bb90
> RCX: ffff8807e49e8000
> =A0 Sep 18 03:49:06 hermes kernel: RDX: 0000000000000000 RSI: 0000000=
000000e80
> RDI: ffff8807e49e9ea0
> =A0 Sep 18 03:49:06 hermes kernel: RBP: ffffffff8102c66e R08: ffff880=
7e49e9e80
> R09: 0000000000000ea0
> =A0 Sep 18 03:49:06 hermes kernel: R10: 0000160000000000 R11: 6db6db6=
db6db6db7
> R12: ffff88080d46bb40
> =A0 Sep 18 03:49:06 hermes kernel: R13: ffffffff8102c4ce R14: 0000000=
000000c31
> R15: 00000000812c6623
> =A0 Sep 18 03:49:06 hermes kernel: FS: =A00000000000000000(0000)
> GS:ffff880028035000(0000) knlGS:0000000000000000
> =A0 Sep 18 03:49:06 hermes kernel: CS: =A00010 DS: 0018 ES: 0018 CR0:
> 0000000080050033
> =A0 Sep 18 03:49:06 hermes kernel: CR2: 000000000042e3a7 CR3: 0000000=
001001000
> CR4: 00000000000426f0
> =A0 Sep 18 03:49:06 hermes kernel: DR0: 0000000000000000 DR1: 0000000=
000000000
> DR2: 0000000000000000
> =A0 Sep 18 03:49:06 hermes kernel: DR3: 0000000000000000 DR6: 0000000=
0ffff0ff0
> DR7: 0000000000000400
> =A0 Sep 18 03:49:06 hermes kernel: Call Trace:
> =A0 Sep 18 03:49:06 hermes kernel: [<ffffffff8135d575>] ?
> compute_parity6+0x2d9/0x376
> =A0 Sep 18 03:49:06 hermes kernel: [<ffffffff8135d783>] ?
> compute_block_1+0x171/0x1c6
> =A0 Sep 18 03:49:06 hermes kernel: [<ffffffff8135f738>] ?
> handle_stripe+0xa85/0x1c24
> =A0 Sep 18 03:49:06 hermes kernel: [<ffffffff81360cbd>] ? raid5d+0x3e=
6/0x439
> =A0 Sep 18 03:49:06 hermes kernel: [<ffffffff8136aee5>] ? md_thread+0=
xfb/0x12d
> =A0 Sep 18 03:49:06 hermes kernel: [<ffffffff8107fbdb>] ?
> autoremove_wake_function+0x0/0x5a
> =A0 Sep 18 03:49:06 hermes kernel: [<ffffffff8136adea>] ? md_thread+0=
x0/0x12d
> =A0 Sep 18 03:49:06 hermes kernel: [<ffffffff8107f7b7>] ? kthread+0x9=
b/0xa3
> =A0 Sep 18 03:49:06 hermes kernel: [<ffffffff8102cbaa>] ? child_rip+0=
xa/0x20
> =A0 Sep 18 03:49:06 hermes kernel: [<ffffffff8107f71c>] ? kthread+0x0=
/0xa3
> =A0 Sep 18 03:49:06 hermes kernel: [<ffffffff8102cba0>] ? child_rip+0=
x0/0x20
>
> This happens on fedora 11 on a data-check of RAID array md4. I get se=
veral
> of these, but the system keeps on running.

Yes, these are harmless.  When resyncing/checking raid6 arrays there
is a probability that when the soft lockup checker fires it frequently
sees the raid thread "stuck" in the parity generation routines.  The
change below should address this, and is on its way upstream for
2.6.32:

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 826eb34..84cd91c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4180,6 +4180,7 @@ static void raid5d(mddev_t *mddev)
                handled++;
                handle_stripe(sh, conf->spare_page);
                release_stripe(sh);
+               cond_resched();

                spin_lock_irq(&conf->device_lock);
        }


> Another system with the same
> setup and hardware seems to always lock up. md4 is a raid6 consisting=
 of
> 8 disks. There is absolutly no load on this array and it has an empty
> ext4 filesystem mounted.

This one does not seem like a raid problem.  Would need more data to
disposition this.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
