From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] RAID-6 check standalone man page
Date: Tue, 9 Aug 2011 10:43:55 +1000
Message-ID: <20110809104355.7362af84@notabene.brown>
References: <20110321140244.2314b4b4@notabene.brown>
	<20110321104007.GA15379@lazy.lzy>
	<20110321220457.29d52f5c@notabene.brown>
	<20110321115440.GA15635@lazy.lzy>
	<20110322095905.737fb1d5@notabene.brown>
	<20110404175242.GA3411@lazy.lzy>
	<20110405091242.3427e0b1@notabene.brown>
	<20110508185408.GA25378@lazy.lzy>
	<20110509114500.116926ba@notabene.brown>
	<20110509184333.GA28743@lazy.lzy>
	<20110515211515.GA30260@lazy.lzy>
	<20110516200857.3a009a64@notabene.brown>
	<4E2716EF.1050509@nexgo.de>
	<20110726152523.54433754@notabene.brown>
	<4E3EC6E5.8050303@nexgo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E3EC6E5.8050303@nexgo.de>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 07 Aug 2011 19:09:57 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> On 07/26/2011 07:25 AM, NeilBrown wrote:
> > On Wed, 20 Jul 2011 19:57:03 +0200 Piergiorgio Sartor
> > <piergiorgio.sartor@nexgo.de> wrote:
> > 
> >> Hi Neil,
> >>
> >> sorry for the very late answer.
> >>
> >> On 05/16/2011 12:08 PM, NeilBrown wrote:
> >>> On Sun, 15 May 2011 23:15:15 +0200 Piergiorgio Sartor
> >>> <piergiorgio.sartor@nexgo.de> wrote:
> >>>
> >>>> Hi Neil,
> >>>>
> >>>> reminder for the suspend patch.
> >>>>
> >>>> Thank you so much for the code review.
> >>>>
> >>>> I modified it in order to fix, hopefully, all the flaws.
> >>>>
> >>>> New patch attached below.
> >>>>
> >>>> Please note that "sigblock()" cannot be used, since it is
> >>>> declared, at least on my system, as "deprecated".
> >>>> Furthermore, I noticed that "Grow.c" is not checking the
> >>>> return value of "sysfs_set_num()" while suspending the
> >>>> array, maybe you'll need to look at this.
> >>>>
> >>>> Finally, please check the new patch too, while I can
> >>>> confirm the software is doing what is supposed to do,
> >>>> I still need support in order to confirm the suspend
> >>>> and resume code.
> >>>>
> >>>> Thanks again for your help, again let me know what
> >>>> is the next expected step.
> >>>
> >>> That all looks fine thank.  I've applied it and pushed it out.
> >>>
> >>> I'm not sure what you mean exactly by the 'next expected step'... 
> >>
> >> Well, is there anything than should be done, like
> >> documentation or code cleanup?
> >>
> >> At the moment, it seems to me, the check itself it is
> >> fine, maybe performance is not at best (anyone wants
> >> to help, here?).
> >>
> >> So, I was thinking about the "repair" process, that is
> >> fixing the chunks which seem corrupted, instead of just
> >> the parity.
> >>
> >> Before I go that way, I would like to close pending issues,
> >> if any, with the actual software.
> > 
> > Very sensible - thanks.
> > 
> > I haven't actually used it or tested it at all so I don't know of any issues
> > in that regard.
> > I agree with an earlier reply that a man-page would be a good idea.
> > You could start by looking at "mdadm.8.in" and basing your man page on that.
> > It doesn't have to be very long - just explain what it does and how to use
> > it, and maybe how to interpret the results.
> > Often writing a man page is enough to flush out any serious usability issues
> > - if you find it hard to explain how to use it, it is probably because it is
> > hard to use :-)
> > 
> > If you aren't familiar with the troff -man markup language don't let it worry
> > you - I am happy to fix up any markup issues before including it.
> > 
> > It might be good to create a test script too - something that can go in the
> > tests/ directory would be ideal.
> > e.g. create and initialise a RAID6, deliberately corrupt one block, then run
> > your program an check that it reports the right thing.
> > Probably corrupt a different blocks (randomly?) on each device and test that
> > it reports all of the errors correctly... something like that.
> > 
> > NeilBrown
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Hi Neil,
> 
> please find below a draft of the man page (as patch) for raid6check.
> Please have a look and let me know any issues (typos for sure).
> 
> The test cases will come later.
> 
> --- cut here ---
> 
> diff -uNr a/raid6check.8.in b/raid6check.8.in
> --- a/raid6check.8.in	1970-01-01 01:00:00.000000000 +0100
> +++ b/raid6check.8.in	2011-08-07 19:04:17.352680683 +0200
> @@ -0,0 +1,101 @@
> +.\" -*- nroff -*-
> +.\" Copyright Piergiorgio Sartor and others.
> +.\"   This program is free software; you can redistribute it and/or modify
> +.\"   it under the terms of the GNU General Public License as published by
> +.\"   the Free Software Foundation; either version 2 of the License, or
> +.\"   (at your option) any later version.
> +.\" See file COPYING in distribution for details.
> +.TH RAID6CHECK 8 "" v1.0.0
> +.SH NAME
> +raid6check \- check MD RAID6 device for errors
> +.I aka
> +Linux Software RAID
> +
> +.SH SYNOPSIS
> +
> +.BI raid6check " <raid6 device> <start stripe> <number of stripes>"
> +
> +.SH DESCRIPTION
> +RAID 6 devices in which one single component drive has errors can use
> +the double parity in order to find out the component drive.
> +The "raid6check" tool checks, for each stripe, the double parity
> +consistency and, it reports mismatches and, if possible, which
> +component drive has the mismatch.
> +Since it works at stripe level, it can report different drives with
> +mismatches at different stripes.
> +
> +"raid6check" requires a non-degraded RAID 6 MD device, as first
> +parameter, a starting stripe, usually 0, and the number of stripes
> +to be checked.
> +If this third parameter is also 0, it will check the array up to
> +the end.
> +
> +"raid6check" will start printing information about the RAID 6, then
> +for each stripe, it will report the parity rotation status.
> +In case of parity mismatches, "raid6check" reports, if possible,
> +which component drive could be responsible. Otherwise it reports
> +that it is not possible to find the component drive.
> +
> +If the given MD device is not a RAID 6, "raid6check" will, of
> +course, not continue.
> +
> +If the RAID6 MD device is degraded, "raid6check" will report
> +an error and it will not proceed further.
> +
> +No write operation are performed on the array or the components.
> +Furthermore, the checked array can be online and in use during
> +the operation of "raid6check".
> +
> +.SH EXAMPLES
> +
> +.B "  raid6check /dev/md0 0 0"
> +.br
> +This will check /dev/md0 from start to end.
> +
> +.B "  raid6check /dev/md3 0 1"
> +.br
> +This will check the first stripe of /dev/md3.
> +
> +.B "  raid6check /dev/md1 1000 0"
> +.br
> +This will check /dev/md1 from stripe 1000 up to the end.
> +
> +.B "  raid6check /dev/m127 128 256"
> +.br
> +This will check 256 stripes of /dev/md127 starting from stripe 128.
> +
> +.B "  raid6check /dev/md0 0 0 | grep -i error > md0_err.log"
> +.br
> +This will check /dev/md0 completely and create a log file only
> +with errors, if any.
> +
> +.SH FILES
> +
> +"raid6check" uses directly the component drives as found in /dev.
> +Furthermore, the sysfs interface is needed in order to find out
> +the RAID 6 parameters.
> +
> +.SH BUGS
> +Negative parameters can lead to unexpected results.
> +
> +It is not clear what will happen if the RAID 6 MD device gets
> +degraded during the check.
> +
> +.PP
> +The latest version of
> +.I raid6check
> +should always be available from
> +.IP
> +.B http://www.kernel.org/pub/linux/utils/raid/mdadm/
> +.PP
> +Related man pages:
> +.PP
> +.IR mdadm (8)
> +.IR mdmon (8),
> +.IR mdadm.conf (5),
> +.IR md (4).
> +.PP
> +.IR raidtab (5),
> +.IR raid0run (8),
> +.IR raidstop (8),
> +.IR mkraid (8).
> 
> --- cut here ---
> 


Thanks.
I've made few changes as follow - mostly "RAID 6" to "RAID6" for consistency
with other man pages.  I've also named the file "raid6check.8" (no ".in") and
added bits to the Makefile.

I was thinking that it might be good to restore the old interface as an
option.  i.e. to be able to list some devices explicitly even though they
aren't in an active array.  Occasionally people lose their metadata and this
could be used to confirm if a collection of devices in a particular order
really look like a RAID6.... Just a thought.

Thanks,
NeilBrown
