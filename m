From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and
 async writes
Date: Tue, 12 Oct 2004 10:06:18 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <416BE4DA.1040408@steeleye.com>
References: <40198E85.29EBC8E0@SteelEye.com>	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>	<4027E342.D02202F1@SteelEye.com>	<16424.8182.876520.280031@notabene.cse.unsw.edu.au>	<402D3A86.97CF894F@SteelEye.com>	<16456.2775.641721.204171@notabene.cse.unsw.edu.au>	<4048F9AA.1BBD67F@SteelEye.com>	<406B1024.7BF88C@SteelEye.com>	<16528.49083.998593.199805@cse.unsw.edu.au>	<40C6273B.2060200@steeleye.com>	<16590.38597.170409.499394@cse.unsw.edu.au>	<40D9FA9E.9010003@steeleye.com>	<40F7E50F.2040308@steeleye.com>	<16649.61212.310271.36561@cse.unsw.edu.au>	<4119400A.40307@steeleye.com>	<16668.12228.187383.596856@cse.unsw.edu.au>	<414F9FD4.4070308@steeleye.com>	<41507EA7.1000905@steeleye.com> <16747.15933.68499.915859@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16747.15933.68499.915859@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: jejb@steeleye.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
>>Paul Clements wrote:

>>itself. Check out the new patch here:
>>
>>http://parisc-linux.org/~jejb/md_bitmap/md_bitmap_2_37_2_6_9_rc2.diff
>>

> Further comments.
> 
> bitmap_events
>   1/  You have inserted bitmap_event_hi/lo *before* recovery_cp, thus
>       moving recovery_cp, and thus breaking backwards comparability.

Yes. I guess when recovery_cp came along I failed to notice that...

>   2/ The test in hot_add_disk:
> +		if (refsb && sb && uuid_equal(sb, refsb) &&
> +		    sb->events_hi >= refsb->bitmap_events_hi &&
> +		    sb->events_lo >= refsb->bitmap_events_lo) {
> +			bitmap_invalidate = 0;
>    is wrong.  The events count must be compared as a 64bit
>   number. e.g. it is only meaningful to compare events_lo if both
>   events_hi are equal.

Yes, that is broken.

> pending_bio_list
>   1/ Do you really need a separate pending_bio_lock, or would
>      the current device_lock be adequate to the task.

Probably so...especially with the following change...

>   2/  I think there can be a race with new requests being added to
>      this list while bitmap_unplug is running in unplug_slaves.
>      I think you should "bio_get_list" before calling bitmap_unplug,
>      So that you only then submit requests that were made definitely
>      *before* the call the bitmap_unplug.  This would have the added
>      advantage that you don't need to keep claiming and dropping
>      pending_bio_lock. 

Yes, that would make sense.

> collection.  I would really appreciate it if any further changes could
> be sent as incremental patches, as reading through a large patch like
> that takes a fair bit of effort.

Yes, I certainly understand that. I appreciate all the effort you've put 
into reviewing and giving suggestions. Further patches will be on top of 
the current bitmap patch.

I will send out an incremental patch to fix the issues above, probably 
in a couple of days.

Thanks,
Paul

