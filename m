From: "Calvin Webster" <cwebster@ec.rr.com>
Subject: RE: Software RAID Stopped Working With Aurora Kernel
Date: Wed, 29 May 2002 09:07:09 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <CPEAKNIMKMJOCFPEOBGAMEDNCFAA.cwebster@ec.rr.com>
References: <15601.48418.82978.28645@notabene.cse.unsw.edu.au>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15601.48418.82978.28645@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Neil Brown
> Sent: Monday, May 27, 2002 12:59 AM
> To: cwebster@ec.rr.com
> Cc: linux-raid
> Subject: Re: Software RAID Stopped Working With Aurora Kernel
>
>
> On Wednesday May 22, cwebster@ec.rr.com wrote:
> >
> > There were a few other minor inconsistencies that I thought you might be
> > interested in between the output of "mdadm" and that of "lsraid" from
> > the new raidtools.
> >
> >
> > "mdadm --examine /dev/sda1" shows "State : dirty, no-errors". All other
> > RAID drives show the same.
> >
> > "lsraid -D -a /dev/md0" shows "state		= good".
> All other RAID devices
> > show the same.
>
> I have never looked at "lsraid".  My guess is that "good" is
> equivalent to "no-errors" and that lsraid doesn't bother to report
> "dirty".  This shouldn't relate to the filesystem superblock though...
>  still, a fsck every few months is a good idea.

What made this observation noteworthy, however, was that it persisted even
_after_ e2fsck was run on /dev/md0.

--Cal Webster

