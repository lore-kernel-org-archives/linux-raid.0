From: Jurriaan on adsl-gate <thunder7@xs4all.nl>
Subject: Re: 2.6.15-mm3 hangs during boot (raid related?)
Date: Thu, 12 Jan 2006 18:29:00 +0100
Message-ID: <20060112172900.GA3687@gates.of.nowhere>
References: <20060112062310.GA12471@gates.of.nowhere> <17349.63738.220760.681335@cse.unsw.edu.au>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17349.63738.220760.681335@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jurriaan <thunder7@xs4all.nl>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

From: Neil Brown <neilb@suse.de>
Date: Thu, Jan 12, 2006 at 05:36:42PM +1100
Sent-To: 
> On Thursday January 12, thunder7@xs4all.nl wrote:
> > 
> > 2.6.15-mm3 hangs during boot for me, after the lines
> > 
> > ========
> > md4: bitmap initialized from disk: read 15/15 pages, set 51 bits, status: 0
> > created bitmap (224 pages) for device md4
> > ========
> > 
> > ctrl-alt-del to reboot works sometimes (2 out of 3). Below is complete
> > dmesg (from 2.6.15-mm2, ver_linux output, .config and raid details).
> 
> Yep, this is probably a known problem with recent changes to the
> 'barrier' code.
> 
> Try to convince md not to use barrier by changing md_super_write in
> drivers/md/md.c.  Simply remove
> 
> 	if (!test_bit(BarriersNotsupp, &rdev->flags)) {
> 		struct bio *rbio;
> 		rw |= (1<<BIO_RW_BARRIER);
> 		rbio = bio_clone(bio, GFP_NOIO);
> 		rbio->bi_private = bio;
> 		rbio->bi_end_io = super_written_barrier;
> 		submit_bio(rw, rbio);
> 	} else
> 
> leaving the
> 		submit_bio(rw, rbio);
> 
> which comes after it.
> 
With this patch, it boots and works just fine.

Kind regards,
Jurriaan
-- 
His pride could withstand anything. He simply wouldn't care.
	Melanie Rawn - Skybowl
Debian (Unstable) GNU/Linux 2.6.15-mm3 2x4802 bogomips 0.31
