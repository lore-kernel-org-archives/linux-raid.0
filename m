From: Neil Brown <neilb@suse.de>
Subject: RE: Problem in creating RAID5 MD array with kernel 2.6.15
Date: Tue, 11 Apr 2006 17:30:58 +1000
Message-ID: <17467.23346.965887.568254@cse.unsw.edu.au>
References: <17467.21890.331141.217376@cse.unsw.edu.au>
	<WM99EB121D93CD43f188D3116C52572664@spsoftindia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Yogesh Pahilwan on Tuesday April 11
Sender: linux-raid-owner@vger.kernel.org
To: Yogesh Pahilwan <pahilwan.yogesh@spsoftindia.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 11, pahilwan.yogesh@spsoftindia.com wrote:
> Hi Neil,
> 
> I have set --bitmap-chunk=1024 and RAID5 gets created successfully.

Good.

> 
> But why I will have to set --bitmap-chunk for big size devices such as 500GB
> each in my case?
> 
> What is the default value of --bitmap-chunk?

4, which is probably too low.

For every 2048 chunks, md potentially needs to allocate one page.
md also needs to allocate a table to hold all these pages.

At a chunk size of 4K, your 500GB would use 125million chunks.
That's 64000 pages - but these are only allocated on demand, and we can
survive failure.
However the table would need 4 bytes per page, or 250K
Allocating a 250K stable is unlikely to succeed due to memory
fragmentation.

With 1024K chunks you only need 1K, which is easy.

You could safely go down to 256K chunks but I'm not sure it would gain
much.

I have put a note on my mdadm todo list to choose a more sensible
default chunk size which limits the number of chunks to 2million.

NeilBrown
