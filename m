From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v6 03/11] md/r5cache: State machine for raid5-cache write back mode
Date: Wed, 16 Nov 2016 11:17:13 +1100
Message-ID: <87bmxgi8hi.fsf@notabene.neil.brown.name>
References: <20161110204623.3484694-1-songliubraving@fb.com> <20161110204623.3484694-4-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161110204623.3484694-4-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 11 2016, Song Liu wrote:

> This patch adds state machine for raid5-cache. With log device, the
> raid456 array could operate in two different modes (r5c_journal_mode):
>   - write-back (R5C_MODE_WRITE_BACK)
>   - write-through (R5C_MODE_WRITE_THROUGH)
>
> Existing code of raid5-cache only has write-through mode. For write-back
> cache, it is necessary to extend the state machine.
>
> With write-back cache, every stripe could operate in two different
> modes:
>   - caching
>   - writing-out
>
> In caching mode, the stripe handles writes as:
>   - write to journal
>   - return IO
>
> In writing-out mode, the stripe behaviors as a stripe in write through
> mode R5C_MODE_WRITE_THROUGH.
>
> STRIPE_R5C_WRITE_OUT is added to sh->state to differentiate caching and
> writing-out mode.
>
> When the array is write-through, stripes also go between caching mode
> and writing-out mode.

This bothers me.  Why would a stripe *ever* be in "caching mode" (or
"caching phase") when the array is in write-through?  It doesn't seem to
make sense.

A stripe_head goes through several states/stages/phases/things.

 1/ write data blocks to journal
 2/ reading missing data blocks and compute parity
 3/ write data and parity to journal
 4/ write data and parity to RAID

When there is no log, we only perform 2 and 4
When there is a log in WRITE_THOUGH we perform 2,3,4
When there is a log in WRITE_BACK we perform 1 (maybe several times) 2 3 4.

Step 2 is initiated by calling handle_stripe_dirtying().
A new function is introduced "r5c_handle_stripe_dirtying()" which
determines if handle_stripe_dirtying() should do anything.
(It returns '0' if it shouldn't proceed, and -EAGAIN if it should,
 which seems a little strange).

If there is no log, or if STRIPE_R5C_WRITE_OUT is set, -EAGAIN is
returned.
Otherwise if in MODE_WRITE_THROUGH, STRIPE_R5C_WRITE_OUT is set and
=2DEAGAIN is returned.
else (in next patch) are more complex determination is made, but
=2DEAGAIN is only ever returns with STRIPE_R5C_WRITE_OUT set, or if log =3D=
=3D NULL.

So STRIPE_R5C_WRITE_OUT is (sometimes) set to enter step 2, and cleared
when step 4 completes.

STRIPE_R5C_WRITE_OUT means that the 2(3)4 writeout sequence has
commenced and not yet completed.  I would like to see it *always* set
when that happens, including when log=3D=3DNULL.
I would probably even rename r5c_handle_stripe_dirtying() to something
like  r5c_check_need_writeout() which would check to see if writeout was
needed, and would set STRIPE_R5C_WRITE_OUT if it was.
Then handle_stripe_dirtying() would be called iff STRIPE_R5C_WRITE_OUT
were set. (it could even be named to handle_stripe_writeout()??)

There are two actions that can be taken when where are ->towrite blocks
on a stripe.  We can enter WRITE_OUT, or they can be cached in the
journal.  Also we can enter WRITE_OUT when a stripe needs to be removed
From=20memory or from the journal.
This makes "writeout" and "cache" seem more like "actions" than states,
modes, or phases.  Naming is hard.

Trying to understand R5_InJournal:
 It is set (on pd_idx) when step 3 completes.
 It is only used (in this patch) in r5c_finish_stripe_write_out()
   to make sure WRITE_OUT isn't cleared until after InJournal is
 cleared.

So setting InJournal[pd_idx] marks the end of step 3 and clearing WRITE_OUT
marks the end of step 4.

I think that observation helps me understand the code a bit better.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYK6WJAAoJEDnsnt1WYoG5jxQQAKRi0o5sAk+iXxk4ak8y245C
DSFu5KCphh+8g1GHUDZ9Usr8NHiazDaq6C6EWRilcrIlN4te8sfoNhHypuXQdFG0
Q3YfTiSQZzm1hS03zmu0WgWe+G3B4s189ihWjrTr6iDuvJ+ze94RlZfi8rIndZFp
by6rwAkYG18Pmgc7tK+0Tu41qOLg2QDZ1pvdb8olnARn4HOLZCyw4zbHk93a0g4r
7i1AXZrfIjh3yoOxqdgKDBnSf28Hi7TKrYwFpBsZQpkT6242d0eCRoVwBXIZ98Xd
+0jNaOYQyWdR51iRIw1mk+7ilqnAPlrmUw6h+a+9kbyE8IOOfzXHxx7pvdor7TTB
4HiiH9mpd/7KJqUAHPrymPr2pUOKmunFztzpvQeHpppTIA7S4dsRiS1vHbCPm1Tj
wUqjVul/6FZrpN0zAmn8si4iTIQbA2edviT6VEX3+73cv+AzYNIlOCpn7nuoQKnl
J7/JjSVsJC41EKcHz+9FSHPtRAQlCwchW6pFF9uvZ7nytAP5bNtVzJp27eRDQluO
1it6EOqKDSmdXTjhee7i9zkQ2P+7KAdKLKwtpryhNjwCQ/EOagLf6wVkglDwQ5Ai
lOPobP3Ndb57kUE2uy4kc90QPckYP4OwPeolxRXZJ9TeytWBcIrCze5nhL+x90ac
vYr65FPQWun10pHJgwgU
=4w4l
-----END PGP SIGNATURE-----
--=-=-=--
