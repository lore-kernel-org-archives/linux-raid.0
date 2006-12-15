From: Ed Tomlinson <edt@aei.ca>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent Filesystems
Date: Fri, 15 Dec 2006 18:58:19 -0500
Message-ID: <200612151858.19935.edt@aei.ca>
References: <Pine.GSO.4.53.0612122217360.22195@compserv1> <200612150747.02708.edt@aei.ca> <Pine.GSO.4.53.0612151504360.3466@compserv1>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.53.0612151504360.3466@compserv1>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Nikolai Joukov <kolya@cs.sunysb.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 15 December 2006 15:11, Nikolai Joukov wrote:
> > On Wednesday 13 December 2006 12:47, Nikolai Joukov wrote:
> > > We have designed a new stackable file system that we called RAIF:
> > > Redundant Array of Independent Filesystems
> >
> > Do you have a function similar to an an EMC cloneset?   Basicily a cloneset
> > tracks what has changed in both the source and target luns (drives).  When one
> > updates the cloneset the target is made identical to the source.  Its a great
> > way to do backups.  Its an important feature to be able to write to the target drives.
> > I would love to see this working at a filesystem level.
> 
> Well, if you mount RAIF over your file system and a for-backups file
> system, RAIF can replicate the files on both of them automatically.  I
> guess that's what you need.

Yes and no.  The idea behind the cloneset is that most of the blocks (or files)
do not change in either source or target.  This being the case its only necessary
to update the changed elements.  This means updates are incremental.  Once
the system has figured out what it needs to update its usable and if you access
an element that should be updated you will see the correctly updated version - even 
though backgound resyncing is still in progress.  This type of logic is great for backups.

Thanks
Ed Tomlinson
