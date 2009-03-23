From: Nifty Fedora Mitch <niftyfedora@niftyegg.com>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Mon, 23 Mar 2009 13:20:43 -0700
Message-ID: <20090323202043.GA3841@compegg.wr.niftyegg.com>
References: <87ljr4hsk9.fsf@frosties.localdomain> <18882.54987.332211.49180@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18882.54987.332211.49180@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Tuesday March 17, goswin-v-b@web.de wrote:
> > Hi,
> > 
> > I'm wondering why the kernel requires a raid6 to have at least 4
> > disks (of which at most 2 can be missing). Why not 3 disks?

I should think that this is the 'defination' of a raid6.
If you build a raid6 resource it should be raid6 and
as such be able to tolerate the loss of two disks
and all the other raid6 properties.

If you build a raidN with three disks that can tolerate the
loss of one disk it is not raid6 but raid5 and should be called
by the correct descriptive name.

The importance of this strictness surfaces in documentation.   
Both to the system admin working on the system and also
documentation from the system admin to his management that
is comparing prices and matching features.   i.e. "Bob's raid6 
is 25% less costly than Fred's".   Truth in advertising comes
to play.

Hidden in this thread is an interesting notion of migration from a
"lesser" raid to a more durable raid over time.   It might make sense to
facilitate limited tools to this end.   Even for those sites that wish to stage
the construction of a large raid install or to stagger the poweron hours
and date codes of drives on the common notion that batches of drives
fail together.  Or perhaps a "raid6 ready" raid5 that gets populated with
the absent drive on the first statistical sniff of an error outside of
the norm.  Or the arrival of warrenty expiration....

Such a "raidN ready" setup does confuse the notion of operational health
for any monitoring tool and is likely a very bad idea for that reason alone.

This 2001 URL is interesting in the comments about how unfortunate the
choice of the world "level" was.
   http://www.pcguide.com/ref/hdd/perf/raid/levels/index.htm
also interesting is the coment about a vendor being sloppy
with the technical language.


-- 
	T o m  M i t c h e l l 
	Found me a new hat, now what?

