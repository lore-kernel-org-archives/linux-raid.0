From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: MD/RAID1 Large File Support
Date: Tue, 13 May 2003 01:10:17 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030512221017.GH24892@mea-ext.zmailer.org>
References: <EC803175C921D411BCE2000000006429081C363F@ash-exch_lg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <EC803175C921D411BCE2000000006429081C363F@ash-exch_lg>
To: "Duncan, Mike" <Mike.Duncan@Sonopress.com>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 12, 2003 at 04:42:41PM -0400, Duncan, Mike wrote:
...
> Basically, we are trying to transfer (via FTP and SSH) files larger than 2G.
> I have read that SuSE has LFS in all of its distros from 7.1 and up (kernels
> 2.4.1 and up) and that kernel-wise and glibc-wise everything is ok. So after
> re-compiling kernels, textutils, gcc, binutils, and glibc in an effort to
> figure out which one is not compiled with LFS support in ... and ...
> restarting from scratch once I found out it was not them ... I am left with
> md.o or raid1.o as being the culprit. 
> 
> So --- is there LFS support in md.o and raid1.o modules? If not, is this
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
