From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast RAID5
Date: Fri, 10 Sep 2004 19:12:37 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409101712.i8AHCbY31083@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: From "(env:" "ptb)" at "Sep 2, 2004 05:10:14 am"
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Also sprach ptb:"
> I'll comment the salient features of this patch now.

And now the real abstract overview.

  1) when finishing write i/o successfully for a buffer head, clear the
     bitmap at the point corresponding to the block (this is in
     raid4_end_write_request, AFAIR).

  2) activate the bitmap on a write error, at the point where a
     previously operational disk is marked not operational (change of
     disk->operational, in raid5_error, just as we call
     mark_disk_faulty). Also do it when error detected in the spare,
     though I don't understand that condition. so fixme.

  3) mark the bitmap as writes are dispatched, in raid5_make_request,
     only for write requests.

     record the events counter as we make the first mark/forst write
     on a previously clean bitmap, so we can tell later by the events
     counter in a newly returned disk if we have the record of
     what writes it missed.

  4) in the resync thread, in raid5_sync_request, just before we get a
     stripe struct with get_active_stripe, determine if the stipe is 
     dirty anywhere by checking the bitmap. If it is dirty, go ahead
     and do the normal handle_stripe call. If it is not dirty pretend
     we did handle the stripe by clearing the STRIPE_SYNCING and
     setting the STRIPE_INSYNC bits on the stripe struct, before
     returning from the routine the expected number of sectors done.

I have since been able to make the resync thread more precise about
what is dirty and what is not, so that it resyncs only dirty blocks
within stripes, not whole stripes.  That is merely down to the
observation that handle_stripe is called many times for the same stripe,
advancing two sectors each time.

The rest of the changes are in md.c, and are the same changes as made to
support hot-repair there in the Fast RAID1 driver
  (ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.14d.tgz,
  http://fr1.sf.net/).

Peter
