From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Enable SCTERC in the kernel?
Date: Fri, 25 Oct 2013 18:29:33 +0200
Message-ID: <20131025162933.GA2231@lazy.lzy>
References: <1969984.qn2lKzvFd6@eseries.newtech.fi>
 <20131025214252.1929c7f1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131025214252.1929c7f1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: dag@newtech.fi, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 25, 2013 at 09:42:52PM +1100, NeilBrown wrote:
> On Fri, 25 Oct 2013 11:51 +0300 Dag Nygren <dag@newtech.fi> wrote:
> 
> > 
> > Hi all!
> > 
> > Just run into the standard problem by not having SCTERC enabled
> > for my drives due to a spelling mistake in my rc.local script
> > setting the parameters and started wondering:
> > 
> > - What if the md module automatically set this during assembly
> > of the RAID? - In the kernel module itself. It could always set it,
> > if the set failed we could spit out a kernel warning that the used
> > drive might not be the best as a RAID device. Would there be any ill
> > effects from this?
> > - And ditto for the device time-out.
> > 
> > This would definitely make md work a lot better for people. I have a
> > strange feeling that most don't know the parameter needs setting...
> 
> I don't think it is appropriate for the kernel to automatically set such
> things.  However it might be appropriate for mdadm to do it when assembling
> or creating the array.

Actually, IMHO, "mdadm" should trigger an exernal
event, which, consequently, runs a script.

This is already in place, somehow, using "udev".

From a post, on this mailing list, of Sam Bingner:

I have written a simple udev rule calling a bash script to set the timeouts on all connected devices.
I would like to a) provide this to anybody who feels they may need it and b) know if anybody sees any
potential issues with this.
It seems to work fine for me over a couple reboots...

contents of udev rule:
ACTION=="add", SUBSYSTEM=="block", KERNEL=="[sh]d[a-z]", RUN+="/usr/local/bin/settimeout"

contents of /usr/local/bin/settimeout:
#!/bin/bash

[ "${ACTION}" == "add" ] && {
        /usr/sbin/smartctl -l scterc,70,70 ${DEVNAME} || echo 180 > /sys/${DEVPATH}/device/timeout
}

I guess, what is missing, is to connect the HDDs
with a specific "mdadm" event, instead of running
for each HDD.
I'm not sure if this is already possible, since
some "udev" rules for "md" are already existing.

bye,

pg

> I'm happy to review and  possibly accept patches.
> 
> NeilBrown



-- 

piergiorgio
