From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent Filesystems
Date: Fri, 22 Dec 2006 22:21:47 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0612222206170.10362@compserv1>
References: <Pine.GSO.4.53.0612122217360.22195@compserv1>
 <200612161635.49502.a1426z@gawab.com> <Pine.GSO.4.53.0612161118010.24531@compserv1>
 <200612172059.07941.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200612172059.07941.a1426z@gawab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > 3. A known ideal solution for this problem is sharing of the cached pages
> >    between file systems.  We attempted to do it for Tracefs but the
> >    resulting code is not beautiful and is potentially racy:
> >    <http://marc.theaimsgroup.com/?l=linux-fsdevel&m=113193082115222&w=2>
> >    Unfortunately, for fan-out file systems this solution requires even
> >    more support from the OS.  However, this is what most OSs do
> >    (including BSD and Windows) but unfortunately not Linux :-(
>
> VFS-hooks seem to be the cleanest solution not only for a stacked-fs, but
> also for many other situations.  It's rather sad that linux hasn't seen the
> light yet.

Jeff Sipek just got his proposal for a paper/discussion topic accepted to
the Linux Storage and Filesystems workshop, co-located with FAST.  The
topic for discussion will be what "surgery" the Linux kernel needs to
support stackable file systems properly.  I hope it is an indicator that
the situation with support of the stackable file systems in Linux may
improve soon.

Nikolai.
