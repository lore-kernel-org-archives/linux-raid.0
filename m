From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC] MD: Allow restarting an interrupted incremental recovery.
Date: Tue, 18 Oct 2011 07:58:54 +1100
Message-ID: <20111018075854.7f026e2a@notabene.brown>
References: <20111017142039.5a07b12f@notabene.brown>
	<992889476.11312.1318872404724.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/42eCC_37AWdTWY91GIUJxIi"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <992889476.11312.1318872404724.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Warkentin <awarkentin@vmware.com>
Cc: Andrei Warkentin <andreiw@vmware.com>, linux-raid@vger.kernel.org, "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
List-Id: linux-raid.ids

--Sig_/42eCC_37AWdTWY91GIUJxIi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Oct 2011 10:26:44 -0700 (PDT) Andrei Warkentin
<awarkentin@vmware.com> wrote:

> Hi Neil,

> > If you look at it that way, you might notice that saved_raid_disk is
> > also set
> > in slot_store, so probably InIncremental should be set there.  So
> > that might
> > be the one thing you missed.
> >
>=20
> Actually, maybe you can clarify something a bit about that code? The part=
 where
> slot !=3D -1 and mddev->pers !=3D NULL looks a lot like the add_new_disk =
path - except:
>=20
> After pers->hot_add_disk:
> 1) rdev In_sync isn't cleared

That looks like a bug.  I don't think I've ever tested re-adding a device by
setting 'slot' - only adding.  And for adding, In_sync is already clear.
Thanks for spotting that.

> 2) Array isn't checked for degraded state and MD_RECOVERY_RECOVER isn't c=
onditionally set.

I think that isn't really needed in add_new_disk.
md_check_recovery will set it before recovery starts if there are spares in
the array.
So I'm inclined to just remove it from add_new_disk, but I feel that I need
to read the code a bit more carefully first.

In any case, the next point makes the omission harmless even if
MD_RECOVERY_RECOVER is needed there for some reason.


> 3) MD_RECOVERY_NEEDED isn't set.


That might be deliberate.  It allows a few drives to be added, then recovery
started by writing "recover" to sync_action.
The same could be achieved by writing "frozen" to sync_action first but I
probably wrote this code before I added "frozen".


> 4) mddev->thread is't woken up.

That goes with 3.  we only wake up the thread so that it notices
MD_RECOVERY_NEEDED.


>=20
> Is this because if an array was degraded AND there were extra spares, the=
y would already be
> assigned to the array?

Probably, yes.

Thinking a bit more, you would only get to set 'slot' on a spare in an acti=
ve
array if you had first 'frozen' sync_action .. so some of my comments above
might be a bit wrong.
And given that you have frozen sync_action, you really don't want to set
MD_RECOVERY_NEEDED or start the thread.


Thanks,
NeilBrown



> =20
> > Could you respin the patch without adding InIncremental, and testing
> >   rdev->saved_raid_disk >=3D 0
> > instead, check if you agree that should work, and perform a similar
> > test?
> > (Is that asking too much?).
> >=20
>=20
> Absolutely! Thanks again!
>=20
> A


--Sig_/42eCC_37AWdTWY91GIUJxIi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpyXFDnsnt1WYoG5AQJlrA//UYGrWSufN+/ifEgsVjfbIQ/bunv2X/wm
0vzYkTlH7KajeoBZaoSUD05aRuD7KZXEoW8HDCbUI8C2DPYTAIo3AgVVNaE3EBCF
Tl7+iQTRNQANRrO7KtDfchTvuDtdqrW2Qv22bsNDKpx2bK3LJdFftuIWmFwuCefO
76CGRdt8tC/3fz7mhiS8SMThQXvMWImPsmdSTQMRKWRp7zGGueOcuzbyrVyM/hmi
pc8wvNy9YP+Bc15+TWo+5wnrIxezZ/SueuknbbvMZbkq5VHoE/EFpGrRDsay+4TT
h5/tMulVlP1tqu2+VUPmXtYl6f0yHLw+ORuXD+sJXiJiR5UQ0qqyqfxln0V5IacJ
O3KR0AQizZOJaEIni5VGaS3eqcaAhZOPrKRADOrE2oVYQ687ob+Nx/YwMtE7qjsK
EE7cX+CgEcJOEgUNR9RQiSjjAmYvQNCukWS/94bX74VsxuQPQRYzt+CL8qBUzbeh
g9DdTAkj8u280Z/rYHHYHjAErwkZ9qQEcByteDD195a8gKI2aOzDiZOsCcU4gp9k
MVT1RJCs+oZ9IwRrAJ6AzXt4FRFNg4tVedK8dTtp0rbK0Z3xIRI/Jn+iOz/q36YP
zD3hWFummecgcGlo3BXpiRl1phWxRkuW0g7jk7VEvwdTeB1AJFexCraZrDYqz5Oe
LnM3F6pYh7M=
=wTW0
-----END PGP SIGNATURE-----

--Sig_/42eCC_37AWdTWY91GIUJxIi--
