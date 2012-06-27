From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: Stacked array data recovery
Date: Wed, 27 Jun 2012 11:07:24 +0200
Message-ID: <1340788044.3420.8.camel@hoferr-desktop.hofer.rummelring>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org>
	  <4FE5B213.5010503@hardwarefreak.com> <js70ce$fgv$1@dough.gmane.org>
	  <4FE72053.4040101@hardwarefreak.com> <4FE7E044.6040506@hardwarefreak.com>
	  <js9emr$761$1@dough.gmane.org> <4FE91619.4020709@hardwarefreak.com>
	 <1340699839.3241.29.camel@hoferr-desktop.hofer.rummelring>
	 <4FEA1A4F.9090605@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FEA1A4F.9090605@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Die, 2012-06-26 at 15:23 -0500, Stan Hoeppner wrote:
> On 6/26/2012 3:37 AM, Ramon Hofer wrote:
> 
> > Btw I ran the four dd commands within a screen session if this is of any
> > importance?
> 
> Can you get to that screen session?  Recall I showed you the output you
> should have seen when each dd command completed?  Did you see four such
> sets of output in the screen session?

I was able to get into the screen session but the output wasn't shown.
It seemed as if all four commands were still running.
top showed the dd commands as well but I'm not sure if each four were
still running.


> Regardless, unless the dd commands hung in some way, they should not
> show up in top right now.  So it's probably safe to assume they completed.

How long would it approximately take for the dd command to clear the
drive?
Can I assume a write rate of 100 MB/s?
With a disk size of 2 TB thid should take about 6 hours?
I think I'll let it run again this evening so that it can complete until
the next day.


> So at this point you can try creating the RAID5 array again.  If the dd
> command did what we wanted, /dev/sdk should have remapped the bad
> sector, and you shouldn't get the error kicking that drive.  If you
> still do, you may need to replace the drive.

I'm not sure if I didn't kille the dd command too early.
Maybe it's better to let it run again. Maybe even each disk at once?
Maybe this would already tell if a disk is faulty?


Cheers
Ramon



