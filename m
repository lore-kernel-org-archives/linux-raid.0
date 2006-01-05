From: Francois Barre <francois.barre@gmail.com>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Thu, 5 Jan 2006 15:03:22 +0100
Message-ID: <fd8d0180601050603t6f62ff91o@mail.gmail.com>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
	 <fd8d0180601050106s5f5b4306o@mail.gmail.com>
	 <17341.8541.33899.167524@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17341.8541.33899.167524@smtp.charter.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2006/1/5, John Stoffel <john@stoffel.org>:
>
> So what are you doing for backups, and can you allow the downtime
> needed to restore all your data if there is a problem?  Remember, it'=
s
> not the cost of doing backups which drives things, it's the cost of
> the time to *restore* the data which drives issues.
>

Well, backups mean snapshots. Snapshots mean having a non-changing set
of data for the time the backup goes. Not sure about that.
=46urthermore, backup means increasing the TCO per GB. I must keep it
close to .50 euro per GB. That's my main issue at the moment...

[....]
> Why do you not want to use LVM?  It gives you alot of flexibility to
> change your mind down the road.  Also, it means that you could just
> build a pair of RAID5/6 arrays and stripe across them.  Yes, you lose
> some disk space since you now have multiple arrays, each with their
> own parity disks, but it also means that
>
I don't trust it. I'm wrong I know, but I don't trust it. Had a very
bad experience with a stupidly configured system (not configured by
me, of course :-p) a couple of months ago, with a LVM on top of a
linear Raid. Guess what ? Most of mission-critical data was lost. I
know LVM was not responsible for this, but, you know, trust is
sometimes not only a matter of figures and scientific facts.

> In terms of filesystems, I still like ext3 for it's reliability, but =
I
> would like a filesystem which can be resized on the fly if at all
> possible.   I've been slowly leaning towards xfs, but maybe that's
> just me not liking Hans Reiser's attitude on the lkml at points.  And
> I certainly don't trust reiser4 at all yet, it's way too early for
> production data.

What did Hans say on LKML ? I thought he was considered as the
gentle-and-wise-guru for filesystems, just as Linus is for the
kernel...

> Oh yeah, don't forget to mirror the root disk.  And if you're looking
> to make a file server, you might want to look at that OpenNAS stuff
> and boot it off a compact flash card/USB dongle as well.  Keep as few
> a number of moving parts as possible.
>

Speaking of this, I began to think about splitting all the disks in
two partitions : 1 of 1Go, the rest for data, and build two mds :
md0, 12*1GB of raid1 (mirrored) for /
md1, 12*229GB of raid6 for data.
Maybe this is a little bit parano=EFd for / but :
1. I can afford loosing 1GB of space on each DD
2. All disks have the same partition structure
3. I can boot on each DD, regardless to the number of valid DDs it has.

BTW : is there any kind of limitation on the number of devices in a rai=
d1 ?

Of course, updating data on / will be at a high cost : 12 times for
each write... But it's a fileserver, so config will not change so
often (maybe an issue for logs...).
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
