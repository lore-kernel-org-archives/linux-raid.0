From: "mirovis" <mirovis@inet.hr>
Subject: Re: Shouldn't --zero-superblock reset the UUID?
Date: Fri, 21 Sep 2012 22:29:04 +0200
Message-ID: <505cce10.2cd.1bad.1591021886@inet.hr>
Reply-To: mirovis@inet.hr
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Almost the entire little thread of concern is half a page:
http://marc.info/?l=3Dlinux-raid&m=3D129790712716243&w=3D2

I'm reconstructing it from web, because wasn't subscribed then (Feb 201=
1).


> hansbkk@gmail.com wrote:
> > I've only seen this problem with RAID1, but perhaps it applies to o=
ther levels.
> >
> > When adding a member partition to an array, the UUID of that partit=
ion
> > gets set to that of the array (and all the other members)
> >
> > However, when fail/remove/zero-superblock 'ing a member back out of
> > the array, the UUID gets left behind, along with the label and fs
> > type.
> >
> > Ideally the partition would be left in a state as if it never had a=
ny
> > filesystem at all on it, as when using dd /if=3Ddev/zero and a fres=
h
> > sfdisk.
> >
> > If this isn't possible, perhaps the zero-superblock option should
> > trigger a reminder message to either zero the drive or re-format th=
e
> > partition?
> >
> >  =20
> I recall reading on this list that zero-superblock only zero's the fi=
rst=20
> superblock that it finds. It may be necessary to run mdadm=20
> zero-superblock several times to remove all superblocks that may be o=
n=20
> the device from historical times.
>=20

The latest mdadm will zero all superblocks it can find.

How I suspec the OP is actually talking about a 'filesystem' uuid rathe=
r than
a 'raid' uuid...  After all it is "along with the label and fs type".

So: kansbkk: What makes you think the uuid is left behind?  Knowing tha=
t will
  help know what uuid you are talking about.

NeilBrown

There.
In the first place, thank you for giving the world such great program!
Here's my woe, however. Pls. bear with me!
I am struggling on system update matters (
https://forums.gentoo.org/viewtopic-p-7146038.html#7145606 raid1/rai5 t=
here too ).
I made a fine raid1 /dev/md0 from /dev/sdb2 and /dev/sdc2 as boot patit=
ion but grub2 and initrd
wouldn't properly work on it.
So I did (from memory writing):
# mdadm -S /dev/md0
# mdadm --zero-superblock /dev/sdb2
# mdadm --zero-superblock /dev/sdc2
Still, after numerous reboots and many tries, those, the raid's uuid an=
d the part uuids are still
there, and I can not use /dev/sdb2 or /dev/sdc2 for boot partition beca=
use now I am still getting on
them, upon grub2-mkconfig (pls find the line in forums.gentoo link abov=
e):
/usr/sbin/grub2-probe: warning: Couldn't find physical volume `(null)'.=
 Some modules may be missing
from core image..=20
or something to that effect.
Wait, I just explained it there in a sequence. Now search for more rece=
nt
=2E..Couldn't find physical volume `(null)'
in the same forums' thread.
Too many numerous tries I made on that grub2 on raid1 and than reverted=
 to plain partitions boot
issue, to find now the configuration with the original uuids.
But, the construction that blkid shows with my other raid devices, say:
# blkid -c /dev/null | egrep 'sdb3|sdc3'
/dev/sdb3: UUID=3D"bb6ad459-356a-4801-ad1f-7887fea0a4a5"
UUID_SUB=3D"aa20fe15-5856-4ee5-8267-8b1d126e00e7" LABEL=3D"at8-g250-c:1=
" TYPE=3D"linux_raid_member"=20
/dev/sdc3: UUID=3D"bb6ad459-356a-4801-ad1f-7887fea0a4a5"
UUID_SUB=3D"041a185c-91f6-49df-7024-d1ea9c7e09e5" LABEL=3D"at8-g250-c:1=
" TYPE=3D"linux_raid_member"=20
#
which is on raid5 /dev/md1 device:
# mdadm -D /dev/md1 | egrep 'sdb3|sdc3|UUID'
           UUID : bb6ad459:356a4801:ad1f7887:fea0a4a5
       0       8       19        0      active sync   /dev/sdb3
       1       8       35        1      active sync   /dev/sdc3
In the same fashion:
cf771640-1e0f-4ddf-a0cd-10a191d86f75
from blkid in the forums.gentoo is gotten from the not-killable, no way=
, can't kill that beast!,
raid1 /dev/md0
cf771640:1e0f4ddf:a0cd10a1:91d86f75
How do I recover now plain partitions for me.
I tried:
mdadm --kill-subarray ...
but can't quite figure how exactly to use that.
I will be grateful for any insight to resolve this issue so I get my pl=
ain partitions back from
these UUID that seem to be as sticky as Google cookies! No Libert=E9, n=
o Tails can run away from
them! Or maybe...
How do I kill these UUIDs? In general terms. Because I sure want to be =
able to remake my boot raid1,
or even raid5 partition when Grub2 learns to treat them!
Thanks again in advance!
Miroslav Rovis
Pls. allow me to possible add a correction mail if I wrongly or unclear=
ly worded or mispasted some
data. I am quite exhausted with this work on my hands.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
