From: Neil Brown <neilb@suse.de>
Subject: Re: the question about raid0_make_request
Date: Tue, 20 Jun 2006 08:23:29 +1000
Message-ID: <17559.9185.778789.896340@cse.unsw.edu.au>
References: <4558af040606181821l17679796tf1c756de636ddb11@mail.gmail.com>
	<17558.5.526854.354998@cse.unsw.edu.au>
	<4558af040606190029i72564bd5u735e5b4740bb2ad1@mail.gmail.com>
	<17558.28534.725605.257058@cse.unsw.edu.au>
	<4558af040606190814k2f76cfc8h38374eaed7fe6b19@mail.gmail.com>
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
> We can imagine that there is a raid0 array whose layerout is drawn in the
> attachment.
> Take this for example.
> There are 3 zones totally, and their zone->nb_dev is 5,4,3 respectively.
> In the raid0_make_request function, the var block is the offset of bio in
> kilobytes.
> 
> 
>  x = block >> chunksize_bits;
>   tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
> 
> If block is in the chunk 5, then x = block >> chunksize_bits = 5.And the
> nb_dev of zone2 is 4.
> So tmp_dev = zone->dev[sector_div(5,4)] = zone->dev[1].
> But we can see that the right result should be zone->dev[0].
> Then how does the 'bug'  get the  right  underlying device?

When you say 'right' result, you really mean 'expected' result.

You expect the layout to be

   0   1   2   3   4
       5   6   7   8
           9   10  11

The actual layout for Linux-md-raid0 is

   0   1   2   3   4
       8   5   6   7
           9   10  11

Not what you would expect, but still a valid layout.

NeilBrown
