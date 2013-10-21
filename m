From: NeilBrown <neilb@suse.de>
Subject: Re: Advice recovering from interrupted grow on RAID5 array
Date: Mon, 21 Oct 2013 12:09:43 +1100
Message-ID: <20131021120943.179a2bb0@notabene.brown>
References: <CA+90J__=u_m9RW7c9KHGMRr+6ZOSVQUN6yXm61YM_yir-7LE7A@mail.gmail.com>
	<20131016162625.628c5558@notabene.brown>
	<CA+90J_9vLnEVPhAkQmZ5VS=gTw0fjf107wf=2riLn+=RstJMSQ@mail.gmail.com>
	<20131017110725.54de5b06@notabene.brown>
	<CA+90J_8y+XOhdmKuAm9VSKSvb61+57YU0iYWGjkh4WP3BAF5pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ARsgs.qG=CsI3aYOl72AEXL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+90J_8y+XOhdmKuAm9VSKSvb61+57YU0iYWGjkh4WP3BAF5pA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Yates <jyates65@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ARsgs.qG=CsI3aYOl72AEXL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Oct 2013 01:36:28 -0400 John Yates <jyates65@gmail.com> wrote:

> On Wed, Oct 16, 2013 at 8:07 PM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 16 Oct 2013 09:02:52 -0400 John Yates <jyates65@gmail.com> wrot=
e:
> >
> >> On Wed, Oct 16, 2013 at 1:26 AM, NeilBrown <neilb@suse.de> wrote:
> >> > On Mon, 14 Oct 2013 21:59:45 -0400 John Yates <jyates65@gmail.com> w=
rote:
> >> >
> >> >> Midway through a RAID5 grow operation from 5 to 6 USB connected
> >> >> drives, system logs show that the kernel lost communication with so=
me
> >> >> of the drive ports which has left my array in a state that I have n=
ot
> >> >> been able to reassemble. After reseating the cable connections and
> >> >> rebooting, all of the drives appear to be functioning normally, so
> >> >> hopefully the data is still intact. I need advice on recovery steps
> >> >> for the array.
> >> >>
> >> >> It appears that each drive failed in quick succession with /dev/sdc1
> >> >> being the last standing and having the others marked as missing in =
its
> >> >> superblock. The superblocks of the other drives show all drives as
> >> >> available. (--examine output below)
> >> >>
> >> >> >mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde=
1 /dev/sdf1 /dev/sdg1
> >> >> mdadm: too-old timestamp on backup-metadata on device-5
> >> >> mdadm: If you think it is should be safe, try 'export MDADM_GROW_AL=
LOW_OLD=3D1'
> >> >> mdadm: /dev/md127 assembled from 1 drives - not enough to start the=
 array.
