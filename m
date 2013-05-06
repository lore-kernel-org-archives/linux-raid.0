From: NeilBrown <neilb@suse.de>
Subject: Re: Reshape Shrink Hung Again
Date: Mon, 6 May 2013 15:29:26 +1000
Message-ID: <20130506152926.067d3459@notabene.brown>
References: <96A49024-A8A7-4ED9-82B1-5AE430374EBE@bingner.com>
	<20130422072414.3e30882c@notabene.brown>
	<7A4C666A-D95E-41AB-96B2-5E75097D8BBB@bingner.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BMHmFaIGgu6jvVePIJRfQMw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7A4C666A-D95E-41AB-96B2-5E75097D8BBB@bingner.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Bingner <sam@bingner.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/BMHmFaIGgu6jvVePIJRfQMw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 1 May 2013 02:00:30 +0000 Sam Bingner <sam@bingner.com> wrote:

> On Apr 21, 2013, at 11:24 AM, NeilBrown <neilb@suse.de> wrote:
>=20
> > On Fri, 19 Apr 2013 08:29:37 +0000 Sam Bingner <sam@bingner.com> wrote:
> >=20
> >> I'll start this off by saying that no data is in jeopardy, but I would=
 like to track down the cause of this problem and fix it.  I originally tho=
ught it must have been due to the incorrect backup-file size with a raid ar=
ray shrunk to smaller than the final size when it happened to me last time =
but this time this was not the case.
> >>=20
> >> I initiated a shrink from a 4-drive RAID5 to a 3-drive RAID5, this shr=
ink had no problems except that a drive failed right at the end of the resh=
ape... then it hung at 99.9% and does not allow me to remove the failed dri=
ve from the array because it is "rebuilding".  I am not sure if the drive f=
ailed at the end, or if it was after it had gotten to 99.9% because I didn'=
t see this until the next morning as it ran overnight.
> >>=20
> >> Sam
> >>=20
> >> root@fs:/var/log# uname -a
> >> Linux fs 2.6.32-5-686 #1 SMP Mon Jan 16 16:04:25 UTC 2012 i686 GNU/Lin=
ux
> >>=20
> >> Apr 17 22:37:41 fs kernel: [25860779.639762] md1: detected capacity ch=
ange from 749122093056 to 499414728704
> >> Apr 17 22:38:40 fs kernel: [25860837.912441] md: reshape of RAID array=
 md1
> >> Apr 17 22:38:40 fs kernel: [25860837.912447] md: minimum _guaranteed_ =
 speed: 1000 KB/sec/disk.
> >> Apr 17 22:38:40 fs kernel: [25860837.912452] md: using maximum availab=
le idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
> >> Apr 17 22:38:40 fs kernel: [25860837.912459] md: using 128k window, ov=
er a total of 243854848 blocks.
> >> Apr 18 07:51:09 fs kernel: [25893987.273813] raid5: Disk failure on sd=
a2, disabling device.
> >> Apr 18 07:51:09 fs kernel: [25893987.273815] raid5: Operation continui=
ng on 2 devices.
> >> Apr 18 07:51:09 fs kernel: [25893987.287168] md: super_written gets er=
ror=3D-5, uptodate=3D0
> >> Apr 18 07:51:10 fs kernel: [25893987.657039] md: md1: reshape done.
> >> Apr 18 07:51:10 fs kernel: [25893987.781599] md: reshape of RAID array=
 md1
> >> Apr 18 07:51:10 fs kernel: [25893987.781607] md: minimum _guaranteed_ =
 speed: 100 KB/sec/disk.
> >> Apr 18 07:51:10 fs kernel: [25893987.781613] md: using maximum availab=
le idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
> >> Apr 18 07:51:10 fs kernel: [25893987.781620] md: using 128k window, ov=
er a total of 243854848 blocks.
> >>=20
> >>=20
> >> md1 : active raid5 sdd2[3] sda2[0](F) sdc2[2] sdb2[4]
> >>      487709696 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2]=
 [_UU]
> >>      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.]  re=
shape =3D 99.9% (243853824/243854848) finish=3D343.6min speed=3D0K/sec
> >>=20
> >=20
> > Looks like a bug - probably in mdadm.
> > mdadm needs to help the reshape over the last little bit, and md is pro=
bably
> > waiting for it to do that.  This will be the only time in the whole pro=
cess
> > when the backup file is used.
> >=20
> > I would try stopping the array and re-assembling it.  That might requir=
e a
> > reboot.  If that doesn't fix it, let me know and I'll prioritise this.
> > Otherwise - I've put it on my to-do list.  I'll try to reproduce and fi=
x it
> > in due course.
> >=20
> > Thanks for the report,
> > NeilBrown
>=20
> Sorry for the delay in responding, the server was at a remote location an=
d didn't have a remote console.  My attempt to make an initrd that provided=
 me SSH failed for unknown reasons (it works now that I've got physical acc=
ess to the server).  Based on the results below, it looks like the drive th=
at did drop out was pretty much at the very end and I really don't think it=
 was related to the error.  I can leave the system in this state and get yo=
u access to it to see if you desire.  This system was in the process of bei=
ng decommissioned and soon after the failure the replacement came in.  This=
 same error happened to me twice, but I also did another reshape where it d=
idn't happen.  I can play with this system and try to duplicate it again al=
so.  As I said, I'll be happy to do anything to help find the source of thi=
s.=20
>=20
> In any case, here is what happened from initramfs:

Thanks.
It looks like sda2 (first device in array) failed shortly after Thu Apr 18
11:49:51 2013 when there was still 13MB to be reshaped.
Then the reshape froze with only 2MB to go.  Don't know why yet.

Could yo retry the assemble command with --verbose added?
i.e.
  mdadm.static --assemble /dev/md0 --backup-file=3D/boot/backup.md --verbose

The=20
   export MDADM_GROW_ALLOW_OLD=3D1
and try again.
If that doesn't start the array, try adding
   --invalid-backup

and report the results.

Thanks.

NeilBrown


--Sig_/BMHmFaIGgu6jvVePIJRfQMw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYc/tjnsnt1WYoG5AQKUow//Tc5GhRzwkH+WdK8CXwRVEVNMupkKtWib
oe+5i+S7ZNqrlQbZXTjGMLoGSUhk5q8QGrmY7kCxIIqc9AEzUO9OYAgjQbu3+kBo
7W3FCNWdMiDHTF44ZjexLgjzGZAjb9HesLd+XdjvN/VvBv9n31iCfCA5BlqlAXHV
uDXgE2NTvs+8awVHkymYo2gB7txa5v/qcMZILkYYB5syGHQjyDyAOeJxp9ujJERJ
7IkCQQY3w/muljnOF3ITccXTJ5zIGYB67kxA8LC0/P9J2Ii/PJXmgEWtua1fiP02
1f7mP1v79aBcCFi84YHYyuhiSGIqjqrUOqoCrMItyVJ+LEw6n/OGZ3KASudV4lD9
Qhv/8F2YFL47MTeUKE3UmkRSdDsoYpQL/PXoeTPVXVyFuYtJuLxDkG31a+JWVJkq
B97Mz8fK01dvxdB821/JjRsCd0GUod78EEZXgFJmtnHbLtZYL7HRcLBMhLa+sf+g
1py2LFVv46NPAPCaPVEHMfZv19EKJVERudTbcLPkwYf0yM7GQF0MKNk+o+Cqyuap
/mH8dWchzwktFTgYQehm1HjOJYh5VLYB+O9NfNYAASeDMcvbU+MOSMZG+epIzsP7
Ng9nFu9q+DGFCKszs3EVImjUhZKEBDdg1Q7RSLU7gHdFg6dE/4Y6+h4KnW40gHya
W1ZIm81JdTE=
=+JuX
-----END PGP SIGNATURE-----

--Sig_/BMHmFaIGgu6jvVePIJRfQMw--
