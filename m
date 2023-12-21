Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92B7B647
	for <linux-raid@vger.kernel.org>; Thu, 21 Dec 2023 06:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4SwgJV3Z0Fz4f3lV6
	for <linux-raid@vger.kernel.org>; Thu, 21 Dec 2023 14:19:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id B7D271A0193
	for <linux-raid@vger.kernel.org>; Thu, 21 Dec 2023 14:19:59 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgD3Rg0M2YNlR_rkEA--.31454S3;
	Thu, 21 Dec 2023 14:19:58 +0800 (CST)
Subject: Re: [PATCH] Revert "raid: Remove now superfluous sentinel element
 from ctl_table array"
To: Coly Li <colyli@suse.de>, song@kernel.org
Cc: linux-raid@vger.kernel.org, Joel Granados <j.granados@samsung.com>,
 Luis Chamberlain <mcgrof@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <20231221044925.10178-1-colyli@suse.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <aef386e9-90b2-9847-89cd-1566a5969a08@huaweicloud.com>
Date: Thu, 21 Dec 2023 14:19:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20231221044925.10178-1-colyli@suse.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgD3Rg0M2YNlR_rkEA--.31454S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZw17JFy5JFyktrWDuw47XFb_yoW7JrW7pF
	1Yqr17Wa18Jrn3t3yUAr45XF98Ja17A3Z8Xwn7W3WIyF1v9r98Jr4UWr4UGFyqg34UAFy3
	JF1DJr48tr18taDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUrR6zUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2023/12/21 12:49, Coly Li Ð´µÀ:
> This reverts commit dd6291c506490c195620b394dc96763675e7e5f4.
> 
> With this patch, a kernel oops triggered when creating a md device,
> [  311.224353][ T3545] BUG: unable to handle page fault for address: 000003e800030d40
> [  311.314951][ T3545] #PF: supervisor read access in kernel mode
> [  311.384748][ T3545] #PF: error_code(0x0000) - not-present page
> [  311.454538][ T3545] PGD 12be1c067 P4D 0
> [  311.501451][ T3545] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  311.561888][ T3545] CPU: 19 PID: 3545 Comm: modprobe [snipped...]
> [  311.869958][ T3545] RIP: 0010:string+0x48/0xe0
> [  311.923116][ T3545] Code: 3b 45 89 d1 45 31 c0 49 01 f9 66 45 85 d2 75 1a eb 1f 48 39 f7 73 02 88 07 48 83 c7 01 41 83 c0 01 48 83 c2 01 4c 39 cf 74 07 <0f> b6 02 84 c0 75 e1 48 89 f2 44 89 c6 e9 c6 e3 ff ff 48 c7 c0 3d
> [  312.156194][ T3545] RSP: 0018:ffa000000b877a70 EFLAGS: 00010086
> [  312.227025][ T3545] RAX: 000003e80002fd40 RBX: ffa000000b877b86 RCX: ffff0a00ffffff04
> [  312.320737][ T3545] RDX: 000003e800030d40 RSI: ffa000000b877b68 RDI: ffa000000b877b86
> [  312.414449][ T3545] RBP: ffa000000b877b48 R08: 0000000000000000 R09: ffa000010b877b85
> [  312.508160][ T3545] R10: ffffffffffffffff R11: 0000000000000040 R12: ffa000000b877b68
> [  312.601873][ T3545] R13: ffffffff99c221fa R14: 0000000000000008 R15: ffffffff99c221fa
> [  312.695583][ T3545] FS:  00007fea7a856740(0000) GS:ff11000fffd80000(0000) knlGS:0000000000000000
> [  312.800733][ T3545] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  312.877805][ T3545] CR2: 000003e800030d40 CR3: 0000000123790001 CR4: 0000000000771ee0
> [  312.971518][ T3545] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  313.065229][ T3545] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  313.158940][ T3545] PKRU: 55555554
> [  313.199610][ T3545] Call Trace:
> [  313.237162][ T3545]  <TASK>
> [  313.270554][ T3545]  ? __die+0x23/0x70
> [  313.315391][ T3545]  ? page_fault_oops+0x14d/0x490
> [  313.372701][ T3545]  ? update_load_avg+0x7e/0x7d0
> [  313.428972][ T3545]  ? exc_page_fault+0x71/0x160
> [  313.484203][ T3545]  ? asm_exc_page_fault+0x26/0x30
> [  313.542555][ T3545]  ? string+0x48/0xe0
> [  313.588426][ T3545]  vsnprintf+0x2d5/0x5a0
> [  313.637417][ T3545]  vprintk_store+0x15e/0x4b0
> [  313.690567][ T3545]  ? schedule_timeout+0x147/0x160
> [  313.748918][ T3545]  ? wait_for_completion_killable+0x1a6/0x1d0
> [  313.819750][ T3545]  vprintk_emit+0xc9/0x230
> [  313.870823][ T3545]  _printk+0x5c/0x80
> [  313.915657][ T3545]  sysctl_err+0x6a/0x90
> [  313.963610][ T3545]  ? __kmalloc+0x4d/0x150
> [  314.013639][ T3545]  __register_sysctl_table+0x144/0x7d0
> [  314.077192][ T3545]  ? kmalloc_trace+0x2a/0xa0
> [  314.130341][ T3545]  md_init+0xd2/0xff0 [snipped...]
> [  314.228226][ T3545]  ? __pfx_md_init+0x10/0x10 [snipped...]
> [  314.333383][ T3545]  do_one_initcall+0x47/0x220
> [  314.387576][ T3545]  ? kmalloc_trace+0x2a/0xa0
> [  314.440726][ T3545]  do_init_module+0x60/0x240
> [  314.493878][ T3545]  __do_sys_finit_module+0xac/0x120
> [  314.554308][ T3545]  do_syscall_64+0x5d/0x90
> [  314.605380][ T3545]  ? ksys_lseek+0x66/0xb0
> [  314.655411][ T3545]  ? syscall_exit_to_user_mode+0x2b/0x40
> [  314.721042][ T3545]  ? do_syscall_64+0x6c/0x90
> [  314.774194][ T3545]  ? exit_to_user_mode_prepare+0x142/0x1f0
> [  314.841906][ T3545]  ? syscall_exit_to_user_mode+0x2b/0x40
> [  314.907535][ T3545]  ? do_syscall_64+0x6c/0x90
> [  314.960685][ T3545]  ? exc_page_fault+0x71/0x160
> [  315.015917][ T3545]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [  315.084667][ T3545] RIP: 0033:0x7fea79f161bd
> 
> The last NULL element in raid_table[] is necessary, after reverting this

Based on commit message, avoid last NULL element is exactly what [1]
did, if this is not true, can you explame more how sysctl_err() is
called from md_init()? I can't find this by code review, and I think
maybe it's better to fix this in sysctl error path.

Thanks,
Kuai

[1] https://lore.kernel.org/all/ZO5Yx5JFogGi%2FcBo@bombadil.infradead.org/
> patch, the above oops message is removed.
> 
> Fixes: dd6291c50649 ("raid: Remove now superfluous sentinel element from ctl_table array")
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Joel Granados <j.granados@samsung.com>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> ---
>   drivers/md/md.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9bdd57324c37..90481ed6fdbb 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -312,6 +312,7 @@ static struct ctl_table raid_table[] = {
>   		.mode		= S_IRUGO|S_IWUSR,
>   		.proc_handler	= proc_dointvec,
>   	},
> +	{ }
>   };
>   
>   static int start_readonly;
> 

