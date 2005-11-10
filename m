From: Neil Brown <neilb@suse.de>
Subject: Re: Still Need Help on mdadm and udev
Date: Thu, 10 Nov 2005 17:48:15 +1100
Message-ID: <17266.60719.545745.800152@cse.unsw.edu.au>
References: <1200.146.115.27.35.1131563572.squirrel@webmail.editshare.com>
	<1235.146.115.27.35.1131564483.squirrel@webmail.editshare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from andyliebman@editshare.com on Wednesday November 9
Sender: linux-raid-owner@vger.kernel.org
To: andyliebman@editshare.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 9, andyliebman@editshare.com wrote:
> > Okay,
> >
> > PLEASE somebody who knows answer the following:
> >
> > 1)  what is the difference between running
> >
> >              mdadm -A -ayes 1/dev/md1--uuid=xxxxx /dev/sd*
> >
> >     and
> >
> >              mdadm -A -amd 1/dev/md1 --uuid=xxxxx /dev/sd*
> >
> >
> >     In other words, how do the "yes" and "md" options behave
> >     differently.

 From 'man mdadm'

       -a, --auto{=no,yes,md,mdp,part,p}{NN}
              Instruct mdadm to create the device file if needed, possibly allocat-
              ing an unused minor number.  "md" causes a non-partitionable array to
              be  used.  "mdp", "part" or "p" causes a partitionable array (2.6 and
              later) to be used.  "yes" requires the named md device to have a from
              this.  See DEVICE NAMES below.

Hmmm. there is some text missing there.  It should read:

       -a, --auto{=no,yes,md,mdp,part,p}{NN}
              Instruct  mdadm  to  create  the device file if needed, possibly
              allocating an unused minor number.  "md" causes a non-partition-
              able array to be used.  "mdp", "part" or "p" causes a partition-
              able array (2.6 and later) to be used.  "yes" requires the named
              md  device  to  have a 'standard' format, and the type and minor
              number will be determined from this.  See DEVICE NAMES below.

(typo in the mdadm.8 source file).

Does that help?

> >
> >
> > 2)  If you create an array /dev/md0 with mdadm, is there any reason why
> > you shouldn't start it as /dev/md1?

No technical reason.  This works perfectly.


> >
> > The second option above (-amd 1) would NOT start an array that was created
> > as /dev/md0 (under an older mdadm -- 1.8.? ) whereas the first option
> > (-ayes /dev/md1) had no difficulty.
> >
> > Thank you.
> > Andy Liebman
> >
> >
> 
> Sorry, my bad:
> 
> I meant to give as my examples:
> 
>       mdadm -A -amd 1 --uuid=xxxxx /dev/sd*

This is wrong.  It will create a device files called '1' in the
current directory (assuming it works at all).

> 
>    and
> 
>       mdadm -A -ayes /dev/md1 --uuid=xxxxx /dev/sd*

Given that /dev/md1 is a 'standard' format name, this will have the
same effect as "-amd /dev/md1".  You only get the difference when you
want to use a name like "/dev/md/home" or "/dev/swap", in which case,
"-ayes" isn't allowed as mdadm cannot differentiate between
partitioned and not.


NeilBrown
