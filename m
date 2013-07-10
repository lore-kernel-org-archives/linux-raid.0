From: Phil Turmel <philip@turmel.org>
Subject: Re: Query regarding disk failure
Date: Wed, 10 Jul 2013 10:51:28 -0400
Message-ID: <51DD74F0.8020006@turmel.org>
References: <51DD4EF0.6020509@perpetual-data.com> <20130710131119.GA26658@cthulhu.home.robinhill.me.uk> <51DD6D07.1060401@perpetual-data.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51DD6D07.1060401@perpetual-data.com>
Sender: linux-raid-owner@vger.kernel.org
To: Priya Kamala <priya.kamala@perpetual-data.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/10/2013 10:17 AM, Priya Kamala wrote:
> 
> On 10/07/2013 14:11, Robin Hill wrote:
>> If the check/repair process finds a read error, it will trigger a
>> rewrite of the affected block (rebuilding the data from the other
>> drives). If the write fails then the disk will be removed from the RAID.
>> This shouldn't happen, as the disk should either succeed in the write,
>> or should remap the bad block with one of its spares.
>>
>> If you're getting repeated problems with this, it's likely that you are
>> using consumer-level drives without TLER/ERC and have failed to adjust
>> the kernel timeouts to compensate for this. In this case the rewrite
>> will be triggered while the disk is still attempting the read process
>> and will therefore be ignored, causing the write to fail and the disk to
>> be removed.
>>
> Thank you for the quick response. The drives in question do support ERC.

You haven't actually told us whether it is turned on.  Desktop drives
that support it don't have it enabled by default.  Please show "smartctl
-l scterc /dev/sdX" for each of your drives.

Also, while read errors will normally be rewritten, there is a kernel
limit of 20 read errors in an hour, and 10 per hour after that.  So if
your check operation is encountering numerous UREs, it might be hitting
this limit.

> I have some additional questions. Is the drive status changed to an
> underscore in /proc/mdstat during this remap process?

No.

> This is an extract from the system log:
> 
> Apr  4 07:44:02 src@AA20NOV sd 8:0:0:0: SCSI error: return code =
> 0x08000002
> Apr  4 07:44:02 src@AA20NOV sde: Current: sense key: Medium Error
> Apr  4 07:44:02 src@AA20NOV Additional sense: No additional sense
> information
> Apr  4 07:44:02 src@AA20NOV Info fld=0x620cb71
> Apr  4 07:44:02 src@AA20NOV end_request: I/O error, dev sde, sector
> 102812529
> Apr  4 07:44:02 src@AA20NOV raid5:md3: read error corrected (8 sectors
> at 86035184 on sde5)
> Apr  4 07:44:02 src@AA20NOV raid5:md3: read error corrected (8 sectors
> at 86035192 on sde5)
> Apr  4 07:44:05 src@AA20NOV raid5: Disk failure on sde5, disabling
> device. Operation continuing on 4 devices
> Apr  4 07:44:05 src@AA20NOV md: cannot remove active disk sde5 from md3 ...

You haven't really shown enough, but this looks like the tail of the
event sequence when ERC is disabled or unavailable.

Phil
