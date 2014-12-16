From: NeilBrown <neilb@suse.de>
Subject: Re: "bitmap file is out of date, doing full recovery"
Date: Wed, 17 Dec 2014 09:26:06 +1100
Message-ID: <20141217092606.473d74f0@notabene.brown>
References: <CAGRgLy5zhV49xF=ZwULaF46Xx=8rnWcypTWxxgf0HmEPpCP+yQ@mail.gmail.com>
	<20141013092426.5ea1288d@notabene.brown>
	<CAGRgLy69gC2n0oAP8CRNBzTb+tBnwmwoJOCdKb+aRMO=Oeqf3Q@mail.gmail.com>
	<20141029101950.5528b347@notabene.brown>
	<CAGRgLy4YjfUtziFfFyZmC5SHGm+PLUzmLACJfanBBN8SS7JjCg@mail.gmail.com>
	<CAGRgLy7EW=3Tcy0swpcHNnyMz+A=9LiOoWXkx4-6R5YL1nVE_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/MVlLaV3VibS18iwrCb0Gs0a"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7EW=3Tcy0swpcHNnyMz+A=9LiOoWXkx4-6R5YL1nVE_w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/MVlLaV3VibS18iwrCb0Gs0a
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 14 Dec 2014 14:11:05 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> This issue keeps happening to us. Do you see any problem in always
> incrementing the event count?

The reason we don't always increment the event count is that it wakes up
spare device unnecessarily.

Maybe the event counts on spare devices should be ignored....

NeilBrown


