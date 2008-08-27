From: Tony Coffman <tony@emitony.com>
Subject: Re: Device naming and raid1
Date: Wed, 27 Aug 2008 09:21:14 -0400
Message-ID: <48B554CA.4010804@emitony.com>
References: <48B42226.3020702@emitony.com> <A20315AE59B5C34585629E258D76A97C01A506E3@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C01A506E3@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Lethe wrote:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Tony Coffman
>> Sent: Tuesday, August 26, 2008 10:33 AM
>> To: linux-raid@vger.kernel.org
>> Subject: Device naming and raid1
>>
>> I've have a Centos5 box running a software raid-1 set on a pair of
>>     
> SATA
>   
>> drives.
>>
>> The SATA controller or driver has a flaw.
>> Every 150 days or so, one of the two drives will experience errors and
>> fail.
>>
>> Subsequent tests always show the drive and cable to be ok.  We bought
>>     
> a
>   
>> couple of replacement drives before we figured that out :-(
>>
>> On the last event this weekend, I went searching for a way to get the
>> raid back online with no host downtime.  I found the technique that
>> deletes the drive and then brings it back online with a bus scan using
>> the /sys filesystem delete and rescan entities.
>>
>> I didn't realize that you could also perform a rescan on a single LUN.
>> I'll have to use that next time.
>>
>> My question - since I've done a delete/rescan bus operation, my device
>> name and major,minor numbers have changed.
>>
>> Original
>> [0:0:0:0]    disk    ATA      ST3250410AS      3.AA  /dev/sdc
>>
>> Current
>> [0:0:0:0]    disk    ATA      ST3250410AS      3.AA  /dev/sdc
>>
>> If I re-add the device to the raid set using the new device name, will
>> it cause any problems on the next boot?
>>
>> The drive appears to be fine.  I can read all blocks with no errors.
>> Partition table looks ok, etc..
>>
>> In the future if I rescan just the single LUN, I'm pretty sure I won't
>> run into again this but I'd like to avoid an outage on this event if
>> possible.
>>
>> Thanks and regards,
>> --Tony
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.htm
>>     
> Don't be too quick to say the drive(s) are good, or for that matter,
> making any assumptions about what is bad or good. (Well, OK, let's
> assume the monitor is good).   If the drives are reporting errors and
> the drives fail, why not trap the error messages and do some diagnostics
> while drives are still in that failed state?  Error messages tell you
> what the errors are.   Make yourself a bootable CDROM or USB and next
> time the drives lockup and/or start spitting out errors, then capture
> everything.  Then boot to the external device (do NOT cycle power), and
> run one of many possible diagnostics to confirm or eliminate the disks.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
Thanks much for the reply.  For the purposes of this discussion you can
assume that I've already re-established confidence in the drive, the
cable, and the controller and that the data on the drives is worthless
and I just want to get maximum uptime without causing a raid assemble
problem on the next reboot.

Any idea on my original question?  If I re-add the drive using the
/dev/sdc name will I have problems on the next boot when the drive is
named /dev/sda?

Based on my experience with Linux and other software raid
implementations, I'm strongly inclined to think that the device naming
doesn't matter - the system will scan the drives at boot looking for
raid sets and re-assemble them no matter what major and minor numbers or
device names are.  I'm not opposed to finding out the hard way but I'd
really like to get a definitive answer now because by the time this
system is next rebooted I'll probably have long forgotten about this.

Regards,
--Tony

