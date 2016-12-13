From: NeilBrown <neilb@suse.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Wed, 14 Dec 2016 09:18:22 +1100
Message-ID: <877f73zd5d.fsf@notabene.neil.brown.name>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com> <87a8c20xpg.fsf@notabene.neil.brown.name> <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com> <87oa0gzuej.fsf@notabene.neil.brown.name> <CAMGffEm4BDhKJSiDt=2WmxrpRutg862at7JP221gMi6_SpPomQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMGffEm4BDhKJSiDt=2WmxrpRutg862at7JP221gMi6_SpPomQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Dec 14 2016, Jinpu Wang wrote:

>
> As you suggested, I re-run same test with 4.4.36 with no our own patch on MD.
> I can still reproduce the same bug, nr_pending on heathy leg(loop1) is till 1.
>

Thanks.

I have an hypothesis.

md_make_request() calls blk_queue_split().
If that does split the request it will call generic_make_request()
on the first half. That will call back into md_make_request() and
raid1_make_request() which will submit requests to the underlying
devices.  These will get caught on the bio_list_on_stack queue in
generic_make_request().
This is a queue which is not accounted in nr_queued.

When blk_queue_split() completes, 'bio' will be the second half of the
bio.
This enters raid1_make_request() and by this time the array have been
frozen.
So wait_barrier() has to wait for pending requests to complete, and that
includes the one that it stuck in bio_list_on_stack, which will never
complete now.

To see if this might be happening, please change the

	blk_queue_split(q, &bio, q->bio_split);

call in md_make_request() to

	struct bio *tmp = bio;
	blk_queue_split(q, &bio, q->bio_split);
	WARN_ON_ONCE(bio != tmp);

If that ever triggers, then the above is a real possibility.

Fixing the problem isn't very easy...

You could try:
1/ write a function in raid1.c which calls punt_bios_to_rescuer()
  (which you will need to export from block/bio.c),
  passing mddev->queue->bio_split as the bio_set.

1/ change the wait_event_lock_irq() call in wait_barrier() to
   wait_event_lock_irq_cmd(), and pass the new function as the command.

That way, if wait_barrier() ever blocks, all the requests in
bio_list_on_stack will be handled by a separate thread.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhQc64ACgkQOeye3VZi
gbkb+xAAg3OBFqNPaZkQoveJmYWZnzbhCFV43Ifr5aymLwm+PEDb9szhalH1jQUq
2WZBgQ6S1wy1HUERXVR3kr5A/zvMQkmrYLS052ap92xaqfb3yOd/V8Jc7bjPwiMh
3uJ40gtJkj3Mkm0EHL1TFBtea+UM5nkddj9cl7cS/Z/HbkXD6ARDQxCdWJoqx5hs
S0WDYBEQilyZfDBqyMXcf5lg2EMUqivgxhQ1y3X9jAiQ7HvBwcc2FqIkbJ2RU8Zy
R0o1ukRU8IHam/aau6Ex5ucThXlncqwYhP+VfeqVG6tgZXNnYwWE4xJu/9nWUx08
DrI+GAXI1fxPpyHpeSqxnBR1SeU+UXBoTZSFkemhVlwU2xKassJSC+2qnhI6ydhq
fAwsLHOfwSHhMZCGlCHuQlm1XiNUq//N78RNg3sE6aIfkrvdzybmA6df5MNP7yiA
1zsPzx9utYuFigV7YODn0dszuCS8zGbCyCqHJE+knoQ0TvXuTk4SDi1RASzVQ3Mi
ozWZ2KWYCnsODP2ZWxyh1czbUMB/EkqyD3mPTbaXlJQTd2ojuZgUl0GMsf9cNM9E
iDK5LyRK+8todxffJHAU79vn1omixE6+yI3S0SFWSpUduQpFC0S2DCW52sDPHa1x
qIB9fcnahR/4fhnw0VqVc+VQhZ+DDL4TCUORpmTxdiv1v0tUJgw=
=OL2s
-----END PGP SIGNATURE-----
--=-=-=--
