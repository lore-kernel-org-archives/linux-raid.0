From: Titus Winters <twinters@odin.ac.hmc.edu>
Subject: Not-fresh + failure
Date: Tue, 18 Jun 2002 16:28:13 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020618162813.A2366@cs.hmc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Please help my poor file server: 

I've got 4 scsi drives on two controllers running RAID-5 in software.

So as near as I can tell I've got one drive that failed and cut off 
communications with the other disk on the SCSI controller (or something)
which made that second drive become not-fresh before the kernel panicked.

dmseg says that one is not-fresh, and the other is faulty.  How do I
proceed without data loss?  I've tried raidhotadd to bring up the 
not-fresh drive, but the raid device can't start up and thus I can't 
hot add it.  

Thank you very much
-Titus Winters


