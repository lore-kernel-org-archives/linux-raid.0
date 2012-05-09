From: NeilBrown <neilb@suse.de>
Subject: Re: Failed drive while converting raid5 to raid6, then a hard
 reboot
Date: Wed, 9 May 2012 10:47:34 +1000
Message-ID: <20120509104734.20236b70@notabene.brown>
References: <CAFTzWnrQARaemDkMNe48zT8tipPmsVbt0ZFgfDTyrtUc9KjuZQ@mail.gmail.com>
	<20120509064858.4e39c389@notabene.brown>
	<CAFTzWnrGf5Fs4wRekjnOHfutANArJiT8j-Y6Mbd+nxPXXXrnSA@mail.gmail.com>
	<20120509092109.0cae5c3c@notabene.brown>
	<CAFTzWnoEZdZDA6jwHzXmq84T_7eESim0=GW4wr=RgPuTAxYjzQ@mail.gmail.com>
	<CAFTzWnqdTt92RWjSr8Ve_oOWBUphw5DFTGY3Xn4AkawN-0YBpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YDIMY3hSaENZzaYwH=1QewL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFTzWnqdTt92RWjSr8Ve_oOWBUphw5DFTGY3Xn4AkawN-0YBpA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?H=E1kon_G=EDslason?= <hakon.gislason@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/YDIMY3hSaENZzaYwH=1QewL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 9 May 2012 00:20:29 +0000 H=E1kon G=EDslason <hakon.gislason@gmail.=
com>
wrote:

> Hi again, I thought the drives would last long enough to complete the
> reshape, I assembled the array, it started reshaping, went for a
> shower, and came back to this: http://pastebin.ubuntu.com/976993/
>=20
> The logs show the same as when the other drives failed:
> May  8 23:58:26 axiom kernel: ata4: hard resetting link
> May  8 23:58:32 axiom kernel: ata4: link is slow to respond, please be
> patient (ready=3D0)
> May  8 23:58:37 axiom kernel: ata4: hard resetting link
> May  8 23:58:42 axiom kernel: ata4: link is slow to respond, please be
> patient (ready=3D0)
> May  8 23:58:47 axiom kernel: ata4: hard resetting link
> May  8 23:58:52 axiom kernel: ata4: link is slow to respond, please be
> patient (ready=3D0)
> May  8 23:59:22 axiom kernel: ata4: limiting SATA link speed to 1.5 Gbps
> May  8 23:59:22 axiom kernel: ata4: hard resetting link
> May  8 23:59:27 axiom kernel: ata4.00: disabled
> May  8 23:59:27 axiom kernel: ata4: EH complete
> May  8 23:59:27 axiom kernel: sd 3:0:0:0: [sdd] Unhandled error code
> May  8 23:59:27 axiom kernel: sd 3:0:0:0: [sdd] Result:
> hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
> May  8 23:59:27 axiom kernel: sd 3:0:0:0: [sdd] CDB: Write(10): 2a 00
> 00 00 00 08 00 00 02 00
> May  8 23:59:27 axiom kernel: md: super_written gets error=3D-5, uptodate=
=3D0
> May  8 23:59:27 axiom kernel: sd 3:0:0:0: [sdd] Unhandled error code
> May  8 23:59:27 axiom kernel: sd 3:0:0:0: [sdd] Result:
> hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
> May  8 23:59:27 axiom kernel: sd 3:0:0:0: [sdd] CDB: Read(10): 28 00
> 0a 9d cb 00 00 00 40 00
> May  8 23:59:27 axiom kernel: md: md0: reshape done.
>=20
> What course of action do you suggest I take now?

I'm not surprised.  Until you fix the underlying issue you will continue to
suffer pain.

You should be able to assemble the array again the same way as before - plus
the --force option.

It continue to reshape for a little while and then will probably another
error.  Each time that happens there is a risk of some corruption.

Once you get it going again you could
   echo frozen > /sys/block/md0/md/sync_action
to freeze the reshape.  Then mount the filesystem and backup the important
data.
That what the constant reshape activity won't trigger any errors  - though
just extracting data for the backup might.

NeilBrown


