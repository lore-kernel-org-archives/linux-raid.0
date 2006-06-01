From: Neil Brown <neilb@suse.de>
Subject: Re: kernel messages when "rmmod md" module
Date: Thu, 1 Jun 2006 12:22:44 +1000
Message-ID: <17534.20340.521351.699187@cse.unsw.edu.au>
References: <200605311737409216484@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from  =?ISO-8859-1?Q?=20=1B$(AMuV>@$=1B(B?= on Wednesday May 31
Sender: linux-raid-owner@vger.kernel.org
To: =?gb2312?B?zfXWvsCk?= <raidwang@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday May 31, raidwang@gmail.com wrote:
> hi,
> 	I build the linux-2.6.11 kernel using the default kernle config file in configs directory and just config "<M> RAID support". When i use "mdadm -S /dev/md0" to stop md, everything is ok! But when i "rmmod md", kernel prints messages as follow.
>  
> Debug: sleeping function called from invalid context at kernel/workqueue.c:264
> in_atomic():1, irqs_disabled():0
>  [<c013bbf4>] flush_workqueue+0x1a/0x27
>  [<c029ec2f>] blk_cleanup_queue+0x30/0x78
>  [<c021eb5d>] kref_put+0x29/0x8c
>  [<e11e50d1>] mddev_put+0xad/0x133 [md]
>  [<c021df71>] kobject_put+0x1e/0x22
>  [<e11ec802>] md_exit+0x1ce/0x2b3 [md]
>  [<c014a059>] __try_stop_module+0x27/0x3e
>  [<c014a098>] try_stop_module+0x28/0x2d
>  [<c014a248>] sys_delete_module+0x13b/0x180
>  [<c0108ac4>] do_syscall_trace+0x10b/0x14c
>  [<c010384d>] syscall_call+0x7/0xb
> 
>     I add some debug message in the md.c and find "md_exit" function calls "mddev_put" function. After "mddev_put" function calls "blk_put_queue(mddev->queue);", the kernel prints message as above.
> 	I have noticed that "do_md_stop" function calls "mddev->pers->stop(mddev);", and "stop" function has called "blk_sync_queue(mddev->queue);"
>  
> 	Would anybody give me some suggestions? Thanks!

You should always work with the latest kernel.
That problem was fixed recently in

 http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=926ce2d8a7d446c720faec9d8c5105eeb04bcf7a

NeilBrown
