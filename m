From: James Braid <jamesb@loreland.org>
Subject: Re: chunk size must be power of two?
Date: Thu, 07 Dec 2006 00:16:55 +0000
Message-ID: <45775D77.8040200@loreland.org>
References: <45773622.8020704@loreland.org> <17783.15369.828178.167586@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17783.15369.828178.167586@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
 > On Wednesday December 6, jamesb@loreland.org wrote:
 >> Is there any reason the chunk size has to be a power of two?
 >
 > It makes division a lot easier and faster.

Thanks for the reply.

 >> We're trying to use md devices to stripe over hardware RAID5 arrays, so
 >> to align the I/O correctly, I want to set the chunk size to (n - 1) *
 >> stripe_size for the underlying array. Which is impossible to do because
 >> mdadm (and the kernel) insist on the chunk size being a power of
 >> two.
 >
 > Surely you want to set chunk_size to 1 * stripe_size for the
 > underlying array ... or maybe 1/(n-1) * stripe_size.  But certainly
 > not (n-1) * stripe_size.  That wouldn't make any sense at all.

I suspect I haven't explained myself very clearly... I'm trying to 
stripe over multiple separate hardware raid5 luns using md... see below 
for details.

 >> I haven't tried just removing the kernel checks yet ... is there a
 >> reason why md is limited to power of two chunk sizes?
 >
 > You would need to check all the div and mod operations based on chunk
 > size and make sure they don't implicitly assume it is a power of 2.

OK, thanks.

 > What exactly is the geometry of the array you wan to access with md??

four 7+1 raid5 luns (from multiple controllers etc) with a stripe size 
of 128K, and I am then striping across all four luns with md.

So I want to set the md chunk_size to 896K so we write a full stripe (7 
* 128K) to each lun before moving on to the next.

Testing on other volume managers (IRIX/Linux with xvm) has shown 
aligning the I/O like this improves performance for our workload (lots 
of large files with streaming reads and writes), but I can't use xvm for 
this particular system.

Thanks, James
