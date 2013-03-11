From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 lockups post ca64cae96037de16e4af92678814f5d4bf0c1c65
Date: Tue, 12 Mar 2013 09:32:31 +1100
Message-ID: <20130312093231.72c54735@notabene.brown>
References: <wrfj1ubvi88x.fsf@redhat.com>
	<20130305080010.6285b435@notabene.brown>
	<wrfjlia2fd6h.fsf@redhat.com>
	<20130306131804.0b39752a@notabene.brown>
	<wrfj4ngog9h0.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lPFw9lZwwAIzgKrGWCeSHVB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj4ngog9h0.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, Eryu Guan <eguan@redhat.com>
List-Id: linux-raid.ids

--Sig_/lPFw9lZwwAIzgKrGWCeSHVB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 06 Mar 2013 10:31:55 +0100 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> NeilBrown <neilb@suse.de> writes:
> > On Tue, 05 Mar 2013 09:44:54 +0100 Jes Sorensen <Jes.Sorensen@redhat.co=
m>
> > wrote:
> >> > Does this fix it?
> >> >
> >> > NeilBrown
> >>=20
> >> Unfortunately no, I still see these crashes with this one applied :(
> >>=20
> >
> > Thanks - the symptom looked  similar, but now that I look more closely =
I can
> > see it is quite different.
> >
> > How about this then?  I can't really see what is happening, but based o=
n the
> > patch that you identified it must be related to these flags.
> > It seems that handle_stripe_clean_event() is being called to early, and=
 it
> > doesn't clear out the ->written bios because they are still locked or
> > something.  But it does clear R5_Discard on the parity block, so
> > handle_stripe_clean_event doesn't get called again.
> >
> > This makes the handling of the various flags somewhat more uniform, whi=
ch is
> > probably a good thing.
>=20
> Hi Neil,
>=20
> With this one applied I end up with an OOPS instead. Note I had to
> modify the last test/clear bit sequence to use &sh->dev[i].flags instead
> of &dev->flags to avoid a compiler warning.

Oops.

>=20
> I am attaching the test script I am running too. It was written by Eryu
> Guan.

Thanks for that.  I've tried using it but haven't managed to trigger a BUG
yet.  What size are the loop files?  I mostly use fairly small ones, but
maybe it needs to be bigger to trigger the problem.

My current guess is that recovery and discard are both called on the stripe
at the same time and they race and leave the stripe in a slightly confused
state.  But I haven't found the exact state yet.

The discard code always attaches a 'discard' request to every device in a
stripe_head all at once, under stripe_lock.  However when ops_bio_drain pic=
ks
those discard requests of ->towrite and puts them on ->written, it takes
stripe_lock once per device.
Maybe we just need to change the coverage to stripe_lock there to be held f=
or
the entire loop.  We would still want to drop it before calling
async_copy_data() and reclaim afterwards, but that wouldn't affect the
'discard' case.

>=20
>=20
> [ 2623.554780] kernel BUG at drivers/md/raid5.c:2954!

Could you confirm exactly which line this was - there are a few BUG_ON()s
around there.  They are all related to R5_UPTODATE not being set I think,
but it might help to know exactly when it isn't set.


Thanks,
NeilBrown


--Sig_/lPFw9lZwwAIzgKrGWCeSHVB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUT5bfznsnt1WYoG5AQLPJg/+Iv4Uv3K6zx0n3DU6Ipt1Gl8d+T+MlKTR
okpsmesdS33mS8TWZ68grxfLRyYfBG1dEwJg/QFXHjSuscLimWMcWQ2s+6AFZh+f
fyTVz5SY5+Fh3btHOdMMz8UboCcuJQuhv74shBcBUiNP/IatOEGtXPinIrL37Va3
/Lc53oF3rPcEtYj6l6lyyd+nPTYCowSm6ryEIHjKccA9shcxs37bQhaShR/xAcgt
ghEQI2/YwAys/R1WnUA2i5jFWz4r+eBEdpMwYM4agUQsXCuMkkeDFLfczhUB/52I
puqdxzi7o7vgyc3RbgkWIBD7zwxUY2K82dY8w3p7t20OCAVBtDK0Az3o+NwHX1PL
1MKsRG9j3Jw2FlCLPnQR+csVcelu79j0A3Ah0M0wN+tynspFlkmF3buPXglaCoES
bNg4Q9vC+ylyy7zeu1RegK6fzkIkTu7NkOKNTJUXGoI3hBc8knetshooeH5BFSfZ
vJqfLT8RutgsinD1ns3yF0QdTBZAX0Z5U3+uQZvcz5E09iqaIemQ2123RUmR5E96
pRZ3Pf5QQyLQ9x04HGA6mONwhDRQVH1gg5OYRiIptj/2uz4CLCH5a0I9mTT+3XWH
mQ8mM57BqnSsllASiZpEvRdN4sj2lM1DV6aCGymnXQDFOwey2MMFIUhE2HXHKDMS
T8FBCxMpq20=
=T/V3
-----END PGP SIGNATURE-----

--Sig_/lPFw9lZwwAIzgKrGWCeSHVB--
