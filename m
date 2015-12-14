From: "Micheal Blue" <mblue@gmx.us>
Subject: Re: core dump on initial sync of raid10 please help
Date: Mon, 14 Dec 2015 20:31:20 +0100
Message-ID: <trinity-3e0abfe9-de99-450e-a215-4af82f2177be-1450121480258@3capp-mailcom-bs12>
References: <trinity-c6018f35-ed0d-46be-b418-7799c4874238-1450100929825@3capp-mailcom-bs06>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <trinity-c6018f35-ed0d-46be-b418-7799c4874238-1450100929825@3capp-mailcom-bs06>
Sender: linux-raid-owner@vger.kernel.org
To: Micheal Blue <mblue@gmx.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> Sent: Monday, December 14, 2015 at 8:48 AM
> From: "Micheal Blue" <>
> To: linux-raid@vger.kernel.org
> Subject: core dump on initial sync of raid10 please help
>
> I noticed my initial sync when making a 4 disk raid10 is really slow. I looked in dmesg and found this.
> I do not know what it means. Suggestions please :)
> 
> [  600.959945] INFO: task md0_resync:676 blocked for more than 120 seconds.
> [  600.959976]       Not tainted 4.3.2-1-ARCH #1
> [  600.959994] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  600.960024] md0_resync      D ffff88021fa956c0     0   676      2 0x00000000
> [  600.960028]  ffff8800ca143b40 0000000000000046 ffff880216659b80 ffff8800377244c0
> [  600.960030]  ffff8800ca144000 ffff88003765a000 ffff8800ca143b68 ffff88003765a100
> [  600.960032]  ffff88003765a000 ffff8800ca143b58 ffffffff8157f92a ffff88003765a0dc
> [  600.960034] Call Trace:
> [  600.960040]  [<ffffffff8157f92a>] schedule+0x3a/0x90
> [  600.960044]  [<ffffffffa0548f52>] raise_barrier+0x122/0x190 [raid10]
> [  600.960049]  [<ffffffff810b5dc0>] ? wake_atomic_t_function+0x60/0x60
> [  600.960051]  [<ffffffffa054eea1>] sync_request+0x731/0x19b0 [raid10]

...

It seems that the kernel itself is to blame for this.
If I boot into kernel version 4.1.14 everything seems to be running fine as I create the array.
