From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: Device state during an incremental assembly
Date: Sun, 21 Nov 2010 09:41:59 -0500
Message-ID: <20101121144159.GB29163@animx.eu.org>
References: <20101120015225.GA9625@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101121171948.4b793254@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > I am not on this list, please always CC me.

I am now.

> > Is there anyway to determine the array state after incrementally adding a
> > device?  I was hoping to find something in /sys but I was unable to.  I was
> > trying not to parse the output of mdadm for each invocation.

> Yes.

> Note: if you don't find that there is enough detail in this answer, it
> simply
> reflects the level of detail in the question :-)

I've been playing with incremental assembly on a test system and wanted to
have a way of knowing if the md device was in a state that it could be
started.  I'm working with a script that will assemble arrays for me and
possibly query if an array should be started if it hasn't.

For instance.

Lets say that I have a 4 disk array (In my case, raid level is really of no
importance, but if we must, assume this is raid5).  The array was setup as
/dev/md0.

I run mdadm -I /dev/sda1

Obviously, this is not enough to start the array even in degraded mode.  At
this point, is there a way to know if the array could be started and usable
without parsing the output of mdadm?

Next, mdadm -I /dev/sdb1
Still not enough.
Next, mdadm -I /dev/sdc1
At this point, I could start the array in degraded.  This is what I'd like
to beable to query from beneath /sys/block/md0 or some where else.

And of course, mdadm -I /dev/sdd1
makes the array fully active.

P.S. cantor2.suse.de[195.135.220.15] does pipelining even if pipelining
wasn't performed.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
