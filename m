From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5: add support for rmw writes in raid6
Date: Mon, 29 Apr 2013 11:29:57 +1000
Message-ID: <20130429112957.4bd6cd71@notabene.brown>
References: <20130418005609.6782.15041.stgit@dev279.prn2.facebook.com>
	<20130422142211.71a1ae8e@notabene.brown>
	<CAA9_cmdbZ_K5Wvo7BH1nPGvttL5As1ncnbPK1ax3TFvGOch6zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.VeCGmcfG+AtB4h5Q1NLP9M"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmdbZ_K5Wvo7BH1nPGvttL5As1ncnbPK1ax3TFvGOch6zw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Kumar Sundararajan <kumar@fb.com>
List-Id: linux-raid.ids

--Sig_/.VeCGmcfG+AtB4h5Q1NLP9M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Apr 2013 14:35:27 -0700 Dan Williams <djbw@fb.com> wrote:

> On Sun, Apr 21, 2013 at 9:22 PM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 17 Apr 2013 17:56:56 -0700 Dan Williams <djbw@fb.com> wrote:
> >
> >> From: Kumar Sundararajan <kumar@fb.com>
> >>
> >> Add support for rmw writes in raid6. This improves small write perform=
ance for most workloads.
> >> Since there may be some configurations and workloads where rcw always =
outperforms rmw,
> >> this feature is disabled by default. It can be enabled via sysfs. For =
example,
> >>
> >>       #echo 1 > /sys/block/md0/md/enable_rmw
> >>
> >> Signed-off-by: Kumar Sundararajan <kumar@fb.com>
> >> Signed-off-by: Dan Williams <djbw@fb.com>
> >> ---
> >> Hi Neil,
> >>
> >> We decided to leave the enable in for the few cases where forced-rcw
> >> outperformed rmw and there may be other cases out there.
> >>
> >> Thoughts?
> >
> > - More commentary would help.  The text at the top should explain enoug=
h so
> >   when I read the code I am just verifying the text at the top, not try=
ing to
> >   figure out how it is supposed to work.
>=20
> Ok, along the lines of:
>=20
> "raid5 has supported sub-stripe writes by computing:
>=20
> P_new =3D P_old + D0_old + D0_new

The '0' looks out of place.  All 'D's are treated the same, so I would write
it
   P_new =3D P_old + D_old + D_new
though that is a small point.

>=20
> For raid6 we add the following:
>=20
> P_new =3D P_old + D0_old + D0_new
>=20
> Q_sub =3D Q_old + syndrome(D0_old)
> Q_sub =3D Q_old + g^0*D0_old
> Q_new =3D Q_old + Q_sub + g^0*D0_new

But here the different Ds are different, so I would be using "Di" or simila=
r.

  P_new =3D P_old + Di_old + Di_new

and I assume the two 'Q_sub' lines are meant to mean the same thing, so let=
's
take the second:

  Q_sub =3D Q_old + g^i * Di_old
  Q_new =3D Q_old + Q_sub + g^i * Di_new

which looks odd as when that expands out, we add Q_old to Q_old and as  '+'
is 'xor', it disappears.  Maybe you mean:

  Q_new =3D Q_sub + g^i * Di_new
??

This is exactly the sort of thing I wanted to see, but I hoped it wouldn't
confuse me like it seems to be doing :-)


>=20
> This has been verified with check and dual-degraded recovery operations.

Good, thanks.

>=20
> > - If 'enable_rmw' really is a good idea, then it is possibly a good ide=
a for
> >   RAID5 to and so should be a separate patch and should work for RAID4/=
5/6.
> >   The default for each array type may well be different, but the
> >   functionality would be the same.
>=20
> Yes, although Kumar's testing has not found a test case that makes
> significant difference for raid5.  I.e. it makes sense to not
> artificially prevent raid5 from disabling rmw if the knob is there for
> raid6, but it would need a specific use case to flip it from the
> default.

Agreed.

>=20
> > - Can you  explain *why* rcw is sometimes better than rmw even on large
> >   arrays? Even a fairly hand-wavy arguement would help.  And it would g=
o in
> >   the comment at the top of the patch that adds enable_rmw.
>=20
> Hand wavy argument is that rcw guarantees that the drives will be more
> busy so small sequential writes have more chance to coalesce into
> larger writes.  Kumar, other thoughts?

