From: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.15-mm3 hangs during boot (raid related?)
Date: Thu, 12 Jan 2006 17:36:42 +1100
Message-ID: <17349.63738.220760.681335@cse.unsw.edu.au>
References: <20060112062310.GA12471@gates.of.nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932683AbWALGg5@vger.kernel.org>
In-Reply-To: message from Jurriaan on adsl-gate on Thursday January 12
Sender: linux-kernel-owner@vger.kernel.org
To: Jurriaan <thunder7@xs4all.nl>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 12, thunder7@xs4all.nl wrote:
> 
> 2.6.15-mm3 hangs during boot for me, after the lines
> 
> ========
> md4: bitmap initialized from disk: read 15/15 pages, set 51 bits, status: 0
> created bitmap (224 pages) for device md4
> ========
> 
> ctrl-alt-del to reboot works sometimes (2 out of 3). Below is complete
> dmesg (from 2.6.15-mm2, ver_linux output, .config and raid details).

Yep, this is probably a known problem with recent changes to the
'barrier' code.

Try to convince md not to use barrier by changing md_super_write in
drivers/md/md.c.  Simply remove

	if (!test_bit(BarriersNotsupp, &rdev->flags)) {
		struct bio *rbio;
		rw |= (1<<BIO_RW_BARRIER);
		rbio = bio_clone(bio, GFP_NOIO);
		rbio->bi_private = bio;
		rbio->bi_end_io = super_written_barrier;
		submit_bio(rw, rbio);
	} else

leaving the
		submit_bio(rw, rbio);

which comes after it.

NeilBrown
