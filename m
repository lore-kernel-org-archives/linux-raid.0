From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Thu, 13 Jan 2005 10:53:28 -0500
Message-ID: <200501131551.j0DFpW904826@www.watkins-home.com>
References: <uhrhb2-gku.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <uhrhb2-gku.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "'Peter T. Breuer'" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter said:
"Well, I don't see where there's any window in which its degraded."

These are the steps that cause the window (see "Original Message" for full
details):

1. fail out the chosen drive. (array is now degraded)

2. combine it with the spare in a raid1 with no superblock (re-synce starts)

3. add this raid1 back into the main array. (The main array is now in-sync
other than any changes that occurred since you failed the disk in step 1)

Guy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Peter T. Breuer
Sent: Thursday, January 13, 2005 4:28 AM
To: linux-raid@vger.kernel.org
Subject: Re: Spares and partitioning huge disks

Neil Brown <neilb@cse.unsw.edu.au> wrote:
> On Saturday January 8, bugzilla@watkins-home.com wrote:
> > 
> > Guy says:
> > But, I could tell md which disk I want to spare.  After all, I know
which
> > disk I am going to fail.  Maybe even an option to mark a disk as "to be
> > failed", which would cause it to be spared before it goes off-line.
Then md
> > could fail the disk after it has been spared.  Neil, add this to the
wish
> > list!  :)
> 
> Once the "bitmap of potentially dirty blocks" is working, this could
> be done in user space (though there would be a small window).
> 
> - fail out the chosen drive.
> - combine it with the spare in a raid1 with no superblock
> - add this raid1 back into the main array.
> - md will notice that it has recently been removed and will only
>   rebuild those blocks which need to be rebuilt
> - raid for the raid1 to fully sync
> - fail out the drive you want to remove.

I don't really understand what this is all about, but I recall that when
I was writing FR5 one of the things I wanted as an objective was to be
able to REPLACE one of the disks in the array efficiently because
currently there's no real way that doesn't take you through a degraded
array, since you have to add the replacement as a spare, then fail one
of the existing disks.

What I wanted was to allow the replacement to be added in and synced up
in the background.

Is that what you are talking about? I don't recall if I actually did it
or merely planned to do it, but I recall considering it (and that
should logically imply that I probably did something about it).

> You only have a tiny window where the array is degraded, and it we
> were to allow an md array to block all IO requests for a time, you
> could make that window irrelevant.

Well, I don't see where there's any window in which its degraded. If
one triggers a sync after adding in the spare and marking it as failed
then the spare will get a copy from the rest and new writes will also go
to it, no?

Ahh ..  I now recall that maybe I did this in practice for RAID5 simply
by running RAID5 over individual RAID1s already in degraded mode.  To
"replace" any of the disks one adds a mirror component to one of the
degraded RAID1s, waits till it syncs up, then fails and removes the
original component.  Hey presto - replacement without degradation.

Presumably that also works for RAID1. I.e. you run RAID1 over several
RAID1s already in degraded mode. To replace one of the disks you simply
add in the replacement to one of the "degraded" RAID1s. When it's
synced you fail out the original component.

Peter

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

