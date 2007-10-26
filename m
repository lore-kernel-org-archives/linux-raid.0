From: Neil Brown <neilb@suse.de>
Subject: Re: Raid-10 mount at startup always has problem
Date: Fri, 26 Oct 2007 16:12:12 +1000
Message-ID: <18209.34108.317187.935813@notabene.brown>
References: <46D3147D.2040201@amfes.com>
	<46D49F1A.7030409@tmr.com>
	<46E4A39C.8040509@amfes.com>
	<46E4A5F0.9090407@sauce.co.nz>
	<46E4A7C3.1040902@amfes.com>
	<471F5542.3020504@amfes.com>
	<18208.13247.106651.142652@notabene.brown>
	<47209B40.1000807@amfes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Daniel L. Miller on Thursday October 25
Sender: linux-raid-owner@vger.kernel.org
To: "Daniel L. Miller" <dmiller@amfes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 25, dmiller@amfes.com wrote:
> Neil Brown wrote:
> > It might be worth finding out where mdadm is being run in the init
> > scripts and add a "-v" flag, and redirecting stdout/stderr to some log
> > file.
> > e.g.
> >    mdadm -As  -v > /var/log/mdadm-$$ 2>&1
> >
> > And see if that leaves something useful in the log file.
> >
> >   
> I haven't rebooted yet, but here's my /etc/udev/rules.d/70-mdadm.rules
> file (BTW - running on Ubuntu 7.10 Gutsy):
> 
> SUBSYSTEM=="block", ACTION=="add|change",
> ENV{ID_FS_TYPE}=="linux_raid*", RUN+="watershed -i udev-mdadm
> /sbin/mdadm -As -v > /var/log/mdadm-$$ 2>&1"

Yes, that would do exactly what you are experiencing.
Every time a component of a raid array is discovered, it will try to
assemble all known arrays.
So one drive appears, it tries to assemble the array but there aren't
enough so it gives up.
Then two drives.  Chances are there still aren't enough, so it gives
up again.
Then when there are three drives it will successfully assemble the
array - degraded.

Then when there are 4 drives, it will be too late.  I cannot see why
that would lead to the "cannot update array info" error, but it
certainly explains the rest.

That is really bad stuff to have in udev.
The "--incremental" mode was written precisely for use in udev.  I
wonder why they didn't use it....

Maybe you should log a bug report with Ubuntu and suggest they discuss
their udev scripts with the developer of mdadm (that would be me I
guess).

NeilBrown
