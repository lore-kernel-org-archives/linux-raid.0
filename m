From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Sat, 28 Apr 2012 13:23:31 +1000
Message-ID: <20120428132331.01396da6@notabene.brown>
References: <4F9AFBC6.7070803@weboperative.com>
	<4F9B14FA.1090001@weboperative.com>
	<20120428080522.637bc564@notabene.brown>
	<4F9B2BE1.5080207@weboperative.com>
	<4F9B3B48.8020900@weboperative.com>
	<4F9B57E9.2060409@weboperative.com>
	<20120428125506.6a2388eb@notabene.brown>
	<4F9B5D24.1050708@weboperative.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RvAzT4Jbe=2yH2RMJ527NHs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F9B5D24.1050708@weboperative.com>
Sender: linux-raid-owner@vger.kernel.org
To: likewhoa <likewhoa@weboperative.com>
Cc: "linux-raid@vger.kernel.org >> \"linux-raid@vger.kernel.org\"" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/RvAzT4Jbe=2yH2RMJ527NHs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Apr 2012 22:59:48 -0400 likewhoa <likewhoa@weboperative.com> wro=
te:

> On 04/27/2012 10:55 PM, NeilBrown wrote:
> > On Fri, 27 Apr 2012 22:37:29 -0400 likewhoa <likewhoa@weboperative.com>=
 wrote:
> >
> >> On 04/27/2012 08:35 PM, likewhoa wrote:
> >>> I am not sure how to proceed now with the output that shows possible
> >>> pairs as it won't allow me to setup all 8 devices on the array but on=
ly
> >>> 4. Should I run the array creation with -x4 and set the available spa=
re
> >>> devicesor or just create the array as I can remember which was one pa=
ir
> >>> from each controller. i.e /dev/sda3 /dev/sde3 ...?
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> ok I was able to recreate the array with correct order which I took fr=
om
> >> my /dev/md0's --details output and was able to decrypt the luks mapping
> >> but XFS didn't open and xfs_repair is currently doing the matrix. I wi=
ll
> >> keep this posted with updates.
> > I hope the order really is correct.... I wouldn't expect xfs to find pr=
oblems
> > if it was...
> >
> >> Thanks again Neil.
> >> WRT 3.3.3 should I just go back to 3.3.2 which seemed to run fine and
> >> wait until there is a release of 3.3.3 that has fix?
> > 3.3.4 has the fix and was just released.
> > 3.3.1, 3.3.2 and 3.3.3 all have the bug.  It only triggers on shutdown =
and
> > even then only occasionally.
> > So I recommend 3.3.4.
> >
> > NeilBrown
> The reason I believe it was correct was that 'cryptsetup luksOpen
> /dev/md1 md1' worked. I really do hope that it was correct too because
> after opening the luks mapping I assume there is no going back.

Opening the luks mapping could just mean that the first few blocks are
correct.  So the first disk is right but others might not be.

There is going backup unless something has been written to the array.  Once
that happens anything could be corrupted.  So if the xfs check you are  doi=
ng
is read-only you could still have room to move.

With a far=3D2 array, each first half of each device is mirrored on the sec=
ond
half.  So you can probably recover the ordering by finding which pairs matc=
h.

The "Used Dev Size" is 902992896 sectors.  Half of that is 451496448
or 231166181376 bytes.

So to check if two devices are adjacent in the mapping you can try:

 cmp --ignore-initial=3D0:231166181376 --bytes=3D231166181376 first-dev sec=
ond-dev

You could possibly use a smaller --bytes=3D number, at least on the first
attempt.
You a similar 'for' loop to before an use this command and it might tell you
which pairs of devices are consecutive.  From that you should be able to get
the full order.

NeilBrown


--Sig_/RvAzT4Jbe=2yH2RMJ527NHs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5tisznsnt1WYoG5AQIjTA/+P5UDgpwGRdEEGkEQIrgu0y2OuscfbZ+z
IbTiFHDwEx9nERKXTlBQtEHNW7IvjbUJBbkiYTjDkmsDkdggFcIMNag3KYIYou/v
fGs+bsb28iOIzBIZa6OYD4oma84Y+RNyo7WZ0uYIS2j0YY/isHyEnm6/c5tzUfFs
KwNa2fAVItV8fD3WDxfDLnbW/SjHBfI1cFrzKSkh9/MM0Cxo/8xqVDNElayuIX5M
LBEqPpJxrkDzWb1WWjJ3Sy0iZyOZsf7uw0ynGfdJZqDjl1MEF5ner72srZmY9Bru
ptIHeIVsgtk/qB0MWMFqItNLc0Hjva0PwhjGnUPXkItRZ7O89EegJbfFut/9xfk3
tTEe1Ejy7VP2yUY39drr0jVvzk3VdJkS5SUNRwSxWFUE3rnbVK7Z2wMQzIuaVaSH
KM8asRWGbquevk+GYzLnKdfBiPkMOzdEje89jD41btcPm39dIddvX/dOVOyAkK40
vKUbaDis/9YxZi1Vfw95JmCSea+y4anqSjNUkqhS1maRj7fWXTuTmuFwSxJo5kv7
7sRu72bbobysOstB8CcSQ94hQ8YEk2VfdFlR1yURZnrQXdMU2o5IaeXP4xhMgdoW
Vt8GmLfnm0ZnBZMudb/it9sB1J9/dos2Q0iitU16OgeE6EEK3DnOHfkpCAchUYUO
kJM+S/LVYbA=
=Oje3
-----END PGP SIGNATURE-----

--Sig_/RvAzT4Jbe=2yH2RMJ527NHs--