>=20
> --
> H=E1kon G.
>=20
>=20
> On 8 May 2012 23:55, H=E1kon G=EDslason <hakon.gislason@gmail.com> wrote:
> > Thank you very much!
> > It's currently rebuilding, I'll make an attempt to mount the volume
> > once it completes the build. But before that, I'm going to image all
> > the disks to my friends array, just to be safe. After that, backup
> > everything.
> > Again, thank you for your help!
> > --
> > H=E1kon G.
> >
> >
> > On 8 May 2012 23:21, NeilBrown <neilb@suse.de> wrote:
> >> On Tue, 8 May 2012 22:19:49 +0000 H=E1kon G=EDslason <hakon.gislason@g=
mail.com>
> >> wrote:
> >>
> >>> Thank you for the reply, Neil
> >>> I was using mdadm from the package manager in Debian stable first
> >>> (v3.1.4), but after the constant drive failures I upgraded to the
> >>> latest one (3.2.3).
> >>> I've come to the conclusion that the drives are either failing because
> >>> they are "green" drives, and might have power-saving features that are
> >>> causing them to be "disconnected", or that the cables that came with
> >>> the motherboard aren't good enough. I'm not 100% sure about either,
> >>> but at the moment these seem likely causes. It could be incompatible
> >>> hardware or the kernel that I'm using (proxmox debian kernel:
> >>> 2.6.32-11-pve).
> >>>
> >>> I got the array assembled (thank you), but what about the raid5 to
> >>> raid6 conversion? Do I have to complete it for this to work, or will
> >>> mdadm know what to do? Can I cancel (revert) the conversion and get
> >>> the array back to raid5?
> >>>
> >>> /proc/mdstat contains:
> >>>
> >>> root@axiom:~# cat /proc/mdstat
> >>> Personalities : [raid6] [raid5] [raid4]
> >>> md0 : active (read-only) raid6 sdc[6] sdb[5] sda[4] sdd[7]
> >>> =A0 =A0 =A0 5860540224 blocks super 1.2 level 6, 32k chunk, algorithm=
 18 [5/3] [_UUU_]
> >>>
> >>> unused devices: <none>
> >>>
> >>> If I try to mount the volume group on the array the kernel panics, and
> >>> the system hangs. Is that related to the incomplete conversion?
> >>
> >> The array should be part way through the conversion. =A0If you
> >> =A0 mdadm -E /dev/sda
> >> it should report something like "Reshape Position : XXXX" indicating
> >> how far along it is.
> >> The reshape will not restart while the array is read-only. =A0Once you=
 make it
> >> writeable it will automatically restart the reshape from where it is u=
p to.
> >>
> >> The kernel panic is because the array is read-only and the filesystem =
tries
> >> to write to it. =A0I think that is fixed in more recent kernels (i.e. =
ext4
> >> refuses to mount rather than trying and crashing).
> >>
> >> So you should just be able to "mdadm --read-write /dev/md0" to make th=
e array
> >> writable, and then continue using it ... until another device fails.
> >>
> >> Reverting the reshape is not currently possible. =A0Maybe it will be w=
ith Linux
> >> 3.5 and mdadm-3.3, but that is all months away.
> >>
> >> I would recommend an "fsck -n /dev/md0" first and if that seems mostly=
 OK,
> >> and if "mdadm -E /dev/sda" reports the "Reshape Position" as expected,=
 then
> >> make the array read-write, mount it, and backup any important data.
> >>
> >> NeilBrown
> >>
> >>
> >>>
> >>> Thanks,
> >>> --
> >>> H=E1kon G.
> >>>
> >>>
> >>>
> >>> On 8 May 2012 20:48, NeilBrown <neilb@suse.de> wrote:
> >>> >
> >>> > On Mon, 30 Apr 2012 13:59:56 +0000 H=E1kon G=EDslason
> >>> > <hakon.gislason@gmail.com>
> >>> > wrote:
> >>> >
> >>> > > Hello,
> >>> > > I've been having frequent drive "failures", as in, they are repor=
ted
> >>> > > failed/bad and mdadm sends me an email telling me things went wro=
ng,
> >>> > > etc... but after a reboot or two, they are perfectly fine again. =
I'm
> >>> > > not sure what it is, but this server is quite new and I think the=
re
> >>> > > might be more behind it, bad memory or the motherboard (I've been
> >>> > > having other issues as well). I've had 4 drive "failures" in this
> >>> > > month, all different drives except for one, which "failed" twice,=
 and
