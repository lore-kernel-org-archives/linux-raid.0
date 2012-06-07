From: NeilBrown <neilb@suse.de>
Subject: Re: degraded raid 6 (1 bad drive) showing up inactive, only spares
Date: Fri, 8 Jun 2012 07:14:12 +1000
Message-ID: <20120608071412.5408516f@notabene.brown>
References: <B5902F16-9C82-4072-BD67-FC6D6488ADB7@googlemail.com>
	<20120607222933.14ec3cd5@notabene.brown>
	<CAGHsWsm_Xvf59VCuHyJvoMW6peiFHK=YQKGzr3cq=RDk7jyqKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/S7T5PQ1iskPx4adgcKu/oIH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGHsWsm_Xvf59VCuHyJvoMW6peiFHK=YQKGzr3cq=RDk7jyqKg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Ziler <martin.ziler@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/S7T5PQ1iskPx4adgcKu/oIH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Jun 2012 18:49:49 +0200 Martin Ziler <martin.ziler@googlemail.com>
wrote:

> 2012/6/7 NeilBrown <neilb@suse.de>
>=20
> > On Thu, 7 Jun 2012 13:55:32 +0200 Martin Ziler <
> > martin.ziler@googlemail.com>
> > wrote:
> >
> > > Hello everybody,
> > >
> > > I am running a 9-disk raid6 without hot spares. I already had one dri=
ve
> > go bad, which I could replace and continue using the array without any
> > degraded raid messages. Recently I had another drive going bad by the
> > smart-info. As it wasn't quite dead I left the array as was without rea=
lly
> > using it all that much waiting for a replacement drive I ordered. As I
> > booted the machine up in order to replace the drive I was greeted by an
> > inactive array with all devices showing up as spares.
> > >
> > > md0 : inactive sdh2[0](S) sdi2[7](S) sde2[6](S) sdd2[5](S) sdf2[1](S)
> > sdg2[2](S) sdc1[9](S) sdb2[3](S)
> > >       15579088439 blocks super 1.2
> > >
> > > mdadm --examine confirms that. I already searched the web quite a bit
> > and found this mailing list. Maybe someone in here can give me some inp=
ut.
> > Normally a degraded raid should still be active. So I am quite surprised
> > that my array with only one drive missing goes inactive. I appended the
> > info mdadm --examine puts out for all the drives. However the first two
> > should probably suffice as only /dev/sdk differs from the rest. The fau=
lty
> > drive - sdk - is still recognized as a raid6 member, wheres all the oth=
ers
> > show up as spares. With lots of bad sectors sdk isn't accessible anymor=
e.
> >
> > You must be running 3.2.1 or 3.3 (I think).
> >
> > You've been bitten by a rather nasty bug.
> >
> > You can get your data back, but it will require a bit of care, so don't
> > rush
> > it.
> >
> > The metadata on almost all the devices have been seriously corrupted.  =
The
> > only way to repair it is to recreate the array.
> > Doing this just writes new metadata and assembles the array.  It doesn't
> > touch
> > the data so if we get the --create command right, all your data will be
> > available again.
> > If we get it wrong, you won't be able to see your data, but we can easi=
ly
> > stop
> > the array and create again with different parameters until we get it ri=
ght.
> >
> > First thing to do it to get a newer kernel.  I would recommend the late=
st
> > in
> > the 3.3.y series.
> >
> > Then you need to:
> >  - make sure you have a version of mdadm which gets the data offset to =
1M
> >   (2048 sectors).  I think 3.2.3 or earlier does that - don't upgrade to
> >   3.2.5.
> >  - find the chunk size - looks like it is 4M, as sdk2 isn't corrupt.
> >  - find the order of devices.  This should be in your kernel logs in
> >    "RAID conf printout".  Hopefully device names haven't changed.
> >
> >  Then (with new kernel running)
> >
> >  mdadm --create /dev/md0 -l6 -n9 -c 4M -e 1.2 /dev/sdb2 /dev/sdc2
> > /dev/sdd2 \
> >     /dev/sde2 /dev/sdf2 /dev/sdg2 /dev/sdh2 /dev/sdi2 missing \
> >     --assume-clean
> >
> >  Make double-sure you add that --assume-clean.
> >
> >  Note the last device is 'missing'. That corresponds to sdk2 (which we
> >  know is device 8 - the last of 9 (0..8)).  It fails so it not part of =
the
> >  array any more.  The others I just guessed the order.  You should try =
to
> >  verify it before you proceed (see RAID conf printout in kernel logs).
> >
> >  After the 'create' use "mdadm -E" to look at one device and make sure
> >  the Data Offset, Avail Dev Size and Array Size are the same as we saw
> >  on sdk2.
> >  If it is, try "fsck -n /dev/md0". That assumes ext3 or ext4.  If you h=
ad
> >  something else on the array some other command might be needed.
> >
> >  If that looks bad, "mdadm -S /dev/md0" and try again with a different
> > order.
> >  If it looks good, "echo check > /sys/block/md0/md/sync_action" and wat=
ch
> >  "mismatch_cnt" in the same directory.  If it says low (few hundred at
> > most)
> >  all is good.  If it goes up to thousands something is wrong - try anot=
her
> >  order.
> >
> >  Once you have the array working again,
> >    "echo repair > /sys/block/md0/md/sync_action"
> >  then add your new device to be rebuilt.
> >
> > Good luck.
> > Please ask if you are unsure about anything.
> >
> > NeilBrown
> >
> >
>=20
> Hello Neil,
>=20
> thank you very much for this detailed input. My last reply didn't make it
> into the mailing list due to the format of my mail client (OSX mail). My
> kernel (Ubuntu) was 3.2.0 , I upgraded to 3.3.8. mdadm version was fine.
>=20
> I searched the log files I got and was unable to find anything concerning
> my array. Maybe that sorta stuff isn't logged in ubuntu. I did find some
> mails concerning degraded raid that do not correlate with my current
> breakage. I received the following 2 messages:
>=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active (auto-read-only) raid6 sdi2[1] sdh2[0] sdg2[8] sdc1[9] sdd2[=
5]
> sdb2[3] sdf2[7] sde2[6]
>       13586485248 blocks super 1.2 level 6, 4096k chunk, algorithm 2 [9/8]
> [UU_UUUUUU]
>=20
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active (auto-read-only) raid6 sdj2[2] sdg2[8] sdd2[5] sde2[6] sdb2[=
3]
> sdf2[7] sdc1[9]
>       13586485248 blocks super 1.2 level 6, 4096k chunk, algorithm 2 [9/7]
> [__UUUUUUU]
>=20
> I conclude that my setup must have been sdh2 [0], sdi2 [1], sdj2 [2], sdb2
> [3], sdd2 [5] , sde2 [6], sdf2 [7], sdg2 [8], sdc1 [9]

