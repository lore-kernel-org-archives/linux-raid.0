From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Broken RAID1 boot arrays
Date: Fri, 14 May 2010 07:43:28 -0500
Message-ID: <23.42.25297.5754DEB4@cdptpa-omtalb.mail.rr.com>
References: <1273820935.5140.2770.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1273820935.5140.2770.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: 'Daniel Reurich' <daniel@centurion.net.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > > What type of filesystem is it?
> > >
> > > Try "mount -v /dev/md1 /"
> 
> Sorry.  Should have been "mount -v /dev/md1 /target" - assuming /dev/md1
> is your root filesystem.

	Actually, /dev/md2 is root, but no, it wouldn't mount, no matter
what I tried.  What's more, now that I assembled the arrays under the Debian
live CD, Ubuntu will no longer assemble any of them.  Note the Ubuntu live
CD has an old version of mdadm (v2.6.7.1)


> > 	It doesn't matter what switches I try, it always gives me that
> > error.  The md1 array (/boot) is ext2, and the md2 array (/) is ext3.
 
> you did "mkdir /target"  didn't you?  Can verify it is there?

	Yes.

> > 	No, I'm not.  Remember?  I can't mount /target (/dev/md2) so I can't
> > chroot to it:
> >
> > ~ # chroot /target /bin/bash
> > chroot: cannot execute /bin/bash: No such file or directory
> >
> > 	Everything in your method requires me to be able to mount the / and
> > /boot file systems.  Hmm.  The only thing I can't do under the Ubuntu CD
> is
> > assemble and mount the swap, so this should work using the Ubuntu CD...

	'So much for that effort.  I think I'll try one of the other
suggested distros...


