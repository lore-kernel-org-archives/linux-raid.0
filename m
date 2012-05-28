From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 devices all marked as spares?!
Date: Tue, 29 May 2012 09:09:38 +1000
Message-ID: <20120529090938.5af8a7ed@notabene.brown>
References: <4FC3E4FB.4010003@schinagl.nl>
	<20120529080736.03c62ae1@notabene.brown>
	<4FC3FFE7.6020606@schinagl.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eRakAZa_GReS5jP+yh5+WTe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FC3FFE7.6020606@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/eRakAZa_GReS5jP+yh5+WTe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 May 2012 00:44:55 +0200 Oliver Schinagl <oliver+list@schinagl.nl>
wrote:

> On 05/29/12 00:07, NeilBrown wrote:
> > On Mon, 28 May 2012 22:50:03 +0200 Oliver Schinagl<oliver+list@schinagl=
.nl>
> > wrote:
> >
> >> Hi list,
> >>
> >> I'm sorry if this is the wrong place to start, but I've been quite lost
> >> as to what is going wrong here.
> >
> > No, you are in exactly the right place!
> Pfew :D
>=20
> >
> >>
> >> I've been having some issues latly with my raid10 array. First some in=
fo.
> >>
> >> I have three raid10 arrays on my gentoo box on 2 drives using GPT.
> >> I was running 3.2.1 at the time but have 3.4.0 running at the moment.
> >> mdadm - v3.2.5 - 18th May 2012
> >>
> >>
> >> md0, a 2 far-copies, 1.2 metadata, raid10 array  consisting of /dev/sd=
a4
> >> and sdb4.
> >> md1, a 2 offset-copies, 1.2 metadata, raid10 array consisting of
> >> /dev/sda5 and sdb5
> >> md2, a 2 offset-copies, 1.2 metadata, raid10 array consisting of
> >> /dev/sda6 and sdb6
> >
> > I'm liking the level of detail you are providing - thanks.
> The more information provided, the better I always recon!
>=20
> >
> >>
> >> sd*1 is bios_grub data, sd*2 is 256mb fat for playing with uefi and sd=
*3
> >> is 8gigs of unused space, may have some version of ubuntu on it and sd=
*7
> >> for swap.
> >>
> >> For all of this, md0 has always worked normally. it is being assembled
> >> from initramfs where a static mdadm lives as such:
> >> /bin/mdadm -A /dev/md0 -R -a md /dev/sda4 /dev/sdb4 || exit 1
> >
> > In general I wouldn't recommend this.  Names of sd devices change when
> > devices are removed or added, so this is fragile.  It may cause the act=
ual
> > problems you have been experiencing currently.
> Yes! Yes yes yes! I know. Kinda offtopic here, but:
>=20
> I've always used a small 100mb -250mb (or 1gb on my desktop) array using=
=20
> metadata 0.9 and autodetect. This worked perfectly. /usr, /home etc=20
> where on exotic raid setups (metadata 1.2 etc) but this all just worked=20
> (tm).
>=20
> Recently Fedora decided booting and /usr was a mess and not long after=20
> udev (i belive not only in gentoo) 'agreed' that /usr and / should be=20
> merged.
>=20
> With 0.90 autodetect being depreciated by the kernel anyway I decided to=
=20
> bite the bullit and use my 8gb /usr as combined / and /usr. Now however=20
> I was 'forced' to also use an initramfs to get my raid array going. Long=
=20
> story short, I just quickly hacked that together as minimally as=20
> possible, as I haven't found any 'clean' way to do=20
> it/documented/recommended way to copy.
>=20
> It's not only just error-prone, It's also broken. Having a disk missing=20
> or fail, causes kernel panics due to init pre-maturly failing because=20
> mdadm fails at finding /dev/sdb.

If you want to build a simple-as-possible initramfs to assemble you root md
array, I recommend  README.initramfs in the mdadm source code.

http://neil.brown.name/git?p=3Dmdadm;a=3Dblob;f=3DREADME.initramfs;h=3D8f9b=
8ddffb32f1eb3dc087ccda9bc0ff93870a33;hb=3DHEAD

