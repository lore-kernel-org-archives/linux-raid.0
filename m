From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: Re: raid0 + raid1 question
Date: Thu, 09 Oct 2003 15:54:42 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1065729282.10027.127.camel@localhost.localdomain>
References: <3F84793F.6060400@siue.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F84793F.6060400@siue.edu>
To: anthony mayes <anmayes@siue.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We actually used to backup our data in this fashion, but we used a
triple mirror.  We had three hardware RAID arrays and then we used Linux
software RAID to mirror those three (i.e. /dev/hdc1, /dev/hdd1, and
/dev/hde1).  At night we used mdadm to break the mirror, mount the
removed partition and backup, and then add the partition back in and
re-mirror.

One thing to remember: if this application is database driven, you may
have inconsistencies in your data if the database is in the middle of a
transaction when the mirror is broken.

Our current Linux backup solution uses LVM on top of a Linux software
RAID10 array.  We suspend the database application long enough for all
transactions to complete and then use Linux LVM to snapshot the volume. 
We then resume database operations, mount the snapshot and copy it to
another RAID array.  Once completed I remove the snapshot and the static
disk partition is backed up to tape.  

The database is unavailable for less than 1 minute while the snapshot is
taken (it actually takes less than 10 seconds to snapshot ~360GB, the
other time is just the script sleeping, making sure all transactions
complete).  This solution ensures a consistent database, while also
having near-line backups available on disk.

So to answer your question, yes Linux can perform what you need.  There
are plenty of tools that make Linux more than up to the challenge.  I
recommend using mdadm for your software RAID management and Linux LVM
(it comes standard in most new kernels and Linux distros) to do
snapshots.

Here are some links:

http://tldp.org/HOWTO/LVM-HOWTO/
http://www.cse.unsw.edu.au/~neilb/source/mdadm/

If you have further questions, feel free to email me.

Regards,
Andy.


On Wed, 2003-10-08 at 16:53, anthony mayes wrote:
> I have 7 disks in an x86 box.  I want to have 2 raid0's (concatenations) 
> of 3 disks each.  Then I want to raid1 (mirror) the raid0's.   This 
> leaves 1 disk for the OS.
> 
> Is it possible to remove one of the raid0's (concatenation of 3 disks) 
> from the raid1 (mirror)?
> 
> I need to perform a backup while a highly visible application continues 
> to run.  Currently I am using Disksuite on a Solaris 8/SPARC platform 
> with the afore mentioned configuration. First the mirror is broken and 
> half of the mirror is mounted as another filesystem while the 
> application continues to run on the other half of the mirror.  The 
> backup is performed and then the mirror is resync'ed.  However, I want 
> to move to x86 and linux and need to know if the same is possible and 
> how to do it.  Does anyone have any experience / advise?
-- 

Regards,
Andrew Rechenberg
Infrastructure Team, Sherman Financial Group
