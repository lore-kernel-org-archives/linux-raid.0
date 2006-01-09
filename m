From: Francois Barre <francois.barre@gmail.com>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Mon, 9 Jan 2006 10:00:44 +0100
Message-ID: <fd8d0180601090100mf7d1e7cq@mail.gmail.com>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
	 <fd8d0180601050106s5f5b4306o@mail.gmail.com>
	 <17341.8541.33899.167524@smtp.charter.net>
	 <fd8d0180601050603t6f62ff91o@mail.gmail.com>
	 <17341.27534.41206.232976@smtp.charter.net>
	 <fd8d0180601060108rbe9d663p@mail.gmail.com>
	 <20060106104931.GB20546@atc5.vermine.org>
	 <62b0912f0601090000l8eb613ci4c3b237805c77182@mail.gmail.com>
	 <Pine.LNX.4.56.0601090809510.4480@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0601090809510.4480@lion.drogon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I was bitten with LVM some time back (maybe 18 months to 2 years) and then
> I didn't have time to track down the real cause[...]

Well, that's part of my LVM fear... Ifever something goes wrong,
because of an admin mistake or because of a LVM bug, chances to
recover a problematic LVM are small. That's part of why I do not wish
to use it.

<ABSOLUTELY OUT OF RAID TOPIC>
Regarding snapshots, seems like XFS has some snapshot features (from
http://oss.sgi.com/projects/xfs/index.html : XFS supports filesystem
growth for mounted volumes, allows filesystem "freeze" and "thaw"
operations to support volume level snapshots, and provides an online
file defragmentation utility).
Did anyone play with this ? Could it be a good way to implement robust
and trustworthy snapshots ?
Anyway, I believe that snapshot logic shall live inside of filesystem
layer ; capability to have a filesystem freezed within a special
process, while other processes still modifying the fs could be great :
alterations of the fs could be stored in a particular place of the fs,
committed at the end of the 'freezed' process... That would be great.
But it does not seem to be implemented by anyone...
Another way to do so would be to play with unionfs like this :
- unmount your working partition
- mount it ro with an additionnal rw temp partition using unionfs
- make snapshots
- merge the temp and the working
- unmount all, remount the working one rw
That would mean stopping all your services, and I guess it would not
scale great with large files (writing to a database would mean moving
it from ro to rw...).

Maybe linux-raid is not the right place to speak of this, but as lots
of people here seem to handle large pieces of data, and have
experiences with backuping, I guess your advices can be really
valuable...

<MAYBE MORE LINUX-RAID IN-TOPIC>
Gordon, why not using raid-1 (mirror) for backup proposes ? I mean,
you have your raid5 partition, and you have your backup one. Let's
assume they are the same size.
Why not build a raid1 on top of these two, mount/use raid1 as *the*
working partition, and backup mechanism should look as follow :
- tag the bakcup partition faulty in raid1. raid1 no longer writes
anything to backup.
- backup/tape your backup partition. It's a mere snapshot of your raid5 here.
- resync raid5 and your backup partition. raid1 is done for this.
The only issue I see here is : how to make sure backups are
application-level consistent ?
