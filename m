From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: question regarding a raid-1 set
Date: Tue, 26 Aug 2003 11:44:54 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F4B8076.5CF468D5@SteelEye.com>
References: <200308261637.08588.jbaten@i2rs.nl> <yq13cfov4g7.fsf@wilson.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Martin K. Petersen" <mkp@mkp.net>
Cc: Jeroen Baten <jbaten@i2rs.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Martin K. Petersen" wrote:
> 
> >>>>> "Jeroen" == Jeroen Baten <jbaten@i2rs.nl> writes:
> 
> Jeroen> md2 : active raid1 sdb6[1] sda6[0] 31848704 blocks [2/1] [U_]
>                            ^^^^^^^                                ^
> 
> Jeroen> when he types 'raidhotadd /dev/md2 /dev/sdb6' it generates:
> Jeroen> "dev/md2: can not hot-add disk: disk busy"
> 
> sdb6 *is* busy.  It's sda6 that's out of sync.

Nope. Actually sdb6 is disk 1, sda6 is disk 0, which means that sdb6 is
the one that is non-operational, as Jeroen originally said.


Jeroen, in order to be able to hot-add, you must first raidsetfaulty,
then hot-remove the disk, then hot-add it. But, you should probably
first check your system log to see why the array is not syncing. The
hot-add may not help, depending on what the problem is.

--
Paul
