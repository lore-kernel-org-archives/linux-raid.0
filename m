From: "bo" <bo@sosnetwork.net>
Subject: Re: Couldn't umount on /mnt/md0-device busy???
Date: Thu, 18 Jul 2002 10:11:31 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <073d01c22e7e$299d8020$5701a8c0@bomoon>
References: <Pine.LNX.4.33.0207161515560.29547-100000@pandora.is.bizsystems.com> <15668.41627.988382.451061@notabene.cse.unsw.edu.au> <003c01c22db8$57b86590$5701a8c0@bomoon> <3D35BCD6.7030300@cfht.hawaii.edu> <06d001c22def$eaa10510$5701a8c0@bomoon> <009d01c22e54$54d968a0$f6de11cc@black>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mike Black <mblack@csi-inc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike,

It does not matter with the order in /etc/exports.
This "umount" problem goes away when I remove "/mnt/md0" entry from
/etc/exports.  I have 3 more;/mnt/md1, /mnt/md2, /mnt/md3 without any
problem.

I think system has a special meaning with "/mnt/md0".  What does it do???

Any idea?

Bo


----- Original Message -----
From: "Mike Black" <mblack@csi-inc.com>
To: "bo" <bo@sosnetwork.net>
Sent: Thursday, July 18, 2002 5:12 AM
Subject: Re: Couldn't umount on /mnt/md0-device busy???


> Try changing the order in /etc/exports and see if the problem moves.
> Just an idea to test....
>
> ----- Original Message -----
> From: "bo" <bo@sosnetwork.net>
> To: "Kanoalani Withington" <kanoa@cfht.hawaii.edu>
> Cc: <linux-raid@vger.kernel.org>
> Sent: Wednesday, July 17, 2002 8:13 PM
> Subject: Re: Couldn't umount on /mnt/md0-device busy???
>
>
> > Yes, I have 4 entries in /etc/exports; /mnt/md0, /mnt/md1, ..md3.
> > Why do I have this "umount" problem ONLY on /mnt/md0?
> >
> > These 4 entries have the same option and parameters.
> >
> > Any more help will be appreciated.
> >
> > Bo
> > ----- Original Message -----
> > From: "Kanoalani Withington" <kanoa@cfht.hawaii.edu>
> > To: "bo" <bo@sosnetwork.net>
> > Cc: <linux-raid@vger.kernel.org>
> > Sent: Wednesday, July 17, 2002 11:52 AM
> > Subject: Re: Couldn't umount on /mnt/md0-device busy???
> >
> >
> > > There may be an entry for /mnt/md0 in /etc/exports. If there is,
usually
> > > the startup scripts will start an NFS server at boot time and the
> > > filesystem will be busy as long as that daemon is running. If you
mount
> > > the volume after the scripts run a server won't be started and the
> > > volume can be manually unmounted without any errors.
> > >
> > > -Kanoa
> > >
> > > bo wrote:
> > >
> > > >Hello!
> > > >
> > > >I have found a VERY strange issue on using the name "md0" as a mount
> > point.
> > > >If I use "/mnt/md0" as a mount point for the md device or normal HD
> > device,
> > > >I could not umount it after booting the system having "device is
busy"
> > > >error.
> > > >
> > > >However, it is OK if I manually make a RAID then mount it to
"/mnt/md0".
> > > >I checked if it has any processes running on it with "fuser" but
nothing.
> > > >
> > > >Does "/mnt/md0" have a special meaning(usage) for system?
> > > >
> > > >Please provide me a clue.
> > > >
> > > >Thanks,
> > > >
> > > >//Bo
> > > >
> > > >The followins are my experiment on this issue;
> > > >
> > > >root@P3000-PP1:/home/bmoon# cat /proc/mounts
> > > >/dev/root / ext2 rw 0 0
> > > >none /proc proc rw 0 0
> > > >/dev/md0 /mnt/md0 ext2 rw 0 0
> > > >/dev/md3 /mnt/md3 ext2 rw 0 0
> > > >
> > > >root@P3000-PP1:/home/bmoon# umount /mnt/md0
> > > >umount: /mnt/md0: device is busy
> > > >---------------
> > > >root@P3000-PP1:/etc# fuser -v /mnt/md0
> > > >
> > > >                     USER        PID ACCESS COMMAND
> > > >/mnt/md0            root     kernel mount  /mnt/md0
> > > >
> > > >----------------after chnage the name of mount point  from /mnt/md0
to
> > > >/mnt/user---------------
> > > >root@P3000-PP1:/home/bmoon# cat /proc/mounts
> > > >/dev/root / ext2 rw 0 0
> > > >none /proc proc rw 0 0
> > > >/dev/md0 /mnt/user ext2 rw 0 0
> > > >/dev/md3 /mnt/md3 ext2 rw 0 0
> > > >
> > > >root@P3000-PP1:/home/bmoon# umount /mnt/user
> > > >root@P3000-PP1:/home/bmoon#
> > > >------------------------
> > > >root@P3000-PP1:/etc# vi fstab
> > > >/dev/hda2        /               ext2    defaults        1 1
> > > >none             /proc           proc    defaults        0 0
> > > >/dev/hda3        swap            swap    defaults        0 0
> > > >/dev/md0         /mnt/user       ext2    defaults        0 0
> > > >/dev/md3         /mnt/md3        ext2    defaults        0 0
> > > >
> > > >Another experiment
> > > >----------------------
> > > >root@P3000-PP1:/home/bmoon# cat /proc/mounts
> > > >/dev/root / ext2 rw 0 0
> > > >none /proc proc rw 0 0
> > > >/dev/hdb2  /mnt/md0 ext2 rw 0 0
> > > >/dev/md3 /mnt/md3 ext2 rw 0 0
> > > >
> > > >root@P3000-PP1:/home/bmoon# umount /mnt/md0
> > > >umount:  /mnt/md0:  device is busy
> > > >
> > > >
> > > >-
> > > >To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> > > >the body of a message to majordomo@vger.kernel.org
> > > >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > >
> > > >
> > >
> > >
> > >
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

