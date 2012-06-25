From: Christian Balzer <chibi@gol.com>
Subject: Re: linux-image-2.6.32-5-686: kernel BUG at ...
 build/source_i386_none/drivers/md/raid5.c:2764!
Date: Mon, 25 Jun 2012 11:58:33 +0900
Message-ID: <20120625115833.71190b7e@batzmaru.gol.ad.jp>
References: <20120622121953.GA25149@calhariz.com>
	<20120624182146.7d63fbbb@notabene.brown>
	<20120624170234.GA13154@calhariz.com>
	<20120625123906.2c302212@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120625123906.2c302212@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 25 Jun 2012 12:39:06 +1000 NeilBrown wrote:

> On Sun, 24 Jun 2012 18:02:34 +0100 Jose Manuel dos Santos Calhariz
> <jose.spam@netvisao.pt> wrote:
> 
> > On Sun, Jun 24, 2012 at 06:21:46PM +1000, NeilBrown wrote:
> > > On Fri, 22 Jun 2012 13:19:53 +0100 Jose Manuel dos Santos Calhariz
> > > <jose.spam@netvisao.pt> wrote:
> > > 
> > > > 
> > > > In another day during the periodic mdadm RAID check: 
> > > >  - the linux kernel gave a kernel BUG, 
> > > >  - tried to kick out a failed disk and 
> > > >  - stopped accepting I/O to the affected raid.  
> > > > 
> > > > The affected programs were in state D.  The only way to recover
> > > > was to do a reboot.  After reboot the problematic disk was
> > > > replaced.
> > > > 
> > > > I reported the bug to Debian and is there all the information
> > > > about it:
> > > > 
> > > > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=675969
> > > > 
> > > > I was asked to report the BUG here in case someone knows what
> > > > happened.
> > > > 
> > > > Here is a summary of the more relevant information:
> > > > 
> > > > This machine have 2 x RAID6 with 6 disks each, for a total of 12
> > > > disks. 
> > > > 
> > > > I have 5 systems with a similar setup and only one failed, maybe
> > > > because of the failing disk.  I will use one of the systems to try
> > > > to reproduce the bug, before triyng a new kernel.
> > > > 
> > > > 
> > > > The proprietary module is the openafs filesystem v1.6.1 backported
> > > > from Debian testing.
> > > > 
> > > > The kernel bug is:
> > > > 
> > > > 
> > > > build/source_i386_none/drivers/md/raid5.c:2764!
> > 
> > > 
> > > This bug was fixed in 2.6.32.49 and 3.2
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=61d433c479a6ccfed6a7e73e6111ca8fa0348c63
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=9a3f530f39f4490eaa18b02719fb74ce5f4d2d86
> > > 
> > > NeilBrown
> > 
> > The failing kernel had that fix all ready.  The machine was running
> > the kernel Debian 2.6.32-41squeeze2.  Looking into the change log,
> > this kernel have all the fixes until 2.6.32.51 plus other fixes.
> > 
> >      Jose Calhariz
> > 
> 
> The oops report said:
> 
> (2.6.32-5-686 #1)
> 
> is "5" the same as "41squeeze2" ???  This is a genuine question - I have
> little idea about Debian versioning so maybe these are the same thing
> somehow.  But they look different.
> 
Yes, the "name' of the kernel and it's actual detail version are disjunct
like that in Debian, the current kernel of that vintage is:
---
Package: linux-image-2.6.32-5-amd64
Source: linux-2.6
Version: 2.6.32-44
---

Regards,

Christian
-- 
Christian Balzer        Network/Systems Engineer                
chibi@gol.com   	Global OnLine Japan/Fusion Communications
http://www.gol.com/
