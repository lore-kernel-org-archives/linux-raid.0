From: Andy Sy <andy@nospam.com>
Subject: Software RAID0 behaviour/performance on ATA drives
Date: Fri, 25 Mar 2005 00:29:47 +0800
Message-ID: <4242EAFB.9060008@nospam.com>
Reply-To: andy@neotitans.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The recommended setup for doing RAID0 with ATA drives is
that each hard drive should be on its own IDE channel.  The
reasoning is so they can operate concurrently... i.e.  if you
put them in a master-slave configuration on the same channel,
you lose the benefits of striping since both drives cannot
use the channel at the same time and have to wait for the
others' read/write to finish first.

QUESTION:  Is this really accurate?  Is the md driver smart/multi-threaded
enough to read/write ahead non-consecutive sectors simultaneously?
When writing, for example, the 1st to 4th chunks of a file across
a striped two-drive array, would it write the 2nd and 4th
chunks on one drive without waiting for the 1st and 3rd chunks
to finish writing on the other?

If it can't, and the writes have to proceed in sequence/lockstep,
how can putting the striped drives on separate channels help?


-- 
reply-to: a n d y @ n e o t i t a n s . c o m
