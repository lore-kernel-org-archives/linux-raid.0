From: Shaohua Li <shli@kernel.org>
Subject: Re: Process stuck in md_flush_request (state: D)
Date: Fri, 17 Feb 2017 12:06:44 -0800
Message-ID: <20170217200644.amaxgira4nqlbchh@kernel.org>
References: <36A8825E-F387-4ED8-8672-976094B3BEBB@lesstroud.com>
 <99A92F4D-338D-4486-BB1C-C114A8524403@lesstroud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <99A92F4D-338D-4486-BB1C-C114A8524403@lesstroud.com>
Sender: linux-raid-owner@vger.kernel.org
To: Les Stroud <les@lesstroud.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 17, 2017 at 02:05:49PM -0500, Les Stroud wrote:
> 
> I have a problem with processes entering an uninterruptible sleep state in md_flush_request and never returning. I having trouble identifying the underlying issue. I’m hoping someone on here may be able to help.
> 
> The servers in question are running in aws (xen hvm) with kernel 3.8.13-118.16.2.el6uek.x86_64.  The server has two mounts.  The first is vanilla ext4.  The second is a software RAID0 array, striped with 256k chunks, buiIt with md.  It’s file system is ext4. 
> 
> The most immediately and obvious symptom of the issue are kernel errors “kernel: INFO task [some process]: blocked for more than 120 seconds.”.  Shortly there after, other processes start entering the same uninterruptible wait state (D). This almost always impacts ssh logins.
> 
> The problem does not occur when the system is under load, or was recently under load.  It happens when the system is quiet (no cpu, very little io).

This seems suggesting we have a missed blk-plug flush in light workload. Can
you check the output of /sys/block/disk-bame/inflight for both md and the
underlayer disks? This will let us know if there is IO pending.
Also it would be great if you can test a upstream kernel.

Thanks,
Shaohua
