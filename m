From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent Filesystems
Date: Mon, 25 Dec 2006 10:13:10 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0612250942340.25572@compserv1>
References: <OF582D7197.D6F604B1-ON88257248.0069CC60-88257248.006AE165@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OF582D7197.D6F604B1-ON88257248.0069CC60-88257248.006AE165@us.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> > Every stackable file system caches the data at its own level and
> > copies it from/to the lower file system's cached pages when necessary.
> > ...
> > this effectively reduces the system's cache memory size by two or more
> > times.
>
> It should not be that bad with a decent cache replacement policy; I
> wonder if observing the problem (that you corrected in the various ways
> you've described), you got some insight as to what exactly was happening.

I agree that appropriate replacement policies can partially eliminate
the double caching problem for stackable file systems.  In fact, that's
exactly what RAIF does: it forces the data pages of the lower file
systems to be evicted right after they are written and are not needed
anymore.  This solves the problem for most write-intensive workloads.
Without this optimization the situation is much worse because Linux is
trying to protect caches of different file systems from each other.  But,
as you mentioned, any cache replacement policy is optimized for some set
of workloads and is bad for some other set of workloads.  Also, caching
the data at multiple layers not just increases the memory consumption but
also adds CPU time overheads because of the data copying between the
pages.  I believe that the real solution to the problem is the ability to
share data pages between file systems.

Nikolai.
