From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent Filesystems
Date: Fri, 15 Dec 2006 16:20:48 -0800
Message-ID: <OFCB8FCFF5.BA0A74ED-ON88257246.0000FE7C-88257246.0001E5FD@us.ibm.com>
References: <200612151858.19935.edt@aei.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <200612151858.19935.edt@aei.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ed Tomlinson <edt@aei.ca>
Cc: Nikolai Joukov <kolya@cs.sunysb.edu>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>The idea behind the cloneset is that most of the blocks (or files)
>do not change in either source or target.  This being the case its only 
necessary
>to update the changed elements.  This means updates are incremental. Once
>the system has figured out what it needs to update its usable and if you 
access
>an element that should be updated you will see the correctly updated 
version - even 
>though backgound resyncing is still in progress.

I still can't tell what you're describing.  With RAID1 as well, only 
changed elements ever get updated.  I have two identical filesystems, 
members of a RAIF set.  I change one file.  One file in each member 
filesystem gets updated, and I again have two identical filesystems.

How would a cloneset work differently, and how would it be better?

>This type of logic is great for backups.

Can you give an example of using it for backup?

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems



