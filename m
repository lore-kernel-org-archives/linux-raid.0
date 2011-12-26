From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: dirty chunks on bitmap not clearing (RAID1)
Date: Mon, 26 Dec 2011 20:07:16 +0200
Message-ID: <CAGRgLy7AtJf=3AkmU3nU4BMpfLqVVTVP5OmQe6YKZQBcdOeOeg@mail.gmail.com>
References: <CAGtzr3fC8bWLa4A5eRRgjHCtgfENdx4jtaKNb53dD7NX61nf7g@mail.gmail.com>
	<20110831173842.44ab5b03@notabene.brown>
	<alpine.DEB.2.00.1108311313550.27546@ubuntu>
	<20111223094815.6beaf413@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111223094815.6beaf413@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Chris Pearson <pearson.christopher.j@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

from the patch it looks like for raid levels with more than a single
redundancy, like 3-way raid1 or raid6, when there is an additional
missing drive, the bits will still not be cleared, correct?
This seems to be protected by !bitmap->mddev->degraded part. Because
these bits are still needed to rebuild future drive(s)?

Thanks,
  Alex.


On Fri, Dec 23, 2011 at 12:48 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 31 Aug 2011 13:23:01 -0500 (CDT) Chris Pearson
> <pearson.christopher.j@gmail.com> wrote:
>
>> I'm happy to apply a patch to whichever kernel you like, but the blo=
cks have since cleared, so I will try and reproduce it first.
>
> I have finally identified the problem here. =A0I was looking into a d=
ifferent
> but related problem and saw what was happening. =A0I don't know what =
I didn't
> notice it before.
>
> You can easily reproduce the problem by writing to an array with a bi=
tmap
> while a spare is recovering. Any bits that get set in the section tha=
t has
> already been recovered will stay set.
>
> This patch fixes it and will - with luck - be in 3.2.
>
> Thanks,
> NeilBrown
>
> From b9664495d2a884fbf7195e1abe4778cc6c3ae9b7 Mon Sep 17 00:00:00 200=
1
> From: NeilBrown <neilb@suse.de>
> Date: Fri, 23 Dec 2011 09:42:52 +1100
> Subject: [PATCH] md/bitmap: It is OK to clear bits during recovery.
>
> commit d0a4bb492772ce5c4bdfba3744a99ed6f6fb238f introduced a
> regression which is annoying but fairly harmless.
>
> When writing to an array that is undergoing recovery (a spare
> in being integrated into the array), writing to the array will
> set bits in the bitmap, but they will not be cleared when the
> write completes.
>
> For bits covering areas that have not been recovered yet this is not =
a
> problem as the recovery will clear the bits. =A0However bits set in
> already-recovered region will stay set and never be cleared.
> This doesn't risk data integrity. =A0The only negatives are:
> =A0- next time there is a crash, more resyncing than necessary will
> =A0 be done.
> =A0- the bitmap doesn't look clean, which is confusing.
>
> While an array is recovering we don't want to update the
> 'events_cleared' setting in the bitmap but we do still want to clear
> bits that have very recently been set - providing they were written t=
o
> the recovering device.
>
> So split those two needs - which previously both depended on 'success=
'
> and always clear the bit of the write went to all devices.
>
> Signed-off-by: NeilBrown <neilb@suse.de>
>
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index b690711..6d03774 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -1393,9 +1393,6 @@ void bitmap_endwrite(struct bitmap *bitmap, sec=
tor_t offset, unsigned long secto
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_read(&bitmap->=
behind_writes),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bitmap->mddev->bitmap=
_info.max_write_behind);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 if (bitmap->mddev->degraded)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Never clear bits or update events_cl=
eared when degraded */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 success =3D 0;
>
> =A0 =A0 =A0 =A0while (sectors) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sector_t blocks;
> @@ -1409,7 +1406,7 @@ void bitmap_endwrite(struct bitmap *bitmap, sec=
tor_t offset, unsigned long secto
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (success &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (success && !bitmap->mddev->degraded=
 &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bitmap->events_cleared < bitma=
p->mddev->events) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bitmap->events_cleared=
 =3D bitmap->mddev->events;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bitmap->need_sync =3D =
1;
>
>
>
>>
>> On Wed, 31 Aug 2011, NeilBrown wrote:
>>
>> >Date: Wed, 31 Aug 2011 17:38:42 +1000
>> >From: NeilBrown <neilb@suse.de>
>> >To: Chris Pearson <kermit4@gmail.com>
>> >Cc: linux-raid@vger.kernel.org
>> >Subject: Re: dirty chunks on bitmap not clearing (RAID1)
>> >
>> >On Mon, 29 Aug 2011 11:30:56 -0500 Chris Pearson <kermit4@gmail.com=
> wrote:
>> >
>> >> I have the same problem. =A03 chunks are always dirty.
>> >>
>> >> I'm using 2.6.38-8-generic and mdadm - v3.1.4 - 31st August 2010
>> >>
>> >> If that's not normal, then maybe what I've done differently is th=
at I
>> >> created the array, raid 1, with one live and one missing disk, th=
en
>> >> added the second one later after writing a lot of data.
>> >>
>> >> Also, though probably not the cause, I continued writing data whi=
le it
>> >> was syncing, and a couple times during the syncing, both drives
>> >> stopped responding and I had to power off.
>> >>
>> >> # cat /proc/mdstat
>> >> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [rai=
d5]
>> >> [raid4] [raid10]
>> >> md127 : active raid1 sdd1[0] sdc1[2]
>> >> =A0 =A0 =A0 1904568184 blocks super 1.2 [2/2] [UU]
>> >> =A0 =A0 =A0 bitmap: 3/15 pages [12KB], 65536KB chunk
>> >>
>> >> unused devices: <none>
>> >>
>> >> # mdadm -X /dev/sd[dc]1
>> >> =A0 =A0 =A0 =A0 Filename : /dev/sdc1
>> >> =A0 =A0 =A0 =A0 =A0 =A0Magic : 6d746962
>> >> =A0 =A0 =A0 =A0 =A0Version : 4
>> >> =A0 =A0 =A0 =A0 =A0 =A0 UUID : 43761dc5:4383cf0f:41ef2dab:43e6d74=
e
>> >> =A0 =A0 =A0 =A0 =A0 Events : 40013
>> >> =A0 Events Cleared : 40013
>> >> =A0 =A0 =A0 =A0 =A0 =A0State : OK
>> >> =A0 =A0 =A0 =A0Chunksize : 64 MB
>> >> =A0 =A0 =A0 =A0 =A0 Daemon : 5s flush period
>> >> =A0 =A0 =A0 Write Mode : Allow write behind, max 256
>> >> =A0 =A0 =A0 =A0Sync Size : 1904568184 (1816.34 GiB 1950.28 GB)
>> >> =A0 =A0 =A0 =A0 =A0 Bitmap : 29062 bits (chunks), 3 dirty (0.0%)
>> >> =A0 =A0 =A0 =A0 Filename : /dev/sdd1
>> >> =A0 =A0 =A0 =A0 =A0 =A0Magic : 6d746962
>> >> =A0 =A0 =A0 =A0 =A0Version : 4
>> >> =A0 =A0 =A0 =A0 =A0 =A0 UUID : 43761dc5:4383cf0f:41ef2dab:43e6d74=
e
>> >> =A0 =A0 =A0 =A0 =A0 Events : 40013
>> >> =A0 Events Cleared : 40013
>> >> =A0 =A0 =A0 =A0 =A0 =A0State : OK
>> >> =A0 =A0 =A0 =A0Chunksize : 64 MB
>> >> =A0 =A0 =A0 =A0 =A0 Daemon : 5s flush period
>> >> =A0 =A0 =A0 Write Mode : Allow write behind, max 256
>> >> =A0 =A0 =A0 =A0Sync Size : 1904568184 (1816.34 GiB 1950.28 GB)
>> >> =A0 =A0 =A0 =A0 =A0 Bitmap : 29062 bits (chunks), 3 dirty (0.0%)
>> >
>> >I cannot see how this would be happening. =A0If any bits are set, t=
hen they
>> >will be cleared after 5 seconds, and then 5 seconds later the block=
 holding
>> >the bits will be written out so that they will appear on disk to be=
 cleared.
>> >
>> >I assume that if you write to the array, the 'dirty' count increase=
s, but
>> >always goes back to three?
>> >
>> >And if you stop the array and start it again, the '3' stays there?
>> >
>> >If I sent you a patch to add some tracing information would you be =
able to
>> >compile a new kernel with that patch applied and see what it says?
>> >
>> >Thanks,
>> >
>> >NeilBrown
>> >
>> >
>> >>
>> >>
>> >> Quoting NeilBrown <neilb@suse.de>:
>> >>
>> >> > On Thu, October 15, 2009 9:39 am, aristizb@ualberta.ca wrote:
>> >> >> Hello,
>> >> >>
>> >> >> I have a RAID1 with 2 LVM disks and I am running into a strang=
e
>> >> >> situation where having the 2 disks connected to the array the =
bitmap
>> >> >> never clears the dirty chunks.
>> >> >
>> >> > That shouldn't happen...
>> >> > What versions of mdadm and the Linux kernel are you using?
>> >> >
>> >> > NeilBrown
>> >> >
>> >> >>
>> >> >> I am assuming also that when a RAID1 is in write-through mode,=
 the
>> >> >> bitmap =A0indicates that all the data has made it to all the d=
isks if
>> >> >> there are no dirty chunks using mdadm --examine-bitmap.
>> >> >>
>> >> >> The output of cat /proc/mdstat is:
>> >> >>
>> >> >> md2060 : active raid1 dm-5[1] dm-6[0]
>> >> >> =A0 =A0 =A0 =A02252736 blocks [2/2] [UU]
>> >> >> =A0 =A0 =A0 =A0bitmap: 1/275 pages [12KB], 4KB chunk, file: /t=
mp/md2060bm
>> >> >>
>> >> >>
>> >> >> The output of mdadm --examine-bitmap /tmp/md2060bm is:
>> >> >>
>> >> >> Filename : md2060bm
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 Magic : 6d746962
>> >> >> =A0 =A0 =A0 =A0 =A0 Version : 4
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0UUID : ad5fb74c:bb1c654a:087b2595:8=
a5d04a9
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0Events : 12
>> >> >> =A0 =A0Events Cleared : 12
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 State : OK
>> >> >> =A0 =A0 =A0 =A0 Chunksize : 4 KB
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0Daemon : 5s flush period
>> >> >> =A0 =A0 =A0 =A0Write Mode : Normal
>> >> >> =A0 =A0 =A0 =A0 Sync Size : 2252736 (2.15 GiB 2.31 GB)
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0Bitmap : 563184 bits (chunks), 3 dirty =
(0.0%)
>> >> >>
>> >> >>
>> >> >> Having the array under no IO, I waited 30 minutes but the dirt=
y data
>> >> >> never gets clear from the bitmap, so I presume =A0the disks ar=
e not in
>> >> >> sync; but after I ran a block by block comparison of the two d=
evices I
>> >> >> found that they are equal.
>> >> >>
>> >> >> The superblocks and the external bitmap tell me that all the e=
vents
>> >> >> are cleared, so I am confused on why the bitmap never goes to =
0 dirty
>> >> >> chunks.
>> >> >>
>> >> >> How can I tell if the disks are in sync?
>> >> >>
>> >> >>
>> >> >> Thank you in advance for any help
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> >
>> >
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