So it goes faster because it goes slower?  We seem to see that a lot with
RAID5/6 :-(  But that argument seems to work adequately for both.  If there
is a measured difference it would be nice to know where it comes from.  Not
essential, but nice.

I had guessed that rcw spreads the load over more devices which might help =
on
very busy arrays.

My concern is that rcw being faster might be due to a bug somewhere because
it is counter intuitive.
Or maybe the trade off is different for RAID6 than RAID5.  Or maybe it is
wrong for RAID5 but we haven't noticed.

We currently count the number of devices we will need to read from to satis=
fy
the demands of rcw and rmw, and choose the fewest.
Maybe it is more expensive to read from a device that we are about to write
to by - say - 50% because it keeps the head in the same region for longer
(or more often). So we could scale the costs appropriately.
Maybe a useful tunable would be "read-before-write penalty" rather than
"allow rmw".
With a high read-before-write penalty it would choose rcw more (as it reads
from different devices to where it writes.  With a low read-before-write
penalty it would be more likely to choose rmw where possible.

>=20
> > - patch looks fairly sane assuming that it works - but I don't really k=
now if
> >   it does.  You've reported speeds but haven't told me that you ran 'ch=
eck'
> >   after doing each test and it reported no mismatches.  I suspect you d=
id but
> >   I'd like to be told.  I'd also like to be told what role 'spare2' pla=
ys.
>=20
> spare2 is holding the intermediate Q_sub result of subtracting out the
> syndrome of the old data block(s)

That makes sense.  I wonder if we should call it "Q_sub" rather than "spare=
2".
Maybe there is a better name for spare_page too.

....
> > The continual switching on 'subtract' make this hard to read too.  It is
> > probably a bit big to duplication ... Is there anything you can do to m=
ake it
> > easier to read?
> >
>=20
> Is this any better? Kumar?

Yes thanks.  Together with the above description of what it is trying to
achieve, I can almost say I understand it :-)

Thanks,
NeilBrown


>=20
> static struct dma_async_tx_descriptor *
> ops_run_rmw(struct stripe_head *sh, struct raid5_percpu *percpu,
>             struct dma_async_tx_descriptor *tx, int subtract)
> {
>         int pd_idx =3D sh->pd_idx;
>         int qd_idx =3D sh->qd_idx;
>         struct page **blocks =3D percpu->scribble;
>         struct page *xor_dest, *result, *src, *qresult, *qsrc;
>         struct async_submit_ctl submit;
>         dma_async_tx_callback done_fn;
>         int count;
>=20
>         /* the spare pages hold the intermediate P and Q results */
>         if (subtract) {
>                 result =3D percpu->spare_page;
>                 src =3D sh->dev[pd_idx].page;
>=20
>                 qresult =3D percpu->spare_page2;
>                 qsrc =3D sh->dev[qd_idx].page;
>=20
>                 /* we'll be called once again after new data arrives */
>                 done_fn =3D NULL;
>         } else {
>                 /* this is the final stage of the reconstruct */
>                 result =3D sh->dev[pd_idx].page;
>                 src =3D percpu->spare_page;
>=20
>                 qresult =3D sh->dev[qd_idx].page;
>                 qsrc =3D percpu->spare_page2;
>                 done_fn =3D ops_complete_reconstruct;
>                 atomic_inc(&sh->count);
>         }
>=20
>         pr_debug("%s: stripe %llu\n", __func__,
>                 (unsigned long long)sh->sector);
>=20
>         count =3D set_rmw_syndrome_sources(blocks, sh, percpu, subtract);
>=20
>         init_async_submit(&submit, ASYNC_TX_ACK, tx, NULL, NULL,
>                           to_addr_conv(sh, percpu));
>         tx =3D async_gen_syndrome(blocks, 0, count+2, STRIPE_SIZE, &submi=
t);
>=20
>         xor_dest =3D blocks[0] =3D result;
>         blocks[1] =3D src;
>=20
>         init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, =
tx,
>                           NULL, sh, to_addr_conv(sh, percpu));
>         tx =3D async_xor(xor_dest, blocks, 0, 2, STRIPE_SIZE, &submit);
>=20
>         xor_dest =3D blocks[0] =3D qresult;
>         blocks[1] =3D qsrc;
>=20
>         init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, =
tx,
>                           done_fn, sh, to_addr_conv(sh, percpu));
>         tx =3D async_xor(xor_dest, blocks, 0, 2, STRIPE_SIZE, &submit);
>=20
>         return tx;
> }


--Sig_/.VeCGmcfG+AtB4h5Q1NLP9M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUX3NFTnsnt1WYoG5AQLfIQ/+ISKkBwEGLXStq406zkZNINaDgr99XxJe
zKNlWS8LXP94PQhvoGStlhAcdTZCvXKGo+9rCjwr1B5qlWw/ZH2nc3Orvx7No8Ev
xpvfMvI4lV6ktIuylnMnqQJ+o9shg/dN7UIh0bAYitPOFWxQKLuOHs+Vu9gVeBNA
OwlH0ce7Iuk/3U5dnnMAZY+c1J5e+1mcyozDEDcLBFlqkuYgbRqn2b4RjcqRu1cS
nAe7jDArQMY7IKlrEoc5d2Vk6+aRT2zEFMP5drUwhDKs51Qdmbeqi7czup3U3E7I
OjKiHrwld/mga9Ta9Z4FJgkOwtYss94Q/bPyskD3HW/ey8iVLGN7kILQFn5ZUl6L
V1rTErbjw2of2OyBwRpNTdQk5JTtLdZJoowr+Qo3JNSZ895OhwNNAAn+lUFHiYI/
trNbRXNiXa4rAk2ElpBziUMMQV8K/4GBbIShNIBfvEaG2RsHXYJEwYsJ+ie/LTus
9+wdsjL9kYIu3/4aiVLk2BHccoqJLBTkBpgG2998YZzYZKKvgUW7e1aefe94PEkD
Xvdv8gX8cOf5e+fjnf2doTbksDihGG9FejIlzfoGvy3ugfog0ZE0BiA04+IXs8QA
v+WSYVs/yveqdSaWjqFa+Gdf5BnbuLtrhWbvKLYJIUUyqBclAWszb4lWj09nLnk1
QPeuHq/Gn1U=
=/wPP
-----END PGP SIGNATURE-----

--Sig_/.VeCGmcfG+AtB4h5Q1NLP9M--
