From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: What is the status of SW-Raid in 2.5.x
Date: Mon, 29 Jul 2002 20:00:16 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15685.4656.919671.427924@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.33.0207291008200.29640-100000@talentix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Holger Kiehl on Monday July 29
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday July 29, Holger.Kiehl@dwd.de wrote:
> Hello
> 
> What's the status of SW-Raid in the 2.5.x kernel? I did try it with
> 2.5.29 and it does seem to boot fine, however when booting 2.4.19-rc1
> it always whant's to resink and then sometimes fails because
> it kicks out one or more drives telling me they are bad. Using
> only 2.4.19-rc1 everything is ok and I can reboot as much as I want.

That's a very good question....

The SW-Raid code (aka the md driver) is currently in the middle of a
very substantial re-write.  I want to do a lot of cleaning up and
regularising of the code.  It should keep working at every stage, but
I cannot make any promises... bugs happen and this is a development
kernel.

There are a couple of problems with the code that I know of that are
not (I don't think) a result of my changes and so I haven't been
particularly motivated to fix them.  I will get round to them in the
process of the re-write but I don't have any particular intention to
expedite the fixing.

One is that raid arrays are not marked as clean on shutdown.  This is
what you have noticed.
This is because of the "return NOTIFY_DONE" early in
md_notify_reboot in drivers/md/md.c
I don't know why that was put there and I will eventually remove it
(you can ofcourse remove it yourself),
but I actually want to make other changes to the "mark-clean"
concept.  Then the management daemons (raid5d, raid1d) get signalled,
as they normally do at shutdown, I want them to switch to a mode where
they mark the arrays clean the moment there are no pending writes, and
then mark them dirty when a new write arrives.  I then probably want
to extend this to mark them clean at any time when there is more than
(say) 2 seconds of inactivity.

The other problem is that raid1 resync doesn't finish properly.  The
raid1 resync code was re-written quite a bit by Ingo Molnar quite
early in the 2.5 series and I haven't had a change to look in detail
at what he did and why and to figure out the cause of this problem.

NeilBrown
