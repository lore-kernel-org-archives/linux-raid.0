From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: Question about mdadm commit d6508f0cfb60edf07b36f1532eae4d9cddf7178b
 "be more careful about add attempts"
Date: Tue, 1 Nov 2011 18:26:14 +0200
Message-ID: <CAGRgLy5zkfy2bfrJnC_eKQ_-VAcdaKCyeSounjZ3FjBb83T0mQ@mail.gmail.com>
References: <CAGRgLy6Q9Qq8TeykEseXX45goi4kS8wOwrUOo1+tNZyxdyFHkw@mail.gmail.com>
	<20111027085125.747691a9@notabene.brown>
	<CAGRgLy7biNy4Tj9wXhBosjC4QNy7dXC2aoimu7ezGqdL82Axxg@mail.gmail.com>
	<20111031101649.657a1ab3@notabene.brown>
	<CAGRgLy7G_M=FtdZ9mmDvxxN52+AF+L=0+OaEP=dK7Z+Z5YBYKw@mail.gmail.com>
	<20111031201933.314d130f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111031201933.314d130f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,
I hope you don't find my questions too pesky; I hope as time goes, I
will be able to contribute as well, and not just ask for information.

What you suggested works great, but only if the drive already has a
valid superblock. This is according to md_import_device(), which calls
super_1_load(). Although it calls it with NULL refdev, but it still
performs basic validity checks of the superblock. So it is needed to
have functionality of write_init_super() of mdadm (perhaps can be an
mdadm operation, not sure how dangerous this is to expose such
functionality).

Another question I was digging for, is to find a spot where kernel
determines whether it is going to do a bitmap-based reconstruction or
a full reconstruction. Can you verify that I found it correctly, or I
am way off?

In super_1_validate():
		if (ev1 < mddev->bitmap->events_cleared)
			return 0;
This means that the array bitmap was cleared after the drive was
detached, so we bail right out, and do not set rdev->raid_disk, and
leave all flags off. In that case, eventually, we will need full
reconstruction.
Otherwise, after we decide that this drive is an active device (not
failed or spare):
if ((le32_to_cpu(sb->feature_map) &  MD_FEATURE_RECOVERY_OFFSET))
    rdev->recovery_offset =3D le64_to_cpu(sb->recovery_offset);
else
    set_bit(In_sync, &rdev->flags);
Here we might or might not set the In_sync flag.

Then in slot_store() and in add_new_disk(), we set the important flag
for that matter:
if (test_bit(In_sync, &rdev->flags))
    rdev->saved_raid_disk =3D slot;
else
    rdev->saved_raid_disk =3D -1;

And later, in hot_add_disk (like raid5_add_disk, raid1_add_disk), we
check this flag and set/not set the fullsync flag. And in
raid1_add_disk, like you said, the slot doesn't matter, any valid
saved_raid_disk is good.

Is this correct? If yes, then in the sequence you suggested, we will
always do full reconstruction. Because new_dev_store() and
slot_store() sequence do not call validate_super(), so In_sync is
never set, so saved_raid_disk remains -1. This is perfectly fine.

Thanks!
Alex.












