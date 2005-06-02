From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Troubles making a raid5 system work.
Date: Thu, 2 Jun 2005 02:56:12 +0200
Message-ID: <62b0912f0506011756fa6f59d@mail.gmail.com>
References: <62b0912f05053000534655bb7f@mail.gmail.com>
	 <429df617.35a2a6be.0f63.ffffff9a@mx.gmail.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <429df617.35a2a6be.0f63.ffffff9a@mx.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Zafra <fzafra@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Francisco Zafra wrote:
> Finally I made the raid system work fine :-)
Cool beans ;-).

> 1.- This patch will be included in new kernels versions or I have to applied
> each time I compile a new kernel version?

It will be included at some point, probably "soon".
I'm not part of that process so can't really say for sure when..

> 2.- Working with big files (700megs) in the RAID comsumes a lot of cpu
> resources, is this normal? I have an Pentium 4, 3Ghz and 1GB RAM...

Probably depends how you define "working".
For simple operations, my *guess* would be that your CPU should
outperform your I/O subsystem, at least if you have DMA enabled.  You
can check if that's the case with 'hdparm /dev/hd<x>'.

I'm not sure how to analyze your CPU problem.  You're probably
interested in knowing whether it's MD doing XOR for raid5 or it's the
kernel busy waiting for your IDE disks.  Unless you are doing other
things, like encryption for example.  Perhaps a tool like 'top' can
help you.  But again, I have no real good idea how to find out. 
Perhaps others can be helpful?

With 8 disks and a standard PCI bus, my guess would be that your PCI
bus would be the first thing to get saturated.
