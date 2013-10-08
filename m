From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: imsm identification problem.  mdadm 3.3
Date: Tue, 8 Oct 2013 17:28:51 -0400
Message-ID: <20131008212851.GC21201@animx.eu.org>
References: <20131003022319.GA28770@animx.eu.org>
 <52544DB1.7020402@arcor.de>
Reply-To: Wakko Warner <wakko@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52544DB1.7020402@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Please keep me in CC.

Martin Wilck wrote:
> On 10/03/2013 04:23 AM, Wakko Warner wrote:
> > 
> > I compiled v3.3 to see if the problem was still there.  It is.  The problem. 
> > I setup an imsm array with 2 volumes.  a 200mb raid10 volume, and a raid5 on
> > the remaining space.  This was done from the bios.
> > 
> > mdadm detected the array and volumes ok, but the names are wrong.  the 200mb
> > was named EFI and the other was named ani.
> > 
> > /dev/md127 is the imsm container.
> >        126 is the volume ani. (This is about 7tb.  disks are 3tb each and
> > still initializing)
> >        125 is the volume EFI.
> > 
> > According to --examine /dev/md127,
> > [EFI] UUID is ad256dcf:38ff8fed:8c27647e:24f61d81
> > [ani] UUID is 9fe3c18a:0e9e2d4f:613456ca:b9989dcc
> > 
> > However --detail --export /dev/md125 shows the name as ani with UUID
> > ad256dcf:38ff8fed:8c27647e:24f61d81 and --detail --export /dev/md126 shows
> > the name EFI with UUID 9fe3c18a:0e9e2d4f:613456ca:b9989dcc.
> > 
> > I did manually bring these up using mdadm 3.2.5-5 (Debian).  I don't remember
> > the exact commands off the top of my head, but they should be in my history if
> > needed.
> 
> Do I understand correctly, this is the situation after bringing up the
> array with mdadm 3.2.5, you are just looking at the state of affairs
> with mdadm 3.3? If yes, I wouldn't expect any difference between the
> output of mdadm 3.3 and 3.2.5. Both just reflect the current state of md
> in the kernel (MD_DEVNAME is just the device name the array has under
> /dev/md).

Ok, I wasn't sure.  I believe I did assemble with 3.2.5 but not with 3.3.

This was a set of test disks.  I'm not concerned with any data.

When I boot this system (mdadm has not been setup to start arrays on this
system, or atleast it shouldn't be), what is the best way to assemble the
imsm arrays?

did an mdadm -Es >> /etc/mdadm/mdadm.conf and attempted to mdadm -As (which
didn't assemble anything).  I think that was with 3.2.5 as well.

If there is anything special that needs to go into mdadm.conf, please let me
know.

> In order to see if your problem is fixed with mdadm 3.3, you must
> assemble the array with 3.3 (and mdmon from 3.3 should be used as well).

mdmon should be disabled on the system I'm testing with.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
