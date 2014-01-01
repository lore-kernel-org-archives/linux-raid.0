From: NeilBrown <neilb@suse.de>
Subject: Re: How to prefer some devices over others in raid
Date: Wed, 1 Jan 2014 18:05:17 +1100
Message-ID: <20140101180517.1367bc05@notabene.brown>
References: <CAL1oBhr+V0NQ1zG4LVP8qFT3_wsMHnqhUkZafVibtk0oCDGg5Q@mail.gmail.com>
	<52C2E00B.90406@hardwarefreak.com>
	<CAL1oBhrVUTK5ayU=sgmVgP0Xu5eh1nGcfRjQSYALXXJMVE03+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KYx6qRiaIdNq7NYk8PYxNSZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAL1oBhrVUTK5ayU=sgmVgP0Xu5eh1nGcfRjQSYALXXJMVE03+w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomas M <tomas@slax.org>
Cc: stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/KYx6qRiaIdNq7NYk8PYxNSZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Jan 2014 07:50:24 +0100 Tomas M <tomas@slax.org> wrote:

> My main concern is that I'm not always 100% sure if a certain drive is
> the root cause of slow read performance, so failing a wrong one would
> have terrible consequences. On the other hand, if it was possible to
> say "read the data with pretending one drive has failed, but write to
> the array as if all drives are ok", then I could actually find out if
> copying speed reverts to normal.
>=20
> Maybe I should write a kernel patch to try this out. Any suggestions
> where to start?

raid1.c already has functionality like this, referred to as "Write-mostly".

To add it to raid5.c you would need to modify fetch_block().
It sets Wantread or Wantcompute to indicate the the block should be read, or
computed from others (which is only allows of all the others are valid
already).

So in the case where one device is write-mostly and no other devices are
faulty, it should set Wantread on all those other devices.
Once they have been read, fetch_block will be called again and the current
code will notice that setting Wantcompute is sufficient.

NeilBrown


>=20
> Tomas M
>=20
> On Tue, Dec 31, 2013 at 4:17 PM, Stan Hoeppner <stan@hardwarefreak.com> w=
rote:
> >
> >
> > On 12/31/2013 8:42 AM, Tomas M wrote:
> >> I'm using software raid 5 (stripe with one parity drive).
> >>
> >> Is there a way to force the raid array to MOSTLY ignore one of the dri=
ves?
> >>
> >> Let me explain. If a drive is failing (is very slow, has errors, etc),
> >> then I still prefer to keep it in the array and simply COPY all data
> >> from the array somewhere else, instead of risking that the array gets
> >> degraded if I remove the failing drive and another one dies at the
> >> same time.
> >>
> >> Example:
> >> - 4 drives in raid5
> >> - one drive is slow, lets call the drive DISK1
> >> - copying all data from the array is very slow because it still uses
> >> DISK1 to read data from it, even if it could IGNORE it and COMPUTE the
> >> data from the other three drives
> >>
> >> The filesystem on the array needs to be still mounted rw, though,
> >> since there may be some changes.
> >>
> >> Is there any mdadm parameter or option which would make the array
> >> IGNORE any given disk on reads (since those can be computed from other
> >> drives), while still NOT IGNORING the disk in writes?
> >>
> >> Because if I set it to ignore that failing slow drive, I will copy out
> >> the data 100 times faster while still keeping the array in sync.
> >> Because for me if ANOTHER drive dies, it will still be better to have
> >> the data 100 times slower than nothing. I hope you understand me :)
> >
> > The option you request is not available TTBOMK.  So...
> >
> > Fail the drive.  Copy all the data off the array.  Zero the drive and
> > add it back.  Resync.
> >
> > But while you're at it, why not simply replace the flaky drive before
> > the resync?  Why would you intentionally keep a known-to-be-failing
> > drive in the array?
> >
> > --
> > Stan
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/KYx6qRiaIdNq7NYk8PYxNSZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUsO+Ljnsnt1WYoG5AQKDmA//ZU0LfQlIzsGqLfNLuYO3M1Jn3STK8trI
qkSEUmASDFKM8AJUh19XFN9Py89ppdGa0Pgpm1yUcfinwrQTqCNOvJF0kea01tbW
BfVmdBG8kOsDozwFtpGiK6Bb6S67cD+JDl2SfubXOOvHsPe7BrPDa1XEW6WPZRby
72dDx3LyfwCVM0IrE/8gTMf7C4PvTl1/SW1NOgqwLE/gapzEuM+Tq55OUBlmUjW6
qJiazyQ8tP5Ah8R6mTNgOovKdhbNP7HANU/4b4g7rgsfHRbfkcveiRTvDuI/xiM/
VGoOq1EMBRMrIMJNMmFIqzlPuqHJj9xmCAoy43QzCcZo27F8Ai7N25OZDNhCbx98
hNFICApFachOk6vdOKKjWL3K6UKi8ESCaVkzeuUQrtXiblxESSAgpZxPyFr8xlaz
mwXSryAMaumJt863OtGxaRmZLVPHo2qrh7mf14vP7WfAV99aRJFu+CDIs/BGwHLW
flCGEln8dXGYwrq/+PUQWo0OReYDZkHTf7uvhp1YWY1mc2YJW40/OBkeVog4N7A5
4SLEdnC1JhWRUHb3gxobSymWXRMVzDW0OY+lsT2NEA3ryWJDvaVqTuu11/0EBW4b
xfWaDCxIAXAknwgDE6aRXbcPyNfecN32QHqoBg7LzNWZdctQNAyLnZXHk5s2GOnK
pjJuW/inn3Y=
=Tx06
-----END PGP SIGNATURE-----

--Sig_/KYx6qRiaIdNq7NYk8PYxNSZ--
