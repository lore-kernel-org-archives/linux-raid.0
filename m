From: Mikael Johansson <mpjohans@pcu.helsinki.fi>
Subject: Re: MD/RAID1 Large File Support
Date: Tue, 13 May 2003 14:44:37 +0300 (EEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.OSF.4.51.0305131437100.147081@soul.helsinki.fi>
References: <EC803175C921D411BCE2000000006429081C363F@ash-exch_lg>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <EC803175C921D411BCE2000000006429081C363F@ash-exch_lg>
To: "Duncan, Mike" <Mike.Duncan@Sonopress.com>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hello Mike and All!

On Mon, 12 May 2003, Duncan, Mike wrote:

> md0 : active raid1 hdb2[1] hda2[0]
>       38925376 blocks [2/2] [UU]

As already pointed out, hda and hdb together are a bad idea. It will also
slow things down.


> Basically, we are trying to transfer (via FTP and SSH) files larger than 2G.
> I have read that SuSE has LFS in all of its distros from 7.1 and up (kernels
> 2.4.1 and up) and that kernel-wise and glibc-wise everything is ok. So after
> re-compiling kernels, textutils, gcc, binutils, and glibc in an effort to
> figure out which one is not compiled with LFS support in ... and ...
> restarting from scratch once I found out it was not them ... I am left with
> md.o or raid1.o as being the culprit.

I'm not sure that this is a RAID problem at all. I've encountered the
same problem when trying to scp files larger than 2GB. Never got around to
try and fix it though. Being lazy, I just use 'split' and 'cat'. So maybe
there's some other component/program to blame alltogether.

Anyway, you can always try the 2GB limit on your raid by cat'ting together
a large file enough times (cat iamaonegbfile iamaonegbfile iamaonegbfile
> iamathreegbfile).

If that doesn't work, we don't have the same problem. If it _does_ work,
I'll be just as eagerly waiting for some smart person to present us with
the solution :-)

Have a nice day,
    Mikael J.
    http://www.helsinki.fi/~mpjohans/
