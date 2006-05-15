From: Neil Brown <neilb@suse.de>
Subject: Re: raid0 over 2 h/w raid5's OOPSing at mkfs
Date: Tue, 16 May 2006 09:38:39 +1000
Message-ID: <17513.4351.71436.972341@cse.unsw.edu.au>
References: <Pine.LNX.4.62.0605151440080.29380@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Joshua Baker-LePain on Monday May 15
Sender: linux-raid-owner@vger.kernel.org
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 15, jlb17@duke.edu wrote:
> I've got a x86_64 system with 2 3ware 9550SX-12s, each set up as a raid5 
> w/ a hot spare.  Over that, I do a software raid0 stripe via:
> 
> mdadm -C /dev/md0 -c 512 -l 0 -n 2 /dev/sd[bc]1
> 
> Whenever I try to format md0 (I've tried both mke2fs and mkfs.xfs), the 
> system OOPSes.  I'm running centos-4 with the default kernel, but I've 
> upgraded the 3ware driver/firmware to the most recent versions.  Based on 
> the OOPS I'll paste below, who should I be blaming for this crash?  Any 
> ideas on how to fix it?  Thanks.

Try this.

http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=1eb29128c644581fa51f822545921394ad4f719f

Raid0 has troubles in 64bit machines back in 2.6.9 days.

NeilBrown.


> 
> Unable to handle kernel NULL pointer dereference at 0000000000000027 RIP:
> <ffffffffa0194ab6>{:raid0:raid0_make_request+448}
> PML4 3e913067 PGD 7b652067 PMD 0
> Oops: 0000 [1] SMP
> CPU 1
> Modules linked in: raid0 md5 ipv6 parport_pc lp parport i2c_dev i2c_core sunrpc ipt_REJECT ipt_state ip_conntrack iptable_filter ip_tables dm_mirror dm_mod button battery ac ohci_hcd hw_random tg3 floppy ext3 jbd 3w_9xxx(U) 3w_xxxx sd_mod scsi_mod
> Pid: 2955, comm: mke2fs Not tainted 2.6.9-34.ELsmp
