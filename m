From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: Re: detecting read errors after RAID1 check operation
Date: Wed, 15 Aug 2007 23:27:21 -0400
Message-ID: <15506.1187234841@mdt.ecitele.com>
References: <18115.33874.732489.977468@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Thu, 16 Aug 2007 08:55:14 +1000."
             <18115.33874.732489.977468@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown writes:
> On Wednesday August 15, maccetta@laurelnetworks.com wrote:
> > 
> > There are already files like /sys/block/md_d0/md/dev-sdb/errors in /sys
> > which would be very convenient to consult but according to the kernel
> > driver implementation the error counts reported there are apparently
> > for corrected errors and not relevant for read errors during a "check"
> > operation.
> > 
> 
> When 'check' hits a read error, an attempt is made to 'correct' it by
> over-writing with correct data.  This will either increase the
> 'errors' count or fail the drive completely.
> 
> What 'check' doesn't do (and 'repair' does) it react when it find that
> successful reads of all drives (in a raid1) do not match.
> 
> So just use the 'errors' number - it is exactly what you want.

This happens in our old friend sync_request_write()?  I'm dealing with
simulated errors and will dig further to make sure that is not perturbing
the results but I don't see any 'errors' effect.  This is with our
patched 2.6.20 raid1.c.  The logic doesn't seem to be any different in
2.6.22 from what I can tell, though.

This fragment

	if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
		sbio->bi_end_io = NULL;
		rdev_dec_pending(conf->mirrors[i].rdev, mddev);
	} else {
		/* fixup the bio for reuse */
		...
	}

looks suspicously like any correction attempt for 'check' is being
short-circuited to me, regardless of whether or not there was a read
error.  Actually, even if the rewrite was not being short-circuited,
I still don't see the path that would update 'corrected_errors' in this
case.  There are only two raid1.c sites that touch 'corrected_errors', one
is in fix_read_errors() and the other is later in sync_request_write().
With my limited understanding of how this all works, neither of these
paths would seem to apply here.
--
Mike Accetta

ECI Telecom Ltd.
Transport Networking Division, US (previously Laurel Networks)
