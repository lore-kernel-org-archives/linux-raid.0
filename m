From: "Michael Schwarz" <mschwarz@multitool.net>
Subject: Re: Failed reads from RAID-0 array (from newbie
 who has read the FAQ)
Date: Sat, 17 Mar 2007 15:35:08 -0600 (CST)
Message-ID: <2885.72.21.237.163.1174167308.squirrel@www.multitool.net>
References: <2677.72.21.237.163.1174154498.squirrel@www.multitool.net>
	<Pine.LNX.4.44L0.0703171642270.29501-100000@netrider.rowland.org>
Reply-To: mschwarz@multitool.net
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-bounces@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0703171642270.29501-100000@netrider.rowland.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-users>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-users-bounces@lists.sourceforge.net
Errors-To: linux-usb-users-bounces@lists.sourceforge.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-usb-users@lists.sourceforge.net
List-Id: linux-raid.ids

Comments/questions below...

-- 
Michael Schwarz


>
> This isn't much help.  The important processes here are khubd,
> usb-storage, and scsi_eh_*.  Possibly some raid-related processes too, but
> I don't know which they would be.

I have no copy khubd running. What is the list policy on attachments? I
have the kernel stack traces for the kernel threads you want, but the text
is rather long. Being new to the group I do not know if I should just go
ahead and paste something that long in here, or if it should be a MIME
attachment. Can you (or someone) tell me, and I'll provide what is asked
for. Aw, heck... I'll just put it at the end...

> It also would help a lot to see your dmesg log.  Especially if you would
> build your kernel with CONFIG_USB_DEBUG turned on.

I saw nothing unusual in the dmesg log, and I'm fairly familiar with
reading it. I'm working with a stock FC6 kernel right now, but I will
eventually roll my own with that flag on if we get to where we need
that...

I'm hoping some wise heads here will be able to make something out of some
more logs and stack traces before I go that far...

>
>> I begin to suspect that I have a "dead spot" in my USB hub. But what
>> gets
>> me if that is true is why does the write work? Do cp and dd not check to
>> see if writes succeed?
>
> Depends what you mean.  They do check the return codes from the underlying
> device drivers, but they don't try to read the data back to make sure it
> really was written.

Yeah, I meant return codes from the system calls.

>
>> I know it isn't a particular flash drive because I've used two different
>> sets of 7 USB drives and it seems to fail consistently no matter which.
>
> But you haven't tried using different hubs, different USB cables, or
> different computers.

I just got back from buying a different hub and different cables to do
just that. And I do have a different computer to try, but will try that
last.

>
>> Nonetheless, I'm beginning to think I'm dealing with a hardware issue,
>> not
>> a kernel issue, just because it is so consistent.
>
> People have reported problems in which the hardware fails when it
> encounters a certain pattern of bytes in the data stream.  Maybe you're
> seeing the same sort of thing.

