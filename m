From: piergiorgio.sartor@nexgo.de
Subject: Aw: Roadmap for md/raid ???
Date: Fri, 19 Dec 2008 10:01:33 +0100 (CET)
Message-ID: <32298247.1229677293053.JavaMail.ngmail@webmail11.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

you forgot the "clever RAID-6 check" :-)

Since we are at it, I would like to propose a "concept",
the idea itself is not completely clear in my mind, but
maybe you could find your way in it (or not).

Since it seems bitmaps are so beloved, I would like to
propose the possibility to provide the RAID with an
external bitmap.
=46or what? You'll ask...

To make the array a bit more filesystem aware.

Let's assume we have an md device which is 20%
full. Of course the md itself does not know this,
only the FS knows it.

In case of HD failure and resync, the md will start
the operations from the beginning to the end.
On the other hand,  it would be wise to sync first the
used blocks (20% in the example) and later the others,
if necessary at all.
Because the array will get faster to a "safe state".

In order to do this, some filesystem tool could
provide a "priority map", telling the array which
blocks should be synchronized first and which last.
Probably there is more, like set the md read-only,
not sure about that.

So, from the md point of view, there will be a file,
with some bitmap information, and it will start
a resync accordingly to that bitmap.

How does it sound? Does it make sense at all?

Hope this could give some ideas to improve the
already wonderful md subsystems!

=46or the road map you proposed, I've no major
comments, just my personal priorities would be
raid5->raid6 conversion and hot-device-replace.

Thanks,

bye,

--=20

pg

----- Original Nachricht ----
Von:     Neil Brown <neilb@suse.de>
An:      linux-raid@vger.kernel.org
Datum:   19.12.2008 05:10
Betreff: Roadmap for md/raid ???

>=20
>=20
> Not really a roadmap, more a few tourist attractions that you might
> see on the way if you stick around (and if I stick around)...
>=20
> Comments welcome.
>=20
> NeilBrown
>=20
>=20
> - Bad block list
>   The idea here is to maintain and store on each device a list of
>   blocks that are known to be 'bad'.  This effectively allows us to
>   fail a single block rather than a whole device when we get a media
>   write error.  Of course if updating the bad-block-list gives an
>   error we then have to fail the device.
>=20
>   We would also record a bad block if we get a read error on a degrad=
ed
>   array.  This would e.g. allow recovery for a degraded raid1 where t=
he
>   sole remaining device has a bad block.
>=20
>   An array could have multiple errors on different devices and just
>   those stripes would be considered to be "degraded".  As long a no
>   single stripe had too many bad blocks, the data would still be safe=
=2E
>   Naturally as soon as you get one bad block, the array becomes
>   susceptible to data loss on a single device failure, so it wouldn't
>   be advisable to run with non-empty badblock lists for an extended
>   length of time,  However it might provide breathing space until
>   drive replacement can be achieved.
>=20
> - hot-device-replace
>   This is probably the most asked for feature of late.  It would allo=
w
>   a device to be 'recovered' while the original was still in service.=
=20
>   So instead of failing out a device and adding a spare, you can add
>   the spare, build the data onto it, then fail out the device.
>=20
>   This meshes well with the bad block list.  When we find a bad block=
,
>   we start a hot-replace onto a spare (if one exists).  If sleeping
>   bad blocks are discovered during the hot-replace process, we don't
>   lose the data unless we find two bad blocks in the same stripe.
>   And then we just lose data in that stripe.
>=20
>   Recording in the metadata that a hot-replace was happening might be
>   a little tricky, so it could be that if you reboot in the middle,
>   you would have to restart from the beginning.  Similarly there woul=
d
>   be no 'intent' bitmap involved for this resync.
>=20
>   Each personality would have to implement much of this independently=
,
>   effectively providing a mini raid1 implementation.  It would be ver=
y
>   minimal without e.g. read balancing or write-behind etc.
>=20
>   There would be no point implementing this in raid1.  Just
>   raid456 and raid10.
>   It could conceivably make sense for raid0 and linear, but that is
>   very unlikely to be implemented.
>=20
> - split-mirror
>   This is really a function of mdadm rather than md.  It is already
>   quite possible to break a mirror into two separate single-device
>   arrays.  However it is a sufficiently common operation that it is
>   probably making it very easy to do with mdadm.
>   I'm thinking something like
>       mdadm --create /dev/md/new --split /dev/md/old
>=20
>   will create a new raid1 by taking one device off /dev/md/old (which
>   must be a raid1) and making an array with exactly the right metadat=
a
>   and size.
>=20
> - raid5->raid6 conversion.
>    This is also a fairly commonly asked for feature.
>    The first step would be to define a raid6 layout where the Q block
>    was not rotated around the devices but was always on the last
>    device.  Then we could change a raid5 to a singly-degraded raid6
>    without moving any data.
>=20
>    The next step would be to implement in-place restriping.=20
>    This involves=20
>       - freezing a section of the array (all IO blocks)
>       - copying the data out to a safe backup
>       - copying it back in with the new layout
>       - updating the metadata to indicate that the restripe has
>         progressed.
>       - repeat.
>=20
>    This would probably be quite slow but it would achieve the desired
>    result.=20
>=20
>    Once we have in-place restriping we could change chunksize as
>    well.
>=20
> - raid5 reduce number of devices.
>    We can currently restripe a raid5 (or 6) over a larger number of
>    devices but not over a smaller number of devices.  That means you
>    cannot undo an increase that you didn't want.
>=20
>    It might be nice to allow this to happen at the same time as
>    increasing --size (if the devices are big enough) to allow the
>    array to be restriped without changing the available space.
>=20
> - cluster raid1
>    Allow a raid1 to be assembled on multiple hosts that share some
>    drives, so a cluster filesystem (e.g. ocfs2) can be run over it.
>    It requires co-ordination to handle failure events and
>    resync/recovery.  Most of this would probably be done in userspace=
=2E
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

Jetzt komfortabel bei Arcor-Digital TV einsteigen: Mehr Happy Ends, meh=
r Herzschmerz, mehr Fernsehen! Erleben Sie 50 digitale TV Programme und=
 optional 60 Pay TV Sender, einen elektronischen Programmf=FChrer mit M=
ovie Star Bewertungen von TV Movie. Au=DFerdem, aktuelle Filmhits und s=
pannende Dokus in der Arcor-Videothek. Infos unter www.arcor.de/tv
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
