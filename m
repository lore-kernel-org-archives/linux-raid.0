From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and
 async writes
Date: Fri, 13 Aug 2004 13:04:36 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16668.12228.187383.596856@cse.unsw.edu.au>
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
	<16590.38597.170409.499394@cse.unsw.edu.au>
	<40D9FA9E.9010003@steeleye.com>
	<40F7E50F.2040308@steeleye.com>
	<16649.61212.310271.36561@cse.unsw.edu.au>
	<4119400A.40307@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Tuesday August 10
To: Paul Clements <paul.clements@steeleye.com>
Cc: jejb@steeleye.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 10, paul.clements@steeleye.com wrote:
> Neil,
> 
> I've implemented the improvements that you've suggested below, and 
> preliminary tests are showing some very good results!
> 
> The latest patches are available at:
> 
> http://www.parisc-linux.org/~jejb/md_bitmap/
> 

This is definitely heading in the right direction.  However I think
you have missed some of the subtleties of plugging.

Plugging should be seen as entirely the responsibility of each
device.  Each device will plug it's own queue if or when it thinks
that is a good idea, and will possibly unplug it spontaneously.  Thus
if you ever call generic_make_request, you have to assume that the
request could get services at any moment.

The only interest that clients of a device have in plugging is that
they may request the device to unplug, in case it still has some old
requests in a plugged queue.

When a raid1 write request comes, your code passes that request to
generic_make_request, and schedules a bitmap update for later.
Presumably you assume that the underlying devices are or will-be
plugged and only get unplugged when ->unplug_fn is called.  However
this isn't true.

What you need to do is:
  In the WRITE branch of make_request, schedule the bitmap update as
  you currently do, but *don't* call generic_make_request on the bio.
  Instead, you should add the bio to a queue using ->bi_next for
  linkage. 

  Then in raid1_unplug, you should:
    Call bitmap_unplug
     (this waits for the bitmaps to be safe)
    Walk through the queue of bio and submit them with
      make_request. As the bit(s) will already be marked dirty, the
      request will go straight through.  
    Finally call unplug_slaves.

That should then have the bitmap updates happening before the
data updates, and should cluster bitmap updates better.

The next step would be to stop write_page from being synchronous - I'm
not comfortable about ->unplug-fn having to wait for disk io.

This looks to be quite awkward as there is not call-back that happens
when writeback on a page is completed.  You need to have a kernel
thread to wait for the pages to complete.  I would get the
bitmap_daemon to do this.

write_page puts the page on a queue and wakes up bitmap_write_daemon
bitmap_write_daemon calls prepare_write/commit_write and puts the page
on another queue and wakes up bitmap_daemon.

bitmap_daemon whenever it is woken up:
   - checks if any clean bitmaps needs to be written and puts them on
     the queue for bitmap_write_daemon
   - checks if there is a page in the queue from bitmap_write_daemon
     and, if there is, waits for it (wait_on_page_writeback).
     When that completes, put the page and decrease a count, and go
     round the loop.
   - if the count of pending bitmap updates hits zero, bitmap_daemon
     walks the queue of pending write requests of the array (as I
     suggested above could be done in raid1_unplug) and submits them.

Does that make sense?

I would suggest doing the first version first (leaving write_page
synchronous), and then have a go at making write_page synchronous.

NeilBrown
