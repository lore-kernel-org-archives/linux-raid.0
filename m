From: Luca Berra <bluca@comedia.it>
Subject: Re: raid5: switching cache buffer size
Date: Fri, 13 Dec 2002 19:59:54 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DFA2E2A.20601@comedia.it>
References: <Pine.LNX.4.43.0212131530510.6085-100000@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.43.0212131530510.6085-100000@unicorn.drogon.net>
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson wrote:
> Anyone know what this means?
> 
> My big server is currently fscking a lvm partition which sits on-top of a
> raid5 device and the console is scrolling these messages as fast as it can.
> It says it's switching from 0 to 512, from 512 to 0 and 0 to 1024 ( or
> maybe 512 to 1024, its hard to tell).
> 
> What's happening and how do I stop it?

hi,
you probably have filesystems of different block in the volume group,
raid cache cannot cope with requests of varying block size so it has to 
flush the cache each time, this only hurts performance and is not 
problem for data safety.

fix:
1) make sure everything on your raid5 is the same block size, if you 
have swap you are locked to using 4k blocks, if you are using snapshots 
1k blocks, if you use both jump.
2) comment the printk in the raid5 source

L.


