From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Remote NAS
Date: Tue, 29 Sep 2009 05:09:33 -0500
Message-ID: <20090929100915055.RLFO26368@cdptpa-omta03.mail.rr.com>
References: <228497.14504.qm@web38801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <228497.14504.qm@web38801.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Thanks for the thoughtful and comprehensive advice.
> 
> Yes I do regular backups from machine to machine (one to the other), but
> my video library is getting large and it's impractical to back that up so
> I look to RAID.

	You need to think that through a bit.  A RAID10 (or other mirrored
solution) requires just as many drives as a backup server solution.  Doing a
JOBD solution on both systems and then backing up from one to the other
takes no more drive space than a RAID10.  I am a belt and suspenders sort of
guy, so I personally employ fault tolerant RAID arrays on both systems, but
a backup JOBD array provides essentially as much robustness as a RAID10
solution, as long as one can live with the primary system going down for a
period of time when a drive is lost and live with the time it takes to
transfer the material back from the backup to the main system after a drive
is replaced.  In my case, I eliminate the down time by adding an extra three
parity drives, and employing RAID6 on the main array and RAID5 on the
backup.

> I've thought about backing up to DVD-RW, but I'd need
> several so will likely just make deep storage volumes. (very occasional)

	Several?  Backing up 1T of storage would require over 100 dual layer
DVDs.

> I don't trust tape backup of any type, and blu-ray write is a losing
> concept when disk space is so cheep.

	Agreed, plus multi-terrabyte tape drives are very expensive, and the
media is as expensive as a hard drive.  Blu-Ray is even worse.  Much worse.

 
> I hear you on the human error aspect, and to have the garage as sort of an
> offline storage is interesting, but it would take forever to back up my
> data there.

	No it doesn't.  It's true the initial backup will take a while
(possibly up to 10 hours per terrabyte, or possibly as little as 3 hours per
terrabyte over a Gig-E link), but then so will building the initial array.
Whether you copy the data via rsync (or other file copy utility) or via md
when building the array, it's going to take the same amount of time.  It's
not like you have to sit and watch the process, though, or like the system
is down during the copy.  Activity can continue on your main system
normally, with some performance hit, of course.

> Not familiar with rsync and will look into it.  Maybe it's a
> diff sort of copy.

	One does not do a full backup of the data on a daily basis, no
matter what.  With video in particular, the bulk of the data never changes
once it is written to disk.  Once a video file is copied over to the backup,
it never needs to be copied again.  Rsync offers a large number of options
for copying based upon various criteria.  Take a look at the following from
my video server:

RAID-Server:/usr/bin# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/hda2             110G  5.3G  105G   5% /
tmpfs                 1.7G     0  1.7G   0% /lib/init/rw
udev                   10M  132K  9.9M   2% /dev
tmpfs                 1.7G     0  1.7G   0% /dev/shm
/dev/md0              7.3T  6.4T  957G  88% /RAID
/dev/hda4             788M  948K  747M   1% /etc/mdadm/bitmap
Backup:/Backup        8.2T  6.5T  1.8T  79% /Backup

	The /Backup directory is a remote share using NFS from my backup
server.  Now take a look at this morning's backup to the /Backup directory
performed by the backup server ( I do the backup from the backup server so
the rsync process uses very little CPU time on the video server):

receiving incremental file list
Mail/
Mail/lrhorer
           0   0%    0.00kB/s    0:00:00       106.36M  69%  101.44MB/s
0:00:00       152.08M 100%  108.80MB/s    0:00:01 (xfer#1,
to-check=1391/1469)
Mail_Folders/
Personal_Folders/Leslie/Outlook Files/Outlook Shared File.pst
           0   0%    0.00kB/s    0:00:00           582   0%    0.43kB/s
27:37:05        42.68M 100%   22.51MB/s    0:00:01 (xfer#2,
to-check=1005/5430)
Personal_Folders/Leslie/Quicken/2009.QDF
           0   0%    0.00kB/s    0:00:00         8.73M 100%   13.40MB/s
0:00:00 (xfer#3, to-check=1037/5863)
Server-Main/Movies/
Server-Main/Movies/Unverified TiVo Movies.csv
           0   0%    0.00kB/s    0:00:00            84 100%   82.03kB/s
0:00:00 (xfer#4, to-check=1019/24852)

Number of files: 31734
Number of files transferred: 4
Total file size: 6974.09G bytes
Total transferred file size: 203.49M bytes Literal data: 900.42K bytes
Matched data: 202.59M bytes File list size: 896.65K File list generation
time: 0.001 seconds File list transfer time: 0.000 seconds Total bytes sent:
152.50K Total bytes received: 1.90M

sent 152.50K bytes  received 1.90M bytes  241.03K bytes/sec total size is
6974.09G  speedup is 3404008.11

