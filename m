From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC] MD: Allow restarting an interrupted incremental recovery.
Date: Mon, 17 Oct 2011 14:20:39 +1100
Message-ID: <20111017142039.5a07b12f@notabene.brown>
References: <CANz0V+7ZGKvyznbU_5d2cQm2XL=Wf9B8+HwZZ9KeZSfuawtyOg@mail.gmail.com>
	<1318460733-886-1-git-send-email-andreiw@vmware.com>
	<CANz0V+4-qWrc0HfRB5BD8jYFstSmRBr36YwZw5f9t5wwYggYaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yXSfnSIr2WlpWf93NQSXvQk"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANz0V+4-qWrc0HfRB5BD8jYFstSmRBr36YwZw5f9t5wwYggYaA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
Cc: Andrei Warkentin <andreiw@vmware.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/yXSfnSIr2WlpWf93NQSXvQk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Oct 2011 21:18:43 -0400 "Andrei E. Warkentin"
<andrey.warkentin@gmail.com> wrote:

> 2011/10/12 Andrei Warkentin <andreiw@vmware.com>:
> > If an incremental recovery was interrupted, a subsequent
> > re-add will result in a full recovery, even though an
> > incremental should be possible (seen with raid1).
> >
> > Solve this problem by not updating the superblock on the
> > recovering device until array is not degraded any longer.
> >
> > Cc: Neil Brown <neilb@suse.de>
> > Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
>=20
> FWIW it appears to me that this idea seems to work well, for the
> following reasons:
>=20
> 1) The recovering sb is not touched until the array is not degraded
> (only for incremental sync).
> 2) The events_cleared count isn't updated in the active bitmap sb
> until array is not degraded. This implies that if the incremental was
> interrupted, recovering_sb->events is NOT less than
> active_bitmap->events_cleared).
> 3) The bitmaps (and sb) are updated on all drives at all times as it
> were before.
>=20
> How I tested it:
> 1) Create RAID1 array with bitmap.
> 2) Degrade array by removing a drive.
> 3) Write a bunch of data (Gigs...)
> 4) Re-add removed drive - an incremental recovery is started.
> 5) Interrupt the incremental.
> 6) Write some more data.
> 7) MD5sum the data.
> 8) Re-add removed drive - and incremental recovery is restarted (I
> verified it starts at sec 0, just like you mentioned it should be, to
> avoid consistency issues). Verified that, indeed, only changed blocks
> (as noted by write-intent) are synced.
> 10)  Remove other half.
> 11) MD5sum data - hashes match.
>=20
> Without this fix, you would of course have to deal with a full resync
> after the interrupted incremental.
>=20
> Is there anything you think I'm missing here?
>=20
> A

Not much, it looks good, and your testing is of course a good sign.

My only thought is whether we really need the new InIncremental flag.
You set it exactly when saved_raid_disk is set, and clear it exactly when
saved_raid_disk is cleared (set to -1).
So maybe we can just used saved_raid_disk.
If you look at it that way, you might notice that saved_raid_disk is also s=
et
in slot_store, so probably InIncremental should be set there.  So that might
be the one thing you missed.

Could you respin the patch without adding InIncremental, and testing=20
  rdev->saved_raid_disk >=3D 0
instead, check if you agree that should work, and perform a similar test?
(Is that asking too much?).

If you agree that works I would like to go with that version.

Thanks,
NeilBrown


--Sig_/yXSfnSIr2WlpWf93NQSXvQk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpufBznsnt1WYoG5AQIjEg//Uhz8hAmcqQG2tlH+Y5e8JBFlgnkvYUTo
hEWiDSGvs+p1r1LOS7V321FwpaRTHXJ2KAAIG/wgkQuyCY9flaRV2IIlPJvTBVLY
UjGpJnZqu9Ga2lVPCisG2ou/1eF58bMbK/YfuRqwm4Dbb1iaJ1cN96+XthNQwLy2
9RGwpsSyrerE0mfwJISEv7eVrW44ekgW875SC1dc+fj+2kCQGwIVJQ0jQwh4QiYW
xi2Bo1ZVBH+YJ+WTAhTjh9twrFjGOoEyh/Tf0uh8waj9lx+OOv0kdG3PGxH9TvOF
SBR4qDXmtINlnKuIIlVN+uVHfAXoW87m8N2N390wAMZdDqW0iai4nY9jI3ITv8gK
gCfBStIOJ11sCDcQOsw7MYNj8z6HbO63AjXatfF4NCKcpZEoHw2tI20v0S3uyrlO
Kjw7BGIoexSW+psNLEKsxMtFj1znNllYYnydkrm8FQVhhCh0nhhSxm3BbDS740Pr
msu/x/PxbFB0vEph/jBXiwW7UStPfiB+0r2gINgIHFATOz2fTfzJE2Yww80gKTQ2
znyBIfa4RHLDuf1rc//vceBr7AWp0gvhOQDBkJ448NkH0WYqJerDWe2+K88jZxkS
it1f41lRMGoi9llb2rJ/YsKXPpnnwfz768C2jASKLb/fBc648GCWH+lJZK2UJy9r
s7cSDYVFprU=
=zpIN
-----END PGP SIGNATURE-----

--Sig_/yXSfnSIr2WlpWf93NQSXvQk--
