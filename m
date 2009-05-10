From: Neil Brown <neilb@suse.de>
Subject: Re: Subject: [001/002 ] raid0 reshape
Date: Mon, 11 May 2009 08:31:59 +1000
Message-ID: <18951.21983.1676.992436@notabene.brown>
References: <1241300764.5607.36.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from raz ben yehuda on Sunday May 3
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@013.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday May 3, raziebe@013.net wrote:
> Neil Hello
> The bellow is the raid0 grow code.I have decided to fix raid0 and not 
> perform the transformation raid0-raid4-raid0 due to two reasons:
> 1. raid0 zones. this patch support any zone transformations.
> 2. Undesired dependency of raid0 over raid4 re-striping code. 
> 
> The following tests were conducted:
> 1. various chunk sizes, 4K to 512K. ( mainly in 2.6.27 and 2.6.18 )
> 2. regrow ( tested on 2.6.27 and 2.6.18 )
> 3. various super blocks. 0.9 , 1, 1.1 and 1.2 ( mainly in 2.6.27 and 2.6.18 ).
> 4. support assembling and mounting older raid version ( older kernels and code before patch) after it was grown.
> 
> patch passed checkpatch.pl . other than reshaping code i beautified the code. 
> Currently i about to pass this code to our testing team for further tests. 
> Other things to do:
> 1. Speedup the reshape process.It is too slow.
> 2. Support for non power 2^n ( page size) chunks.
> 
> I will be thankful for your criticism.

Probably my main criticism at this point is that there is no
commentary explaining how it works.
You appear to have chosen to run your own reshape thread rather than
providing a "resync" method and make use of the md_do_sync thread
which provides speed limiting etc.  
Maybe that it a good decision, but as you haven't explained it, it is
hard to be sure.

Also, it seems to if an IO request arrives while the reshape is
happening, then it fails with -EBUSY.
I don't think that is a good thing.
1/ no filesystem is going to be expecting EBUSY so it could cause
   serious problems
2/ if you aren't going to support online reshape so that a device can 
   be reshaped while it is in use, then there seems to be little point
   in putting this code in the kernel.  Just write a program that runs
   in userspace which reshapes the array while it is not assembled.

Also, I cannot see any evidence that you checkpoint the reshape at
all.  So if your machine crashes during the reshape, everything is
lost.  I do not find this acceptable.

NeilBrown
