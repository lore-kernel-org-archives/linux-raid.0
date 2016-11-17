From: NeilBrown <neilb@suse.com>
Subject: Re: Just a thought - linux raid wiki - raid 5 grows getting stuck at 0%
Date: Thu, 17 Nov 2016 17:18:42 +1100
Message-ID: <87inrmhbnh.fsf@notabene.neil.brown.name>
References: <582CF0E5.2030605@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <582CF0E5.2030605@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Nov 17 2016, Wols Lists wrote:

> I've just been doing a bit of work on the wiki when I put 2 and 2
> together, and hope I haven't made 5 ...
>
> Bitmaps interfere with grow operations, I believe ...

Used to, yes.  Don't any more.

>
> And mdadm has recently been modified so that bitmaps are switched on by
> default, I also believe ...
>
> Could this be silently blocking the grow, so you don't get any error and
> it just sits there doing nothing?

Nope.  If it was a problem it would explicitly fail.

>
> But that brings up two points. Should mdadm now explicitly look for a
> bitmap when growing an array, and warn that the bitmap needs to be
> disabled? Apparently it currently comes up with some errors that hint at
> the cause rather than explicitly say so.

If you try to reshape an array which has a bitmap, on a kernel that
doesn't support reshaping arrays with bitmaps, mdadm hits this line of
code:

			if (err == EBUSY &&
			    (array.state & (1<<MD_SB_BITMAP_PRESENT)))
				cont_err("Bitmap must be removed before size can be changed\n");

or maybe this one

		pr_err("Cannot set array shape for %s\n",
		       devname);
		if (err == EBUSY &&
		    (info->array.state & (1<<MD_SB_BITMAP_PRESENT)))
			cont_err("       Bitmap must be removed before shape can be changed\n");

or

			if (err == EBUSY &&
			    (array.state & (1<<MD_SB_BITMAP_PRESENT)))
				cont_err("Bitmap must be removed before level can be changed\n");



>
> And secondly, I'm sure someone sent an email to the list that explained
> when a bitmap was created. I can't find it in my archives. The man page
> says it's created if the array is over 100G, but I'm sure the email gave
> rather more detail than that and that the figure actually varied.

	if (!s->bitmap_file &&
	    s->level >= 1 &&
	    st->ss->add_internal_bitmap &&
	    (s->write_behind || s->size > 100*1024*1024ULL)) {
		if (c->verbose > 0)
			pr_err("automatically enabling write-intent bitmap on large array\n");
		s->bitmap_file = "internal";
	}

So it looks like "over 100G" is the only test.

>
> But I'm sure you can see from this that I'm updating this bit of the
> wiki. Is there anything else I ought to know about bitmaps, so I can
> document it? :-)

If only I could run "diff" between my brain and the wiki....

Thanks for doing this!

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLUvCAAoJEDnsnt1WYoG5knoP/2zUxtSXG9rbFiQF4s9B+tFY
8FjWgC4T8kUwjpYPiIxhgKhzq8SPALYPDq5PAqt8Ytyf6PRSa7gEbbDsskY0Id6a
oamfa72p+GX+MzbZMQuXtetZepN7o8+LvWY4u49gPcohhwEXU43nRzLn8CRxEGoR
bBEflp5p6PBJPGiFXLdW6ElFPLI8Ah+osFY+woPh4hJVshMLmnB4zVKFP2DLvy+h
55Yy+6gHHBqzzkK1/8o3sHzGvmPIWOPsg5WCKVj5RQ7TSAz5K6Ooy1uhNkgG4xFI
JSgY+sOfxS7CcB/WmAMTNIFXo2YMs8YPh4MkMyEPwyjvMPPiz0KqKdq4RlTved8f
Ars0Jpfbzt3Wfnz4mw0JKUOT1m53IkvytOVx3eQOwstq8D0CrSmBvphXhC5PsMWp
aAiYQ13JFCd56p9pB0jXeLQhl/+JpuvNsoK+X/LXcYM0lu+p5s7Ubx289/MX8znn
pk5wo3LnPbuCuxNx7mS0FcOnBfAiSyrfdnuUxC1LEyFdo9QS3N3AvnQ0leYqmFNq
iSxoNkOGzcvx2fp3wbX6xHoADaa+T0j/AMVN/Mm9IbcBXbGt1/6JMdQx8Eb+ClGw
5WqRU3oj+LV4vPiMBVkSRTzshY1y60KQGtDZQ3UvCthY2eWLlbC2aJhNUJ4lW0DC
UiWpzbbiyN+9YiJ3tgz7
=AtIz
-----END PGP SIGNATURE-----
--=-=-=--
