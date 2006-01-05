From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Thu, 5 Jan 2006 11:31:49 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0601051127470.30112@lion.drogon.net>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
 <fd8d0180601050106s5f5b4306o@mail.gmail.com>  <87oe2r2d93.fsf@rimspace.net>
 <fd8d0180601050321k19f12f53r@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180601050321k19f12f53r@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 5 Jan 2006, Francois Barre wrote:

> Well, anyway, thanks for the advice. Guess I'll have to stay on ext3
> if I don't want to have nightmares...

And you can always mount it as ext2 if you think the journal is corrupt.

Have you considered Raid-6 rather than R5?

The biggest worry I have is having a 2nd disk fail during a
reconstruction. True, you lose another disks worth of space, but disk is
cheap these days, right? :)

Especially with 12 disks in the array.

What I do now is do a read-only badblocks test on all the
drives/partitions in a set if I ever have a drive failure. That way I will
know in advance if a disk is going to fail during the reconstruction -
however, this takes time (and can severely impact performance) but
hopefully the time window between checking the disks and the
reconstruction would be small enough that another disk shouldn't go
faulty...

Gordon