On Mon, Oct 31, 2011 at 11:19 AM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 31 Oct 2011 10:57:25 +0200 Alexander Lyakas <alex.bolshoy@gma=
il.com>
> wrote:
>
>> Thank you for the clarification, Neil!
>>
>> I was looking at raid_disk, because I am trying to see whether it is
>> possible to control into which raid slot a disk is being added (not
>> re-added).
>>
>> Let's say we had raid6 with 4 drives (a,b,c,d), and drives c and d
>> failed.Now let's say, that it is decided to replace drive d with a n=
ew
>> drive e (--add for drive e). Then it's possible that drive e will ta=
ke
>> the raid slot of drive c. So later, if we want to bring back drive c
>> into the array, it will have to go into a different slot, resulting =
in
>> a full reconstruction, not bitmap-based reconstruction. While if we
>> would have re-added drive c first, it would have done a bitmap-based
>> reconstruction, so only the e drive would have required a full
>> reconstruction.
>>
>> So do you think it makes sense to somehow (perhaps through
>> disc.raid_disk) instruct the kernel into which slot to add a new
>> drive?
>
> You should be able to do that via sysfs.
> echo frozen > sync_action
> echo $major:$minor > new_dev
> echo $slot > dev-$DEVNAME/slot
> echo idle > sync_action
>
> something like that.
>
> Seems and odd sort of scenario though.
>
> Note that with RAID1 this is not an issue. =A0A re-added drive can ta=
ke any
> position in a RAID1 array - it doesn't have to be the same one.
>
> NeilBrown
>
>
>
>>
>> Thanks,
>> =A0 Alex.
>>
>>
>>
>>
>>
>> On Mon, Oct 31, 2011 at 1:16 AM, NeilBrown <neilb@suse.de> wrote:
>> > On Thu, 27 Oct 2011 11:10:54 +0200 Alexander Lyakas <alex.bolshoy@=
gmail.com>
>> > wrote:
>> >
>> >> Hello Neil,
>> >> it makes perfect sense not to turn a device into a spare inadvert=
ently.
>> >>
>> >> However, with mdadm 3.1.4 under gdb, I tried the following:
>> >> - I had a raid6 with 4 drives (sda/b/c/d), their "desc_nr" in the
>> >> kernel were respectively (according to GET_DISK_INFO): 0,1,2,3.
>> >> - I failed the two last drives (c & d) via mdadm and removed them=
 from the array
>> >> - I wiped the superblock on drive d.
>> >> - I added the drive d back to the array
>> >> So now the array had the following setup:
>> >> sda: disc_nr=3D0, raid_disk=3D0
>> >> sdb: disc_nr=3D1, raid_disk=3D1
>> >> sdd: disc_nr=3D4, raid_disk=3D2
>> >> So sdd was added to the array into slot 2, and received disc_nr=3D=
4
>> >>
>> >> - Now I asked to re-add drive sdc back to array. In gdb I followe=
d the
>> >> re-add flow, to the place where it fills the mdu_disk_info_t stru=
cture
>> >> from the superblock read from sdc. It put there the following con=
tent:
>> >> disc.major =3D ...
>> >> disc.minor =3D ...
>> >> disc.number =3D 2
>> >> disc.raid_disk =3D 2 (because previously this drive was in slot 2=
)
>> >> disc.state =3D ...
>> >>
>> >> Now in gdb I changed disc.number to 4 (to match the desc_nr of sd=
d).
>> >> And then issued ADD_NEW_DISK. It succeeded, and the sdc drive rec=
eived
>> >> disc_nr=3D2 (while it was asking for 4). Of course, it could not =
have
>> >> received the same raid_disk, because this raid_disk was already
>> >> occupied by sdd. So it was added as a spare.
>> >>
>> >> But you are saying:
>> >> > If a device already exists with the same disk.number, a re-add =
cannot
>> >> > succeed, so mdadm doesn't even try.
>> >> while in my case it succeeded (while it actually did "add" and no=
t "re-add").
>> >
>> > We seem to be using word differently.
>> > If I ask mdadm to do a "re-add" and it does an "add", then I consi=
der that to
>> > be "failure", however you seem to consider it to be a "success".
>> >
>> > That seems to be the source of confusion.
>> >
>> >
>> >>
>> >> That's why I was thinking it makes more sense to check disc.raid_=
disk
>> >> and not disc.number in this check. Since disc.number is not the
>> >> drive's role within the array (right?), it is simply a position o=
f the
>> >> drive in the list of all drives.
>> >> So if you check raid_disk, and see that this raid slot is already
>> >> occupied, then, naturally, the drive will be converted to spare, =
which
>> >> we want to avoid.
>> >
>> > It may well be appropriate to check raid_disk as well, yes. =A0It =
isn't so easy
>> > though which is maybe why I didn't.
>> >
>> > With 0.90 metadata, the disc.number is the same as disc.raid_disk =
for active
>> > devices. =A0That might be another reason for the code being the wa=
y that it is.
>> >
>> > Thanks,
>> > NeilBrown
>> >
>> >
>> >
>> >>
>> >> And the enough_fd() check protects us from adding a spare to a fa=
iled
>> >> array (like you mentioned to me previously).
>> >>
>> >> What am I missing?
>> >>
>> >> Thanks,
>> >> =A0 Alex.
>> >>
>> >>
>> >>
>> >>
>> >>
>> >>
>> >>
>> >> On Wed, Oct 26, 2011 at 11:51 PM, NeilBrown <neilb@suse.de> wrote=
:
>> >> > On Wed, 26 Oct 2011 19:02:37 +0200 Alexander Lyakas <alex.bolsh=
oy@gmail.com>
>> >> > wrote:
>> >> >
>> >> >> Greetings everybody,
>> >> >> I have a question about the following code in Manage.c:Manage_=
subdevs()
>> >> >>
>> >> >> disc.number =3D mdi.disk.number;
>> >> >> if (ioctl(fd, GET_DISK_INFO, &disc) !=3D 0
>> >> >> =A0 =A0 || disc.major !=3D 0 || disc.minor !=3D 0
>> >> >> =A0 =A0 || !enough_fd(fd))
>> >> >> =A0 =A0 goto skip_re_add;
>> >> >>
>> >> >> I do not underatand why the checks: disc.major !=3D 0 || disc.=
minor !=3D 0
>> >> >> are required. This basically means that the kernel already has=
 an
