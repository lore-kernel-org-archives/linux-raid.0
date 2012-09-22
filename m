From: "mirovis" <mirovis@inet.hr>
Subject: Re: Shouldn't --zero-superblock reset the UUID?
Date: Sat, 22 Sep 2012 14:53:38 +0200
Message-ID: <505db4d2.3dc.3e7d.1665654674@inet.hr>
Reply-To: mirovis@inet.hr
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46rom: "mirovis" <mirovis@inet.hr>
To: linux-raid@vger.kernel.org
Subject: Re: Shouldn't --zero-superblock reset the UUID?
Date: Fri, 21 Sep 2012 22:29:04 +0200

----- Original Message Follows -----
> Almost the entire little thread of concern is half a page:
> http://marc.info/?l=3Dlinux-raid&m=3D129790712716243&w=3D2
>=20
> I'm reconstructing it from web, because wasn't subscribed then (Feb 2=
011).
>=20
>=20
> > hansbkk@gmail.com wrote:
> > > I've only seen this problem with RAID1, but perhaps it applies to=
 other levels.
> > >
> > > When adding a member partition to an array, the UUID of that part=
ition
> > > gets set to that of the array (and all the other members)
> > >
> > > However, when fail/remove/zero-superblock 'ing a member back out =
of
> > > the array, the UUID gets left behind, along with the label and fs
> > > type.
> > >
> > > Ideally the partition would be left in a state as if it never had=
 any
> > > filesystem at all on it, as when using dd /if=3Ddev/zero and a fr=
esh
> > > sfdisk.
> > >
> > > If this isn't possible, perhaps the zero-superblock option should
> > > trigger a reminder message to either zero the drive or re-format =
the
> > > partition?
> > >
> > >  =20
> > I recall reading on this list that zero-superblock only zero's the =
first=20
> > superblock that it finds. It may be necessary to run mdadm=20
> > zero-superblock several times to remove all superblocks that may be=
 on=20
> > the device from historical times.
> >=20
>=20
> The latest mdadm will zero all superblocks it can find.
>=20
> How I suspec the OP is actually talking about a 'filesystem' uuid rat=
her than
> a 'raid' uuid...  After all it is "along with the label and fs type".
>=20
> So: kansbkk: What makes you think the uuid is left behind?  Knowing t=
hat will
>   help know what uuid you are talking about.
>=20
> NeilBrown
>=20
> There.
> In the first place, thank you for giving the world such great program=
!
> Here's my woe, however. Pls. bear with me!
> I am struggling on system update matters (
> https://forums.gentoo.org/viewtopic-p-7146038.html#7145606 raid1/rai5=
 there too ).
> I made a fine raid1 /dev/md0 from /dev/sdb2 and /dev/sdc2 as boot pat=
ition but grub2 and initrd
> wouldn't properly work on it.
> So I did (from memory writing):
> # mdadm -S /dev/md0
> # mdadm --zero-superblock /dev/sdb2
> # mdadm --zero-superblock /dev/sdc2
> Still, after numerous reboots and many tries, those, the raid's uuid =
and the part uuids are still
> there, and I can not use /dev/sdb2 or /dev/sdc2 for boot partition be=
cause now I am still getting
> on them, upon grub2-mkconfig (pls find the line in forums.gentoo link=
 above):
> /usr/sbin/grub2-probe: warning: Couldn't find physical volume `(null)=
'. Some modules may be
> missing from core image..=20
> or something to that effect.
> Wait, I just explained it there in a sequence. Now search for more re=
cent
> ..Couldn't find physical volume `(null)'
> in the same forums' thread.
> Too many numerous tries I made on that grub2 on raid1 and than revert=
ed to plain partitions boot
> issue, to find now the configuration with the original uuids.
> But, the construction that blkid shows with my other raid devices, sa=
y:
> # blkid -c /dev/null | egrep 'sdb3|sdc3'
> /dev/sdb3: UUID=3D"bb6ad459-356a-4801-ad1f-7887fea0a4a5"
> UUID_SUB=3D"aa20fe15-5856-4ee5-8267-8b1d126e00e7" LABEL=3D"at8-g250-c=
:1"
TYPE=3D"linux_raid_member"=20
> /dev/sdc3: UUID=3D"bb6ad459-356a-4801-ad1f-7887fea0a4a5"
> UUID_SUB=3D"041a185c-91f6-49df-7024-d1ea9c7e09e5" LABEL=3D"at8-g250-c=
:1"
TYPE=3D"linux_raid_member"=20
> #
> which is on raid5 /dev/md1 device:
> # mdadm -D /dev/md1 | egrep 'sdb3|sdc3|UUID'
>            UUID : bb6ad459:356a4801:ad1f7887:fea0a4a5
>        0       8       19        0      active sync   /dev/sdb3
>        1       8       35        1      active sync   /dev/sdc3
> In the same fashion:
> cf771640-1e0f-4ddf-a0cd-10a191d86f75
> from blkid in the forums.gentoo is gotten from the not-killable, no w=
ay, can't kill that beast!,
> raid1 /dev/md0
> cf771640:1e0f4ddf:a0cd10a1:91d86f75
> How do I recover now plain partitions for me.
> I tried:
> mdadm --kill-subarray ...
> but can't quite figure how exactly to use that.
> I will be grateful for any insight to resolve this issue so I get my =
plain partitions back from
> these UUID that seem to be as sticky as Google cookies! No Libert=E9,=
 no Tails can run away from
> them! Or maybe...
> How do I kill these UUIDs? In general terms. Because I sure want to b=
e able to remake my boot
> raid1, or even raid5 partition when Grub2 learns to treat them!
> Thanks again in advance!
> Miroslav Rovis
> Pls. allow me to possible add a correction mail if I wrongly or uncle=
arly worded or mispasted some
> data. I am quite exhausted with this work on my hands.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
I may have gotten some numbers (and a bit of concept) a little wrong, a=
nd I can't even reconstruct
how it really was.
But raid1 did retain some uuids even after stopping it and zero-superbl=
ock'ing its component devices
(sdb2 and sdc2).
The answer how to kill the zombie uuids is, boot partitions are general=
ly small, the files can be
easily properly backed up by programs like rsync, and, the answer I fou=
nd where it was supposed to
be found, in `man mdadm`.
Where it reads, talking about versions of mdadm:
"...store the superblock at different locations on the device..."=20
So:
# cat /dev/zero | dd of=3D/dev/sdb2
and
# cat /dev/zero | dd of=3D/dev/sdc2
(!! warning to readers not sufficiently knowledgeable: Know what you're=
 doing, these command wipe
the partitions clean!)
got my former raid1 partitions finally free from unkillable zombie uuid=
's.
Now blkid finally gets:
#  blkid|egrep 'sdb2|sdc2'
/dev/sdb2: UUID=3D"2c591283-6822-4399-9e97-048626681f46" TYPE=3D"ext2"=20
/dev/sdc2: UUID=3D"1df80e60-d9f4-4f0a-b098-8e0607d6fb78" TYPE=3D"ext2"=20
#
And that's fair enough.
Hope this helps others who get into this kind of trouble (as rad is now=
adays increasingly used by
common non-expert users like me)!
Cheers!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
