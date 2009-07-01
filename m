From: Kris Hofmans <kris.hofmans@gmail.com>
Subject: Re: series of unfortunate events on a raid5 array
Date: Wed, 1 Jul 2009 14:30:14 +0200
Message-ID: <632ddf2c0907010530vf1147e2geddd511238efb4e@mail.gmail.com>
References: <632ddf2c0907010324v667faf1ar8f889e120a989cff@mail.gmail.com>
	<19019.19073.778890.740801@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19019.19073.778890.740801@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Thanks for your feedback, good thing is I learned a lot from this
experience ... not compensate 4TB of dataloss "lot", but I'm trying to
look at this from a positive side :)

I was thinking of doing something like this as an extreme recovery
strategy, a sort of last insane attempt to retrieve some data:

Repartition all 6 drives to have partitions starting at 25-30gb till
the end (so skipping the piece that was touched by my lousy attempts
of recovery)

Building the array as:
mdadm --create --verbose /dev/md0 --level=3D5 --raid-devices=3D6 /dev/s=
da1
/dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

Creating largest possible partition and fschk it in the hope that it
will be able to restore the previous files on there?

this has the advantage that the part that I am using will be valid for
all 6 disks anyway, only the partition and the fs will have a bad
piece cut off, I know I will loose at least 150gig's (probably more)

Not all data is crucial, If I can get the last data added (+-500gigs)
(I assume it's at the back of the disk) I could still get out of this
a happy man.

So it's basically what you are suggesting, only I won't cling on to
those first 20gigs of each disk, I will just try to ignore them?

Kind regards,
Kris

On Wed, Jul 1, 2009 at 1:37 PM, Neil Brown<neilb@suse.de> wrote:
> On Wednesday July 1, kris.hofmans@gmail.com wrote:
>> Hello,
>>
>> It's a long story to tell, but I don't want to omit anything that
>> might be important as to the recovery strategy.
>>
>> I had a 6 1TB disk raid 5 array. One disk started failing, I put the
>> failing one as faulty and added a replacement disk. The rebuild went
>> fine!
>
> Good..
>
>>
>> Since I already had to buy a new disk I decided what the heck, lets
>> buy some extra disks to grow the array with 2 extra disks.
>
> Sounds fair.
>
>>
>> So on monday I started the grow operation adding the 2 disks at the
>> same time (not smart, I know that now) and saw in /proc/mdstat that =
it
>> was very slow (5MB/sec) so I checked dmesg and a disk was giving
>> errors. The grow operation was not completed for more than 0.5%
>
> Two at once shouldn't normally be a problem. =C2=A0Of course if a new=
 drive
> has errors, that's going to cause problems whatever you do.
>
>
>>
>> I saw it was on ata7 so I assumed it was /dev/sdh, and marked it as
>> faulty, hoping to speed up the resync. But then suddenly also /dev/s=
de
>> was marked as faulty, I guess that ata 7 was not /dev/sdh. The resul=
t
>> was that it could not do anything anymore!
>
> That is very sad.
> It certainly is hard to link names like 'ata%d' with '/dev/sd%c'.
> You would think there would be something in /sys, but I cannot find
> it.
>
>
>>
>> After a reboot it did not recognire the md0 anymore.
>>
>> All I want at this point is to have the array back like this:
>>
>> sdd1[6] sda1[0] sdf1[5] sde1[4] sdc1[2] sdb1[1]
>>
>> since that was a working configuration, I don't know if that is
>> possible since it was growing, disks put as faulty ... but in the en=
d,
>> I don't think that much on the hd's moved around, or is that just
>> whishfull thinking on my part?
>
> Probably wishful thinking. =C2=A00.5% of 4 terabytes is about 20 giga=
bytes.
>
>>
>> After reading things yesterday I performed an attempt to zero out al=
l
>> the superblocks on those 6 disks. And then recreate the original
>> array, I am unsure if I do:
>
> Ouch. =C2=A0That was a mistake. =C2=A0You will have lost a very impor=
tant piece
> of information.
> zeroing and recreating can often work. =C2=A0But you were in the midd=
le of
> restriping the array and it is not possible to create an array that i=
s
> in the middle of a restripe.
>
> The first 20Gig (or so) is striped over 8 drives. =C2=A0The remainder=
 is
> striped over 6 drives. =C2=A0Piecing that back together will be far f=
rom
> trivial. =C2=A0In fact, from reading further, I think it will be impo=
ssible.
>
> If you still had the output of --examine of one of the devices before
> you zeroed the metadata, that could have been useful, but probably no=
t
> helpful enough.
>
>
>>
>> mdadm --create --verbose /dev/md0 --level=3D5 --raid-devices=3D6 /de=
v/sda1
>> /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
>>
>> This is the original command I used to create it, but I saw that sdd=
1
>> the replaced disk was [6] after the rebuild ...
>> so do I create it like this:
>>
>> mdadm --create --verbose /dev/md0 --level=3D5 --raid-devices=3D6 /de=
v/sda1
>> /dev/sdb1 /dev/sdc1 /dev/sde1 /dev/sdf1 /dev/sdd1
>>
>
> The 'RaidDevice' column in the --detail output is what you should go
> by, so the first of these is more correct, but not sufficient.
>
> What you would have needed to do is:
> =C2=A0- create the array as an 8-device array.
> =C2=A0- copy the first 20Gig (or so) to somewhere safe
> =C2=A0- destroy and create the array as a 6-device array (using the
> =C2=A0 =C2=A0first of the above commands, but with --assume-clean)
> =C2=A0- copy exactly the right amount of the saved data back on to th=
e
> =C2=A0 =C2=A0array
> =C2=A0- hope that worked.
>
>> ?
>> I actually tried both, zero'ing out the superblocks in between, and
>> tried to do a mount -o ro /dev/md0 /mnt/storage
>> this only gives me an
>
> That was the final mistake. =C2=A0When you created the array like tha=
t a
> resync will have started. =C2=A0A resync over 6 drives of data that w=
as
> really spread over 8 drives. =C2=A0This will have corrupted 1/6 of th=
e data
> in those early blocks - maybe slightly less.
>
> When using --create to restore an existing array, you must always
> either
> =C2=A0- make sure the created array is fully degraded with a suitable
> =C2=A0 =C2=A0number of 'missing' devices, or
> =C2=A0- use --assume-clean to disable the resync.
>
> I'm sorry, but I think your data is gone.
>
>>
>> unknown partition table
>>
>> error ...
>> -----
>> The only thing I can think of now as a next step would be to
>> repartition /dev/md0 and HOPE that when I repartition the disk it wi=
ll
>> be able to see my data again because it's missing the partition
>> table.
>
> Your chances are slim.
> I would follow the outline I gave above - copying 20Gig or so from th=
e
> 8-drive array, then making the 6-drive array (remember
> --assume-clean).
> Then save the first 20Gig or so from the 6drive array before replacin=
g
> it with what you saved from the 8drive array.
> This might give you a readable partition table.
>
> Then try fsck. =C2=A0Maybe there is a backup-superblock somewhere tha=
t fsck
> can find and use to reconstruct some of the array - but I'm not an
> expert on doing that.
>
> NeilBrown
>
>
>>
>> But I would really like some professional opinions and advice before=
 I
>> try to start writing to the array.
>>
>> Any help will be immensely appreciated!
>>
>> Kind regards,
>> Kris Hofmans
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