>=20
> >
> >>
> >> md1 and md2 are being brought up during boot, md0 holds root, /usr etc
> >> wheras md1 are just for home and data.
> >>
> >> The last few weeks md1 and md2 randomly fail to come up properly. md1 =
or
> >> md2 come up as inactive and one of the two drivers are marked as spare=
s.
> >> (Why as spares? Why won't it try to run the array with a missing drive=
?)
> >> While this happens, it's completly abitrary whether sda or sdb is being
> >> used. so md1 can be sda5[2](S) and md2 can be sdb5[2](S).
> >
> > The (S) is a bit misleading here.  When an array is 'inactive', all dev=
ices
> > are marked as '(S)', because they are not currently active (nothing is =
as the
> > whole array is inactive).
> >
> > When md1 has sda5[2](S), is sdb5 mentioned for md1 as well, or is it si=
mply
> > absent.   I'm guessing the second.
> Yes, i'm 99% sure however it's randomly sda6 or sdb6 that's shown. But=20
> never both. Only if I do mdadm -A /dev/md2 /dev/sda6 /dev/sdb6 (after=20
> stopping md2 first of course).

That makes sense.

>=20
> >
> > This it most likely caused by "mdadm -I" being run by udev on device
> > discovery.  Possibly it is racing with an "mdadm -A" run from a boot sc=
ript.
> > Have a look for a udev/rules.d script which run mdadm -I and maybe disa=
ble it
> > and see what happens.
> In init.d I find two scripts calling mdadm. /etc/init.d/mdadm only does=20
> monitoring (mdadm --monitor --scan --daemonize) I strongly doubt that=20
> forces any of the assembling? (even though scan is there?)
>=20
> /etc/init.d/mdraid does some md stuff, but that's not run nor enabled.
>=20
> BTW, I only start md0 from initramfs, so udev apparently does the rest=20
> (and sucks at it?)

Let's just say it is not yet perfect at it.
Now that you are using mdadm 3.2.5 there is a better chance that it will wo=
rk
reliably.  Is it still failing?


>=20
> >
> >>
> >> When this happens, I mdadm --stop /dev/md1 and /dev/md2, followed
> >> immediatly by mdadm -A /dev/md1 (using mdadm.conf which doesn't even
> >> list the devices. ARRAY /dev/md1 metadata=3D1.2 UUID=3Dnnn name=3Dhost=
:home).
> >> The arrays come up and work just fine.
> >>
> >> What happend today however, is that md2 again does not come up, and
> >> sda6[3](S) shows in /proc/mdadm. However re-assembly of the array fails
> >> and only using mdadm -A /dev/md2 /dev/sda6 /dev/sdb6 shows:
> >> mdadm: device 1 in /dev/md2 has wrong state in superblock, but /dev/sd=
b6
> >> seems ok
> >> mdadm: /dev/md2 assembled from 0 drives and 2 spares - not enough to
> >> start the array.
> >> /proc/mdadm shows as somewhat expected.
> >> md2 : inactive sda6[3](S) sdb6[2](S)
> >>
> >> Only using sdb6 however also fails. I guess because it does not want to
> >> use a spare.
> >> mdadm: failed to RUN_ARRAY /dev/md2: Invalid argument
> >> mdadm: Not enough devices to start the array.
> >>
> >> Now the really disturbing part comes from mdadm --examine.
> >> valexia oliver # mdadm --examine /dev/sda6
> >> /dev/sda6:
> >>             Magic : a92b4efc
> >>           Version : 1.2
> >>       Feature Map : 0x0
> >>        Array UUID : nnnn
> >>              Name : host:opt  (local to host host)
> >>     Creation Time : Sun Aug 28 17:46:27 2011
> >>        Raid Level : -unknown-
> >>      Raid Devices : 0
> >>
> >>    Avail Dev Size : 456165376 (217.52 GiB 233.56 GB)
> >>       Data Offset : 2048 sectors
> >>      Super Offset : 8 sectors
> >>             State : active
> >>       Device UUID : nnnn
> >>
> >>       Update Time : Mon May 28 20:52:35 2012
> >>          Checksum : ac17255 - correct
> >>            Events : 1
> >>
> >>
> >>      Device Role : spare
> >>      Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
> >>
> >> sdb6 lists identical content only with the checksum's being correbt,
> >> albeit different and of coruse the Device UUID. Array UUID is of course
> >> identical as is creation time.
> >>
> >> Also to note, is that grub2 does mention an 'error: Unsupported RAID
> >> level: -1000000.' which probably relates to the 'Raid Level: -unknown-=
'.
> >>
> >> As to what may have caused this? I have absolutely no idea. I did a
> >> clean shutdown where the arrays get cleanly unmounted. Not 100% sure if
> >> the arrays get --stopped but I would be surprised if they did not.
> >>
> >> So I guess is this a md driver bug? Is there anything I can do to
> >> recover my data, which i cannot image it not being?
> >
> > This is a known bug which has been fixed.  You are now running 3.4 so a=
re
> > safe from it.
> Well this strange behavior all stemmed from running 3.2.1. I've only=20
> upgraded to 3.4 to see if that 'fixes' it. (It didn't :( unfortunately).

I think that bug was in 3.3 and 3.2.1 and fixed in 3.4 and some later 3.3.y
and 3.2.y kernels.
The bug would cause an array to be destroyed at shutdown in some unusual
circumstances.  Once destroyed you need to re-create.

>=20
> The -100000 error I'm assuming for now also stems from the meta data=20
> being corrupt, and will probably go away when trying the below tomorrow :)

