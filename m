From: Shaohua Li <shli@kernel.org>
Subject: Re: MD device tinning documentation
Date: Wed, 10 May 2017 09:00:19 -0700
Message-ID: <20170510160019.6v2bb34kmu6rvr44@kernel.org>
References: <CA+DJSLwbsUhhK_T+K6YOBX_BLdgRn=qZjz3LUAK92A0_9sL0FQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+DJSLwbsUhhK_T+K6YOBX_BLdgRn=qZjz3LUAK92A0_9sL0FQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vladimir Fedorkov <vlad@astellar.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 08, 2017 at 01:22:53PM +0300, Vladimir Fedorkov wrote:
> Hello there!
> 
> I'm running benchmarks and it looks like that md device is only
> utilizing single core which it limiting it's performance on concurrent
> (4+ threads) writes with 8 SSD drives in software RAID10
> 
> Kernel: Linux host 4.10.12-1.el7.elrepo.x86_64 #1 SMP Fri Apr 21
> 09:58:15 EDT 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
> Exact numbers are here: http://astellar.com/images/sysbench_rnd_writes.png
> 
> Could you please let me know if there is multi-threaded support on MD
> devices in 4.x kernels and point me to the documentation (preferred)
> or source code which describes tunable parts of /dev/mdXX devices.

There is no knob for tunning. At most time, raid10 directly sends IO to
underlayer disks directly from upperlayer thread, so it's multi-threaded. The
problem is we have some locking issues in the barrier side. Coly improved the
raid1 scalability with a new barrier implementation (fd76863e37fe RAID1: a new
I/O barrier implementation to remove resync window), but raid10 is left behind.

Thanks,
Shaohua
