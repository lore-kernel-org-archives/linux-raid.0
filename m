From: Sam Bingner <sam@bingner.com>
Subject: Re: Suggested use of --invalid-backup?
Date: Tue, 9 Apr 2013 02:49:32 +0000
Message-ID: <E0B5C39C-047A-40E7-9450-99258281391B@bingner.com>
References: <CAPSPcXjRvY-1tCH2CFPOWcNbRZBOCReZqmT4WPdAcbSECreN=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXjRvY-1tCH2CFPOWcNbRZBOCReZqmT4WPdAcbSECreN=w@mail.gmail.com>
Content-Language: en-US
Content-ID: <7F1A783DF1E79A4EB964160F3C6848FF@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Cc: "<linux-raid@vger.kernel.org>" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Apr 2, 2013, at 10:20 AM, Barrett Lewis <barrett.lewis.mitsi@gmail.c=
om> wrote:

> I was reshaping a 5x2tb raid5 to a 6x2tb raid6.  Not knowing that
> ubuntu deletes the /tmp/ folder each reboot, I specified my
> --backup-file as /tmp/raid-backup.bak (this is not part of the array)=
=2E
> At 15.1% the system hung sufficiently that REISUB and the reset
> button were ignored and I had to hold the power button down to reset
> the server.  After booting back from the crash, the array would not
> start, and ubuntu had deleted the backup file (and everything else in
> /tmp).
>=20
> The superblock already says it's raid6, all members are present and
> the event counters are the same on all disks.  I tried
>=20
> ubuntu@ubuntu:~$ sudo mdadm --assemble --force --run --verbose
> /dev/md0 /dev/sd[abcdef]
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sda is identified as a member of /dev/md0, slot 4.
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 5.
> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sde is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 1.
> mdadm:/dev/md0 has an active reshape - checking if critical section
> needs to be restored
> mdadm: Failed to find backup of critical section
> mdadm: Failed to restore critical section for reshape, sorry.
>      Possibly you needed to specify the --backup-file
>=20
>=20
> My understanding is that the backup file is only for some early
> critical part of the reshape and that it isn=92t even used after that=
=2E
> 15% into 8tb is well over a terrabyte so wouldn=92t that be far past =
any
> filesystem metadata?  So what exactly is implied (about the state of
> the reshape) by the fact that programmatically it is still requiring
> the backup file?
>=20
> I have read the manpage on the --invalid-backup command but I didn't
> clearly get "use it here, not here" type of information.  I have the
> OS drive (with deleted /tmp/raid-backup.bak) in a data recovery
> process.  If I actually get the backup file recovered, it could
> potentially have corrupted bits.  Is the best course of action to:
> Supply the (potentially corrupted, but maybe some percent ok)
> recovered backup file as the legitimate backup file (without
> --invalid-backup)? (could this be worse than --invalid-backup and a
> blank file?)
> Supply the (potentially corrupted) recovered backup file WITH --inval=
id-backup?
> Supply --invalid-backup and an empty file?
>=20
> Or if I am on the wrong path, let me know of any other thoughts or
> suggestions you might have.
>=20
> If I get nothing useful back from data recovery, and I have to supply
> --invalid-backup with a blank file, considering the reshape made it t=
o
> 15%, how much chance is there that the array could assemble and resum=
e
> reshape?  I would gladly accept the corruption of some files vs losin=
g
> the whole file system (obviously).
>=20
> Thanks!
> --
>=20

I'm not sure about how exactly a reshape from 5-6 with no capacity chan=
ge works... it is possible that it works like a shrink in that the crit=
ical section is at the end, did you try giving it a backup path with no=
thing there? =20

Otherwise, I would suggest making copies of all your devices and workin=
g with the copy... when I had a similar problem, I copied my member dis=
ks into lvms then worked with snapshots so that I could undo any change=
s that had problems.  Once I knew exactly what happened I then went bac=
k to the original disks and corrected the problem while retaining my ba=
ckup in case of further problems.

Also look in your recovered backup - is there actually data in it?

Sam

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
