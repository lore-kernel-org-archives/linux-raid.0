From: Neil Brown <neilb@suse.de>
Subject: Re: Could "bio_vec" be referenced any time?
Date: Wed, 7 Feb 2007 06:45:41 +1100
Message-ID: <17864.56037.855359.839197@notabene.brown>
References: <005a01c74a01$ec1832a0$0100a8c0@sslabmayasky>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752287AbXBFTqS@vger.kernel.org>
In-Reply-To: message from Yu-Chen Wu on Tuesday February 6
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-Chen Wu <g944370@oz.nthu.edu.tw>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday February 6, g944370@oz.nthu.edu.tw wrote:
> Hi all,
> 	I write a module that creates a kernel thread to show the BIOs from
> MD modules.
> 	The kernel thread will call show_bio() when md passing a BIO to my
> module,else sleep.
> 	Sometimes, show_bio() continues working successfully ,but it
> somtimes makes "general protection fault".
> 	The show_bio() always works when I comment the
> "bio_for_each_segment" loop. 
> 	Is the zone I comment the cause of the fault? 
> 	As above, I consider it's the main problem.Also, I strongly want to
> know your opinions.Thank you for help.
> 
> 	THX

Without seeing how the bio gets to show_bio it is hard to be certain,
but my guess would be that by the time show_bio tries to inspect the
bio, the IO request involving it has already completed and the bio has
been freed, so you are accessing freed memory.

> Feb  6 22:00:28 RAID-SUSE kernel: Code: 8b 00 f6 c4 08 74 0e 48 c7 c7 14 9c
> 45 88 31 c0 e8 b5 bf e2

If you feed this line into ksymoops you get:

Code;  0000000000000000 Before first symbol
   0:   8b 00                     mov    (%rax),%eaxC
...

so it is trying to dereference $rax.

> Feb  6 22:00:28 RAID-SUSE kernel: RAX: 6b6b6b6b6b6b6b6b RBX:
> ffff810037f52668 RCX: 0000000000040000

Which contains 6b6b6b6b6b6b6b6b.
which is lots of copies of 'POISON_FREE' (defined in
include/linux/poison.h) which makes it really look like that memory
has already been freed.

NeilBrown
