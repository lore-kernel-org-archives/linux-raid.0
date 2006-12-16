From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent Filesystems
Date: Sat, 16 Dec 2006 12:57:27 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0612161240380.24531@compserv1>
References: <OFCB8FCFF5.BA0A74ED-ON88257246.0000FE7C-88257246.0001E5FD@us.ibm.com>
 <200612160946.20535.edt@aei.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <200612160946.20535.edt@aei.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ed Tomlinson <edt@aei.ca>
Cc: Bryan Henderson <hbryan@us.ibm.com>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Friday 15 December 2006 19:20, Bryan Henderson wrote:
> > >The idea behind the cloneset is that most of the blocks (or files)
> > >do not change in either source or target.  This being the case its only
> > necessary
> > >to update the changed elements.  This means updates are incremental. Once
> > >the system has figured out what it needs to update its usable and if you
> > access
> > >an element that should be updated you will see the correctly updated
> > version - even
> > >though backgound resyncing is still in progress.
> >
> > I still can't tell what you're describing.  With RAID1 as well, only
> > changed elements ever get updated.  I have two identical filesystems,
> > members of a RAIF set.  I change one file.  One file in each member
> > filesystem gets updated, and I again have two identical filesystems.
>
> A cloneset is only syncronized at the point in time that you tell it to resync.
> The source and target fs are useable independently.  When you resync the
> target is reset to be indentical to the source at the point in time of the sync.
> Its also immediatly useable - the sync and access to the source and target
> are coordinated so users of the target see the correct data, even if the sync
> is still running in background.
>
> This allows things likes:
> set oracle in backup mode
> resync cloneset (this takes about 2 mins for a 2TB cloneset)
> set oracle out of backup mode
> (resyncing is still happening in background but accessing the cloneset gives a
> consistant image)
> backup oracle using cloneset files
> or
> start an instance of oracle using cloneset files (handly for a ro copy or if the main instance
> needs certian types of service)
>
> The overhead of the resync is minimized since it only updates the delta.  When
> dealing with 2TB of data this is an important feature, reducing IO.  You can
> only ask for a resync if the bg process from a previous resync is finished.

Although, it is not possible with the current code, it should be possible
to do via failing the branches.  First, you fail the branch intended for
backups and it becomes a backup copy.  Later you can "unfail" the same
branch and fail the newer branch to start the on-line recovery.  If you
enable atime updates on these lower file systems incremental (delta)
updates should not be a problem.

So I guess that if there is a demand for this functionality it won't be a
problem to implement it and automate it.

Nikolai.
---------------------
Nikolai Joukov, Ph.D.
Filesystems and Storage Laboratory
Stony Brook University
