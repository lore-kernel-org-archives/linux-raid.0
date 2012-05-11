From: Pierre Beck <mail@pierre-beck.de>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Fri, 11 May 2012 15:54:38 +0200
Message-ID: <4FAD1A28.6020407@pierre-beck.de>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <4FAC2FF2.5060305@hardwarefreak.com> <4FAC33CC.6040203@pocock.com.au> <4FAC710F.7030705@hardwarefreak.com> <4FACCE51.7050809@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FACCE51.7050809@pocock.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'd like to join the discussion here and contribute a few constructive 
thoughts I've had about timeout issues, as well as answer the original 
questions from Daniel.

The original questions:

- does Linux md RAID actively use the more advanced features of these
drives, e.g. to work around errors?

No. mdraid does not touch SCTERC. You have to set it yourself scripting 
/ using smartctl or hdparm. Same goes for other settings like noise 
reduction or power saving.

- if a non-RAID SAS card is used, does it matter which card is chosen? 
Does md work equally well with all of them?

There's a nice post about available cards and software RAID in general: 
http://blog.zorinaq.com/?e=10

mdraid doesn't really care about controller. Which card is best? The one 
with fastest SCSI resets. I have yet to see reset benchmarks, though. On 
drive failure, you will want quick reset times because that's how 
current interaction fails a non-responding drive and it will suspend I/O 
on all drives attached to the controller until complete. SSD is another 
story - IOPS are easily limited by controller.

- ignoring the better MTBF and seek times of these drives, do any of the
other features passively contribute to a better RAID experience when
using md?

10k+ RPM drives are built with less surface (the platters are smaller), 
stiffer servo, etc. all-in-all trying to make the RAID experience one 
where you never have to replace a drive.

7k RPM drives are near-line SAS / enterprise SATA and built mechanically 
the same as desktop. Different board for SAS, only different firmware 
for SATA. Anything beyond that would surprise me.

Apart from that, vendors play cat and mouse with the ERC timeout 
feature. Enterprise level should always advertise and adhere that 
smartctl SCTERC setting.

- for someone using SAS or enterprise SATA drives with Linux, is there
any particular benefit to using md RAID, dmraid or filesystem (e.g.
btrfs) RAID (apart from the btrfs having checksums)?

dmraid is IMHO only a quick solution for fakeraid, not something I'd 
rely on in a server. mdraid has monitoring, media error handling, 
write-intent bitmaps. btrfs has advantages like faster integrity check 
(scan only used) and no initial sync. But may explode when used - 
real-life testing is limited. So for now, mdraid is the only choice in 
my opinion.

Since this thread also touched timeouts ...

Right now, Linux Software RAID priorizes data / parity integrity above 
everything else, which isn't a bad thing to do. If a request submitted 
to a drive takes minutes to complete, it waits patiently, because after 
ERC timeout, all but the requested sector tend to be intact and protect 
data on other drives. The bad sector is repaired by writing recovered 
data to it.

(SCSI timeout *before* ERC timeout is an unfortunate misconfiguration in 
that context and can be alleviated by increasing the SCSI timeout to a 
higher value than expected ERC timeout, or lowering ERC timeout if that 
is available on the drive)

Of course, having a database or website stall I/O for a few minutes or 
more (if several bad sectors are found) is less than desirable.

How to avoid that?

The first option would be to work the SCSI layer error handling to be 
less aggressive (there's a controller reset in there!) and behave well 
in a 1 second or less timeout configuration. mdraid would get an error 
reply and kick the drive from the array soon, because ERC on the drive 
is still stalling the drive and any read / write to the drive would not 
complete within the SCSI timeout. Write-intent bitmaps to the rescue: 
Script some daemon to check when drive is done stalling, re-add to 
array, sync fast.

Issues with that option: I have no idea whether ultra low SCSI timeouts 
are practical. There might be non-I/O commands which should be excluded 
from that timeout. Or maybe it can't be implemented the way I think 
about it. Some dev from the SCSI layer may be able to answer that. Also, 
spare drives would have to be removed from the array, because otherwise 
right after kicking the timed out drive, a spare would replace it, 
rendering re-add impossible. mdraid could implement a user defined delay 
for spare activation to mitigate this.

The second option would be timeouts in mdraid, with a lot of associated 
work and a new drive state between failed and online. A drive that has 
outstanding I/O but timed out would be kept in the array in "indisposed" 
state and cared for in the background. All outstanding read I/O would be 
duplicated, then redirected to online drives / recovered from parity. 
All write I/O would miss the stalled drive. The queue on the stalled 
drive would be completed (with or without errors) and bad sectors should 
be repaired just like it was online. On queue completion, internally 
re-add the drive and resync fast with write-intent bitmap. If drive 
fails to recover, activate spare.

Either option would make all drives (both desktop and enterprise) much 
less of a pain on URE and maybe other temporary disconnects.

My 2ct,

Pierre Beck
