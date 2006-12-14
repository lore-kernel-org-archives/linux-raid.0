From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent Filesystems
Date: Thu, 14 Dec 2006 18:44:18 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0612141828220.8234@compserv1>
References: <Pine.GSO.4.53.0612122217360.22195@compserv1>
 <200612141412.30686.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <200612141412.30686.a1426z@gawab.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > We started the project in April 2004.  Right now I am using it as my
> > /home/kolya file system at home.  We believe that at this stage RAIF is
> > mature enough for others to try it out.  The code is available at:
> >
> > 	<ftp://ftp.fsl.cs.sunysb.edu/pub/raif/>
> >
> > The code requires no kernel patches and compiles for a wide range of
> > kernels as a module.  The latest kernel we used it for is 2.6.13 and we
> > are in the process of porting it to 2.6.19.
> >
> > We will be happy to hear your back.
>
> When removing a file from the underlying branch, the oops below happens.
> Wouldn't it be possible to just fail the branch instead of oopsing?

This is a known problem of all Linux stackable file systems.  Users are
not supposed to change the file systems below mounted stackable file
systems (but they can read them).  One of the ways to enforce it is to use
overlay mounts.  For example, mount the lower file systems at
/raif/b0 ... /raif/bN and then mount RAIF at /raif.  Stackable file
systems recently started getting into the kernel and we hope that there
will be a better solution for this problem in the future.  Having said
that, you are right: failing the branch would be the right thing to do.

Nikolai.
---------------------
Nikolai Joukov, Ph.D.
Filesystems and Storage Laboratory
Stony Brook University
