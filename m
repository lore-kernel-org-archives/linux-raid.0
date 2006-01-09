From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Mon, 9 Jan 2006 10:24:51 +0100
Message-ID: <62b0912f0601090124r1d6d30e0i95e20364edb416d9@mail.gmail.com>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
	 <fd8d0180601050106s5f5b4306o@mail.gmail.com>
	 <17341.8541.33899.167524@smtp.charter.net>
	 <fd8d0180601050603t6f62ff91o@mail.gmail.com>
	 <17341.27534.41206.232976@smtp.charter.net>
	 <fd8d0180601060108rbe9d663p@mail.gmail.com>
	 <20060106104931.GB20546@atc5.vermine.org>
	 <62b0912f0601090000l8eb613ci4c3b237805c77182@mail.gmail.com>
	 <Pine.LNX.4.56.0601090809510.4480@lion.drogon.net>
	 <fd8d0180601090100mf7d1e7cq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180601090100mf7d1e7cq@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: xen-users@lists.xensource.com
List-Id: linux-raid.ids

Gordon Henderson wrote:
> I was bitten with LVM some time back (maybe 18 months to 2 years) and then
> I didn't have time to track down the real cause, so resorted to just
> doubling up on disk space (disk is cheap!) and running a nightly rsync to
> create/update the snapshot (and you can make several days worth too with
> some cleverness and not much more disk space), then dumping the snapshot
> to tape... The 3-400GB volumes I have take less than an hour for the rsync
> so it's not a big impact in the middle of the night.

Thanks for the tip :-).

My current approach is to tar the entire filesystem to a "backup" partition
and gzip it with the "--rsyncable" option.  That way I can diff the backup
tar's and keep a whole load of backups online at a minimum of disk space.

Doesn't seem useful at first to have so many backups.  But keep in mind that
the less space each backup takes, the more often you can back up.  With
this approach I can backup every 24 hours which means less work is lost when
I have to restore.

Francois Barre:
> Regarding snapshots, seems like XFS has some snapshot features (from
> http://oss.sgi.com/projects/xfs/index.html : XFS supports filesystem
> growth for mounted volumes, allows filesystem "freeze" and "thaw"
> operations to support volume level snapshots, and provides an online
> file defragmentation utility).
> Did anyone play with this ? Could it be a good way to implement robust
> and trustworthy snapshots ?
> Anyway, I believe that snapshot logic shall live inside of filesystem
> layer ; capability to have a filesystem freezed within a special
> process, while other processes still modifying the fs could be great :

Seeing as server virtualization is all the fuzz right now, what would be
really cool IMHO would be a filesystem where one could make a
block-by-block snapshot of the partition at _any_ point in time and have
a consistent filesystem out of it, without doing any sort of
freeze/unfreeze operations.

This would allow you to do snapshotting and backup *outside* of your
virtual machines, which is much more desirable than doing it from the
inside.  From the outside, your virtual machines can't destroy the backup
process, so you have guarantee that it gets done every time.  And that
your customers do not muck with it.  You also have much better control of
disk space usage.  And you can make backups if the machine happens to be
turned off.  And consistent ones too, even if it has crashed.  There's
probably other advantages I haven't thought of :-).
