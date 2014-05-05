From: NeilBrown <neilb@suse.de>
Subject: Re: raid6 - data integrity issue - data mis-compare on rebuilding
 RAID 6 - with 100 Mb resync speed.
Date: Mon, 5 May 2014 17:21:10 +1000
Message-ID: <20140505172110.73667211@notabene.brown>
References: <13688C12F44C7C428726663F950CA2530972DC8C@venus.in.megatrends.com>
	<20140423170755.1aa92ba6@notabene.brown>
	<CAPcyv4gg6N_FYOZmooXTUYT22AOuBmqFuin_TiKqn8A9DOCnqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/knlDtT5D/I+rye9GY9lxHBx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gg6N_FYOZmooXTUYT22AOuBmqFuin_TiKqn8A9DOCnqw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Manibalan P <pmanibalan@amiindia.co.in>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/knlDtT5D/I+rye9GY9lxHBx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Apr 2014 10:02:00 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> On Wed, Apr 23, 2014 at 12:07 AM, NeilBrown <neilb@suse.de> wrote:
> > On Fri, 11 Apr 2014 17:41:12 +0530 "Manibalan P" <pmanibalan@amiindia.c=
o.in>
> > wrote:
> >
> >> Hi Neil,
> >>
> >> Also, I found the data corruption issue on RHEL 6.5.
> >>
> >> For your kind attention, I up-ported the md code [raid5.c + raid5.h]
> >> from FC11 kernel to CentOS 6.4, and there is no mis-compare with the
> >> up-ported code.
> >
> > This narrows it down to between 2.6.29 and 2.6.32 - is that correct?
> >
> > So it is probably the change to RAID6 to support async parity calculati=
ons.
> >
> > Looking at the code always makes my head spin.
> >
> > Dan : have you any ideas?
> >
> > It seems that writing to a double-degraded RAID6 while it is recovering=
 to
> > a space can trigger data corruption.
> >
> > 2.6.29 works
> > 2.6.32 doesn't
> > 3.8.0 still doesn't.
> >
> > I suspect async parity calculations.
>=20
> I'll take a look.  I've had cleanups of that code on my backlog for "a
> while now (TM)".


Hi Dan,
 did you have a chance to have a look?

I've been consistently failing to find anything.

I have a question though.
If we set up a chain of async dma handling via:
   ops_run_compute6_2 then ops_bio_drain then ops_run_reconstruct

is it possible for the ops_complete_compute callback set up by
ops_run_compute6_2 to be called before ops_run_reconstruct has been schedul=
ed
or run?

If so, there seems to be some room for confusion over the setting for
R5_UPTODATE on blocks that are being computed and then drained to.  Both wi=
ll
try to set the flag, so it could get set before reconstruction has run.

I can't see that this would cause a problem, but then I'm not entirely sure
why we clear R5_UPTODATE when we set R5_Wantdrain.

NeilBrown

--Sig_/knlDtT5D/I+rye9GY9lxHBx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU2c75jnsnt1WYoG5AQK7Gw/+JVgYW+lrBySKg8AjKK2942nPHsjkyaBU
QM/k7bMS+Xbg3blGLL+zxOVGMh5p/FAhAAc5ARA/24+5bYNeOrs+v4kI415tNPoH
RdzM3T0q2xkZGpkxbpBKvV8yC0eGOaNTguyZMeASpBtgBKIcStaKQORAxDebXz68
H9bhy4VN4Qt+gy3/w+/y5jPNmfUC0pcxnwbD42Vx5JNv9wQg3Pa12W5Q1TVp5oO7
m4JxTOf6jEL7t/9UaQ2iNkM0xZGbSQgMXxgS8cN3G23c31Wl/M6M8CPvnACbbHzP
uG2Ir4kmllTQQIdlxFhxhE0RyXWn/BylBUzfMDWAiVwkXre6IWeBIVXkxyTq2Xo3
jsDSNqNm5QO0xd3cAsbx2pK+Dz244zq8Z+a4oK0aKp7XMXRyK44pU3nHrhCjHJOj
TOy7QdztxkyBpam7qwTU4vMHVAd6hES/TkgobY8//P1nsR/1hoF60loRVzdNt98P
MYrG59NA+/4kIZANb6ZOgNaeF2gfepeItrjYly9d6SUOCexa1cswhiV76GO24WpR
u0qUiO6EQNXr/snG7nvFhrhQ4bN0j0mH5tlK4dJ5PZYuYYCrQ5BTLDqOKpWbP7SS
mqoODrCdXIYuQMT6z5xOHFpIHhBJJVhp/O02azdKn1xN/HRuBOOSwUDhtgvdhcaS
I6R9Z43QsEk=
=bXRs
-----END PGP SIGNATURE-----

--Sig_/knlDtT5D/I+rye9GY9lxHBx--