>> >> >> rdev->desc_nr equal to disc.number. But why fail the re-add pr=
ocedure?
>> >> >>
>> >> >> Let's say that enough_fd() returns true, and we go ahead an is=
sue
>> >> >> ioctl(ADD_NEW_DISK). In this case, according to the kernel cod=
e in
>> >> >> add_new_disk(), it will not even look at info->number. It will
>> >> >> initialize rdev->desc_nr to -1, and will allocate a free desc_=
nr for
>> >> >> the rdev later.
>> >> >>
>> >> >> Doing this with mdadm 3.1.4, where this check is not present, =
actually
>> >> >> succeeds. I understand that this code was added for cases when
>> >> >> enough_fd() returns false, which sounds perfectly fine to prot=
ect
>> >> >> from.
>> >> >>
>> >> >> I was thinking that this code should actually check something =
like:
>> >> >> if (ioctl(fd, GET_DISK_INFO, &disc) !=3D 0
>> >> >> =A0 =A0 || disk.raid_disk !=3D mdi.disk.raid_disk
>> >> >> =A0 =A0 || !enough_fd(fd))
>> >> >> =A0 =A0 goto skip_re_add;
>> >> >>
>> >> >> That is to check that the slot that was being occupied by the =
drive we
>> >> >> are trying to add, is already occupied by a different drive (n=
eed also
>> >> >> to cover cases of raid_disk <0, raid_disk >=3D raid_disks etc.=
=2E.) and
>> >> >> not the desc_nr, which does not have any persistent meaning.
>> >> >>
>> >> >> Perhaps there are some compatibility issues with old kernels? =
Or
>> >> >> special considerations for ... containers? non-persistent arra=
ys?
>> >> >
>> >> > The point of this code is to make --re-add fail unless mdadm is=
 certain that
>> >> > the kernel will accept the re-add, rather than turn the device =
into a spare.
>> >> >
>> >> > If a device already exists with the same disk.number, a re-add =
cannot
>> >> > succeed, so mdadm doesn't even try.
>> >> >
>> >> > When you say in 3.1.4 it "actually succeeds" - what succeeds? =A0=
Does it re-add
>> >> > the device to the array, or does it turn the device into a spar=
e?
>> >> > I particularly do not want --re-add to turn a device into a spa=
re because
>> >> > people sometimes use it in cases where it cannot work, their de=
vice gets
>> >> > turned into a spare, and they lose information that could have =
been used to
>> >> > reconstruct the array.
>> >> >
>> >> > That that make sense?
>> >> >
>> >> > NeilBrown
>> >> >
>> >> >
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> >
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
