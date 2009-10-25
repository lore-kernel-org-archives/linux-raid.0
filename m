From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is My Data DESTROYED?!
Date: Sun, 25 Oct 2009 09:16:55 -0500
Message-ID: <20091025141659041.ENAX12118@cdptpa-omta02.mail.rr.com>
References: <903282.80364.qm@web38803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <903282.80364.qm@web38803.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Yes it's my video collection which I've worked long and hard to gather.
> Your point is taken that it doesn't have to be hot online, but if it can
> why not?  I hate tape, and claim that it's obsolete.

	I never suggested tape for you.  In a data center, where hard disk
backup systems can run many tens of thousands or even many hundreds of
thousands of dollars, they are the medium of choice.  As to being obsolete,
tape systems are far better than they used to be, but they are a poor choice
for systems smaller than 50 - 100T.

> I am shocked at all who think that human error is so prevalent, and in
> fact obviates the case for RAID as backup.  I've run Debian for 12 years
> on all my personal servers and remember literally only 3 or 4 cases in
> that time where I muggered something up and had to go to backup.  There
> must be alot of fsckups out there...

	Half the files I have lost on my video system were due to my
personal errors.  Absolutely none were due to drive failures.  By a very
wide margin, the most common cause of data loss is human error.  EVERY
SINGLE FILE THAT HAS EVER BEEN LOST SINCE THE FIRST DIGITAL COMPUTER WAS
BUILT HAS BEEN DUE TO THERE NOT BEING A VALID BACKUP.

> That said, I am now considering making the storage server in the garage a
> backup rather than a RAID.  This means I'll want it to go to sleep most of
> the time, and I'll need a mobo that does wake-on-LAN successfully and
> automatically.

	OK.  It's certainly doable.  You could also just let the drives
sleep, if the motherboard or Ethernet adapter doesn't support WOL.

> Now a backup by cron is nice and all, but what if it silently fails in
> some obscure way?  This is one thing I like about RAID or ZFS, it lets you
> know when anything's wrong.

	Here is the e-mail sent by the daily system backup:

receiving incremental file list
Mail/
Mail/lrhorer
           0   0%    0.00kB/s    0:00:00        88.87M  59%   81.33MB/s
0:00:00       148.87M 100%  100.05MB/s    0:00:01 (xfer#1,
to-check=1391/1469)
Mail_Folders/
Personal_Folders/Leslie/Outlook Files/Outlook Shared File.pst
           0   0%    0.00kB/s    0:00:00        42.68M 100%   74.41MB/s
0:00:00 (xfer#2, to-check=1005/5430)
Recordings/Star Trek The Next Generation/ Recordings/Star Trek The Next
Generation/Star Trek Next Generation - Hero Worship (Recorded Mon Aug 31,
2009, SYFYHD).mpg.txt
           0   0%    0.00kB/s    0:00:00           839 100%  819.34kB/s
0:00:00 (xfer#3, to-check=1090/12581)
Server-Main/Movies/
Server-Main/Movies/Unverified TiVo Movies.csv
           0   0%    0.00kB/s    0:00:00           180 100%  175.78kB/s
0:00:00 (xfer#4, to-check=1029/24920)

Number of files: 31767
Number of files transferred: 4
Total file size: 7043.27G bytes
Total transferred file size: 191.55M bytes Literal data: 682.10K bytes
Matched data: 190.87M bytes File list size: 898.25K File list generation
time: 0.031 seconds File list transfer time: 0.000 seconds Total bytes sent:
133.88K Total bytes received: 1.67M

sent 133.88K bytes  received 1.67M bytes  144.10K bytes/sec total size is
7043.27G  speedup is 3910112.63

	What's obscure about that?  It's also a simple matter to run a
compare between the two systems.  One can compare every single file, or for
brevity one can easily compare only the most recently created files.

> I can imagine setting up a fancy-pants backup
> system then going about my life, and some quirk happens on the next update
> which subtlely hoses my exotic backup system.  It is desirable to have
> bolt-tight assurance of backed-up data.  (And please don't bore us with
> 'nothing is for sure')

	Subtlely?  Such a thing is no more likely (less so, in fact) with
the backup system than with the main system.  And what is with the
characterization "exotic"?  Your backup system should be as plain vanilla as
a system gets.  Load Debian (or whatever) with mail support, load the
packages for NUT, rsync and ssh, configure them, and you're done.  Create
the wakeup / backup script on the main system, and you're on your way.  I
suggest running the rsync on the remote system for best performance, but
it's up to you.  If you don't, you can forego the mail support on the backup
system.  Desktop support is unnecessary, unless you just want to run a
desktop like Gnome or KDE.  Even if you do, its not necessary to have a
mouse, keyboard, or display attached.  Loading ftpd and ntp won't hurt.

> Seems like a sync process, and then a checksum process to compare drives
> and email a result, although minor files are changing all the time and I
> wouldn't want to be notified if /tmp has changed.

	My advice is to run the backup only against the array.  For files
outside the array, I would run a tar job on the external drives and save the
tarball to the array.  You can make them multi-generation backups if you
like.  Either way, the data gets backed up with the array.

> Also I've noticed rsync mentioned several times.  This seems to have
> facilities for incremental backups, but I've also read that it is non-
> secure over networks and that we should use scp instead.

	It's secure if you use ssh with passphraseless keys as its transfer
mechanism.  Why are you worried about it if this is a home LAN, though?  How
is someone gong to sniff your LAN, especially the link between the two
hosts?

> But scp doesn't
> seem to have incremental attributes.  Yes, this is my home LAN, but I have
> a thing about security in and out.

	For video files?  Regardless, exactly how do you suggest that
someone could possibly intercept the data?  Unnecessary security
notwithstanding, however, ssh with passphraseless keys is a great way to
manage the remote system, so I suggest implementing it anyway.

>  Isn't there another way of syncing two disks (over a network)?

	Sure.  Lots of them.  I can't think of any more straightforward than
rsync, though.

