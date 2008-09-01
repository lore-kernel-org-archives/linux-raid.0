From: Philip Molter <philip@datafoundry.com>
Subject: Re: RAID1 disk failure causes hung mount
Date: Mon, 01 Sep 2008 15:44:17 -0500
Message-ID: <48BC5421.7050901@datafoundry.com>
References: <48BC352A.5010701@datafoundry.com> <A20315AE59B5C34585629E258D76A97C01B75E09@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C01B75E09@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David Lethe wrote:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Philip Molter
>> Sent: Monday, September 01, 2008 1:32 PM
>> To: Linux RAID Mailing List
>> Subject: RAID1 disk failure causes hung mount
>>
>> Hello,
>>
>> We're running a modified version of the FC4 2.6.17 kernel (2.6.17.4).
>> I
>> realize this is an old kernel.  For internal reasons, we cannot update
>> to a newer version of the kernel at this time.
>>
>> We have a 3ware 9550SXU card with 12 drives in JBOD mode.  These 12
>> drives are mirrored in 6 RAID1 pairs, then striped together in one big
>> RAID0 stripe.  When we have a disk error with one of the drives in a
>> RAID1 pair, the entire RAID0 mount locks up.  We can still cd to the
>> mount and read from it, but if we try to write anything to the mount,
>> the process hangs in an unkillable state.
 >>
>> ...
 >>
> Phillip:
> The problem really isn't with the LINUX kernel. Your 3WARE is the
> issue. Specifically, when the RAID1 "failed", LINUX did what it was
> supposed to do. /dev/sdj1 is the 3WARE-defined RAID1, and it generated a
> media error because it could not reconcile bad data on the RAID1 set. My
> guess is that you had a drive failure in combination with an
> unrecoverable read error on a physical block on the surviving disk in
> the pair.
> 
> I write 3WARE-specific diags, and have code to drill down into the
> card and get debug info, and most likely repair the damage, but it is
> well beyond the scope of giving you a simple how-to, beyond booting
> 3WARE BIOS and doing data consistency checks on the broken RAID1. If you
> don't care about recovering data on the RAID0 slice, then do a
> consistency check/repair, and then you'll have only minor loss. If you
> want all of the data back, then you'll probably have to pay somebody for
> their time. Due to your hardware RAID component failure, it isn't really
> applicable to a software RAID forum. 

Hi David,

I'm sorry if I wasn't clear enough about this.  I have no hardware RAID. 
  My 12-drive 3ware controller has all of its drives configured in JBOD 
mode and my RAIDs (6 RAID1s striped into a single RAID0, NOT a 12-drive 
RAID10) are all defined and assembled using Linux's md software RAID. 
The OS sees 12 drives, and from those 12 drives, configures 6 software 
RAID1s and one software RAID0 using mdadm/raid auto-detect.

As for the behavior, only one disk is having an error.  The 3ware 
reports errors from only one drive (confirmed via SMART data gathered 
off the drive), and the second drive in the RAID set reports no error 
via SMART data gathered off the disk nor through 3ware diagnostics.  The 
drive is easy to replace.  It's the hangup on write to the RAID1 that is 
causing problems, because it requires a reboot to get the drive into a 
replaceable state with regards to md.  I can replace the drive, but I 
can never remove the drive using mdadm until I reboot, and I can't sync 
any data before the reboot, which effectively means I have to recover my 
filesystem and associated data every time I lose a disk.

I appreciate the offer of help.  If you have any other ideas of what may 
be wrong, I am very eager to hear them.

Philip
