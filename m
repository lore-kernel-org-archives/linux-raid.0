From: Alex Izvorski <aizvorski@gmail.com>
Subject: Re: Large Stripe Size (>4MB)
Date: Wed, 22 Mar 2006 21:59:11 +0000 (UTC)
Message-ID: <loom.20060322T223645-85@post.gmane.org>
References: <dd43dcfb0602180704n78f4de2lb61dd359387897b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul M. <paul <at> gpmidi.net> writes:

> 
> Couple questions related to some raid using some firewire disks:
> 
> Is it possible to set the stripe size to 16+MB?
> 
> Is there a way to force the raid driver to only access one disk at a time?
> 
> Thanks,
> 
> Paul

Yes, it's possible - just change the #define MAX_CHUNK_SIZE 
in linux/include/linux/raid/md_k.h and rebuild your kernel.  I am 
happily running an array with a 64MB chunk.

Can some knowledgeable person explain if there is any downside to a very large
number in that define (as in, a few GB)?  Does it use up any resources or can it
overflow any arithmetic somewhere in the kernel?

The original 4MB max limit and 64k default in mdadm appears to be based on the
(erroneous) assumption that small chunks always provide better performance, but
that *really* depends on the application.  I would say that there are two ways
in which high performance can be achieved, both based on minimizing the number
of seeks per transaction or per unit of throughput: either a chunk size much
smaller than the typical read size (so all heads seek to the same place and then
read a bunch from there), or a chunk size much larger than the typical read, and
a lot of concurrent reads (so each read is typically serviced by only a single
seek on one drive, but all drives are kept busy).

--Alex


--- linux.orig/include/linux/raid/md_k.h        2006-03-22 16:42:49
+++ linux/include/linux/raid/md_k.h     2006-03-21 15:04:38
@@ -83,7 +83,7 @@
  * options passed in raidrun:
  */

-#define MAX_CHUNK_SIZE (4096*1024)
+#define MAX_CHUNK_SIZE (128*1024*1024)

 /*
  * MD's 'extended' device


