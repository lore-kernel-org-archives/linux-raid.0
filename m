From: Neil Brown <neilb@suse.de>
Subject: Re: Possible bug
Date: Wed, 9 Dec 2009 12:57:24 +1100
Message-ID: <20091209125724.2652d413@notabene.brown>
References: <4B1E5220.8030500@syscall.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B1E5220.8030500@syscall.eu>
Sender: linux-raid-owner@vger.kernel.org
To: ml-raid@syscall.eu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 08 Dec 2009 14:18:24 +0100
ml-raid@syscall.eu wrote:

> Hello,
> I have a 2.6.27.29-4-grsec (from http://kernelsec.cr0.org) Linux box, on
> x86, running debian lenny. On sunday, during the monthly rebuild of my
> standard RAID1 setup (/proc/mdstat):
> 
> Personalities : [raid1]
> md127 : active raid1 sda1[0] sdb1[1]
>       488383936 blocks [2/2] [UU]
> 
> unused devices: <none>
> 
> The kernel started outputting thousands of backtraces (see attached log)
> The IO throughput was drastically reduced but the resync finally
> completed after about 38 hours.
> 
> This is the first time I have been bitten by this bug. The server has
> been running on this kernel for 74 days and the previous resync didn't
> exhibit any problem.

This is not a RAID problem - it was a problem with the grsec patches.
They assume that any atomic variable is used as a counter and should not
overflow.  That is not the case with bd_disk->sync_io.  It is expected to
overflow.  So the "PAX: ..." report is a false positive.

NeilBrown
