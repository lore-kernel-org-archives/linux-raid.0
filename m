From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and
 async writes
Date: Tue, 15 Jun 2004 16:27:17 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16590.38597.170409.499394@cse.unsw.edu.au>
References: <40198E85.29EBC8E0@SteelEye.com>
	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>
	<4027E342.D02202F1@SteelEye.com>
	<16424.8182.876520.280031@notabene.cse.unsw.edu.au>
	<402D3A86.97CF894F@SteelEye.com>
	<16456.2775.641721.204171@notabene.cse.unsw.edu.au>
	<4048F9AA.1BBD67F@SteelEye.com>
	<406B1024.7BF88C@SteelEye.com>
	<16528.49083.998593.199805@cse.unsw.edu.au>
	<40C6273B.2060200@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Tuesday June 8
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@steeleye.com>
List-Id: linux-raid.ids

On Tuesday June 8, paul.clements@steeleye.com wrote:
> Neil,
> 
> Here's the latest patch...it supports bitmaps in files as well as block 
> devices (disks or partitions), contrary to what I had stated in my 
> previous e-mail. I've tried to address all the issues you've pointed 
> out, and generally cleaned up and fixed the patch some more...details 
> below...

This looks a lot better.  There are a few little issues that I noticed
on a quick read through:
     - last_block_device should return "sector_t", not "unsigned
       long".  It would be worth checking for other placed that
       sector_t might be needed.
     - bitmap_checkpage still isn't quite safe.  If "hijacked" gets
       set while it is allocating a page (unlikely, but possible), it
       will exit with both highjacked set and an allocated page, which
       isn't right.
     - The event comparison
+		    sb->events_hi >= refsb->bitmap_events_hi &&
+		    sb->events_lo >= refsb->bitmap_events_lo) {
       in hot_add_disk is wrong. 

I'll try to make time to try the patch out in a week or so to get a
better feel for it.

The changes to mdadm need a bit of work.
 
You have added "--persistent" and "--non-persistent" flags for
--create.  This is wrong.
--create always uses persistent superblocks.
--build makes arrays without persistent superblocks.

I don't think I like --create-bitmap.  A bitmap file should always be
created in the context of a particular array (partly so that the size
and uuid can be set correctly).  I think I would like to bitmap to be
specified as a "--bitmap=filename" option to --create, --build, or
--grow.  I haven't thought this through in great detail yet, but that
is my leaning.

--examine-bitmap is a bit of a pain too.  I think I would like
--examine to figure out what it has been given to look at, and report
on whatever it finds.

NeilBrown
