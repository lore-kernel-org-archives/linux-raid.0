From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and
 async writes
Date: Tue, 12 Oct 2004 12:15:25 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16747.15933.68499.915859@cse.unsw.edu.au>
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
	<16668.12228.187383.596856@cse.unsw.edu.au>
	<414F9FD4.4070308@steeleye.com>
	<41507EA7.1000905@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Tuesday September 21
To: Paul Clements <paul.clements@steeleye.com>
Cc: jejb@steeleye.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 21, paul.clements@steeleye.com wrote:
> Paul Clements wrote:
> > OK, here we go again. The patch has been updated to 2.6.9-rc2 and mdadm 
> > 1.7.0, and I've implemented the suggestions you've made below...
> > 
> > Patches: http://parisc-linux.org/~jejb/md_bitmap/
> 
> Well, I ran some simple write performance benchmarks today and I was 
> stunned to find the bitmap performance was terrible. After debugging a 
> while, I realized the problem was having the bitmap daemon do the 
> wait_on_page_writeback...if the daemon got caught at the wrong time, it 
> could take quite a while to come back around and do the writeback. So, I 
> added yet another thread, the bitmap writeback daemon (whose sole 
> purpose is to wait for page writebacks) and now things are running 
> excellently. My simple benchmarks, which previously showed about a 
> 25-30% slowdown when using a bitmap vs. not using one, now show only a 
> 4% slowdown, which is pretty close to the margin of error in the test 
> itself. Check out the new patch here:
> 
> http://parisc-linux.org/~jejb/md_bitmap/md_bitmap_2_37_2_6_9_rc2.diff
> 
> Thanks again,
> Paul
> 


Further comments.

bitmap_events
  1/  You have inserted bitmap_event_hi/lo *before* recovery_cp, thus
      moving recovery_cp, and thus breaking backwards comparability.
  2/ The test in hot_add_disk:
+		if (refsb && sb && uuid_equal(sb, refsb) &&
+		    sb->events_hi >= refsb->bitmap_events_hi &&
+		    sb->events_lo >= refsb->bitmap_events_lo) {
+			bitmap_invalidate = 0;
   is wrong.  The events count must be compared as a 64bit
  number. e.g. it is only meaningful to compare events_lo if both
  events_hi are equal.

pending_bio_list
  1/ Do you really need a separate pending_bio_lock, or would
     the current device_lock be adequate to the task.
  2/  I think there can be a race with new requests being added to
     this list while bitmap_unplug is running in unplug_slaves.
     I think you should "bio_get_list" before calling bitmap_unplug,
     So that you only then submit requests that were made definitely
     *before* the call the bitmap_unplug.  This would have the added
     advantage that you don't need to keep claiming and dropping
     pending_bio_lock. 

random damage
   1/ You have changed r1bio_pool_free without it being a useful
      change.
   2/ You have removed "static" from sync_page_io for no apparent
      reason.
   3/ You declare and set start_sector_nr, and never use it.


I have removed the "random damage" bit and merged that patch into my
collection.  I would really appreciate it if any further changes could
be sent as incremental patches, as reading through a large patch like
that takes a fair bit of effort.

I'll hopefully be finishing up some modification to mdadm this week.
I'll aim to include support for bitmaps as part of that (based on your
patch, but probably with a number of changes to match changes in
mdadm).

NeilBrown

