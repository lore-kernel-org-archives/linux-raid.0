From: Priya Kamala <priya.kamala@perpetual-data.com>
Subject: Re: Query regarding disk failure
Date: Wed, 10 Jul 2013 15:17:43 +0100
Message-ID: <51DD6D07.1060401@perpetual-data.com>
References: <51DD4EF0.6020509@perpetual-data.com> <20130710131119.GA26658@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130710131119.GA26658@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 10/07/2013 14:11, Robin Hill wrote:
> If the check/repair process finds a read error, it will trigger a
> rewrite of the affected block (rebuilding the data from the other
> drives). If the write fails then the disk will be removed from the RAID.
> This shouldn't happen, as the disk should either succeed in the write,
> or should remap the bad block with one of its spares.
>
> If you're getting repeated problems with this, it's likely that you are
> using consumer-level drives without TLER/ERC and have failed to adjust
> the kernel timeouts to compensate for this. In this case the rewrite
> will be triggered while the disk is still attempting the read process
> and will therefore be ignored, causing the write to fail and the disk to
> be removed.
>
Thank you for the quick response. The drives in question do support ERC.

I have some additional questions. Is the drive status changed to an 
underscore in /proc/mdstat during this remap process?

This is an extract from the system log:

Apr  4 07:44:02 src@AA20NOV sd 8:0:0:0: SCSI error: return code = 0x08000002
Apr  4 07:44:02 src@AA20NOV sde: Current: sense key: Medium Error
Apr  4 07:44:02 src@AA20NOV Additional sense: No additional sense 
information
Apr  4 07:44:02 src@AA20NOV Info fld=0x620cb71
Apr  4 07:44:02 src@AA20NOV end_request: I/O error, dev sde, sector 
102812529
Apr  4 07:44:02 src@AA20NOV raid5:md3: read error corrected (8 sectors 
at 86035184 on sde5)
Apr  4 07:44:02 src@AA20NOV raid5:md3: read error corrected (8 sectors 
at 86035192 on sde5)
Apr  4 07:44:05 src@AA20NOV raid5: Disk failure on sde5, disabling 
device. Operation continuing on 4 devices
Apr  4 07:44:05 src@AA20NOV md: cannot remove active disk sde5 from md3 ...

We have a service which monitors the md RAID status and tries to remove 
failed disks from degraded RAIDs and it looks like that failed since the 
device is active. But why would it still be active when the previous 
line says that the device is being disabled?

Thanks,
Priya