This theory is (somewhat) blown by the fact that I have tried different
data sources (from vobcopied DVD images to dd'ed images of Linux distros).
I suppose I could try just a large file of zeros...

Anyways, while the list readers ponder this message, I'm going to try the
new hub and cables. Thanks Alan and Neil!

Nasty big stack trace set follows:

Mar 17 16:13:08 localhost kernel:  =======================
Mar 17 16:13:08 localhost kernel: scsi_eh_7     S 00000000  3744  4385    
 7          4386  2257 (L-TLB)
Mar 17 16:13:08 localhost kernel:        ebe2af68 00000046 00000000
00000000 c1c8c94c f7da30f0 c0420c7c c1c8c480
Mar 17 16:13:08 localhost kernel:        f7da30f0 ebe2af28 00000008
e7676d30 f7da25f0 a0caa580 00000032 00000000
Mar 17 16:13:08 localhost kernel:        e7676e3c c1c8c480 00000000
f7f53880 f7da30f0 c1c8c94c f7d98f2c f7f53880
Mar 17 16:13:08 localhost kernel: Call Trace:
Mar 17 16:13:08 localhost kernel:  [<c0420c7c>] enqueue_task+0x29/0x39
Mar 17 16:13:08 localhost kernel:  [<c061fc0d>] _spin_unlock_irq+0x5/0x7
Mar 17 16:13:08 localhost kernel:  [<c061e5c1>]
__sched_text_start+0x999/0xa21
Mar 17 16:13:08 localhost kernel:  [<f88e5415>]
scsi_error_handler+0x0/0x9b6 [scsi_mod]
Mar 17 16:13:08 localhost kernel:  [<f88e5474>]
scsi_error_handler+0x5f/0x9b6 [scsi_mod]
Mar 17 16:13:08 localhost kernel:  [<c0420a03>] complete+0x39/0x48
Mar 17 16:13:08 localhost kernel:  [<f88e5415>]
scsi_error_handler+0x0/0x9b6 [scsi_mod]
Mar 17 16:13:08 localhost kernel:  [<c043779f>] kthread+0xb0/0xd9
Mar 17 16:13:08 localhost kernel:  [<c04376ef>] kthread+0x0/0xd9
Mar 17 16:13:08 localhost kernel:  [<c0404b33>] kernel_thread_helper+0x7/0x10
Mar 17 16:13:08 localhost kernel:  =======================
Mar 17 16:13:08 localhost kernel: usb-storage   S F7E08840  3048  4386    
 7          4410  4385 (L-TLB)
Mar 17 16:13:08 localhost kernel:        f3272f5c 00000046 f3272eec
f7e08840 e764f000 f3efa000 f88cbd5f c1c8c4d4
Mar 17 16:13:08 localhost kernel:        f7da0b30 c0420c7c 0000000a
f7da25f0 f7da0b30 6ce38240 0000096b 00000000
Mar 17 16:13:08 localhost kernel:        f7da26fc c1c8c480 00000000
ec92ec40 00000000 0000000f 00000000 00000000
Mar 17 16:13:08 localhost kernel: Call Trace:
Mar 17 16:13:08 localhost kernel:  [<f88cbd5f>]
usb_stor_bulk_transfer_buf+0x61/0x98 [usb_storage]
Mar 17 16:13:08 localhost kernel:  [<c0420c7c>] enqueue_task+0x29/0x39
Mar 17 16:13:08 localhost kernel:  [<c061fa0d>]
__down_interruptible+0xab/0xf0
Mar 17 16:13:08 localhost kernel:  [<c042f220>] del_timer+0x41/0x47
Mar 17 16:13:08 localhost kernel:  [<c04226ab>] default_wake_function+0x0/0xc
Mar 17 16:13:08 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:08 localhost kernel:  [<c061f8ef>]
__down_failed_interruptible+0x7/0xc
Mar 17 16:13:08 localhost kernel:  [<f88cd067>]
usb_stor_control_thread+0x45/0x1a3 [usb_storage]
Mar 17 16:13:08 localhost kernel:  [<c0420a03>] complete+0x39/0x48
Mar 17 16:13:08 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:08 localhost kernel:  [<c043779f>] kthread+0xb0/0xd9
Mar 17 16:13:08 localhost kernel:  [<c04376ef>] kthread+0x0/0xd9
Mar 17 16:13:08 localhost kernel:  [<c0404b33>] kernel_thread_helper+0x7/0x10
Mar 17 16:13:08 localhost kernel:  =======================
Mar 17 16:13:08 localhost kernel: scsi_eh_8     S 00000000  3744  4410    
 7          4411  4386 (L-TLB)
Mar 17 16:13:08 localhost kernel:        f1ad2f68 00000046 00000000
00000000 c1c8c4d4 f7da30f0 c0420c7c c1c8c480
Mar 17 16:13:08 localhost kernel:        f7da30f0 f1ad2f28 00000009
f3f150f0 f3f145f0 b0d342c0 00000032 00000000
Mar 17 16:13:08 localhost kernel:        f3f151fc c1c8c480 00000000
f7f53880 f7da30f0 c1c8c4d4 f7d98f2c f7f53880
Mar 17 16:13:08 localhost kernel: Call Trace:
Mar 17 16:13:08 localhost kernel:  [<c0420c7c>] enqueue_task+0x29/0x39
Mar 17 16:13:08 localhost kernel:  [<c061fc0d>] _spin_unlock_irq+0x5/0x7
Mar 17 16:13:09 localhost kernel:  [<c061e5c1>]
__sched_text_start+0x999/0xa21
Mar 17 16:13:09 localhost kernel:  [<f88e5415>]
scsi_error_handler+0x0/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<f88e5474>]
scsi_error_handler+0x5f/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<c0420a03>] complete+0x39/0x48
Mar 17 16:13:09 localhost kernel:  [<f88e5415>]
scsi_error_handler+0x0/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<c043779f>] kthread+0xb0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c04376ef>] kthread+0x0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c0404b33>] kernel_thread_helper+0x7/0x10
Mar 17 16:13:09 localhost kernel:  =======================
Mar 17 16:13:09 localhost kernel: usb-storage   S F3F03B40  3068  4411    
 7          4436  4410 (L-TLB)