Unfortunately these number are not the roles of the device in the array.  T=
hey
are the order in which the devices were added to the array.
So 0-8 are very likely roles 0-8 in the array.  '9' is then the first spare,
and it stays as '9' even when it becomes active.  So as there is no '4', it
does look likely that 'sdc1' should come between  'sdb2' and 'sdd2'.

NeilBrown


> sdc1 is the replacement for my first drive that went bad. It's somewhat
> strange that it is now listed as device 9 and not 4, isn't it? I reckon
> that I have to rebuild in that order, notwithstanding.
>=20
> regards,
> Martin


--Sig_/S7T5PQ1iskPx4adgcKu/oIH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9EZqznsnt1WYoG5AQKw3A//fBZgAD4KUYoISmux4ohtA3YKRrSPoeWm
HnKwrTPwcHLmzeZmfNg6vSIYlPhCu8lxr/DSjRg4lDOxTfrqFcQqEwBsccjhZIsJ
/9lKGeYDnkCk6ictsmdoU9jVtwnV0SP9fvBrTHUV5VywuuQSnvT5EGe0qd4LNMnK
eGzrgD3BRi03MNfXCZD+nf07H2gLp66ZPS+2llKk3vmzKT5amkEew+n3wrweYDTz
kSS1WqGCEamy13+ZIlyfexSyB2qCSlK3JQtQbN0a7tSmrdbGnC02IZm278Qbu+sk
pbV9rkLxUCrq3og2ACI7+fsARQRkWq0UwnZ3U8VF93e48L8l4F3m8jPrJWAQK5pY
xs2VYiFIMQkTh8JZkwxp9oDKJbnvsTUz8FFG1csFNkPF0aAh2lUWxAzFHYYMAiwN
pm4E4Ug8aJQ9/JxZYi0dX9RUuikama9/usghrzfm3kHw0gy06ud0GpKwJYKiWWo/
VbFDQyss+fNDO4I4qXfoFxrV3rVr4sRbuieoHFEKJZ/gf6Duxf+UBcTMObOqP+v5
4CjPR0ZakSkBDaHxaHtIzJhnHpwe1rrS7sFLjQcWZYghJAS45CD1oziZqqZW9Gm7
MgneUMLfIAjvfrHoeyYd0zvBWluQmG+OyJi3O3MEUMZOazFnJhFTWW7quL8o7JlL
WJ4a5s+PpoY=
=wKWe
-----END PGP SIGNATURE-----

--Sig_/S7T5PQ1iskPx4adgcKu/oIH--
