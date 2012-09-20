From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5: Avoid doing more read on dev of a stripe at the
 same time
Date: Thu, 20 Sep 2012 13:24:22 +1000
Message-ID: <20120920132422.0f7841f1@notabene.brown>
References: <2012091510203206229010@gmail.com>
	<20120920125144.0ed69ec3@notabene.brown>
	<201209201104415460652@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bAqg6zoPgrVVrl1vk=WlxZz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201209201104415460652@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/bAqg6zoPgrVVrl1vk=WlxZz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Sep 2012 11:04:46 +0800 "Jianpeng Ma" <majianpeng@gmail.com> wro=
te:

> On 2012-09-20 10:51 NeilBrown <neilb@suse.de> Wrote:
> >On Sat, 15 Sep 2012 10:20:35 +0800 "Jianpeng Ma" <majianpeng@gmail.com> =
wrote:
> >
> >> In func 'ops_run_bio' if you read the dev which the last reading
> >> of this dev didn't return,it will destrory the  req/rreq'source of rde=
v.
> >> It may call hung-task.
> >> For example, for badsector or other reasons, read-operation only used
> >> stripe instead of chunk_aligned_read.
> >> First:stripe 0;second: stripe 8;third:stripe 16.At the block-layer,thr=
ee
> >> bios merged.
> >> Because media error of sector from 0 to 7, the request retried.
> >> At this time, raid5d readed stripe0 again.But it will set 'bio->next =
=3D
> >> NULL'.So the stripe 8 and 16 didn't return.
> >>=20
> >> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> >
> >Hi,
> > I'm really trying, but I cannot understand what you are saying.
> >
> Sorry for my bad english.
> >I think the situation that you are describing involves a 24 sector reque=
st.
> >This is attached to 3 stripe_heads - 8 sectors each - at address 0, 8, 1=
6.
> >
> >So 'toread' on the first device of each stripe points to this bio, and
> >bi_next is NULL.
> >
> >The "req" bio for each device is filled out to read one page and these t=
hree
> >'req' bios are submitted.  The block layer merges these into a single re=
quest.
> >
> >This request reports an error because there is a read error somewhere in=
 the
> >first  8 sectors.
> >
> Yes,
> >So one, or maybe all, of the 'req' bios return with an error?
> From my test, when req did not return and at the same time, the bio(strip=
e 0) send.
> So this operation will set bi_next is NULL.

Are you saying that we send another bio before the first one has returned?
That shouldn't be possible as sh->count will prevent it from happening.
While there is an outstanding request, sh->count will be >0, and until
sh->count is 0, we won't try to send any more requests.

So I still don't understand.  Please try to provide as much detail as
possible.  If it is easier, write in your own language and use
translate.google.com to convert to english. ??

Thanks,
NeilBrown



> Why am i mention the badsector? Because my disks which had badsector can =
reproduced easily.
> For disks which didn't have badsector,i can't reproduced this bug.
>=20
> >Then RAID5 marks that device as being bad and reads from the other devic=
es to
> >recover the data.
> >
> >Where exactly does something go wrong?  which bio gets bi_next set to NU=
LL
> >when it shouldn't?
> >
> >If you could explain with lots of detail it would help a lot.
> >
> The question is to ensure the first-read returned and the next to send on=
 same dev of stripe.
