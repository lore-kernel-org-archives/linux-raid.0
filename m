From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: Disk link failure impact on Disks and RAID superblock in MD.
Date: Tue, 24 Apr 2012 11:55:46 +0100
Message-ID: <4F9686B2.9010900@mpstor.com>
References: <4F8EAB1A.6000800@mpstor.com> <4F8EB5E6.80204@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F8EB5E6.80204@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/04/12 13:39, David Brown wrote:
> On 18/04/2012 13:52, Benjamin ESTRABAUD wrote:
>> Hi,
>>
>> I was wondering about the following:
>>
>> Superblocks, and all RAID metadata, are stored on disks (to assemble the
>> RAID), and also on the RAID (while assembled), and are necessary to run
>> a RAID correctly, so long as at least <parity reached> of superblocks on
>> disks are available, as <parity reached> number of disks are required
>> for a specific RAID level to run (this excludes RAID 0 obviously).
>>
>> This means that so long as less than 1 disk fails in RAID5, no more than
>> one superblock will be lost and therefore the RAID can still assemble,
>> and the metadata be read.
>>
>> However, in modern RAID systems, the disks are all connected through a
>> single path, being a SAS cable connected to a JBOD or a single SATA
>> controller that can fail/crash.
>>
>> Also, the RAID is not protected against power failure, which in my head
>> are a bit equivalent to a complete disk link failure (SAS cable pulled).
>>
>> In these cases where all the disks are lost at once, what is the
>> probability of superblock corruption (both on the RAID superblock and
>> the individual disks)?
>>
>> If the superblock was being written during the failure, would it be
>> incompletely written and therefore corrupted?
>>
>> How reliably is it to keep a RAID alive (being able to re-assemble it)
>> after continuously pulling and pushing the SAS cable?
>>
>> Regards,
>> Ben.
>
> I think the idea of RAID is that it is a "redundant array of 
> inexpensive disks" - it is the disks that are redundant.  If you get 
> sudden failure of other parts of the system, there is always a risk of 
> corrupting or losing the whole array.  So it is a question of what are 
> the likely failures, and how is it best to guard against them - 
> minimising the chances of failure and the consequences of failure.
>
> In general, the Linux md raid, the block drivers, the filesystems, 
> etc., are as robust as reasonably practical in the face of unexpected 
> power failures or other crashes.  There are also some filesystems that 
> can be balanced here (such as with xfs, choosing to enable or disable 
> write barriers) between speed and safety.  But I don't think anyone 
> gives you concrete guarantees.
>
> In real life, there are three things that are likely failures.  Hard 
> disks (and SSD's) can fail - RAID protects you here.  The power supply 
> on the server can fail - if you worry about that, most quality servers 
> can be fitted with redundant power supplies.  And the external power 
> supply can fail - for that, you use an UPS.
>
> I have never heard of a SAS or SATA cable failing - I think you would 
> have to abuse it vigorously to cause damage.  Controller cards /can/ 
> fail - the more complex they are, the bigger the risk.  I have never 
> seen a SATA controller fail, but I did once have a SAS card that 
> failed.  If you see this sort of thing as a risk, then make sure you 
> have two controllers, and your array is built using mirrors at some 
> level, with each half of the mirror(s) on separate controllers.
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Hi David,

Thanks for your reply.

I'm actually trying here to determine some probabilities and risk 
related to RAID and superblocks.
I understand that the failures are unlikely and solutions can be 
implemented to prevent failures, but I'm trying to figure out the risks 
involved in various scenarios, like SAS cable failure (pulled out by a 
human), controller failure (can happen, even if rare) etc.

Filesystem here is not an issue either, this is really about MD and its 
sturdiness to various failures.

Considering the metadatas are stored "inband" (on the same device as the 
RAID data), what are the chances of breaking an entire RAID's metadata 
because of a massive failure (all disks failing or SAS/SATA controller 
failing or power failure)? I understand that the last MD BIOs may be 
lost, that some filesystem writes may be lost or corrupted, but I'm more 
interested about the superblock corruption here that would cause the 
RAID never to re-assemble without a drastic action like an entire 
re-create with or without --clean.

Would you know more about that?

Regards,
Ben.

