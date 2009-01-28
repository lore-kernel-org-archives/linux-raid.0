From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: sun x4500 soft lockup during raid creation
Date: Wed, 28 Jan 2009 16:33:42 -0500
Message-ID: <4980CF36.60106@scalableinformatics.com>
References: <1233174633.7008.34.camel@hazard2.francoudi.com>
Reply-To: landman@scalableinformatics.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1233174633.7008.34.camel@hazard2.francoudi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vladimir Ivashchenko <hazard@francoudi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Vladimir Ivashchenko wrote:

> Any stability assurances or workarounds are highly appreciated. :)
> 
> Jan 28 21:31:32 SunSTG kernel: BUG: soft lockup - CPU#0 stuck for 10s!

[...]

> Jan 28 21:31:32 SunSTG kernel:  [<f8d63562>] compute_parity6+0x21c/0x28a
> [raid456]
> Jan 28 21:31:32 SunSTG kernel:  [<f8d6452e>] handle_stripe+0xc8b/0x215e
> [raid456]
> Jan 28 21:31:32 SunSTG kernel:  [<c041fdb3>] enqueue_task+0x29/0x39
> Jan 28 21:31:32 SunSTG kernel:  [<c0420629>] try_to_wake_up+0x371/0x37b
> Jan 28 21:31:32 SunSTG kernel:  [<c041edec>] __wake_up_common+0x2f/0x53
> Jan 28 21:31:32 SunSTG kernel:  [<c041fbe6>] __wake_up+0x2a/0x3d
> Jan 28 21:31:32 SunSTG kernel:  [<f8d61744>] release_stripe+0x21/0x2e
> [raid456]
> Jan 28 21:31:33 SunSTG kernel:  [<f8d65b0c>] raid5d+0x10b/0x130
> [raid456]
> Jan 28 21:31:33 SunSTG kernel:  [<c059aca8>] md_thread+0xdf/0xf5
> Jan 28 21:31:33 SunSTG kernel:  [<c0436347>] autoremove_wake_function
> +0x0/0x2d
> Jan 28 21:31:33 SunSTG kernel:  [<c059abc9>] md_thread+0x0/0xf5
> Jan 28 21:31:33 SunSTG kernel:  [<c0436285>] kthread+0xc0/0xeb
> Jan 28 21:31:33 SunSTG kernel:  [<c04361c5>] kthread+0x0/0xeb
> Jan 28 21:31:33 SunSTG kernel:  [<c0405c3b>] kernel_thread_helper
> +0x7/0x10

Are you able to update the kernel to something more modern, or are you 
required to keep the kernel at the 2.6.18 level?  Out of curiousity, 
could you post the output of

	cat /proc/interrupts


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics LLC,
email: landman@scalableinformatics.com
web  : http://www.scalableinformatics.com
        http://jackrabbit.scalableinformatics.com
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
