From: NeilBrown <neilb@suse.de>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch
 checksum
Date: Tue, 2 Dec 2014 08:46:11 +1100
Message-ID: <20141202084611.45f56d6a@notabene.brown>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
	<20141029200501.1f01269d@notabene.brown>
	<CAK-d5dah-NyQzVNBScYoVSo2cpGA8F3vuK_Zh1YzQn5Mr+_-oQ@mail.gmail.com>
	<CAK-d5dYm7tEY855w1CdkvPz22ukkg1DwGz_mQ_9-JRV0M=O6Rw@mail.gmail.com>
	<20141103165217.3bfd3d3e@notabene.brown>
	<CAK-d5daq+-PbX1s81h01x7GdVDCijyzzPaeRAOCctEXTNideCw@mail.gmail.com>
	<20141125095052.51f8eadc@notabene.brown>
	<CAK-d5dZnWpmyPfWTGB74wHojeywdiXDnT6Fs0yqYqn7bJpSL-Q@mail.gmail.com>
	<CAK-d5dY4QEDupxjkon_+6z0Z7ggPKv=PLF60zTkeSBsbd4+mPQ@mail.gmail.com>
	<CAK-d5dZMjbhAqgs9GOvswG6crZtrV2uSidRzt_hBJAH=m5rGKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/qIQNP.Tjh8QS9uo99nMEm.7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK-d5dZMjbhAqgs9GOvswG6crZtrV2uSidRzt_hBJAH=m5rGKw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/qIQNP.Tjh8QS9uo99nMEm.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Dec 2014 22:04:42 +0530 Anshuman Aggarwal
<anshuman.aggarwal@gmail.com> wrote:

> On 1 December 2014 at 21:30, Anshuman Aggarwal
> <anshuman.aggarwal@gmail.com> wrote:
> > On 26 November 2014 at 11:54, Anshuman Aggarwal
> > <anshuman.aggarwal@gmail.com> wrote:
> >> On 25 November 2014 at 04:20, NeilBrown <neilb@suse.de> wrote:
> >>> On Mon, 24 Nov 2014 12:59:47 +0530 Anshuman Aggarwal
> >>> <anshuman.aggarwal@gmail.com> wrote:
> >>>
> >>>> On 3 November 2014 at 11:22, NeilBrown <neilb@suse.de> wrote:
> >>>> > On Thu, 30 Oct 2014 20:30:40 +0530 Anshuman Aggarwal
> >>>> > <anshuman.aggarwal@gmail.com> wrote:
> >>>> >
> >>>> >> Would chunksize=3D=3Ddisksize work? Wouldn't that lead to the ent=
ire
> >>>> >> parity be invalidated for any write to any of the disks (assuming=
 md
> >>>> >> operates at a chunk level)...also please see my reply below
> >>>> >
> >>>> > Operating at a chunk level would be a very poor design choice.  md=
/raid5
> >>>> > operates in units of 1 page (4K).
> >>>>
> >>>> It appears that my requirement may be met by a partitionable md raid=
 4
> >>>> array where the partitions are all on individual underlying block
> >>>> devices not striped across the block devices. Is that currently
> >>>> possible with md raid? I dont' see how but such an enhancement could
> >>>> do all that I had outlined earlier
> >>>>
> >>>> Is this possible to implement using RAID4 and MD already?
> >>>
> >>> Nearly.  RAID4 currently requires the chunk size to be a power of 2.
> >>> Rounding down the size of your drives to match that could waste nearl=
y half
> >>> the space.  However it should work as a proof-of-concept.
> >>>
> >>> RAID0 supports non-power-of-2 chunk sizes.  Doing the same thing for
> >>> RAID4/5/6 would be quite possible.
> >>>
> >>>>   can the
> >>>> partitions be made to write to individual block devices such that
> >>>> parity updates don't require reading all devices?
> >>>
> >>> md/raid4 will currently tries to minimize total IO requests when perf=
orming
> >>> an update, but prefer spreading the IO over more devices if the total=
 number