Correct.

>=20
> > You can recover your data by re-creating the array.
> >
> >    mdadm -C /dev/md2 -l10 -n2 --layout o2 --assume-clean \
> >    -e 1.2  /dev/sda6 /dev/sdb6
> >
> > Check that I have that right - don't just assume :-)
> That looks very similar to what I used to create the array with, except=20
> the assume-clean part. I wonder however, would it not wiser to create=20
> the array using /dev/sda6 missing thus creating a degraded array?=20
> Atleast I'll still have the sdb6 which MAY contain the data also (since=20
> only sda6 'apparently' has wrong state?

That would be a suitable approach - arguably safer.  If you feel more
comfortable with it, then that is a strong reason to follow that course.

>=20
> Also, would it not be possible to mount sdb6 using the correct offset? I=
=20
> remember raid1 array's could simply be mounted. (with a 2 disk raid10,=20
> from what I understand, atleast 1 disk may be mountable?)

No.  That only works with the 'near' layout.  You used an 'offset' layout.
So if the chunks of data are 'A B C D E F G H', then the first disk contains
 A B C D E F G H
but the second disk contains
 B A D C F E H G
so you could mount sda6 if you added an offset with losetup or similar, but
not sdb6.

>=20
> >
> > when you have created the array, check that the 'Data Offset' is still
> > correct, then if it is "fsck -n" the array to ensure everything looks g=
ood.
> > Then you should be back in business.
> I should then be able to compare it to md1/sda5 and /dev/sdb5. Since md1=
=20
> and md2 where created with identical settings, they should be almost the=
=20
> same when comparing :)
>=20
>=20
> So to summarize, my array went foobar due to an old known bug and the=20
> only way to fix it is to recreate the array, leaving the actual data in=20
> place. The FS _should_ start after 2048 sectors on the disk.

Correct.

NeilBrown

>=20
> >
> > NeilBrown
> >
> >
> >
> >>
> >> Thanks in advance for reading this.
> >>
> >> Oliver
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> Thank you so far for your help!
> Oliver


--Sig_/eRakAZa_GReS5jP+yh5+WTe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8QFsjnsnt1WYoG5AQIdTg/+LrwCfeAqPbygEqU/17QrYWlczDa/ufIx
3/Q6IUvXN8mZf+aPshi+nnPkbzwz5WsNZGIb9hM/CJOadToOLnngOIY2hyoZvQrN
6lg+ksp+vKugqMujYrYEKRGc315+kXl907xDAOkD6dUSCr/NBFhoKfDM0fj6HnQ1
EXyDPhQY1f6UErvrjUp/pM+r2U7z8ycO/iyfj8mML0wsT34ekcLJTI+LzevCVDZh
X+GHdV2rtVot3T4C0ElN5SSLzarjWZMrgTl6ph9eMZXcam/IvJNJdT9cn+qfhDH2
4YMNGQpjA/tk/qGQcQ6vtW3+X8SfKMc4YAH8IESOthy+m4Ga+y7zlFbZeSVt7fcZ
EILJ11pu+8ltt8KpOBVhMu+YUXfiJnZ8kQ3V6meONmHY3SCIZXG/JBY7NUWIO60a
0E3xKJXpY/lTZYCoQBz4Cmq8pIXVYU2/W/lEvZdWH2mUN7ijYoki6PXH32L5t/td
XYXCAqwUk86PwmglG2yy3yh4fb6PaTvS0D3VDA7Prr6M4zFO45EqtwuAbwV9PHLO
sb1p/UcI8Ysi9LxHu+CeJ7i/dad0lpymc3p95MUzOHYbiXlyQIdb2QV8DnsZBcKW
iPLrkt9icPUDejbQlcmkfrPskJ3uevd50eBG1WPhBfVgSlxoNhmNd7r98IMBMRuA
g0DgvKa98dE=
=MxHT
-----END PGP SIGNATURE-----

--Sig_/eRakAZa_GReS5jP+yh5+WTe--