>=20
> Thanks,
> Alex.
>=20
> On Tue, Nov 4, 2014 at 11:17 AM, Alexander Lyakas
> <alex.bolshoy@gmail.com> wrote:
> > Hi Neil,
> > thank you for your comments.
> >
> > On Wed, Oct 29, 2014 at 1:19 AM, NeilBrown <neilb@suse.de> wrote:
> >> On Thu, 23 Oct 2014 19:04:48 +0300 Alexander Lyakas <alex.bolshoy@gmai=
l.com>
> >> wrote:
> >>
> >>> Hi Neil,
> >>> I found at least one way of this happening. The problem is that in
> >>> md_update_sb() we allow to decrease the event count:
> >>>
> >>>     /* If this is just a dirty<->clean transition, and the array is c=
lean
> >>>      * and 'events' is odd, we can roll back to the previous clean st=
ate */
> >>>     if (nospares
> >>>         && (mddev->in_sync && mddev->recovery_cp =3D=3D MaxSector)
> >>>         && mddev->can_decrease_events
> >>>         && mddev->events !=3D 1) {
> >>>         mddev->events--;
> >>>         mddev->can_decrease_events =3D 0;
> >>>
> >>> Then we call bitmap_update_sb(). If we crash after we update (the
> >>> first or all of) bitmap superblocks, then after reboot, we will see
> >>> that bitmap event count is less than MD superblock event count. Then
> >>> we decide to do full resync.
> >>>
> >>> This can be easily reproduced by hacking bitmap_update_sb() to call
> >>> BUG(), after it calls write_page() in case event count was decreased.
> >>>
> >>> Why we are decreasing the event count??? Can we always increase it?
> >>> u64 is a lot to increase...
> >>
> >> The reason for decreasing the event count is so that we don't need to =
update
> >> the event count on spares - they can be left spun down.
> >> We for simple clean/dirty transitions with increment for clean->dirty =
and
> >> decrement for dirty->clean.  But we should only use this optimisation =
when
> >> everything is simple.
> >> We really shouldn't do this when the array is degraded.
> >> Do this fix your problem?
> >>
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 2c73fcb82593..98fd97b10e13 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -2244,6 +2244,7 @@ repeat:
> >>          * and 'events' is odd, we can roll back to the previous clean=
 state */
> >>         if (nospares
> >>             && (mddev->in_sync && mddev->recovery_cp =3D=3D MaxSector)
> >> +           && mddev->degraded =3D=3D 0
> >>             && mddev->can_decrease_events
> >>             && mddev->events !=3D 1) {
> >>                 mddev->events--;
> >>
> >>
> > No, unfortunately, this doesn't fix the problem. In my case, the array
> > is never degraded. Both drives are present and operational, then the
> > box crashes, and after reboot the bitmap event counter is lower than
> > we expect. Again, this is easily reproduced by hacking
> > bitmap_update_sb() as I mentioned earlier.
> >
> > In my case array does not have spares. (There is some other system on
> > top, which monitors the array, and, if needed, adds a spare from a
> > "global" spare pool). Is this ok in this case to always increment the
> > event count?
> >
> > Thanks,
> > Alex.
> >
> >
> >>>
> >>> Some other doubt that I have is that bitmap_unplug() and
> >>> bitmap_daemon_work() call write_page() on page index=3D0. This page
> >>> contains both the superblock and also some dirty bits (could not we
> >>> waste 4KB on bitmap superblock???). I am not sure, but I wonder
> >>> whether this call can race with md_update_sb (which explicitly calls
> >>> bitmap_update_sb), and somehow write the outdated superblock, after
> >>> bitmap_update_sb has completed writing it.
> >>>
> >>
> >> storage.sb_page is exactly the same as storage.filemap[0]
> >> So once an update has happened, the "outdated superblock" doesn't exist
> >> anywhere to be written out from.
> >>
> >>> Yet another suspect is when loading the bitmap we basically load it
> >>> from the first up-to-date drive. Maybe we should have scanned all the
> >>> bitmap superblocks, and selected one that has the higher event count
> >>> (although as we saw "higher" does not necessarily mean "more
> >>> up-to-date").
> >>>
> >>> Anyways, back to decrementing the event count. Do you see any issue
> >>> with not doing this and always incrementing?
> >>>
> >>> Thanks,
> >>> Alex.
> >>>
> >>
> >> Thanks,
> >> NeilBrown


--Sig_/MVlLaV3VibS18iwrCb0Gs0a
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVJCxfjnsnt1WYoG5AQLPoQ//Sg1VC3jD88n1FgvU46m7HwJqAatj296x
608EN+Y3isuqUNr6rclM0LMv8iBPQcMxAD96ZhCrJ3kco6F28d3rKRXxlj6UUDuU
RgWOx+eVQroS3M7TxWjSU44127JMCDVkIwKFPops5CFyMRvjGkjdcyZx8rDkfDSY
0V8qxcrpYYBRnJxhw6QPNGEDt+ukIyOz4OUtU9YzZyCD8mU3DIy19mdXLNZDFEwp
FNAMLHFNbqk9TBtplUJUe0jVWxJUeJ3AKkLLdireFsbG3o4OLYIOMBacqe/zoFeu
IbsysrPyGAJxkxNxFLW93Uk3PRa03SWa1zm1MB+B5XEDkDuwVc6yaxfIIXRSXfew
nTCJ3DBITETYXe6j1lp0pBvMtR3skqiddqToZDc/6HESwSmIhr9SoRSW3uJ2RSKp
X/y7rqZknpseoSikrjnsc1OtcZuV7VMKXz7olSLepcztXooS1GKu5tekxBHprxVr
pvMsEsIbAhoxKkIDmBiflrPui9PfG/3CpmryX5cHnPEloZ9tOiTDmoY9IMHhmNqK
ZxM+8t1ZDgwR5hDhAqQluTOliaB0ZVNqAXd/1BB8c7+FqWqJr51GgYoFAGw4T4s2
mxuIUZjAjS6BaAXHdwj0G5hbRxIWcnzQQgdoeJsO6IO+uFo7wQTZmZ+oPDcnjrCT
7zSVYcXrT9s=
=hbjv
-----END PGP SIGNATURE-----

--Sig_/MVlLaV3VibS18iwrCb0Gs0a--
