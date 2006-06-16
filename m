From: "liu yang" <liudows2@gmail.com>
Subject: Re: to understand the logic of raid0_make_request
Date: Fri, 16 Jun 2006 10:53:34 +0800
Message-ID: <4558af040606151953g2ae4c1aasb0c398294cda5887@mail.gmail.com>
References: <4558af040606121737w1bab008am1110e4e1c2cd8934@mail.gmail.com>
	 <17550.2944.728044.154492@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17550.2944.728044.154492@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2006/6/13, Neil Brown <neilb@suse.de>:
> On Tuesday June 13, liudows2@gmail.com wrote:
> > hello,everyone.
> > I am studying the code of raid0.But I find that the logic of
> > raid0_make_request is a little difficult to understand.
> > Who can tell me what the function of raid0_make_request will do eventually?
>
> One of two possibilities.
>
> Most often it will update bio->bi_dev and bio->bi_sector to refer to
> the correct location on the correct underlying devices, and then
> will return '1'.
> The fact that it returns '1' is noticed by generic_make_request in
> block/ll_rw_block.c and generic_make_request will loop around and
> retry the request on the new device at the new offset.
>
> However in the unusual case that the request cross a chunk boundary
> and so needs to be sent to two different devices, raidi_make_request
> will split the bio into to (using bio_split) will submit each of the
> two bios directly down to the appropriate devices - and will then
> return '0', so that generic make request doesn't loop around.
>
> I hope that helps.
>
> NeilBrown
>


Thanks a lot.I went through the code again following your guide.But I
still can't understand how the bio->bi_sector and bio->bi_dev are
computed.I don't know what the var 'block' stands for.
Could you explain them to me ?
Thanks!
Regards.

YangLiu
