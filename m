From: Christoph Hellwig <hch@infradead.org>
Subject: Re: mdadm - level change from raid 1 to raid 5
Date: Mon, 3 Oct 2011 06:10:45 -0400
Message-ID: <20111003101045.GA9026@infradead.org>
References: <BLU0-SMTP4116DC38F2741F78CA7020C9F70@phx.gbl>
 <20111001080250.65dc83bd@notabene.brown>
 <BLU0-SMTP1299BD19297F8D4A02E6D13C9F50@phx.gbl>
 <20111003075041.188ff3ff@notabene.brown>
 <BLU0-SMTP22900A6C32A672C1C40BF7CC9FA0@phx.gbl>
 <20111003210744.45e637d7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111003210744.45e637d7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Dominique <dcouot@hotmail.com>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Oct 03, 2011 at 09:07:44PM +1100, NeilBrown wrote:
> The default for chunksize should be 512K I thought..

It is.

> I once saw a mathematical formula, but it was a function of the number of
> concurrent accesses and the average IO size - I think.
> 
> Big is good for large streaming requests.  Smaller is good for lots of random
> IO.  Only way to know for sure is to measure your workload on different sizes.
> 
> You can change it once the array is build, but it is a very slow operation as
> it has to move every block on every disk to somewhere else.
> 
>  mdadm -G /dev/md2 --chunk=32

FYI: For XFS I always get much better results using 32k chunk size, even
for simple streaming reads/writes.  I haven't really tracked down why.

Also for any modern system I always have to massively increase the
stripe cache size.

