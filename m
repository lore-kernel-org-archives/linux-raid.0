From: Gordon Henderson <gordon@drogon.net>
Subject: Re: No response?
Date: Thu, 20 Jan 2005 18:14:26 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501201805070.12589@lion.drogon.net>
References: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0501201052240.19586@lewis.et.byu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: David Dougall <davidd@et.byu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 20 Jan 2005, David Dougall wrote:

> Perhaps I was asking a stupid question or an obvious one, but I have
> received not response.
> Maybe if I simplify the question...
>
> If I am running software raid1 and a disk device starts throwing I/O
> errors, Is the filesystem supposed to see any indication of this?

No..

>  I
> thought software raid would mask all of this and just fail the drive.

It should.

> I have servers with xfs as the filesystem and xfs will start to throw I/O
> errors when a disk starts acting up even with software raid in between.
> Please advise on how I can confirm my setup or if this is possibly a bug
> how to diagnose further.

I've experienced long delays (30 seconds? It seemed longer) in a system
when a disk fails for a genuine reason - (I've deliberately run badblocks
on an md device when I knew one of the underlying devices had genuine bad
blocks) maybe the md code really tries hard to read the block, maybe the
underlying device driver tries really hard), but in these cases, I've seen
the system more or less freeze (all processes accessing that device
anyway) until the raid code decided to kick the device out of the array.

Maybe XFS has a timer and doesn't like devices to "go away" for a long
period of time?

> If it makes a difference, I am running linux-2.4.26

I've used 2.4.x for a long time - I did try xfs about a year ago, but
wasn't happy with it all (for various reasons).

Gordon