Mar 17 16:13:09 localhost kernel:        e3339f5c 00000046 e3339eec
f3f03b40 e9355400 f3efa080 f88cbd5f c1c8c4d4
Mar 17 16:13:09 localhost kernel:        f7da0b30 c0420c7c 0000000a
f3f145f0 f7da0b30 7578c640 0000096b 00000000
Mar 17 16:13:09 localhost kernel:        f3f146fc c1c8c480 00000000
e9ddad40 00000000 0000000f 00000000 00000000
Mar 17 16:13:09 localhost kernel: Call Trace:
Mar 17 16:13:09 localhost kernel:  [<f88cbd5f>]
usb_stor_bulk_transfer_buf+0x61/0x98 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c0420c7c>] enqueue_task+0x29/0x39
Mar 17 16:13:09 localhost kernel:  [<c061fa0d>]
__down_interruptible+0xab/0xf0
Mar 17 16:13:09 localhost kernel:  [<c042f220>] del_timer+0x41/0x47
Mar 17 16:13:09 localhost kernel:  [<c04226ab>] default_wake_function+0x0/0xc
Mar 17 16:13:09 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c061f8ef>]
__down_failed_interruptible+0x7/0xc
Mar 17 16:13:09 localhost kernel:  [<f88cd067>]
usb_stor_control_thread+0x45/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c0420a03>] complete+0x39/0x48
Mar 17 16:13:09 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c043779f>] kthread+0xb0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c04376ef>] kthread+0x0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c0404b33>] kernel_thread_helper+0x7/0x10
Mar 17 16:13:09 localhost kernel:  =======================
Mar 17 16:13:09 localhost kernel: scsi_eh_9     S 00000000  3744  4436    
 7          4437  4411 (L-TLB)
Mar 17 16:13:09 localhost kernel:        e31b4f68 00000046 00000000
00000000 c1c8c4d4 f7da30f0 c0420c7c c1c8c480
Mar 17 16:13:09 localhost kernel:        f7da30f0 e31b4f28 00000009
f3e2c2b0 e2c70db0 c0cc9dc0 00000032 00000000
Mar 17 16:13:09 localhost kernel:        f3e2c3bc c1c8c480 00000000
f3ce14c0 f7da30f0 c1c8c4d4 f7d98f2c f3ce14c0
Mar 17 16:13:09 localhost kernel: Call Trace:
Mar 17 16:13:09 localhost kernel:  [<c0420c7c>] enqueue_task+0x29/0x39
Mar 17 16:13:09 localhost kernel:  [<c061fc0d>] _spin_unlock_irq+0x5/0x7
Mar 17 16:13:09 localhost kernel:  [<c061e5c1>]
__sched_text_start+0x999/0xa21
Mar 17 16:13:09 localhost kernel:  [<f88e5415>]
scsi_error_handler+0x0/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<f88e5474>]
scsi_error_handler+0x5f/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<c0420a03>] complete+0x39/0x48
Mar 17 16:13:09 localhost kernel:  [<f88e5415>]
scsi_error_handler+0x0/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<c043779f>] kthread+0xb0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c04376ef>] kthread+0x0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c0404b33>] kernel_thread_helper+0x7/0x10
Mar 17 16:13:09 localhost kernel:  =======================
Mar 17 16:13:09 localhost kernel: usb-storage   S F3D0B440  3048  4437    
 7          4451  4436 (L-TLB)
