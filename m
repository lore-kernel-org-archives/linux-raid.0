From: "Michael Schwarz" <mschwarz@multitool.net>
Subject: Re: Failed reads from RAID-0 array (from newbie who has read the
     FAQ)
Date: Sat, 17 Mar 2007 12:01:38 -0600 (CST)
Message-ID: <2677.72.21.237.163.1174154498.squirrel@www.multitool.net>
References: <1536.72.21.237.163.1174098031.squirrel@www.multitool.net>
    <17915.32057.221461.617241@notabene.brown>
Reply-To: mschwarz@multitool.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17915.32057.221461.617241@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-usb-users@lists.sourceforge.net
List-Id: linux-raid.ids

Neil:

Relevant stack trace follows. Any suggestions? blk_backing_dev_unplug...
Does that mean the raid subsystem thinks one of the usb drives has been
removed? I assure you that physically this is untrue, but that doesn't
mean that some sort logical disconnect hasn't happened...

Makes me wonder if one of my USB hub connections is intermittent...

I would also welcome any tips on any other developers group to follow up
with. I haven't hacked any kernel code since the 2.2.x kernel and things
have changed a bit! I don't mind digging into this, but I suspect I could
get things cleared up fast if I could find the right subject expert!



 =======================
cp            D E2FBEDB0  1784  4271   4270                     (NOTLB)
       e2fbedb4 00200086 c15dc550 e2fbedb0 00000001 00200082 00001000
00000000
       00000000 c15dc550 0000000a e94182b0 f3161430 26320f40 000001c5
00000000
       e94183bc c1c8c480 00000000 ecd7d300 c04e0bf2 c042e0e4 f7d767f8
003b6622
Call Trace:
 [<c04e0bf2>] blk_backing_dev_unplug+0x73/0x7b
 [<c042e0e4>] getnstimeofday+0x30/0xb6
 [<c061ec7e>] io_schedule+0x3a/0x5c
 [<c045626b>] sync_page+0x0/0x3b
 [<c04562a3>] sync_page+0x38/0x3b
 [<c061ed8a>] __wait_on_bit_lock+0x2a/0x52
 [<c045625d>] __lock_page+0x58/0x5e
 [<c043788e>] wake_bit_function+0x0/0x3c
 [<c04569e3>] do_generic_mapping_read+0x1e0/0x459
 [<c0458b0d>] generic_file_aio_read+0x173/0x1a6
 [<c0456070>] file_read_actor+0x0/0xe0
 [<c047202f>] do_sync_read+0xc7/0x10a
 [<c0437859>] autoremove_wake_function+0x0/0x35
 [<c0471f68>] do_sync_read+0x0/0x10a
 [<c04728b6>] vfs_read+0xa6/0x152
 [<c0472d0f>] sys_read+0x41/0x67
 [<c0403f64>] syscall_call+0x7/0xb
 =======================

-- 
Michael Schwarz

> My guess would be a locking bug in the usb storage driver or some
> lower level USB driver..
> A significant difference between raid0 and linear is that a largish IO
> will touch all drives for raid-0, but only one or two for linear.
> That gives much more opportunity for locking bugs to hit.
>
> When it is in the hanging state, do
>   echo t > /proc/sysrq-trigger
>
> and look in the kernel logs for the stack trace of all processes.
> Hopefully the stack trace for the processes in 'D' state will be
> informative.
>
> NeilBrown
>
>
>>
>> Here are my mdadm commands to create the array:
>>
>> mdadm --create /dev/md0 --level=linear --auto=md --chunk=32
>> --raid-devices=7 /dev/sd?
>>
>> (The wildcard works because the seven flash drives are the only scsi
>> devices on the system).
>>
>> The command for the raid-0 array is the same as above except for the
>> "--level=0" it takes to make a raid 0 array.
>>
>> I then use "mkfs" to make the filesystem and mount the resulting array
>> at
>> "/mnt"
>>
>> Can anyone give a raid newbiw some tips? Is there something obvious I'm
>> missing? Would it help to provide strace/ltrace/ptrace of the hanging
>> copy
>> command?
>>
>> Any help (including URLs of manuals I should RTFM) would be most
>> welcome.
>>
>> Thanks!
>>
>>
>> --
>> Michael Schwarz
>>
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

