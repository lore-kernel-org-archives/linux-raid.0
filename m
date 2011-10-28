From: Ryan Castellucci <ryan.castellucci+linux-raid@gmail.com>
Subject: Re: Lost mdadm RAID6 array and tried everything, hoping for any other
 suggestions you may have
Date: Thu, 27 Oct 2011 17:08:25 -0700
Message-ID: <CAO+W5hpzvzrkhVoV_nyTgN4WKUcRTUEMGk5oJ8YtZX1OTgP0wQ@mail.gmail.com>
References: <4E7BB186.1010104@pobox.com> <20110923143053.6a9c5a9e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110923143053.6a9c5a9e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: Eduard Rozenberg <eduardr@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46WIW, I've had the exact issue - four of eight drives going offline
due to a loose cable.  If you force an assemble using --force --assume
clean, then force an array re-sync, you should be able to mount the
filesystem.

Re-creating the array has probably done horrible things to your data
due to the partial resync, but I would expect partial recovery (of the
data not overwritten) to still be possible by brute forcing the disk
layout with repeated creates with the --assume-clean flag.  If
possible, buy another eight hard drives and clone the originals to
them, then try recovering from the clones.

I'm not sure if you'll be able to do anything other than use a carving
tool to get your files back.

-Ryan

On Thu, Sep 22, 2011 at 9:30 PM, NeilBrown <neilb@suse.de> wrote:
>
> Did you keep the "mdadm -E" output from before you started recreating=
 the
> array?
> If not, you are probably out of luck.
>
> When you create a RAID5 array it will write to all the superblocks, a=
nd will
> write over everything on the last device listed - basically treating =
it as a
> spare while the rest is a degraded array, and rebuilding the spare.
>
> So the first n-1 drives are probably largely untouched ... unless you=
 changed
> the order of devices when you created.
>
> The superblock will be somewhere on the first drive. =A0Maybe you can=
 find it.
> That will at least tell you the data offset...
>
> Best advice: =A0As soon as something happens that you don't understan=
d - ask
> for help. =A0Once you don't understand what you are doing, anything y=
ou do will
> probably make it worse.
> Also : keep records of everything.
>
> NeilBrown
>
>
>
> On Thu, 22 Sep 2011 15:07:02 -0700 Eduard Rozenberg <eduardr@pobox.co=
m> wrote:
>
>> Hello,
>>
>> I've had very good luck with mdadm RAID1 over the years and it's rea=
lly
>> helped out.
>> More recently I got a bit more adventurous and tried out RAID6, but
>> after my recent
>> experience with it I'm considering writing my take on "RAID6 conside=
red
>> dangerous" :)
>>
>> Quick summary:
>>
>> * Slackware 64 13.37, Linux 2.6.37.6, on Shuttle XPC 4gb ram
>>
>> * RAID6 array, 8 active drives in a chassis connected via 2 esata ca=
bles
>> to a shuttle pc,
>> =A0 =A0 12TB total, worked fine for several months. Esata controller=
 w/port
>> multiplier support.
>>
>> * Couple of days back, noticed array was down, with second half of t=
he
>> drives shown as
>> =A0 =A0 down. Assumption - 1 cable or esata controller port hickuped=
, taking
>> 4 drives out of the array,
>> =A0 =A0 or something happened due to the hot temps that day
>>
>> * /proc/mdstat showed (S) next to some (or all, can't remember) of t=
he
>> drives in the array -
>> =A0 =A0 I think that means spare, but I had no spares defined for th=
e array
>> so it seemed weird
>>
>> * Rebooted machine and checked smartctl status, all 8 drives in chas=
sis
>> showed OK status,
>> =A0 =A0 and they were all accessible using gdisk and fd00 partitions
>> appeared fine.
>>
>> * Tried to reassemble normally, then with force, nothing happened - =
no
>> errors, array just
>> =A0 =A0 didn't come up. Did not try --assume-clean (to my regret). M=
aybe
>> would have worked,
>> =A0 =A0 will never know.
>>
>> * Took some internet advice and tried --create to recreate the array=
,
>> however I forgot which
>> =A0 =A0 chunk size I used so I tried several times with different ch=
unk
>> sizes (some resync took place
>> =A0 =A0 each time). Could not find any info on Internet about whethe=
r the
>> resyncs blew away my data.
>>
>> * After each mdadm array recreate, tried to mount the array but fail=
ed
>> with missing superblock
>>
>> * dd'd a few gb's from the array and tried to grep text in a failed
>> attempt to determine chunk size
>>
>> * Tried testdisk utility to attempt to locate file system structures
>> after recreating array with various
>> =A0 =A0 chunk sizes, didn't let utility finish but it didn't seem to=
 be
>> doing anything useful
>>
>> * R-Studio - tried using it, didn't seem it would do anything useful=
 for me
>>
>> At this point the key questions I'm aware of:
>>
>> * Did recreating array with various chunk sizes blow away my data/fi=
le
>> system structures
>> =A0 =A0(I did not use --assume-clean when recreating array)
>>
>> * If the data is still ok, is there a way to determine the chunk siz=
e
>> that was used? I'm hoping
>> =A0 =A0 the metadata version and bitmap options used would not affec=
t being
>> able to recover
>> =A0 =A0 the array, because I don't remember which metadata and bitma=
p
>> options I used if any.
>>
>> * Given the correct chunk size, if I recreate the array, is there so=
me
>> way to convince mount to
>> =A0 =A0 mount the array, or some way of fixing the ext4 structure, o=
r any
>> other way to get the data of
>> =A0 =A0 the array other than the file carving utilities that dump ev=
erything
>> in a bunch of random
>> =A0 =A0 directories.
>>
>> I'm well aware RAID !=3D backups and I had a backup but it was a few
>> months old unfortunately.
>> I didn't expect at all this failure mode of having half the disks
>> disappear and having the array
>> be so hard to recover. Most of the Internet information is focused o=
n
>> array creation and mgmt,
>> and I found precious little information on recovery, some of which w=
as
>> wrong and dangerous.
>> At this point I do consider RAID6 to be dangerous and will avoid it
>> where possible. It just makes
>> recovery so much harder when the file system and data is broken up i=
nto
>> little pieces.
>>
>> Thanks in advance for any tips.
>>
>> Regards,
>> --Ed
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>



--=20
Ryan Castellucci http://ryanc.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
