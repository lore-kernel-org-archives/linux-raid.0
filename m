From: Mark Overmeer <Mark@Overmeer.net>
Subject: Re: Really fucked up raid0 array
Date: Tue, 6 Jul 2004 09:22:35 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040706092234.K31606@speeltuin.ATComputing.nl>
References: <40E93DFC.6070507@pulz.no> <200407051658.02492.maarten@ultratux.net> <40E96CA5.9030500@pulz.no> <200407052029.48810.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200407052029.48810.maarten@ultratux.net>; from maarten@ultratux.net on Mon, Jul 05, 2004 at 08:29:48PM +0200
To: maarten van den Berg <maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* maarten van den Berg (maarten@ultratux.net) [040705 20:22]:
> > >Maybe you cannot umount it because it's still in use ?  In that case, run
> > >'lsof | grep <mountpoint>' to see what resources use files on that
> > > mountpoint, and terminate these processes first.
> 
> > Way ahead of you.
> > lsof freeses to, so i arn't able to find out what is using the disk.
> >
> > All programs like:
> > ps
> > w
> > finger
> > who
> > lsof
> > ls
> >
> > and stuff like that freeses

What I recall from a little investigation way-back, when a hanging NFS
frooze the system all the time, this has to do with your mount-point...

Most program (I do not understand why, but really nearly all systems)
call getcwd(), to get their current working directory.  getcwd() is
quite silly... it does  cd ..; cd ..; cd .. until it arrives at /
and then it descends back into the tree based in the inodes of the
directories it encountered... this way, the absolute path (without
symbolic links) of the command is found.

Well, a problem appears when jumping up (with cd ..) over a mount point,
because the root inode of each file-system has number 2.  In that case,
descending back to figure out the path, the directory which contains the
i-node will need to be scanned in detail.  Each mount-point in that
directory will be asked for the device number.

Asking for a device number of a stale-NFS or RAID-set in an illegal state
may have different effects.  It is simply an implementation issue in the
driver.  In some cases it then blocks (waiting for NFS or RAID to come
up) and sometimes results in an error.  Both have their own advantage:
for instance, a network connection may be lost for a few seconds, and
you do not want all programs crash immediately because their NFS data
is lost.  But when a remote NFS server is down for a long time, you may
want to get an error as fast as possible.  Or at least you like to be
able to interrupt the waiting process (in traditional UNIX systems,
you cannot interrupt processes which are waiting in the kernel. NFS is
in the kernel, so you cannot interrupt processes waiting for a response
of the NFS server on those systems: stale NFS)

So, it is really smart (as general rule-of-thumb for the average UNIX
system) to have the mount-points of sub-systems/network systems away
from the tree with normal commands.  So: do not mount in /, but for
instance in /mnt.  Then, if you need to, simplify the path for the users
by creating symlinks.

    /home -> /mnt/home
    /mnt/home is RAID array mount-point

Ok, long story, which may or may not have any relation to your
problem.  However, the behavior you report is very charateric for
this problem.
-- 
               MarkOv

------------------------------------------------------------------------
drs Mark A.C.J. Overmeer                                MARKOV Solutions
       Mark@Overmeer.net                          solutions@overmeer.net
http://Mark.Overmeer.net                   http://solutions.overmeer.net
