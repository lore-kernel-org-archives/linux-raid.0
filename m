From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: No response?
Date: Thu, 20 Jan 2005 19:12:40 +0100
Message-ID: <ot85c2-es9.ln1@news.it.uc3m.es>
References: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Dougall <davidd@et.byu.edu> wrote:
> If I am running software raid1 and a disk device starts throwing I/O
> errors, Is the filesystem supposed to see any indication of this?  I

No - not if the error is on only one disk. The first error will fault
the disk from the array and the driver will retry the read, and must
retry from another disk (the first is no longer there).

The actual i/o to the disks does not form part of the i/o to the raid
array itself, so there is little chance of contamination between the
two. The raid i/o is only acked back to the user when one of the disk 
i/o's (on read) has succeeded.

> thought software raid would mask all of this and just fail the drive.
> 
> I have servers with xfs as the filesystem and xfs will start to throw I/O
> errors when a disk starts acting up even with software raid in between.

That's strange. But not impossible - coding for error situations is
always difficult, and more difficult to test.

> If it makes a difference, I am running linux-2.4.26

Peter

