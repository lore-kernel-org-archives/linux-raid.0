From: "Michael Schwarz" <mschwarz@multitool.net>
Subject: Re: Failed reads from RAID-0 array (from newbie
 who has read the FAQ)
Date: Sun, 18 Mar 2007 21:27:57 -0600 (CST)
Message-ID: <3923.72.21.237.163.1174274877.squirrel@www.multitool.net>
References: <2885.72.21.237.163.1174167308.squirrel@www.multitool.net>
	<Pine.LNX.4.44L0.0703172208400.16306-100000@netrider.rowland.org>
	<3123.72.21.237.163.1174192963.squirrel@www.multitool.net>
	<3612.72.21.237.163.1174236988.squirrel@www.multitool.net>
	<17917.46554.169905.698240@notabene.brown>
Reply-To: mschwarz@multitool.net
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-bounces@lists.sourceforge.net>
In-Reply-To: <17917.46554.169905.698240@notabene.brown>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-users>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-users-bounces@lists.sourceforge.net
Errors-To: linux-usb-users-bounces@lists.sourceforge.net
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, linux-usb-users@lists.sourceforge.net
List-Id: linux-raid.ids

More than ever, I am convinced that it is actually a hardware problem, but
I am curious for the opinions of both of you on whether the "system"
(meaning, I guess, the combination of usb-storage driver and raid) is
really doing the best with what it has.

My last effort was to switch to a different computer. When I did, I got in
the dmesg log (unfortunately, not preserved, although I should be able to
recreate) that one of the flash drives had bad blocks. Some part of the
system eventually decided it was a "dead device" (I believe dmesg indicate
the scsi subsystem said so). The device (it happened to be /dev/sdc) was
peremptorially dropped from the system. This appears to be what hanged the
raid system.

(Why these messages never appeared on the other computer is beyond me;
obviously some difference in how the actual USB controller reports errors,
but, as I said, I've never studied USB drivers or hardware. In fact, once
you get beyond the UARTs you are getting sophisticated to me)

I've built an array of five known-good devices and so far it works
swimmingly (at least on the hardware that was better at error reporting).

So it seems to me that there is probably nothing actually wrong with the
drivers or their interactions at it leaves me only asking if there should
be some sort of improvement in error reporting/recovery up to userland.

If I am right and the scsi system was marking a device as dead, shouldn't
the userland read against the md device get an error instead of an
indefinite hang?

Beyond this question which I leave to you (although I'd love to hear your
answers/thoughts), I think we can safely say that the problem was hardware
(even if hard to find). If either of you would like, I'd be happy to find
time this week to recreate the error on my "better" PC and send that
along.

As for rolling a custom kernel with more message buffer, well, I'm going
to be getting into a new device driver in the coming months, so a custom
debug kernel is definitely in my future, but I'm not sure when.

I must say, the kernel has become a much more complex beastie since 2.2.x!
(Although it also appears to be improved and somewhat more organized --
but definitely MUCH larger!)

Thank you both so much! I wouldn't even have diagnosed my hardware problem
without your prompts. I'm very grateful. Let me know if you'd like those
dmesg logs or if you'd just like to let it go!

-- 
Michael Schwarz