> >>> > > all have been fixed with a reboot or rebuild (all drives reported=
 bad
> >>> > > by mdadm passed an extensive SMART test).
> >>> > > Due to this, I decided to convert my raid5 array to a raid6 array
> >>> > > while I find the root cause of the problem.
> >>> > >
> >>> > > I started the conversion right after a drive failure & rebuild, b=
ut as
> >>> > > it had converted/reshaped aprox. 4%(if I remember correctly, and =
it
> >>> > > was going really slowly, ~7500 minutes to completion), it reported
> >>> > > another drive bad, and the conversion to raid6 stopped (it said
> >>> > > "rebuilding", but the speed was 0K/sec and the time left was a few
> >>> > > million minutes.
> >>> > > After that happened, I tried to stop the array and reboot the ser=
ver,
> >>> > > as I had done previously to get the reportedly "bad" drive working
> >>> > > again, but It=A0wouldn't=A0stop the array or reboot, neither coul=
d I
> >>> > > unmount it, it just hung whenever I tried to do something with
> >>> > > /dev/md0. After trying to reboot a few times, I just killed the p=
ower
> >>> > > and re-started it.=A0Admittedly=A0this was probably not the best =
thing I
> >>> > > could have done at that point.
> >>> > >
> >>> > > I have backup of ca. 80% of the data on there, it's been a month =
since
> >>> > > the last complete backup (because I ran out of backup disk space).
> >>> > >
> >>> > > So, the big question, can the array be activated, and can it comp=
lete
> >>> > > the conversion to raid6? And will I get my data back?
> >>> > > I hope the data can be rescued, and any help I can get would be m=
uch
> >>> > > appreciated!
> >>> > >
> >>> > > I'm fairly new to raid in general, and have been using mdadm for =
about
> >>> > > a month now.
> >>> > > Here's some data:
> >>> > >
> >>> > > root@axiom:~# mdadm --examine --scan
> >>> > > ARRAY /dev/md/0 metadata=3D1.2 UUID=3Dcfedbfc1:feaee982:4e92ccf4:=
45e08ed1
> >>> > > name=3Daxiom.is:0
> >>> > >
> >>> > >
> >>> > > root@axiom:~# cat /proc/mdstat
> >>> > > Personalities : [raid6] [raid5] [raid4]
> >>> > > md0 : inactive sdc[6] sde[7] sdb[5] sda[4]
> >>> > > =A0 =A0 =A0 7814054240 blocks super 1.2
> >>> > >
> >>> > > root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
> >>> > > mdadm: /dev/md0 is already in use.
> >>> > >
> >>> > > root@axiom:~# mdadm --stop /dev/md0
> >>> > > mdadm: stopped /dev/md0
> >>> > >
> >>> > > root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
> >>> > > mdadm: Failed to restore critical section for reshape, sorry.
> >>> > > =A0 =A0 =A0 Possibly you needed to specify the --backup-file
> >>> > >
> >>> > > root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
> >>> > > --backup-file=3D/root/mdadm-backup-file
> >>> > > mdadm: Failed to restore critical section for reshape, sorry.
> >>> >
> >>> > What version of mdadm are you using?
> >>> >
> >>> > I suggest getting a newer one (I'm about to release 3.2.4, but 3.2.3
> >>> > should
> >>> > be fine) and if just that doesn't help, add the "--invalid-backup" =
option.
> >>> >
> >>> > However I very strongly suggest you try to resolve the problem whic=
h is
> >>> > causing your drives to fail. =A0Until you resolve that it will keep
> >>> > happening
> >>> > and having it happen repeatly during the (slow) reshape process wou=
ld not
> >>> > be
> >>> > good.
> >>> >
> >>> > Maybe plug the drives into another computer, or another controller,=
 while
> >>> > the
> >>> > reshape runs?
> >>> >
> >>> > NeilBrown
> >>> >
> >>> >
> >>


--Sig_/YDIMY3hSaENZzaYwH=1QewL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6m+pjnsnt1WYoG5AQLRDw//ZlY+6H4fHDS81gYo5cJrDrp9FtZSD+P5
ZGp8e7dVk0hwHSazjAZ0VsQKzitxh+kUX0iWos+aZ+EasOUrMF739UvcQdVoX56P
FQwHjoJUalrRkh0O69sNqfdcDpwm1S9GLV1rC1wVMx7sP8dM0VpelrfSg7M1Xgor
LaJxnvQFOOXLbHYSNkYY0nOB/E3m/aZzqPSKuYf7mKjUOpseZTtc3DPhVZVp2MnS
BVs2iYEHbqQ72uvokFce+K6dByNLEQOiuqVrJ8WQPoG2+tFf5EJaDxWwd0P9KefT
pYIyC1zfvdAO3ZLva+JfAJP5QRzI9yCrr91mRPWJg4zFNH3Le/d3ueFhoWZTxU83
l1tf8eKJgPnDJkue+DnyNEpO6cLZOtVjlRI2bZM1MjQOhDUZjQsQRGIIyaQsEw6q
l/KP3WdtwQ/NLGJtxsrLg8N87x0MXrLFxqKMXhPpMDmd0C0wo3fnkG9qTQZU2npn
eTFs3Kl57oeoFOM4CKOzMFrbVOxq/8zBAj+Cr/mRrT2V9GiGB79sSyFfQINh2qsd
1k/peQyQGqvjwtKol2mLj6m4yXKpDUYqzlXL152oxS4YX4MvU9iMrCrtWl07HPHv
KhiGQa7NPydDW2MCY3HvIt0AdznGqoCv5aPwzeOwyVq2PkeN/YkyIC75ZGWKa7zv
r6mXx1Bm/IE=
=sVWz
-----END PGP SIGNATURE-----

--Sig_/YDIMY3hSaENZzaYwH=1QewL--