> >>> of requests is the same.
> >>>
> >>> So for a 4-drive RAID4, Updating a single block can be done by:
> >>>   read old data block, read parity, write data, write parity - 4 IO r=
equests
> >>> or
> >>>   read other 2 data blocks, write data, write parity - 4 IO requests.
> >>>
> >>> In this case it will prefer the second, which is not what you want.
> >>> With 5-drive RAID4, the second option will require 5 IO requests, so =
the first
> >>> will be chosen.
> >>> It is quite trivial to flip this default for testing
> >>>
> >>> -       if (rmw < rcw && rmw > 0) {
> >>> +       if (rmw <=3D rcw && rmw > 0) {
> >>>
> >>>
> >>> If you had 5 drives, you could experiment with no code changes.
> >>> Make the chunk size the largest power of 2 that fits in the device, a=
nd then
> >>> partition to align the partitions on those boundaries.
> >>
> >> If the chunk size is almost the same as the device size, I assume the
> >> entire chunk is not invalidated for parity on writing to a single
> >> block? i.e. if only 1 block is updated only that blocks parity will be
> >> read and written and not for the whole chunk? If thats' the case, what
> >> purpose does a chunk serve in md raid ? If that's not the case, it
> >> wouldn't work because a single block updation would lead to parity
> >> being written for the entire chunk, which is the size of the device
> >>
> >> I do have more than 5 drives though they are in use currently. I will
> >> create a small testing partition on each device of the same size and
> >> run the test on that after ensuring that the drives do go to sleep.
> >>
> >>>
> >>> NeilBrown
> >>>
> >
> > Wouldn't the meta data writes wake up all the disks in the cluster
> > anyways (defeating the purpose)? This idea will require metadata to
> > not be written out to each device (is that even possible or on the
> > cards?)
> >
> > I am about to try out your suggestion with the chunk sizes anyways but
> > thought about the metadata being a major stumbling block.
> >
>=20
> And it seems to be confirmed that the metadata write is waking up the
> other drives. On any write to a particular drive the metadata update
> is accessing all the others.
>=20
> Am I correct in assuming that all metadata is currently written as
> part of the block device itself and that the external metadata  is
> still embedded in each of the block devices (only the format of the
> metadata is defined externally?) I guess to implement this we would
> need to store metadata elsewhere which may be a major development
> work. Still that may be a flexibility desired in md raid for other
> reasons...
>=20
> Neil, your thoughts.

This is exactly why I suggested testing with existing code and seeing how f=
ar
you can get.  Thanks.

For a full solution we probably do need some code changes here, but for
further testing you could:
1/ make sure there is no bitmap (mdadm --grow --bitmap=3Dnone)
2/ set the safe_mode_delay to 0
     echo 0 > /sys/block/mdXXX/md/safe_mode_delay

when it won't try to update the metadata until you stop the array, or a
device fails.

Longer term: it would probably be good to only update the bitmap on the
devices that are being written to - and to merge all bitmaps when assembling
the array.  Also when there is a bitmap, the safe_mode functionality should
probably be disabled.

NeilBrown


--Sig_/qIQNP.Tjh8QS9uo99nMEm.7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHzhoznsnt1WYoG5AQJWiw/+ImM0YCn7rwLnIzOsYt5vVg4AtZ6qrxGz
11xtYG9xr9AI18DC55fhZWD4Es5JJotFyqKd7et+PBRFU74xkaefEoBUceIq8Ag7
k71w8zObs9YZ6OpAUmbfaPEqvNDfWfK/xiRL/4ITfiGWh0BUfRko9qXbj7VW7JWj
SFMU6KLfDQF30YEWbB63Js/eWp1OO5mGChZfX9kiEwApj/CsBak7eghdkoNvybA2
xoh9Ck4nnpBiqdQHEuMliss8rFcYvaJv7/RUWZYnbZMU2TJjSqE9uURPWQOS7H1J
wS3sA/v+xFrGrdeBeBXyX12J/jXMCekT+2wuRFr4St9zxhDeLEjvBky0NI7KlOn2
gddGeS/nBCHZuNAxu05qlrCU7RYJhP5ZFxOk1Z4B91emVPOsy6YLvqHzyZOuHYUW
9057VMKICHe5nZJcTiGn+WKrcoP2c0GmwMdcjUIPNkz1mIzN9zAUAxjLSIUj2brT
FY6GyDNul7N55Yau1BAzOMXCaFXvu70IRtdalrOn/dzCDOk6IRxW+Wlvyuuh4k+i
NJSKsTw01r8lVCEUhgsM1TzvBD2qxMXrDwmWbeRM+t1oao/570te4E+VmT/hfACk
1tSkzvByoQJpA9evXyGxJaQwOf6LttlU+LfArXtCjjIYMI18JiVxiIdjeTSXOBta
lIxDVJfoia8=
=U/17
-----END PGP SIGNATURE-----

--Sig_/qIQNP.Tjh8QS9uo99nMEm.7--
