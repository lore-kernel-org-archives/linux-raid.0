From: Neil Brown <neilb@suse.de>
Subject: Re: Device state during an incremental assembly
Date: Mon, 22 Nov 2010 07:58:40 +1100
Message-ID: <20101122075840.1153b020@notabene.brown>
References: <20101120015225.GA9625@animx.eu.org>
	<20101121144159.GB29163@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101121144159.GB29163@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 21 Nov 2010 09:41:59 -0500
Wakko Warner <wakko@animx.eu.org> wrote:

> > > I am not on this list, please always CC me.
> 
> I am now.
> 
> > > Is there anyway to determine the array state after incrementally adding a
> > > device?  I was hoping to find something in /sys but I was unable to.  I was
> > > trying not to parse the output of mdadm for each invocation.
> 
> > Yes.
> 
> > Note: if you don't find that there is enough detail in this answer, it
> > simply
> > reflects the level of detail in the question :-)
> 
> I've been playing with incremental assembly on a test system and wanted to
> have a way of knowing if the md device was in a state that it could be
> started.  I'm working with a script that will assemble arrays for me and
> possibly query if an array should be started if it hasn't.
> 
> For instance.
> 
> Lets say that I have a 4 disk array (In my case, raid level is really of no
> importance, but if we must, assume this is raid5).  The array was setup as
> /dev/md0.
> 
> I run mdadm -I /dev/sda1
> 
> Obviously, this is not enough to start the array even in degraded mode.  At
> this point, is there a way to know if the array could be started and usable
> without parsing the output of mdadm?
> 
> Next, mdadm -I /dev/sdb1
> Still not enough.
> Next, mdadm -I /dev/sdc1
> At this point, I could start the array in degraded.  This is what I'd like
> to beable to query from beneath /sys/block/md0 or some where else.

Ahh.. In this case the answer is actually "no" - sorry.

The answer is a non-trivial function of:
  the raid level
  the number of available non-spare devices
  (for raid10) which slots the available non-spare devices fill.

All of this information is available in sysfs, and mdadm has code to perform
the computation and then take appropriate action.  But there is no simple way
to get this information.

Why do you want this information?  What action will you take depending on the
answer?
If you just want mdadm to assemble as soon a a degraded array is possible,
just use "mdadm -IR" - but I suspect you already know that.


> 
> And of course, mdadm -I /dev/sdd1
> makes the array fully active.
> 
> P.S. cantor2.suse.de[195.135.220.15] does pipelining even if pipelining
> wasn't performed.
I'm guessing this is a statement about SMTP? This would be why I got a bounce
 <wakko@animx.eu.org>: host veg.animx.eu.org[76.7.162.186] said: 554 SMTP
    synchronization error (in reply to MAIL FROM command)
to my original mail.
I guess suse.de is not being conservative in what it sends, and animx is not
being liberal in what it accepts...  Do you know what mail system is in use
on animx??

NeilBrown



> 

