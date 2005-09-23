From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm core dump
Date: Fri, 23 Sep 2005 16:41:14 +0200
Message-ID: <17204.5130.443085.827162@cse.unsw.edu.au>
References: <1127484829.5546.38.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ming Zhang on Friday September 23
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday September 23, mingz@ele.uri.edu wrote:
> i did not read the mdadm code. but i suspect there is a pointer misuse
> when there is no configuration file available.
> 
...
> [root@localhost ~]# strace mdadm --assemble /dev/md0
> execve("/sbin/mdadm", ["mdadm", "--assemble", "/dev/md0"], [/* 23 vars
> */]) = 0
> uname({sys="Linux", node="localhost.localdomain", ...}) = 0
> brk(0)                                  = 0x515000
...
> open("/etc/mdadm.conf", O_RDONLY)       = -1 ENOENT (No such file or
> directory)
> --- SIGSEGV (Segmentation fault) @ 0 (0) ---
> +++ killed by SIGSEGV +++
> 
> [root@localhost ~]# mdadm --version
> mdadm - v1.6.0 - 4 June 2004

Fixed in v1.8.0, but I would recommend upgrading all the way to
1.12.0, or even 2.1.

NeilBrown