> >Thanks,
> >NeilBrown
> >
> >
> >> ---
> >>  drivers/md/raid5.c |   13 ++++++++++---
> >>  drivers/md/raid5.h |    1 +
> >>  2 files changed, 11 insertions(+), 3 deletions(-)
> >>=20
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index adda94d..e52ba1b 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -547,9 +547,14 @@ static void ops_run_io(struct stripe_head *sh, st=
ruct stripe_head_state *s)
> >>  				rw =3D WRITE_FUA;
> >>  			else
> >>  				rw =3D WRITE;
> >> -		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
> >> -			rw =3D READ;
> >> -		else if (test_and_clear_bit(R5_WantReplace,
> >> +		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags)) {
> >> +			/*The last read did not return,so skip this read*/
> >> +			if (test_and_set_bit(R5_Reading, &sh->dev[i].flags)) {
> >> +				clear_bit(R5_LOCKED, &sh->dev[i].flags);
> >> +				continue;
> >> +			} else
> >> +				rw =3D READ;
> >> +		} else if (test_and_clear_bit(R5_WantReplace,
> >>  					    &sh->dev[i].flags)) {
> >>  			rw =3D WRITE;
> >>  			replace_only =3D 1;
> >> @@ -700,6 +705,7 @@ static void ops_run_io(struct stripe_head *sh, str=
uct stripe_head_state *s)
> >>  			pr_debug("skip op %ld on disc %d for sector %llu\n",
> >>  				bi->bi_rw, i, (unsigned long long)sh->sector);
> >>  			clear_bit(R5_LOCKED, &sh->dev[i].flags);
> >> +			clear_bit(R5_Reading, &sh->dev[i].flags);
> >>  			set_bit(STRIPE_HANDLE, &sh->state);
> >>  		}
> >>  	}
> >> @@ -1818,6 +1824,7 @@ static void raid5_end_read_request(struct bio * =
bi, int error)
> >>  	}
> >>  	rdev_dec_pending(rdev, conf->mddev);
> >>  	clear_bit(R5_LOCKED, &sh->dev[i].flags);
> >> +	clear_bit(R5_Reading, &sh->dev[i].flags);
> >>  	set_bit(STRIPE_HANDLE, &sh->state);
> >>  	release_stripe(sh);
> >>  }
> >> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> >> index a9fc249..a596df8 100644
> >> --- a/drivers/md/raid5.h
> >> +++ b/drivers/md/raid5.h
> >> @@ -298,6 +298,7 @@ enum r5dev_flags {
> >>  	R5_WantReplace, /* We need to update the replacement, we have read
> >>  			 * data in, and now is a good time to write it out.
> >>  			 */
> >> +	R5_Reading,	/* this dev on reading on lld*/
> >>  };
> >> =20
> >>  /*
> >
> >

--Sig_/bAqg6zoPgrVVrl1vk=WlxZz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFqMZjnsnt1WYoG5AQL6XQ/6Ak9PTwZqhf5ELCNqnhSKT7AL6G9ASz9H
cLiSAXoQU9p9bOkYtYp7+UVYzg0AOa1Fik5zGy0HnekD0v1geREdCs5RNF+d0cGW
qkSp1OLqv22BdtFsA+8GnwqtWcILZJiAbMXzEozGMDs8ohqXIarvWE/m4vFih1Z1
218tD/p4Xm8zI5yfkt4dWLWQN9ZCtXXVkkDHUPZA4c8wrBA7saXCth99wr7Vz05y
hN+qqdXul1AszilZQbroDLOh2KVqEy0UvQPU1QQwGcaii2kNK1SsbulQ1wF4loqA
ok2W6teJVQ9KVdmFHx8XKJBzKUxvKmulhjI61Mp9X3G7ZoLy5LpXnnuZE98TsBXv
e0EayDn4ZT+ulBbI7xWKCnIVcwSOzqnOb5PNWitWLq2DnTVIxRGi7IpejAp4rb0Y
JpzymENvK17OnyCAX8d0KnjswPYcSM8DacPyUMhMQmXLNnoT6G4JTcdETB68jkLM
PHBqNeDTuGQ2Q1pRn48SHocElzkYRk2DHBbVjajZA+/Vg9LvxeCa8JQxgUD9SROF
4YkFwxaFyTPqwptz+V03R2ARJZaf6XHIiumQGmt+U4n9A9UdyyLay8AsSm3dRoB8
5Ai4EP13i/SFH9I2u1ofedLNNynpYUAOEys90Jke1rDhYewiBrsbIYM8NbxjIS9K
b2gtg77ZSy4=
=zdAH
-----END PGP SIGNATURE-----

--Sig_/bAqg6zoPgrVVrl1vk=WlxZz--
