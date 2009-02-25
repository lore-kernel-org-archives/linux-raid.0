From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Reliability of bitmapped resync
Date: Wed, 25 Feb 2009 19:51:02 +0100
Message-ID: <20090225185102.GA3444@lazy.lzy>
References: <20090223194019.GA3488@lazy.lzy> <b2460d0414270e6a6be4c91ec2d5a071.squirrel@neil.brown.name> <20090223201905.GA7585@lazy.lzy> <e3d195aab8b8de113e146e2932996777.squirrel@neil.brown.name> <20090223214016.GB18555@lazy.lzy> <16ff0082259ce384e30c4a7f9a0e66fb.squirrel@neil.brown.name> <20090224193931.GB3470@lazy.lzy> <18852.44880.811967.897554@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18852.44880.811967.897554@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> > How it could be 55.5% dirty? Is this expected?
> 
> This is a bug.  Is fixed by a patch that I have queued for 2.6.30.  As

ah! OK, good to know.

> I'm fairly use I have found the bug that caused the problem you first
> noticed.  It was introduced in 2.6.25.
> Below are two patches for raid10 which I have just submitted for
> 2.6.29 (As they can cause data corruption and so can jump the queue).
> 
> The first solves your problem.  The second solves a similar situation
> when the bitmap chunk size is smaller.
> 
> If you are able to test and confirm, that would be great.

I downloaded a random kernel (2.6.28.7), patched with
the first patch only (and the bitmap thing).
Then I was lucky enough to have another HD missing
at boot (sigh! It seems the PSU has a bad mood), so I
could immediatly try the bitmap resync (after a second
reboot, of course).
It seems it worked fine.
After the (relativley short) resync, I checked the array
and no mismatches were found.
I had only one test, I hope it is OK.

There is only one thing I noticed.
I was under the impression that, previously, the
"dirty" bits of the bitmap were cleared during
the resync, while now there were all cleared at
the end.
 
> Thanks a lot for reporting the problem and following through!

Nothing, is also in my interest... :-)
Thanks for the quick solution.

Question about the second patch.
Is it really meaningful to have the possibility
of a bitmap chunk smaller than a RAID chunk?

My understanding is that the data "quantum" is a
RAID chunk, so why to be able to track changes
at sub-chunk level?
Maybe constraining the bitmap chunk to an integer
multiple of the RAID chunk would help in having
a simpler and cleaner code, while it will not
bring big disadvantages.

Just my 2 cents...

bye,

-- 

piergiorgio
