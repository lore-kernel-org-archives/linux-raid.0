From: "Duncan, Mike" <Mike.Duncan@Sonopress.com>
Subject: RE: MD/RAID1 Large File Support
Date: Mon, 12 May 2003 22:31:24 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <EC803175C921D411BCE2000000006429081C3641@ash-exch_lg>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Matti Aarnio ' <matti.aarnio@zmailer.org>
Cc: "''linux-raid@vger.kernel.org' '" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry for not giving the error. I was trying "cat /dev/zero > test" as a
test and receiving the error "File too large.". I have 2 machines setup
pretty much identically, except the one that I am receiving the error for is
software-raided with md and raid1. The other one (running SuSE 8.0 as well
with 2.4.20 kernel) does not give this error.

I have tried recompiling the kernel (to several different versions, the last
2.5.69) and recompiling gcc, glibc, and other packages...but no luck ...
still get the same error.

I don't think ulimit is used in newer glibc now...right? Anyways, you may be
right about the drivers not caring about the filesizes, but wouldn't there
be a 32bit limit on blocks if the LFS support was not there?


-----Original Message-----
From: Matti Aarnio
To: Duncan, Mike
Cc: 'linux-raid@vger.kernel.org'
Sent: 5/12/2003 6:10 PM
Subject: Re: MD/RAID1 Large File Support

On Mon, May 12, 2003 at 04:42:41PM -0400, Duncan, Mike wrote:
...
> Basically, we are trying to transfer (via FTP and SSH) files larger
than 2G.
> I have read that SuSE has LFS in all of its distros from 7.1 and up
(kernels
> 2.4.1 and up) and that kernel-wise and glibc-wise everything is ok. So
after
> re-compiling kernels, textutils, gcc, binutils, and glibc in an effort
to
> figure out which one is not compiled with LFS support in ... and ...
> restarting from scratch once I found out it was not them ... I am left
with
> md.o or raid1.o as being the culprit. 
> 
> So --- is there LFS support in md.o and raid1.o modules? If not, is
this
> expected in 2.6 kernels? If so, do I need to apply a patch to get this
> working or just maybe more kernel parameters?

Wrong layer.  MD/RAID does not see FILES, just bunches of diskblocks.

What is the problem you are encountering, to be exact ?
You have two machines in between which you try to transfer files.
Can you do following at both ?

  dd if=/dev/zero bs=1024k count=3 seek=3000 of=test.file

That should create about 3 GB size file at both machines.
(It does SKIP over 3G, and writes 3 MB, thus it does not
need that much diskspace..)

If it doesn't, check that:
$ ulimit -f
unlimited

If it does not give that, there is your problem.

> TIA for any and all help.
> 
> ------------------------------------ 
> Mike Duncan
> Web Master/Developer
> Sonopress LLC
> 
> mike.duncan@sonopress.com
> 828.658.6082 (desk)
> 828.423.3310 (cell)
