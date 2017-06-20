From: NeilBrown <neilb@suse.com>
Subject: RE: mismatch_cnt > 0 during initial sync?
Date: Wed, 21 Jun 2017 07:26:11 +1000
Message-ID: <87bmpi2vws.fsf@notabene.neil.brown.name>
References: <9A8A3C34-EED0-42FF-B631-7AD1D6EAF9A2@stanford.edu> <D974501A-3A8C-438B-A043-8E44DE6D18C7@stanford.edu> <87shix3rpi.fsf@notabene.neil.brown.name> <009901d2e946$a3eff400$ebcfdc00$@wnsdev.com> <87lgon2t30.fsf@notabene.neil.brown.name> <002e01d2ea03$232cb660$69862320$@wnsdev.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002e01d2ea03$232cb660$69862320$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Sangas <pete@wnsdev.com>, 'Stephane Thiell' <sthiell@stanford.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 20 2017, Peter Sangas wrote:

>> From: NeilBrown [mailto:neilb@suse.com]
>> Sent: Monday, June 19, 2017 9:15 PM
>> Subject: RE: mismatch_cnt > 0 during initial sync?
>>=20
>> This is a recovery, not a resync.  They are different.
>=20=20
> Thank you for pointing this out and the nice explanation.=20=20=20=20
>
> From reading this list and other sources issuing a repair command as
> follows:
>
> "echo repair > /sys/block/md2/md/sync_action"
>
> might be ill-advised since it's luck of the draw whether or not the
> operation gets the right data instead of the bad data.
>
> Is this correct?=20

How do you define "right data" and "bad data"?
What is your threat-model which explains how the two blocks are
different?

In most likely cases, neither version if the data is more correct than
the other.  In some others, your hardware is broken and needs to be
replaced.

If you have no understanding of why there might be a difference, then
issuing a repair is not likely to be worse than not issuing a repair.
If you do have that understanding, then use that to make your decision.

NeilBrown

>
> For reference I have a RAID1 with 3 disks.  mdadm - v3.3 - 3rd September
> 2013
>
> Thank you,
> Pete

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllJkvQACgkQOeye3VZi
gbmHjw/9H4X6ePzsWmlAug/CDWOtGNlXaMazOkb6uATOqKcMLRfWC7AQH/u3XHky
/7CgRRXVrFou7I+gGNb1NTqXhb5tSMZcn7p1w47zIwOnIc/weVjFq1Xl6VFdg/DR
vQrrKVw73/p+gwEAhLcBvC169g7IDA17dLH9UzhYfnCuZ/hgVSTaQ41AtdDY0iKp
bCz1TOwnthRktG9ORaqiIHodN6Dabl/Q+SXG7/T4A90oQMU87OSv9xLPLqoYjUcb
7YpxgOFnXR9vZBntciOxvMBNHfbtO3Tlo8yZB3FtuWd9+H9fRj1tnkj3JnFpLph6
zen93TPO/1AL8BDWI5w3bROon99Ni41iCmFg2QbI5PRYj2Gnsx+RTm66injaOjQD
Oh6lYetUmbS+7a9xL/D1uP4uhkbFAA/7RG8qhC0pD1ORxtjm9gFrYMEh5P0qreiv
7qx2Tr9IGJCkMci7xOwZtlHZ/FaQHiKwCvNDk6pHNiITSuMFHTom8b/JAM+Z1Wpf
qOo/RaFnPDQifbQKwtLdnXgJIhiA1JSCqS9wex5oLAfUovS5F5SsiIWlDloPs4Gm
yCEieOPtryb4ZCkywyR43SL2nFTOH6QqBg4K2DdlpEPxVz2gW7LmMiVOYp9a/GEM
O2s//t6g8n434TUqmkyR1EYCou0vqe9jXFqBMpiX5u/qGCb9txY=
=FBY1
-----END PGP SIGNATURE-----
--=-=-=--
