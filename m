From: Neil Brown <neilb@suse.de>
Subject: Re: to understand the logic of raid0_make_request
Date: Tue, 13 Jun 2006 10:49:04 +1000
Message-ID: <17550.2944.728044.154492@cse.unsw.edu.au>
References: <4558af040606121737w1bab008am1110e4e1c2cd8934@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from liu yang on Tuesday June 13
Sender: linux-raid-owner@vger.kernel.org
To: liu yang <liudows2@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 13, liudows2@gmail.com wrote:
> hello,everyone.
> I am studying the code of raid0.But I find that the logic of
> raid0_make_request is a little difficult to understand.
> Who can tell me what the function of raid0_make_request will do eventually?

One of two possibilities.

Most often it will update bio->bi_dev and bio->bi_sector to refer to
the correct location on the correct underlying devices, and then 
will return '1'.
The fact that it returns '1' is noticed by generic_make_request in
block/ll_rw_block.c and generic_make_request will loop around and
retry the request on the new device at the new offset.

However in the unusual case that the request cross a chunk boundary
and so needs to be sent to two different devices, raidi_make_request
will split the bio into to (using bio_split) will submit each of the
two bios directly down to the appropriate devices - and will then
return '0', so that generic make request doesn't loop around.

I hope that helps.

NeilBrown
