From: Maurilio Longo <maurilio.longo@libero.it>
Subject: Re: Bad blocks are killing us!
Date: Tue, 16 Nov 2004 17:28:47 +0100
Message-ID: <419A2ABF.623A126A@libero.it>
References: <200411150522.iAF5MNN18341@www.watkins-home.com> <16793.11589.337840.541169@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Guy Watkins <guy@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown ha scritto:

> On Monday November 15, guy@watkins-home.com wrote:
> > Neil,
> >       This is a private email.  You can post it if you want.
> snip
> >
> >       Anyway, in the past there have been threads about correcting bad
> > blocks automatically within md.  I think a RAID1 patch was created that will
> > attempt to correct a bad block automatically.  Is it likely that you will
> > pursue this for RAID5 and maybe RAID6?  I hope so.
>
> My current plans for md are:

[...]

>
>  2/ Look at recovering from failed reads that can be fixed by a
>     write.  I am considering leveraging the "bitmap resync" stuff for
>     this.  With the bitmap stuff in place, you can let the kernel kick
>     out a drive that has a read error, let user-space have a quick
>     look at the drive and see if it might be a recoverable error, and
>     then give the drive back to the kernel.  It will then do a partial
>     resync based on the bitmap information, thus writing the bad
>     blocks, and all should be fine.  This would mean re-writing
>     several megabytes instead of a few sectors, but I don't think that
>     is a big cost.  There are a few issues that make it a bit less
>     trivial than that, but it will probably be my starting point.
>     The new "faulty" personality will allow this to be tested easily.
>

I think 2/ should go unattended for at least a few retries, then, if they all
fail, kick-out disk and/or call user-space program to see what's going on, I say
this because an occasional read error should not kick-out a disk or require user
intervention to fix it (as it is now).

And it seems to me that new disks have a lot of badsectors regardless their brand.

just my .02 euro cents :)

regards.


--
 __________
|  |  | |__| md2520@mclink.it
|_|_|_|____| Team OS/2 Italia


