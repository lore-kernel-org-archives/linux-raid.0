From: debian@good-with-numbers.com
Subject: Re: disk light remains on
Date: Mon, 2 Jan 2006 21:21:47 -0800
Message-ID: <20060103052147.GA8380@adsl-64-142-29-25.sonic.net>
References: <20060103033213.GB7888@adsl-64-142-29-25.sonic.net> <20060103044914.GB8876@lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060103044914.GB8876@lug.udel.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Vandegrift <ross@lug.udel.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the reply.

On Mon, Jan 02, 2006 at 11:49:14PM -0500, Ross Vandegrift wrote:
>> I just began using RAID-1 (in 2.6.12) on a pair of SATA drives, and
>> now the hard disk drive light comes on during booting--about when the
>> RAID system is loaded--and stays on.
> 
> Could you "cat /proc/mdstat"?  If this is an initial creation and your
> disks are large, it's likely just the initial array build.  If your
> array is synced and your disks are still being accessed, are you sure
> that there's no processes using your disk?

$ cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sda1[0] sdb1[1]
      244195904 blocks [2/2] [UU]

unused devices: <none>


These is a new MD, with new LVM partitions running atop.  It's a new,
minimal system.  Exim, acpid, inetd, mdadm, syslogd, klogd, portmap,
rpc.statd...that's about it.  I've never been sure how to tell which
processes are performing I/O.
