From: Vilhelm von Ehrenheim <vonehrenheim@gmail.com>
Subject: Re: Reshape of RAID5 array from 3 to 4 disks frozen
Date: Tue, 9 Jun 2015 09:07:08 +0200
Message-ID: <CAJ1MkgJrbk+KQaCOBBj28M+JaBBp=x5KBub7sqrRpU128OfgGw@mail.gmail.com>
References: <CAJ1MkgJWoeKr+uT39AVwHOax_Z12ZF1G6v9nUz1OLvSkewQQqg@mail.gmail.com>
	<CAGivzjHHm=faBv_+12ZMKE3=Se=tbja8uLJ1P6xvcMO2kgPYbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGivzjHHm=faBv_+12ZMKE3=Se=tbja8uLJ1P6xvcMO2kgPYbQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Wahler <dwahler@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again!
Thank you so much for this! Really cool. I patched the kernel changing
the line as you said and now the reshape is now continuing. Holding my
breath that it will finish but all looks ok so far.

I needed to change the patch a little as it was for an older kernel so
the lines changed a bit.  This is what i used for linux 4.0.5:

--- a/drivers/md/raid5.c        2015-06-08 23:05:02.808214213 +0200
+++ b/drivers/md/raid5.c        2015-06-08 23:05:47.601355604 +0200
@@ -3855,7 +3855,7 @@
         */
        if (s.failed > conf->max_degraded) {
                sh->check_state = 0;
-               sh->reconstruct_state = 0;
+               //sh->reconstruct_state = 0;
                if (s.to_read+s.to_write+s.written)
                        handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
                if (s.syncing + s.replacing)

Thank you again. :)

/ Vilhelm

On Mon, Jun 8, 2015 at 9:31 AM, David Wahler <dwahler@gmail.com> wrote:
> On Mon, Jun 8, 2015 at 1:19 AM, Vilhelm von Ehrenheim
> <vonehrenheim@gmail.com> wrote:
>> One thing that is strange and that seem to be connected to the reshape
>> is this error, present in dmesg:
>>
>>     [  360.625322] INFO: task md0_reshape:126 blocked for more than 120 seconds.
>>     [  360.625351]       Not tainted 4.0.4-2-ARCH #1
>>     [  360.625367] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>>     [  360.625394] md0_reshape     D ffff88040af57a58     0   126
>> 2 0x00000000
>>     [  360.625397]  ffff88040af57a58 ffff88040cf58000 ffff8800da535b20
>> 00000001642a9888
>>     [  360.625399]  ffff88040af57fd8 ffff8800da429000 ffff8800da429008
>> ffff8800da429208
>>     [  360.625401]  0000000096400e00 ffff88040af57a78 ffffffff81576707
>> ffff8800da429000
>>     [  360.625403] Call Trace:
>>     [  360.625410]  [<ffffffff81576707>] schedule+0x37/0x90
>>     [  360.625428]  [<ffffffffa0120de9>] get_active_stripe+0x5c9/0x760 [raid456]
>>     [  360.625432]  [<ffffffff810b6c70>] ? wake_atomic_t_function+0x60/0x60
>>     [  360.625436]  [<ffffffffa01246e0>] reshape_request+0x5b0/0x980 [raid456]
>>     [  360.625439]  [<ffffffff81579053>] ? schedule_timeout+0x123/0x250
>>     [  360.625443]  [<ffffffffa011743f>] sync_request+0x28f/0x400 [raid456]
>>     [  360.625449]  [<ffffffffa00da486>] ? is_mddev_idle+0x136/0x170 [md_mod]
>>     [  360.625454]  [<ffffffffa00de4ba>] md_do_sync+0x8ba/0xe70 [md_mod]
>>     [  360.625457]  [<ffffffff81576002>] ? __schedule+0x362/0xa30
>>     [  360.625462]  [<ffffffffa00d9e54>] md_thread+0x144/0x150 [md_mod]
>>     [  360.625464]  [<ffffffff810b6c70>] ? wake_atomic_t_function+0x60/0x60
>>     [  360.625468]  [<ffffffffa00d9d10>] ? md_start_sync+0xf0/0xf0 [md_mod]
>>     [  360.625471]  [<ffffffff81093418>] kthread+0xd8/0xf0
>>     [  360.625473]  [<ffffffff81093340>] ? kthread_worker_fn+0x170/0x170
>>     [  360.625476]  [<ffffffff8157a398>] ret_from_fork+0x58/0x90
>>     [  360.625478]  [<ffffffff81093340>] ? kthread_worker_fn+0x170/0x170
>>
>>
>> Also, looking at CPU usage md0_raid5 seems to be having problems as it
>> is stuck on 100% CPU on one core:
>>
>>      PID USER      PR  NI    VIRT    RES  %CPU %MEM     TIME+ S COMMAND
>>      125 root      20   0    0.0m   0.0m 100.0  0.0  35:57.44 R  `- md0_raid5
>>      126 root      20   0    0.0m   0.0m   0.0  0.0   0:00.06 D  `- md0_reshape
>>
>> Could this be why the reshape has stopped?
>>
>> Can I do something to get it going again or Is it possible to revert
>> to using 3 drives again without losing data? The data is not super
>> important, hence no backup solution, but it would mean a lot of lost
>> work.
>>
>> I'm thankful for any help I can get. Not sure what to do now.
>
> Hi Vilhelm,
>
> I ran into this exact situation several weeks ago. Fortunately Neil
> Brown was able to track it down; it turns out that the reshape
> operation can get stuck if it encounters bad blocks. See
> http://article.gmane.org/gmane.linux.raid/48673
>
> You can try applying the kernel patch from that message as a temporary
> hack to allow the reshape to complete. It worked fine for me, aside
> from a small amount of filesystem corruption that was fixable with
> fsck.
>
> -- David