Mar 17 16:13:09 localhost kernel:        e2cc8f5c 00000046 e2cc8eec
f3d0b440 f3cc0400 f3efa100 f88cbd5f c1c8c4d4
Mar 17 16:13:09 localhost kernel:        f7da0b30 c0420c7c 0000000a
e2c70db0 f7da0b30 5cf96980 0000096b 00000000
Mar 17 16:13:09 localhost kernel:        e2c70ebc c1c8c480 00000000
e9316180 00000000 0000000f 00000000 00000000
Mar 17 16:13:09 localhost kernel: Call Trace:
Mar 17 16:13:09 localhost kernel:  [<f88cbd5f>]
usb_stor_bulk_transfer_buf+0x61/0x98 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c0420c7c>] enqueue_task+0x29/0x39
Mar 17 16:13:09 localhost kernel:  [<c061fa0d>]
__down_interruptible+0xab/0xf0
Mar 17 16:13:09 localhost kernel:  [<c042f220>] del_timer+0x41/0x47
Mar 17 16:13:09 localhost kernel:  [<c04226ab>] default_wake_function+0x0/0xc
Mar 17 16:13:09 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c061f8ef>]
__down_failed_interruptible+0x7/0xc
Mar 17 16:13:09 localhost kernel:  [<f88cd067>]
usb_stor_control_thread+0x45/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c0420a03>] complete+0x39/0x48
Mar 17 16:13:09 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c043779f>] kthread+0xb0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c04376ef>] kthread+0x0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c0404b33>] kernel_thread_helper+0x7/0x10
Mar 17 16:13:09 localhost kernel:  =======================
Mar 17 16:13:09 localhost kernel: scsi_eh_10    S 00000000  3744  4451    
 7          4452  4437 (L-TLB)
Mar 17 16:13:09 localhost kernel:        e3368f68 00000046 00000000
00000000 c1c8c94c f7da30f0 c0420c7c c1c8c480
Mar 17 16:13:09 localhost kernel:        f7da30f0 e3368f28 00000009
ea739870 ea738270 d0d53b00 00000032 00000000
Mar 17 16:13:09 localhost kernel:        ea73997c c1c8c480 00000000
f7f53880 f7d086f0 c1c8c94c f7d10c80 f7f53880
Mar 17 16:13:09 localhost kernel: Call Trace:
Mar 17 16:13:09 localhost kernel:  [<c0420c7c>] enqueue_task+0x29/0x39
Mar 17 16:13:09 localhost kernel:  [<c061fc0d>] _spin_unlock_irq+0x5/0x7
Mar 17 16:13:09 localhost kernel:  [<c061e5c1>]
__sched_text_start+0x999/0xa21
Mar 17 16:13:09 localhost kernel:  [<f88e5415>]
scsi_error_handler+0x0/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<f88e5474>]
scsi_error_handler+0x5f/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<c0420a03>] complete+0x39/0x48
Mar 17 16:13:09 localhost kernel:  [<f88e5415>]
scsi_error_handler+0x0/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<c043779f>] kthread+0xb0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c04376ef>] kthread+0x0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c0404b33>] kernel_thread_helper+0x7/0x10
Mar 17 16:13:09 localhost kernel:  =======================
Mar 17 16:13:09 localhost kernel: usb-storage   S F3F03CC0  3032  4452    
 7          4476  4451 (L-TLB)
