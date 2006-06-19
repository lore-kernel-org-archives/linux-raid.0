From: Neil Brown <neilb@suse.de>
Subject: Re: the question about raid0_make_request
Date: Mon, 19 Jun 2006 19:33:42 +1000
Message-ID: <17558.28534.725605.257058@cse.unsw.edu.au>
References: <4558af040606181821l17679796tf1c756de636ddb11@mail.gmail.com>
	<17558.5.526854.354998@cse.unsw.edu.au>
	<4558af040606190029i72564bd5u735e5b4740bb2ad1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from liu yang on Monday June 19
Sender: linux-raid-owner@vger.kernel.org
To: liu yang <liudows2@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 19, liudows2@gmail.com wrote:
> Thanks,Neil.
> I noticed that the whole codes of calculating the underlying device is below
> 	{
> 		sector_t x =  (block - zone->zone_offset) >> chunksize_bits;
> 
> 		sector_div(x, zone->nb_dev);
> 		chunk = x;
> 		BUG_ON(x != (sector_t)chunk);
> 
> 		x = block >> chunksize_bits;
> 		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
> 	}
> 	rsect = (((chunk << chunksize_bits) + zone->dev_offset)<<1)
> 		+ sect_in_chunk;
> 
> so we first set the var x to the chunk number relative to the start of
> the current zone.But after that we execute 'x = block >>
> chunksize_bits' which will set x to the chunk nr relative to the start
>  of the mddev,I think. Right?
> I am confused.

Ahhhh yes, now I remember.

Yes, you are right, this code is 'wrong' - but it is 'definitively
wrong' if that means anything ....

The line
> 		x = block >> chunksize_bits;
really 'should' be
> 		x = (block - zone->zone_offset) >> chunksize_bits;

but it isn't.  That bug has been there 'forever'.  You can see it in
2.0.40 at 
  http://lxr.linux.no/source/drivers/block/raid0.c?v=2.0.40#L201

The effect of that 'bug' is that in zones after the first, all the
blocks are shifted some number of devices to the right compared with
where you would expect them to be.
e.g. the first block in new zone might not be on the first device in
the zone, but might be on the third, or whatever.
However the offset is consistent.   Whether you read or write data,
you will find the block at the same offset.  So the array works
perfectly, except not exactly how you would expect.

Obviously we could not 'fix' this 'bug', because then anyone who has a
raid0 will multiple zones would find their array gets corrupted when
they upgrade.

If we ever wanted to support some raid0 array that was also accessed
by other software (e.g. a DDF array), we would need to make sure that
the 'bug' was fixed in that usage. 

So you are right, the code is confusing, but it does provide a
reliable raid0 array.

I hope that helps.

I guess we should really put a comment in there explaining this....

NeilBrown
