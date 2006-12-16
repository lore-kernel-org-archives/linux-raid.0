From: Ed Tomlinson <edt@aei.ca>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent Filesystems
Date: Sat, 16 Dec 2006 09:46:20 -0500
Message-ID: <200612160946.20535.edt@aei.ca>
References: <OFCB8FCFF5.BA0A74ED-ON88257246.0000FE7C-88257246.0001E5FD@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <OFCB8FCFF5.BA0A74ED-ON88257246.0000FE7C-88257246.0001E5FD@us.ibm.com>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Nikolai Joukov <kolya@cs.sunysb.edu>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 15 December 2006 19:20, Bryan Henderson wrote:
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

A cloneset is only syncronized at the point in time that you tell it to resync.
The source and target fs are useable independently.  When you resync the
target is reset to be indentical to the source at the point in time of the sync.
Its also immediatly useable - the sync and access to the source and target 
are coordinated so users of the target see the correct data, even if the sync 
is still running in background.

This allows things likes:
set oracle in backup mode
resync cloneset (this takes about 2 mins for a 2TB cloneset)
set oracle out of backup mode
(resyncing is still happening in background but accessing the cloneset gives a
consistant image)
backup oracle using cloneset files
or
start an instance of oracle using cloneset files (handly for a ro copy or if the main instance
needs certian types of service)

The overhead of the resync is minimized since it only updates the delta.  When
dealing with 2TB of data this is an important feature, reducing IO.  You can
only ask for a resync if the bg process from a previous resync is finished.
 
> How would a cloneset work differently, and how would it be better?
> 
> >This type of logic is great for backups.
> 
> Can you give an example of using it for backup?
> 
> --
> Bryan Henderson                     IBM Almaden Research Center
> San Jose CA                         Filesystems
> 
> 
> 
> 
