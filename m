From: "John Stoffel" <john@stoffel.org>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Thu, 5 Jan 2006 08:38:37 -0500
Message-ID: <17341.8541.33899.167524@smtp.charter.net>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
	<fd8d0180601050106s5f5b4306o@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180601050106s5f5b4306o@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Francois> Well, I think everything is in the subject... I am looking
Francois> at this solution for a 6*250GB raid5 data server, evolving
Francois> in a 12*250 rai5 in the months to come... Performance is
Francois> absolutely not a big issue for me, but I would not
Francois> appreciate any data loss.

So what are you doing for backups, and can you allow the downtime
needed to restore all your data if there is a problem?  Remember, it's
not the cost of doing backups which drives things, it's the cost of
the time to *restore* the data which drives issues.

In this case, you're looking at just under 1 terabyte to start, and 2
terabytes of data later on once you expand.  Now think how many DLT IV
tapes at 50gb (nominal compression assumed) each it will take to hold
that data, and how long at 5Mb/sec to restore... 

As others have suggested, going with RAID6 will cover the double disk
failure case.  This is one reason I really like NetApps with the new
double parity setup, with the increase of disk sizes, and the close to
24 hour RAID reconstruct time, double disk failures are a serious
issue to think about. 

Francois> Furthermore, I would prefer not to use LVM nor any middle
Francois> layer between MD and the fs... Is this middle layer *very*
Francois> usefull when I'm sure my partitions layout will not evolve
Francois> (e.g. only one enormous fs) ?  Thanks for your
Francois> answerings/advices,

Why do you not want to use LVM?  It gives you alot of flexibility to
change your mind down the road.  Also, it means that you could just
build a pair of RAID5/6 arrays and stripe across them.  Yes, you lose
some disk space since you now have multiple arrays, each with their
own parity disks, but it also means that 

In terms of filesystems, I still like ext3 for it's reliability, but I
would like a filesystem which can be resized on the fly if at all
possible.   I've been slowly leaning towards xfs, but maybe that's
just me not liking Hans Reiser's attitude on the lkml at points.  And
I certainly don't trust reiser4 at all yet, it's way too early for
production data.

From the sound of it, you just want a large place to dump stuff, in
which case you might be happy with a less reliable system.  

Oh yeah, don't forget to mirror the root disk.  And if you're looking
to make a file server, you might want to look at that OpenNAS stuff
and boot it off a compact flash card/USB dongle as well.  Keep as few
a number of moving parts as possible.

John

