From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: BSD disklabel and autodetection
Date: Mon, 29 Jul 2002 12:53:42 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D450296.9B9D9961@tls.msk.ru>
References: <Pine.LNX.4.32.0207261708230.1091-100000@dope.pingdynasty.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

martin@hack.org wrote:
> 
[]
> following some hints i've seen elsewhere on the list i tried to pass md
> parameters to the kernel ->
> 
> Booting on Nautilus using machine vector Nautilus from SRM
> Command line: ro root=/dev/md1 md=1,/dev/sdb5,/dev/sdc2,/dev/sdd2 raid=noautodetect
> md: Will configure md1 (super-block) from /dev/sdb5,/dev/sdc2,/dev/sdd2, below.
> 
> with the raid=noautodetect option it works.
> 
> what other raid/md options can be passed this way? and how do i configure
> more than one device? geez, hope there's not a 256 char limit to the
> command line...

You may use md=N,dev1,dev2,... option as many times as you want, i.e.

 linux root=... md,1=/dev/sda1,.. md=2,/dev/sda2,...

I think that it's sufficient to tell it about only ONE member of
an array this way if your raid device has persistent superblock
(kernel will read superblock from first disk (or second for that
matter - if you choose to tell it about second disk) and read
other devices from there).

About other options - there are only two, raid= (e.g. noautodetect)
and md= (above) that are raid-related.

> are these options documented somewhere??

I personally looked at sources in drivers/md/ directory and got the
above line by reading initialization functions.  Maybe it's documented
somewhere in Documentation/... ;)

/mjt