Mar 17 16:13:09 localhost kernel:        e3352f5c 00000046 e3352eec
f3f03cc0 f3cbc000 f3efa180 f88cbd5f c1c8c4d4
Mar 17 16:13:09 localhost kernel:        f7da0b30 c0420c7c 0000000a
ea738270 f7da0b30 aab2df80 0000096b 00000000
Mar 17 16:13:09 localhost kernel:        ea73837c c1c8c480 00000000
f3fb8540 00000000 0000000f 00000000 00000000
Mar 17 16:13:09 localhost kernel: Call Trace:
Mar 17 16:13:09 localhost kernel:  [<f88cbd5f>]
usb_stor_bulk_transfer_buf+0x61/0x98 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c0420c7c>] enqueue_task+0x29/0x39
Mar 17 16:13:09 localhost kernel:  [<c061fa0d>]
__down_interruptible+0xab/0xf0
Mar 17 16:13:09 localhost kernel:  [<c042f220>] del_timer+0x41/0x47
Mar 17 16:13:09 localhost kernel:  [<c04226ab>] default_wake_function+0x0/0xc
Mar 17 16:13:09 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c061f8ef>]
__down_failed_interruptible+0x7/0xc
Mar 17 16:13:09 localhost kernel:  [<f88cd067>]
usb_stor_control_thread+0x45/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c0420a03>] complete+0x39/0x48
Mar 17 16:13:09 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c043779f>] kthread+0xb0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c04376ef>] kthread+0x0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c0404b33>] kernel_thread_helper+0x7/0x10
Mar 17 16:13:09 localhost kernel:  =======================
Mar 17 16:13:09 localhost kernel: scsi_eh_11    D 00000000  3688  4476    
 7          4477  4452 (L-TLB)
Mar 17 16:13:09 localhost kernel:        f32eff30 00000046 00000000
00000000 00000000 00000000 f3f16260 c1c89780
Mar 17 16:13:09 localhost kernel:        00000000 00000000 0000000a
e32a2e30 f3f160b0 31528500 00000254 00000000
Mar 17 16:13:09 localhost kernel:        e32a2f3c c1c8c480 00000000
e9316b80 00000096 f7cb1400 f7e08640 f7e08640
Mar 17 16:13:09 localhost kernel: Call Trace:
Mar 17 16:13:09 localhost kernel:  [<c0586b4f>] unlink1+0x74/0x86
Mar 17 16:13:09 localhost kernel:  [<c061e701>] wait_for_completion+0x73/0x98
Mar 17 16:13:09 localhost kernel:  [<c04226ab>] default_wake_function+0x0/0xc
Mar 17 16:13:09 localhost kernel:  [<f88cb53a>] command_abort+0x64/0x6d
[usb_storage]
Mar 17 16:13:09 localhost kernel:  [<f88e57a3>]
scsi_error_handler+0x38e/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<c0420a03>] complete+0x39/0x48
Mar 17 16:13:09 localhost kernel:  [<f88e5415>]
scsi_error_handler+0x0/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<c043779f>] kthread+0xb0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c04376ef>] kthread+0x0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c0404b33>] kernel_thread_helper+0x7/0x10
Mar 17 16:13:09 localhost kernel:  =======================
Mar 17 16:13:09 localhost kernel: usb-storage   S 00000010  3048  4477    
 7          4500  4476 (L-TLB)
