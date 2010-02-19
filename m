From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Why does one get mismatches?
Date: Fri, 19 Feb 2010 16:18:09 +0100
Message-ID: <20100219151809.GB4995@lazy.lzy>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
 <4B67451F.8040206@tmr.com>
 <20100202093738.44b4fece@notabene.brown>
 <4B684087.50001@tmr.com>
 <20100211161444.7a0ea7bb@notabene.brown>
 <20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
 <4B7B0D45.7040801@tmr.com>
 <6db64f7872286165ac1fd3436e9d6476@localhost>
 <20100218100547.7aecdc34@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100218100547.7aecdc34@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Steven Haigh <netwiz@crc.id.au>, Bill Davidsen <davidsen@tmr.com>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> When memory changes between being written to one device and to another, this
> does not cause corruption, only inconsistency.   Either the block will be
> written again consistently soon, or it will never be read.

well, is this for sure?
I mean, by design of the md subsystem.

Or it is like that because we trust the filesystem?

And why it is like that? Why not to use the good old
readers-writer mechanism to make sure all blocks are
the same, when they're are written (namely lock).

It seems to me, maybe I'm wrong, not a so safe design.

I assume, it should not be possible to cause this
situation, unless there is a crash or a bug in the
md layer.

What if a new filesystem will write a block, changing
on the fly, i.e. during RAID-1 writes, and then, later,
reading this block again?

It will get, maybe, not the correct data.

In other words, would it be better, for the md layer,
to be robust against these kind of threats?

bye,

-- 

piergiorgio
