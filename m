From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and
 async writes
Date: Fri, 18 Jun 2004 16:48:31 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40D3551F.90708@steeleye.com>
References: <40198E85.29EBC8E0@SteelEye.com>	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>	<4027E342.D02202F1@SteelEye.com>	<16424.8182.876520.280031@notabene.cse.unsw.edu.au>	<402D3A86.97CF894F@SteelEye.com>	<16456.2775.641721.204171@notabene.cse.unsw.edu.au>	<4048F9AA.1BBD67F@SteelEye.com>	<406B1024.7BF88C@SteelEye.com>	<16528.49083.998593.199805@cse.unsw.edu.au>	<40C6273B.2060200@steeleye.com> <16590.38597.170409.499394@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16590.38597.170409.499394@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@steeleye.com>
List-Id: linux-raid.ids

Neil,

responses to your feedback on the kernel code:

Neil Brown wrote:
> On Tuesday June 8, paul.clements@steeleye.com wrote:

> This looks a lot better.  There are a few little issues that I noticed
> on a quick read through:
>      - last_block_device should return "sector_t", not "unsigned
>        long".  It would be worth checking for other placed that
>        sector_t might be needed.

Yes, there were a couple. I've fixed them now.

>      - bitmap_checkpage still isn't quite safe.  If "hijacked" gets
>        set while it is allocating a page (unlikely, but possible), it
>        will exit with both highjacked set and an allocated page, which
>        isn't right.

Yes, that's right. Fixed.

>      - The event comparison
> +		    sb->events_hi >= refsb->bitmap_events_hi &&
> +		    sb->events_lo >= refsb->bitmap_events_lo) {
>        in hot_add_disk is wrong. 

I think it's OK. Basically, I only record bitmap events while the array 
is in sync. As soon as the array goes out of sync, we continue to set 
bits in the bitmap, but never clear them. This means that the bitmap is 
valid for resyncing any disk that was part of the array at the time it 
was last in sync. Does that make sense, or am I missing a corner case?


> I'll try to make time to try the patch out in a week or so to get a
> better feel for it.

OK, that sounds great.

Thanks,
Paul
