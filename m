From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and
 async writes
Date: Wed, 23 Jun 2004 17:48:14 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40D9FA9E.9010003@steeleye.com>
References: <40198E85.29EBC8E0@SteelEye.com>	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>	<4027E342.D02202F1@SteelEye.com>	<16424.8182.876520.280031@notabene.cse.unsw.edu.au>	<402D3A86.97CF894F@SteelEye.com>	<16456.2775.641721.204171@notabene.cse.unsw.edu.au>	<4048F9AA.1BBD67F@SteelEye.com>	<406B1024.7BF88C@SteelEye.com>	<16528.49083.998593.199805@cse.unsw.edu.au>	<40C6273B.2060200@steeleye.com> <16590.38597.170409.499394@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16590.38597.170409.499394@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@steeleye.com>
List-Id: linux-raid.ids

Hi Neil,

Here's the next round of patches:

kernel patch against 2.6.7:
--------------------------
http://www.parisc-linux.org/~jejb/md_bitmap/md_bitmap_2_32_2_6_7.diff

mdadm patch against 1.6.0:
-------------------------
http://www.parisc-linux.org/~jejb/md_bitmap/md_bitmap_2_32_2_6_7.diff


Details below...


Neil Brown wrote:
> On Tuesday June 8, paul.clements@steeleye.com wrote:

> This looks a lot better.  There are a few little issues that I noticed
> on a quick read through:
>      - last_block_device should return "sector_t", not "unsigned
>        long".  It would be worth checking for other placed that
>        sector_t might be needed.

Fixed.

>      - bitmap_checkpage still isn't quite safe.  If "hijacked" gets
>        set while it is allocating a page (unlikely, but possible), it
>        will exit with both highjacked set and an allocated page, which
>        isn't right.

Fixed.

>      - The event comparison
> +		    sb->events_hi >= refsb->bitmap_events_hi &&
> +		    sb->events_lo >= refsb->bitmap_events_lo) {
>        in hot_add_disk is wrong. 

This is still there, see my explanation in the previous email...

> The changes to mdadm need a bit of work.
>  
> You have added "--persistent" and "--non-persistent" flags for
> --create.  This is wrong.
> --create always uses persistent superblocks.
> --build makes arrays without persistent superblocks.

OK, changed. The --build command now also accepts the --bitmap option.

> I don't think I like --create-bitmap.  A bitmap file should always be
> created in the context of a particular array (partly so that the size
> and uuid can be set correctly).  I think I would like to bitmap to be
> specified as a "--bitmap=filename" option to --create, --build, or
> --grow.  I haven't thought this through in great detail yet, but that
> is my leaning.

OK, --create-bitmap remains solely for the --build case, but is no 
longer needed for --create. The --create command now does all the array 
creation in userspace and simply Assembles the resulting collection of 
disks. It also initialises the bitmap correctly for use with the array 
(i.e., uuid and size match).

> --examine-bitmap is a bit of a pain too.  I think I would like
> --examine to figure out what it has been given to look at, and report
> on whatever it finds.

This also remains as-is for now, pending your reply to my previous emails.


Thanks,
Paul
