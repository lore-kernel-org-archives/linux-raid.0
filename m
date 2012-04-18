From: David Brown <david.brown@hesbynett.no>
Subject: Re: Disk link failure impact on Disks and RAID superblock in MD.
Date: Wed, 18 Apr 2012 14:39:02 +0200
Message-ID: <4F8EB5E6.80204@hesbynett.no>
References: <4F8EAB1A.6000800@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F8EAB1A.6000800@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/04/2012 13:52, Benjamin ESTRABAUD wrote:
> Hi,
>
> I was wondering about the following:
>
> Superblocks, and all RAID metadata, are stored on disks (to assemble the
> RAID), and also on the RAID (while assembled), and are necessary to run
> a RAID correctly, so long as at least <parity reached> of superblocks on
> disks are available, as <parity reached> number of disks are required
> for a specific RAID level to run (this excludes RAID 0 obviously).
>
> This means that so long as less than 1 disk fails in RAID5, no more than
> one superblock will be lost and therefore the RAID can still assemble,
> and the metadata be read.
>
> However, in modern RAID systems, the disks are all connected through a
> single path, being a SAS cable connected to a JBOD or a single SATA
> controller that can fail/crash.
>
> Also, the RAID is not protected against power failure, which in my head
> are a bit equivalent to a complete disk link failure (SAS cable pulled).
>
> In these cases where all the disks are lost at once, what is the
> probability of superblock corruption (both on the RAID superblock and
> the individual disks)?
>
> If the superblock was being written during the failure, would it be
> incompletely written and therefore corrupted?
>
> How reliably is it to keep a RAID alive (being able to re-assemble it)
> after continuously pulling and pushing the SAS cable?
>
> Regards,
> Ben.

I think the idea of RAID is that it is a "redundant array of inexpensive 
disks" - it is the disks that are redundant.  If you get sudden failure 
of other parts of the system, there is always a risk of corrupting or 
losing the whole array.  So it is a question of what are the likely 
failures, and how is it best to guard against them - minimising the 
chances of failure and the consequences of failure.

In general, the Linux md raid, the block drivers, the filesystems, etc., 
are as robust as reasonably practical in the face of unexpected power 
failures or other crashes.  There are also some filesystems that can be 
balanced here (such as with xfs, choosing to enable or disable write 
barriers) between speed and safety.  But I don't think anyone gives you 
concrete guarantees.

In real life, there are three things that are likely failures.  Hard 
disks (and SSD's) can fail - RAID protects you here.  The power supply 
on the server can fail - if you worry about that, most quality servers 
can be fitted with redundant power supplies.  And the external power 
supply can fail - for that, you use an UPS.

I have never heard of a SAS or SATA cable failing - I think you would 
have to abuse it vigorously to cause damage.  Controller cards /can/ 
fail - the more complex they are, the bigger the risk.  I have never 
seen a SATA controller fail, but I did once have a SAS card that failed. 
  If you see this sort of thing as a risk, then make sure you have two 
controllers, and your array is built using mirrors at some level, with 
each half of the mirror(s) on separate controllers.