> On Sunday March 18, mschwarz@multitool.net wrote:
>> cp -rv /mnt/* fs2d2/
>>
>> At this point, the process hangs. So I ran:
>>
>> echo t > /proc/sysrq-trigger
>> dmesg > dmesg-5-hungread.log
>
> Unfortunate (as you say) the whole trace doesn't fit.
> Could you try compiling the kernel with a larger value for
> CONFIG_LOG_BUF_SHIFT ??  It looks like you have 17.  21 is the max.
> 19 should probably be sufficient.
>
> Two things look a bit odd.
> 1/ hald-addon-st (process 3974) seems to be hung doing a
>   'test_unit_ready' after a media-changed signal.  Any idea why?
>   Could you try killing of hald while running the test?
>
> 2/ one usb-storage thread (3667) appears to be waiting for
>   IO to complete (though that is just a guess really).
>
> Maybe usb-storage is waiting for the hald test-unit-ready?
>
> But I'm a bit out of my depth here, so I'll leave it to the USB
> experts.
>
> NeilBrown
>
>  =======================
> hald-addon-st D EF9FBD00  2812  3974   2935          3977  3966 (NOTLB)
>        ef9fbd14 00000086 00000002 ef9fbd00 ef9fbcfc 00000000 00000000
> ed4fcbe4
>        c04dc5cc 00000086 0000000a ed407770 c06fb480 18f88700 00000206
> 00000000
>        ed40787c c1c8c480 00000000 ebe7adc0 001d605d db30e9c8 00000096
> ffffffff
> Call Trace:
>  [<c04dc5cc>] elv_next_request+0xfe/0x1ac
>  [<c061e701>] wait_for_completion+0x73/0x98
>  [<c04226ab>] default_wake_function+0x0/0xc
>  [<c04df415>] blk_execute_rq+0xcf/0xe5
>  [<c04de74f>] blk_end_sync_rq+0x0/0x23
>  [<c04dbdf0>] elv_set_request+0x14/0x22
>  [<c04decda>] get_request+0x205/0x2b2
>  [<c04df4e7>] get_request_wait+0x26/0x16c
>  [<f8de1116>] scsi_execute+0xc6/0xd9 [scsi_mod]
>  [<f8de11e0>] scsi_execute_req+0xb7/0xd5 [scsi_mod]
>  [<f8de1241>] scsi_test_unit_ready+0x43/0x80 [scsi_mod]
>  [<f8d726a5>] sd_media_changed+0x60/0xb5 [sd_mod]
>  [<c04e8c82>] kobject_get+0xf/0x13
>  [<c0491481>] check_disk_change+0x16/0x5c
>  [<c055890a>] class_device_get+0xe/0x14
>  [<f8d72b70>] sd_open+0x92/0x120 [sd_mod]
>  [<c04e14cc>] exact_match+0x0/0x4
>  [<c0491b65>] do_open+0x19f/0x255
>  [<c0491d8e>] blkdev_open+0x0/0x4d
>  [<c0491db3>] blkdev_open+0x25/0x4d
>  [<c0470cac>] __dentry_open+0xc3/0x17a
>  [<c0470ddd>] nameidata_to_filp+0x24/0x33
>  [<c0470e1e>] do_filp_open+0x32/0x39
>  [<c061f0e0>] do_nanosleep+0x42/0x66
>  [<c0470bdf>] get_unused_fd+0xb3/0xbd
>  [<c0470e67>] do_sys_open+0x42/0xbe
>  [<c0470f1c>] sys_open+0x1c/0x1e
>  [<c0403f64>] syscall_call+0x7/0xb
>  =======================
> usb-storage   S 00000010  3048  3667      7          3669  3666 (L-TLB)
>        ebcaee78 00000046 f88459c0 00000010 ebc6b7dc f6de08e4 c0587c0e
> 00000010
>        00000000 c06fb480 0000000a ed5f2bb0 d80fa9b0 e8b0e880 00000205
> 00000000
>        ed5f2cbc c1c8c480 00000000 ebe7a9c0 001d5d31 00000205 00000000
> ffffffff
> Call Trace:
>  [<c0587c0e>] usb_hcd_submit_urb+0x6cd/0x773
>  [<c061ecc2>] schedule_timeout+0x13/0x8d
>  [<c061e925>] wait_for_completion_interruptible_timeout+0x99/0xd5
>  [<c04226ab>] default_wake_function+0x0/0xc
>  [<f8db090c>] usb_stor_msg_common+0xc9/0xe8 [usb_storage]
>  [<f8db0d5f>] usb_stor_bulk_transfer_buf+0x61/0x98 [usb_storage]
>  [<f8db12a9>] usb_stor_Bulk_transport+0xcb/0x221 [usb_storage]
>  [<f8db2022>] usb_stor_control_thread+0x0/0x1a3 [usb_storage]
>  [<f8db1414>] usb_stor_invoke_transport+0x15/0x259 [usb_storage]
>  [<c061fa40>] __down_interruptible+0xde/0xf0
>  [<c04226ab>] default_wake_function+0x0/0xc
>  [<f8db2022>] usb_stor_control_thread+0x0/0x1a3 [usb_storage]
>  [<f8db214a>] usb_stor_control_thread+0x128/0x1a3 [usb_storage]
>  [<c0420a03>] complete+0x39/0x48
>  [<f8db2022>] usb_stor_control_thread+0x0/0x1a3 [usb_storage]
>  [<c043779f>] kthread+0xb0/0xd9
>  [<c04376ef>] kthread+0x0/0xd9
>  [<c0404b33>] kernel_thread_helper+0x7/0x10
>  =======================
>


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys-and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
