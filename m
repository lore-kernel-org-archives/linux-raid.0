From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: MD/RAID1 Large File Support
Date: Tue, 13 May 2003 09:47:30 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030513064730.GI24892@mea-ext.zmailer.org>
References: <EC803175C921D411BCE2000000006429081C3641@ash-exch_lg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <EC803175C921D411BCE2000000006429081C3641@ash-exch_lg>
To: "Duncan, Mike" <Mike.Duncan@Sonopress.com>
Cc: Linux SW Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 12, 2003 at 10:31:24PM -0400, Duncan, Mike wrote:
> Sorry for not giving the error. I was trying "cat /dev/zero > test" as a
> test and receiving the error "File too large.". I have 2 machines setup
> pretty much identically, except the one that I am receiving the error for is
> software-raided with md and raid1. The other one (running SuSE 8.0 as well
> with 2.4.20 kernel) does not give this error.

In that test, it all depends upon what your shell is doing when it
is opening the file 'test' in that IO redirection.

If it does not do  O_LARGEFILE  properly, (likely when using open(2) 
directly,) then the file won't be opened allowing its size to exceed 2G.

From   man 2 open

       O_LARGEFILE
              On 32-bit systems that support the Large Files System, allow 
              files whose sizes cannot be represented in 31 bits  to  be
              opened.

The world is still full of code that does not have  Large File Summit
support in them:     http://www.sas.com/standards/large.file/
(Heck, even I write code that does not support LFS -- its problem space
does not include the need.)

> I have tried recompiling the kernel (to several different versions, the last
> 2.5.69) and recompiling gcc, glibc, and other packages...but no luck ...
> still get the same error.
> 
> I don't think ulimit is used in newer glibc now...right? Anyways, you may be
> right about the drivers not caring about the filesizes, but wouldn't there
> be a 32bit limit on blocks if the LFS support was not there?

The   ulimit (getrlimit / setrlimit) is implemented and eforced in the 
kernel in conjunction with  O_LARGEFILE control flag.

/Matti Aarnio
