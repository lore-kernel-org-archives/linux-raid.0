From: Nikolai Joukov <kolya@cs.sunysb.edu>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent Filesystems
Date: Fri, 15 Dec 2006 20:20:02 -0500 (EST)
Message-ID: <Pine.GSO.4.53.0612152004080.10315@compserv1>
References: <OFCB8FCFF5.BA0A74ED-ON88257246.0000FE7C-88257246.0001E5FD@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OFCB8FCFF5.BA0A74ED-ON88257246.0000FE7C-88257246.0001E5FD@us.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Ed Tomlinson <edt@aei.ca>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> >The idea behind the cloneset is that most of the blocks (or files)
> >do not change in either source or target.  This being the case its only
> necessary
> >to update the changed elements.  This means updates are incremental. Once
> >the system has figured out what it needs to update its usable and if you
> access
> >an element that should be updated you will see the correctly updated
> version - even
> >though backgound resyncing is still in progress.
>
> I still can't tell what you're describing.  With RAID1 as well, only
> changed elements ever get updated.  I have two identical filesystems,
> members of a RAIF set.  I change one file.  One file in each member
> filesystem gets updated, and I again have two identical filesystems.
>
> How would a cloneset work differently, and how would it be better?

Thanks, Bryan.  I was about to write almost the same.

> > This type of logic is great for backups.
>
> Can you give an example of using it for backup?

I guess, you can mount Versionfs (yet another stackable file system)
below RAIF and above one of the lower file systems or use some other
versioning file system such as ext3cow.  This will allow rolling back to
any older file system version at any time.

Nikolai.
---------------------
Nikolai Joukov, Ph.D.
Filesystems and Storage Laboratory
Stony Brook University
