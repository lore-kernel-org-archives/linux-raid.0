From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID without superblock
Date: Sun, 19 Apr 2009 23:04:07 +0200
Message-ID: <20090419210200.GA6942@lazy.lzy>
References: <20090419114743.GA29195@lazy.lzy> <e96b335a0ba8595e2921d164f9b15ff7.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e96b335a0ba8595e2921d164f9b15ff7.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

thanks for the answer.

> Why would you want a RAID-1 without superblock. I generally
> consider that a legacy configuration.

Ah! I was thinking about it as a method to
build a RAID with an already existing disk
or partition, which cannot be modified.
So, let's say I've already a disk with some
data and I want/need to protect it with a
RAID configuration, but I cannot re-create
the RAID from scratch, because this will
damage the content of the disk.
Of course, if there is another solution,
like having the superblock on a separate
file, it would be nice too.
BTW, have you ever consider that?

> As there is no superblock, md cannot tell if the array is "clean"
> or not.  It assumes the worst.
> If you know for a fact that the two mirrors are consistent,
> then tell mdadm with "--assume-clean".

Uhm, no, it is not clean, but one of the two
has the correct data, the other no.
Is the "-B" always copying from the first to
the second or else?
For example, I found consistent to create the
array with the correct disk and "missing",
then add the mirror.
Of course, if there is a known order for the
resync, then it would be enough to build
the array with this in mind.
The issue could also be that the "primary"
disk could be updated alone, sometimes.

> A bitmap (which has to be in a separate file) can be use

Of course, it is a separate file... :-)

> to record the clean/dirty status.  It provides some of the same
> functionality as a superblock.  But it is not a complete replacement.

OK, this is clear.
 
> To quote from the man page:
> 
>         Because of this, the Build mode should only be used
>         together with a complete understanding of what you are doing.

Exactly, I ran into that sentence, that's why
I'm asking, I try to get the full understanding
in order to see if I can use this "feature"...

In any case, if this is "legacy", maybe better
to forget about it.

Thanks again,

bye,

-- 

piergiorgio