Mar 17 16:13:09 localhost kernel:        e31dee78 00000046 f88459c0
00000010 f7e0865c f3da8364 c0587c0e 00000010
Mar 17 16:13:09 localhost kernel:        00000000 f7da25f0 0000000a
edb68630 f7da25f0 390b2d00 00000246 00000000
Mar 17 16:13:09 localhost kernel:        edb6873c c1c8c480 00000000
ec92ec40 00219434 c04062cf 00000073 ffffffff
Mar 17 16:13:09 localhost kernel: Call Trace:
Mar 17 16:13:09 localhost kernel:  [<c0587c0e>]
usb_hcd_submit_urb+0x6cd/0x773
Mar 17 16:13:09 localhost kernel:  [<c04062cf>] do_IRQ+0xc6/0xdb
Mar 17 16:13:09 localhost kernel:  [<c061ecc2>] schedule_timeout+0x13/0x8d
Mar 17 16:13:09 localhost kernel:  [<c061e925>]
wait_for_completion_interruptible_timeout+0x99/0xd5
Mar 17 16:13:09 localhost kernel:  [<c04226ab>] default_wake_function+0x0/0xc
Mar 17 16:13:09 localhost kernel:  [<f88cb90c>]
usb_stor_msg_common+0xc9/0xe8 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<f88cbd5f>]
usb_stor_bulk_transfer_buf+0x61/0x98 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<f88cc2a9>]
usb_stor_Bulk_transport+0xcb/0x221 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<f88cc414>]
usb_stor_invoke_transport+0x15/0x259 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c061fa40>]
__down_interruptible+0xde/0xf0
Mar 17 16:13:09 localhost kernel:  [<c04226ab>] default_wake_function+0x0/0xc
Mar 17 16:13:09 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<f88cd14a>]
usb_stor_control_thread+0x128/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c0420a03>] complete+0x39/0x48
Mar 17 16:13:09 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c043779f>] kthread+0xb0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c04376ef>] kthread+0x0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c0404b33>] kernel_thread_helper+0x7/0x10
Mar 17 16:13:09 localhost kernel:  =======================
Mar 17 16:13:09 localhost kernel: scsi_eh_12    S 00000000  3744  4500    
 7          4501  4477 (L-TLB)
Mar 17 16:13:09 localhost kernel:        e2d43f68 00000046 00000000
00000000 c1c8c4d4 f7da30f0 c0420c7c c1c8c480
Mar 17 16:13:09 localhost kernel:        f7da30f0 e2d43f28 00000009
e2d4d370 e2c71330 f0c7f100 00000032 00000000
Mar 17 16:13:09 localhost kernel:        e2d4d47c c1c8c480 00000000
f7f53880 f7da30f0 c1c8c4d4 f7d98f2c f7f53880
Mar 17 16:13:09 localhost kernel: Call Trace:
Mar 17 16:13:09 localhost kernel:  [<c0420c7c>] enqueue_task+0x29/0x39
Mar 17 16:13:09 localhost kernel:  [<c061fc0d>] _spin_unlock_irq+0x5/0x7
Mar 17 16:13:09 localhost kernel:  [<c061e5c1>]
__sched_text_start+0x999/0xa21
Mar 17 16:13:09 localhost kernel:  [<f88e5415>]
scsi_error_handler+0x0/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<f88e5474>]
scsi_error_handler+0x5f/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<c0420a03>] complete+0x39/0x48
Mar 17 16:13:09 localhost kernel:  [<f88e5415>]
scsi_error_handler+0x0/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<c043779f>] kthread+0xb0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c04376ef>] kthread+0x0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c0404b33>] kernel_thread_helper+0x7/0x10
Mar 17 16:13:09 localhost kernel:  =======================
Mar 17 16:13:09 localhost kernel: usb-storage   S F3D0B740  3048  4501    
 7          4518  4500 (L-TLB)
Mar 17 16:13:09 localhost kernel:        f1315f5c 00000046 f1315eec
f3d0b740 e764f400 f3efa280 f88cbd5f c1c8c4d4
Mar 17 16:13:09 localhost kernel:        f7da0b30 c0420c7c 0000000a
e2c71330 f7da0b30 a4522ec0 0000096b 00000000
Mar 17 16:13:09 localhost kernel:        e2c7143c c1c8c480 00000000
e9ddab40 00000000 0000000f 00000000 00000000
Mar 17 16:13:09 localhost kernel: Call Trace:
Mar 17 16:13:09 localhost kernel:  [<f88cbd5f>]
usb_stor_bulk_transfer_buf+0x61/0x98 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c0420c7c>] enqueue_task+0x29/0x39
Mar 17 16:13:09 localhost kernel:  [<c061fa0d>]
__down_interruptible+0xab/0xf0
Mar 17 16:13:09 localhost kernel:  [<c042f220>] del_timer+0x41/0x47
Mar 17 16:13:09 localhost kernel:  [<c04226ab>] default_wake_function+0x0/0xc
Mar 17 16:13:09 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c061f8ef>]
__down_failed_interruptible+0x7/0xc
Mar 17 16:13:09 localhost kernel:  [<f88cd067>]
usb_stor_control_thread+0x45/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c0420a03>] complete+0x39/0x48
Mar 17 16:13:09 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c043779f>] kthread+0xb0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c04376ef>] kthread+0x0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c0404b33>] kernel_thread_helper+0x7/0x10
Mar 17 16:13:09 localhost kernel:  =======================
Mar 17 16:13:09 localhost kernel: scsi_eh_13    S 00000000  3744  4518    
 7          4519  4501 (L-TLB)
