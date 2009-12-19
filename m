From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID5 / 6 Growth
Date: Sat, 19 Dec 2009 21:36:42 +0300
Message-ID: <70ed7c3e0912191036o2a1d413es6492bdafc3a75267@mail.gmail.com>
References: <27.2B.01550.F982C2B4@cdptpa-omtalb.mail.rr.com>
	<2F.73.01567.6991D2B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2F.73.01567.6991D2B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Do any of the disks report sector errors or ATA or read errors?
smartctl -a /dev/sdx should give the report, assuming you run smartd
and have it probe disks periodically.

I've seen newer versions of the xfsprogs and libs packages. Try using
those. I know you're against new packages that haven't been included
in "stable" -- but if this is a dev/backup system, it's worth the shot
in my opinion.

Good luck.

On Sat, Dec 19, 2009 at 9:21 PM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
> Well, the RAID growth completed on the backup system, but now when I =
attempt
> to mount the XFS file system, mount returns the error "mount: Structu=
re
> needs cleaning". =C2=A0When I issue the xfs_repair command, I get thi=
s:
>
> Backup:/boot/grub# xfs_repair -v /dev/md0
> Phase 1 - find and verify superblock...
> =C2=A0 =C2=A0 =C2=A0 =C2=A0- block cache size set to 28616 entries
> Phase 2 - using internal log
> =C2=A0 =C2=A0 =C2=A0 =C2=A0- zero log...
> zero_log: head block 38584 tail block 38504
> ERROR: The filesystem has valuable metadata changes in a log which ne=
eds to
> be replayed. =C2=A0Mount the filesystem to replay the log, and unmoun=
t it before
> re-running xfs_repair. =C2=A0If you are unable to mount the filesyste=
m, then use
> the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a=
 mount
> of the filesystem before doing this.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0The file system was shut down cleanly with=
 umount prior to starting
> the growth, but xfs still seems to think the file system is dirty and=
 the
> journal needs to be replayed. =C2=A0Running xfs_repair with the -n co=
mmand shows
> the file system has a few errors. =C2=A0Before I purge the log and po=
tentially
> lose a few files, is there something else I should try under mdadm to
> possibly fix teh array structure? =C2=A0(I doubt it, but I wanted to =
check with
> others more knowledgeable than I before I proceed.)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
