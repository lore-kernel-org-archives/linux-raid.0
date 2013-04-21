From: NeilBrown <neilb@suse.de>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Mon, 22 Apr 2013 07:46:28 +1000
Message-ID: <20130422074628.655f4241@notabene.brown>
References: <516869D2.9030506@bucksch.org>
	<516B3077.9020507@schinagl.nl>
	<516B590C.5060807@bucksch.org>
	<516AE7A0.4070504@schinagl.nl>
	<516BD5E0.4040007@bucksch.org>
	<516FF25B.4000907@bucksch.org>
	<516FFC13.2030803@ultratux.net>
	<5171CB91.1040708@bucksch.org>
	<5171EED3.8030505@bucksch.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EQP5lAwwhaq99G0tQgQO00="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5171EED3.8030505@bucksch.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Bucksch <linux.news@bucksch.org>
Cc: linux-raid@vger.kernel.org, Maarten <maarten@ultratux.net>
List-Id: linux-raid.ids

--Sig_/EQP5lAwwhaq99G0tQgQO00=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 20 Apr 2013 03:26:43 +0200 Ben Bucksch <linux.news@bucksch.org> wro=
te:

> linux.news@bucksch.org wrote, On 20.04.2013 00:56:
> > Maarten wrote, On 18.04.2013 15:58:
> >> On 18/04/13 15:17, Ben Bucksch wrote:
> >>> To re-summarize (for full info, see first post of thread):
> >>> * There are 2 RAID5 arrays in the machine, each have 8 disks.
> >>> * I upgraded Ubuntu 10.04 to 12.04.
> >>> * After reboot, both arrays had each ejected one disk.
> >>>    The ejected disks are working fine (at least now).
> >>> * During the resync mandated by above ejection,
> >>>     one other drive failed, this one fatally with a real hardware=20
> >>> failure.
> >>> * The second array resynced fine, further proving that the
> >>>     disks ejected during upgrade were working.
> >>> * Now I am left with: originally 8-disk RAID5, 6 disks are healthy,
> >>>    1 disk with hardware failure, and 1 disk that was ejected, but is
> >>> working.
> >>> * The latter is currently marked "spare" by md and has an event count
> >>>    (only) 2 events lower than the other 6 disks.
> >>> * My task is to get the latter disk back online *with* its data,=20
> >>> without
> >>> resync.
> >>>
> >>> I desperately need help, please.
> >>>
> >>> Based on suggestions here by Oliver and on forums, I did (and the=20
> >>> result
> >>> is):
> >>>
> >>>> # mdadm --stop /dev/md0
> >>>> mdadm: stopped /dev/md0
> >>>> # mdadm --assemble --run --force /dev/md0 /dev/sd[jlmnopq]
> >>>> mdadm: failed to RUN_ARRAY /dev/md0:
> >>>> mdadm: Not enough devices to start the array.
> >> At this point, does dmesg show anything pointing to that input/output
> >> error ? The procedure is correct
> >
> > [dmesg]
> > The problem is:
> > md: kicking non-fresh sdl from array!
> > thus:
> > raid5: not enough operational devices for md0 (2/8 failed)
> >
> > So, the question is: How do I convince md not to be so anal retentive=20
> > and prevent me from accessing any of my data? The drive ***is fine***,=
=20
> > has practically all the data (I don't care about these 2 events), just=
=20
> > use it already. Nobody seems to know the magic shell commands to do tha=
t.
>=20
> Good news:
> In my desperation, I now ran the following dangerous command:
> mdadm --create /dev/md0 --assume-clean --level=3Draid5 -n 8 --chunk=3D64=
=20
> --layout=3Dleft-symmetric --metadata=3D0.90 /dev/sdj missing /dev/sdl=20
> /dev/sd[mopnq]
> and that worked. I can read my files again, without problem, all is happy.
>=20
> Before doing that, I saved the superblock, using (no warranty!):
> 1. mdadm -E /dev/sdj
> 2. "Used Dev Size" (in KB) * 1024 / 64 - 1 (use this as <skip blocks>)
> 3. dd if=3D/dev/sdl of=3D/root/sdj.mdsuperblock  ibs=3D64 skip=3D<skip bl=
ocks>
>=20
> ---
>=20
> Thanks, Maarten and Oliver, for your help and moral support.
>=20
> ---
>=20
> I still maintain that all of this represents 2 design bugs in the md=20
> implementation:
> 1. ejecting devices out that are working

Without being able to examine the full sequence of events I cannot be sure
what happened here, but my best guess is that the working device wasn't
"ejected" so much as it simply wasn't included.

The modern approach to booting involves devices appearing asynchronously,
with filesystems being mounted as the relevant devices appear.
This is slightly awkward for md/raid.  If you have a 5-disk RAID5 and only 4
disks have appeared, do you start the array degraded, or do you wait for the
5th disk to appear.
What if the 5th disk has been physically removed?  That would mean waiting
forever.
mdadm doesn't impose a policy but allows the boot scripts to choose one.
Some boot scripts might get this wrong.

If you have a write-intent-bitmap on your array, then getting it wrong isn't
too bad:  when the 5th disk does appear it can easily be re-added.  Without
the bitmap, it cannot.

My guess is that you got bitten by something going wrong in the init script=
s.

> 1.1. individual sectors not readable/writable, but rest of device working
>       (This is very common these days with large drives)

Yes, this is a problem.  There is code to handle it better by recording bad
blocks.  It isn't quite production read yet.   And it'll never work on 0.90
metadata.

> 1.2. temporary errors, e.g. disk not connected, loose cable, bad=20
> controller etc.
> 1.3. Linux distro upgrade, no disk problem at all (my case)

unless there are bugs in the distro scripts.

> 2. not allowing me to re-add ejected disks, with data, without resync

It *must* be hard to do this, because it *will* cause data loss.  Maybe it
shouldn't be quite as hard as it is.  But then there are lots of improvemen=
ts
that could be made, but not very many developers working on it.

NeilBrown

>=20
> The result of this is:
> 1. a device is ejected for no good reasons
> 2. a resync is triggered
> 3. the resync discovers a disk that is *really* broken
>=20
> I am left with 2 disks marked "failed", but only 1 actually failed, so=20
> normally I should be able to recover, yet I cannot read anything. This=20
> fails the very definition of RAID5, therefore is a bug. I have to do=20
> risky operations like re-create that can easily destroy all data.=20
> Effectively, md achieves the opposite that is intended: It actively=20
> risks and destroys my data.
>=20
> I am BEGGING you md raid devs to fix these.
>=20
> Ben Bucksch
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/EQP5lAwwhaq99G0tQgQO00=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXReNDnsnt1WYoG5AQJrMQ//T/FXJb7ugLuoZ+Gb4VQtMjlfs5hwKvt6
tN02BEUF2j8yxW2ZGpQ2NntueRX6qfVIYl09PdyJFa5eBCtH8KvgU7sdsy0Wu5Ak
dSxb+BsHRo5XHA8ruZTIp3knFu59aAWsGlSHfvlP6DlTmacXWaLKtq+5stQcGdXo
VcyidehhPqm0orecLb0CoI96gVfQU0Ue2QJ0/F1XWX604dJ45Hn0WKj1TNCl89kQ
GkbLodKmOKV/f9fOce2RGEE0YfDzgbSBHOyGcDVGkw8DOmlgR4ecjUezgMPPE9+o
96baXEFUt7vpXqa6RuYVG4883jIZACkIwPFrSsK43culoc2SN8TtEF2ptz5b09Wl
DZrFXymoacOIqbFv5q9L3QWkGOmjczR6Rjq+9CzJb69AfKl3PONLBFiqYLAItHrp
e4LtLVLJBvL9kmed5WPHhc8Hl7tcjr3w2VnchyxLWI2Zt00VQ3BVkZlWAJZA5SUA
bCAN6O9mQOaP82Crosd/j2z+n5Qu/UJB2BhVjofPFbeVBLpeX9jXJ2F5SSzygMxY
19iO40FDg0HLQo9if5arqbnMSHUkb8pLFLYs9ZNg4xjyoYd4cBoJv8VlQaQ3weHn
X64UjJW7xwGrtEYeTXv8f/xCBDCtXOJOq8gxaJXwXh0utr/AYS/W7zlg+3llwTAW
SFw6/+ZZhcI=
=5Y0E
-----END PGP SIGNATURE-----

--Sig_/EQP5lAwwhaq99G0tQgQO00=--