Mar 17 16:13:09 localhost kernel:        e2d2af68 00000046 00000000
00000000 c1c8c94c f7da30f0 c0420c7c c1c8c480
Mar 17 16:13:09 localhost kernel:        f7da30f0 e2d2af28 00000009
e2d4d8f0 e2c718b0 00c14c00 00000033 00000000
Mar 17 16:13:09 localhost kernel:        e2d4d9fc c1c8c480 00000000
f7f53880 f7d086f0 c1c8c94c f7d10c80 f7f53880
Mar 17 16:13:09 localhost kernel: Call Trace:
Mar 17 16:13:09 localhost kernel:  [<c0420c7c>] enqueue_task+0x29/0x39
Mar 17 16:13:09 localhost kernel:  [<c061fc0d>] _spin_unlock_irq+0x5/0x7
Mar 17 16:13:09 localhost kernel:  [<c061e5c1>]
__sched_text_start+0x999/0xa21
Mar 17 16:13:09 localhost kernel:  [<f88e5415>]
scsi_error_handler+0x0/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<f88e5474>]
scsi_error_handler+0x5f/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<c0420a03>] complete+0x39/0x48
Mar 17 16:13:09 localhost kernel:  [<f88e5415>]
scsi_error_handler+0x0/0x9b6 [scsi_mod]
Mar 17 16:13:09 localhost kernel:  [<c043779f>] kthread+0xb0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c04376ef>] kthread+0x0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c0404b33>] kernel_thread_helper+0x7/0x10
Mar 17 16:13:09 localhost kernel:  =======================
Mar 17 16:13:09 localhost kernel: usb-storage   S F7E088C0  3068  4519    
 7          4976  4518 (L-TLB)
Mar 17 16:13:09 localhost kernel:        e2c3ff5c 00000046 e2c3feec
f7e088c0 f3cc1400 f3efa300 f88cbd5f c1c8c4d4
Mar 17 16:13:09 localhost kernel:        f7da0b30 c0420c7c 0000000a
e2c718b0 f7da0b30 9f5071c0 0000096b 00000000
Mar 17 16:13:09 localhost kernel:        e2c719bc c1c8c480 00000000
e2c445c0 00000000 0000000f 00000000 00000000
Mar 17 16:13:09 localhost kernel: Call Trace:
Mar 17 16:13:09 localhost kernel:  [<f88cbd5f>]
usb_stor_bulk_transfer_buf+0x61/0x98 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c0420c7c>] enqueue_task+0x29/0x39
Mar 17 16:13:09 localhost kernel:  [<c061fa0d>]
__down_interruptible+0xab/0xf0
Mar 17 16:13:09 localhost kernel:  [<c042f220>] del_timer+0x41/0x47
Mar 17 16:13:09 localhost kernel:  [<c04226ab>] default_wake_function+0x0/0xc
Mar 17 16:13:09 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c061f8ef>]
__down_failed_interruptible+0x7/0xc
Mar 17 16:13:09 localhost kernel:  [<f88cd067>]
usb_stor_control_thread+0x45/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c0420a03>] complete+0x39/0x48
Mar 17 16:13:09 localhost kernel:  [<f88cd022>]
usb_stor_control_thread+0x0/0x1a3 [usb_storage]
Mar 17 16:13:09 localhost kernel:  [<c043779f>] kthread+0xb0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c04376ef>] kthread+0x0/0xd9
Mar 17 16:13:09 localhost kernel:  [<c0404b33>] kernel_thread_helper+0x7/0x10


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
