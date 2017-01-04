From: Shaohua Li <shli@kernel.org>
Subject: Re: PROBLEM: Kernel BUG with raid5 soft + Xen + DRBD - invalid opcode
Date: Wed, 4 Jan 2017 14:30:15 -0800
Message-ID: <20170104223015.cr6vtyhxuwxrg76g@kernel.org>
References: <585D6C34.2020908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <585D6C34.2020908@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: MasterPrenium <masterprenium.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, xen-users@lists.xen.org, linux-raid@vger.kernel.org, "MasterPrenium@gmail.com" <MasterPrenium@gmail.com>, xen-devel@lists.xenproject.org
List-Id: linux-raid.ids

On Fri, Dec 23, 2016 at 07:25:56PM +0100, MasterPrenium wrote:
> Hello Guys,
> 
> I've having some trouble on a new system I'm setting up. I'm getting a kernel BUG message, seems to be related with the use of Xen (when I boot the system _without_ Xen, I don't get any crash).
> Here is configuration :
> - 3x Hard Drives running on RAID 5 Software raid created by mdadm
> - On top of it, DRBD for replication over another node (Active/passive cluster)
> - On top of it, a BTRFS FileSystem with a few subvolumes
> - On top of it, XEN VMs running.
> 
> The BUG is happening when I'm making "huge" I/O (20MB/s with a rsync for example) on the RAID5 stack.
> I've to reset system to make it work again.

what did you mean 'huge' I/O (20M/s)? Is it possible you can reproduce the
issue with a raw raid5 raid? It would be even better if you can give me a fio
job file with the issue, so I can easily debug it.

also please check if upstream patch (e8d7c33 md/raid5: limit request size
according to implementation limits) helps.

Thanks,
Shaohua
