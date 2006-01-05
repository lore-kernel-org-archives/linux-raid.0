From: "John Stoffel" <john@stoffel.org>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Thu, 5 Jan 2006 13:55:10 -0500
Message-ID: <17341.27534.41206.232976@smtp.charter.net>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
	<fd8d0180601050106s5f5b4306o@mail.gmail.com>
	<17341.8541.33899.167524@smtp.charter.net>
	<fd8d0180601050603t6f62ff91o@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180601050603t6f62ff91o@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Francois" =3D=3D Francois Barre <francois.barre@gmail.com> write=
s:

=46rancois> 2006/1/5, John Stoffel <john@stoffel.org>:
>>=20
>> So what are you doing for backups, and can you allow the downtime
>> needed to restore all your data if there is a problem?  Remember, it=
's
>> not the cost of doing backups which drives things, it's the cost of
>> the time to *restore* the data which drives issues.
>>=20

=46rancois> Well, backups mean snapshots. Snapshots mean having a
=46rancois> non-changing set of data for the time the backup goes.=20

No, backups do not mean snapshots.  Backups mean a copy of the data is
kept on a reliable medium somewhere else, so that when a <Insert
disaster here> destroys your disk array, you can reload the data from
your backup media. =20

Snapshots are merely a way to take backups of a consistent view of the
filesystem, so that the time between the initial scan of all
directories and files in a filesystem, and the time when you actually
start to dump them to disk, you don't have users changing stuff
behind your back. =20

Don't mix them up, you'll be really really unhappy.=20

=46rancois> Not sure about that.  Furthermore, backup means increasing
=46rancois> the TCO per GB. I must keep it close to .50 euro per
=46rancois> GB. That's my main issue at the moment...

What is your cost if the disk array goes up in flames and you need to
access your data then?  Or can you just reload it from some other
source and not care about it?=20

=46rancois> I don't trust it. I'm wrong I know, but I don't trust
=46rancois> it. Had a very bad experience with a stupidly configured
=46rancois> system (not configured by me, of course :-p) a couple of
=46rancois> months ago, with a LVM on top of a linear Raid. Guess what =
?
=46rancois> Most of mission-critical data was lost. I know LVM was not
=46rancois> responsible for this, but, you know, trust is sometimes not
=46rancois> only a matter of figures and scientific facts.

So did you have backups?  Sounds like you didn't which just makes my
point that I've been pushing: "How will you backup your data?"=20

Also, setting up a Linear RAID0 of disks is just asking for trouble,
which you obviously know since you're talking about using RAID5 in
this new array.  *grin*  If this mis-configured system had been setup
with an MD array that was just linear, without LVM, you would have
still lost data. =20

=46rom the sound of it, the old system was configure with MD on top of
LVM, which is the inverse of how I do it.  I put MD down low, and
layer LVM on top of the reliable (redundant) MD device.  Then I can
span my LVM across multiple MD devices.

You're blaming the wrong part of the system for your data loss.  First
off blame the user/sysadmin who set it up, then blame the person who
put Linear RAID on your system and into MD/LVM.  :]=20

As another poster said, using LVM on top of MD allows you to move your
filesystems from one set of physical media to another without having
any down time for your users.  Or even more importantly, it allows you
to grow/move your storage without having to dump your data to another
filesystem or tape.

=46rancois> What did Hans say on LKML ? I thought he was considered as
=46rancois> the gentle-and-wise-guru for filesystems, just as Linus is
=46rancois> for the kernel...

Umm... not exactly.  He's more a pain in the butt to deal with at
times, with an abrasive personality which only seems to care about his
projects.  He doesn't like working with other people to make it FS
work within the Linux kernel designs and philosophy. =20

All my opinion of course.  Plus, I've been a bunch of horror stories
about Resierfs3 problems, though I admit not recently, say the past
six months to a year.  But resierfs4 I wouldn't deploy production data
on yet...

>> Oh yeah, don't forget to mirror the root disk.  And if you're lookin=
g
>> to make a file server, you might want to look at that OpenNAS stuff
>> and boot it off a compact flash card/USB dongle as well.  Keep as fe=
w
>> a number of moving parts as possible.
>>=20

=46rancois> Speaking of this, I began to think about splitting all the =
disks in
=46rancois> two partitions : 1 of 1Go, the rest for data, and build two=
 mds :
=46rancois> md0, 12*1GB of raid1 (mirrored) for /
=46rancois> md1, 12*229GB of raid6 for data.

=46rancois> Maybe this is a little bit parano=EFd for / but :
=46rancois> 1. I can afford loosing 1GB of space on each DD

It's going a bit too far I think.  Just dedicate a pair of small disks
to your OS.  Or again, get the OpenNAS software and boot off CDROM/USB
and not worry about it.

=46rancois> 2. All disks have the same partition structure

It's an advantage. =20

=46rancois> 3. I can boot on each DD, regardless to the number of valid
=46rancois> DDs it has.

At that point, it depends on what your BIOS supports for bootable
disks. =20

=46rancois> BTW : is there any kind of limitation on the number of
=46rancois> devices in a raid1 ?

Don't know.  I suspect that there might be.

=46rancois> Of course, updating data on / will be at a high cost : 12
=46rancois> times for each write... But it's a fileserver, so config
=46rancois> will not change so often (maybe an issue for logs...).

Send the logs via syslog to another server.  End of problem.  :]

John
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