> >> >
> >> > Did you try following the suggestion and run
> >> >
> >> >  export MDADM_GROW_ALLOW_OLD=3D1
> >> >
> >> > and the try the --asssemble again?
> >> >
> >> > NeilBrown
> >>
> >> Yes I did, thanks. Not much change though. It accepts the timestamp,
> >> but then appears not to use it.
> >>
> >> mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> >> /dev/sdf1 /dev/sdg1 --verbose
> >> mdadm: looking for devices for /dev/md127
> >> mdadm: /dev/sdb1 is identified as a member of /dev/md127, slot 4.
> >> mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 3.
> >> mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 2.
> >> mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 0.
> >> mdadm: /dev/sdf1 is identified as a member of /dev/md127, slot 1.
> >> mdadm: /dev/sdg1 is identified as a member of /dev/md127, slot 5.
> >> mdadm: :/dev/md127 has an active reshape - checking if critical
> >> section needs to be restored
> >> mdadm: accepting backup with timestamp 1381360844 for array with
> >> timestamp 1381729948
> >> mdadm: backup-metadata found on device-5 but is not needed
> >> mdadm: added /dev/sdf1 to /dev/md127 as 1
> >> mdadm: added /dev/sdd1 to /dev/md127 as 2
> >> mdadm: added /dev/sdc1 to /dev/md127 as 3
> >> mdadm: added /dev/sdb1 to /dev/md127 as 4 (possibly out of date)
> >> mdadm: added /dev/sdg1 to /dev/md127 as 5 (possibly out of date)
> >> mdadm: added /dev/sde1 to /dev/md127 as 0
> >> mdadm: /dev/md127 assembled from 4 drives - not enough to start the ar=
ray.
> >
> >
> > What about with MDADM_GROW_ALLOW_OLD=3D1 *and* --force ??
> >
> > If that doesn't work, please add --verbose as well, and report the outp=
ut.
> >
> > NeilBrown
>=20
> Thanks Neil. I had tried that as well (output below). I'm wondering if
> there is a way to fix the metadata for /dev/sdc1 since that seems to
> be the odd one where the --examine data indicates that the other disks
> are all bad when I don't believe they really are (just the result of a
> partial kernel or driver crash). I have read about some people zeroing
> the superblock on a device so that it can be recreated, but I am not
> sure exactly how that works and am hesitant to try it since a reshape
> was in progress. I have also read about people having had success by
> re-running the original mdadm --create while leaving the data intact,
> but again I am hesitant to try that, especially because of the reshape
> state.
>=20
> Or... maybe this all has more to do with the Update Time, since the
> output seems to indicate 4 drives are usable. All of the drives have
> the same Update Time except for /dev/sdc1 which is about 5 minutes
> later than the rest. Since it is the fourth device, perhaps the
> assemble is satisfied with devices 0, 1, 2, 3, but then seeing an
> Update Time on devices 4 and 5 that is earlier than device 3, it
> marks them as "possibly out of date" and stops trying to assemble the
> array. Hard to tell, but I still would not have any idea how to
> overcome that scenario. I appreciate your help!
>=20
> # export MDADM_GROW_ALLOW_OLD=3D1
> # mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> /dev/sdf1 /dev/sdg1 --force --verbose
> mdadm: looking for devices for /dev/md127
> mdadm: /dev/sdb1 is identified as a member of /dev/md127, slot 4.
> mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 3.
> mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 2.
> mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 0.
> mdadm: /dev/sdf1 is identified as a member of /dev/md127, slot 1.
> mdadm: /dev/sdg1 is identified as a member of /dev/md127, slot 5.
> mdadm: :/dev/md127 has an active reshape - checking if critical
> section needs to be restored
> mdadm: accepting backup with timestamp 1381360844 for array with
> timestamp 1381729948
> mdadm: backup-metadata found on device-5 but is not needed
> mdadm: added /dev/sdf1 to /dev/md127 as 1
> mdadm: added /dev/sdd1 to /dev/md127 as 2
> mdadm: added /dev/sdc1 to /dev/md127 as 3
> mdadm: added /dev/sdb1 to /dev/md127 as 4 (possibly out of date)
> mdadm: added /dev/sdg1 to /dev/md127 as 5 (possibly out of date)
> mdadm: added /dev/sde1 to /dev/md127 as 0
> mdadm: /dev/md127 assembled from 4 drives - not enough to start the array.

That shouldn't happen.  With '-f' it should force the event count of either=
 b1
or g1 (or maybe both) to match the others.

What version of mdadm are you using? (mdadm -V)

Maybe try the latest
  git clone git://git.neil.brown.name/mdadm
  cd mdadm
  make mdadm
  ./mdadm .....

NeilBrown

--Sig_/ARsgs.qG=CsI3aYOl72AEXL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmR+1znsnt1WYoG5AQLTfQ/+ImOXCj6w+EH9mC9/h04hzCg7OvUi3pBy
HskNQp54aQCl3qflBvPyp/RaXHlumFiKtAR7BMqwJK+w3RQU8r9PqHSFCzc2LTy1
Fh8fgxI0IT/8unq7cLdfrqjicBsaibz25MFpFn2KlKlxLheQzFaprgvOSpfA4kkp
1MmfCJlF6t5bCyXResHROdeSgLEB9aYhMSkCfsKFcRxBlmGWa6uJP9+RjWTHCiCn
gRL/1XohtNuMqdpCHTeV1bof3MVJsajV80IRgJYILGDKJgpqfl69f/ChsBKMYo4O
gq1BmvwK1iUxZzQ7y/l+dnVQWaQQ/WLinx7AArWsu42lGj6F/r+IbBGpBSaH2rkH
eC/H2IynsSMZCQwX7oiDU/jPWYeTIezlacp/vmgx8zNyU1EnDlQsvesX0XfJZ1c8
VKF8yAL8DR0e4PICmK4OjTaG3bSI59/cYBt6nGV7TrAF/ZvLnFC/j7VVQ366vU5M
GfZA1rMNP+FiD997vokkB3/XTqUZlQw7XCzQvaQIoqDc4dnxZ4mpAfFlP4Bpzehb
LuFKx+tF6MIA4apSOGH3wCt1OUJBs12hw3575dlLsjU/Mh2devWj/UwOTFou9luu
RoDkBAPy0UtorEC2gZQSLWQrllHZfeaqHtjVtBoWelRV398CrQBfzGcStrGSWyco
ECbJzvLI/c4=
=w+Dc
-----END PGP SIGNATURE-----

--Sig_/ARsgs.qG=CsI3aYOl72AEXL--
