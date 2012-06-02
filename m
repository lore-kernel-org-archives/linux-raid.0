From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Sat, 02 Jun 2012 00:47:00 -0500
Message-ID: <4FC9A8D4.9060803@hardwarefreak.com>
References: <20120531083158.GE3867@bitfolk.com> <4FC81B85.8090807@hardwarefreak.com> <20120601192524.GH3867@bitfolk.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120601192524.GH3867@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/1/2012 2:25 PM, Andy Smith wrote:
> Hi Stan,
> 
> On Thu, May 31, 2012 at 08:31:49PM -0500, Stan Hoeppner wrote:
>> On 5/31/2012 3:31 AM, Andy Smith wrote:
>>> Now, is this sort of behaviour expected when under incredible load?
>>> Or is it indicative of a bug somewhere in kernel, mpt driver, or
>>> even flaky SAS controller/disks?
>>
>> It is expected that people know what RAID is and how it is supposed to
>> be used.  RAID is to be used for protecting data in the event of a disk
>> failure and secondarily to increase performance.  That is not how you
>> seem to be using RAID.
> 
> Just to clarify, this was the hypervisor host. The VMs on it don't
> use RAID themselves as that would indeed be silly.

Cool.  I only mentioned this as I've seen it in the wild more than once.

>> There are a number of scenarios where md RAID is better than hardware
>> RAID and vice versa.  Yours is a case where hardware RAID is superior,
>> as no matter the host CPU load, drives won't get kicked offline as a
>> result, as they're under the control of a dedicated IO processor (same
>> for SAN RAID).
> 
> Fair enough, thanks.

You could still use md RAID in your scenario.  But instead of having
multiple md arrays built of disk partitions and passing each array up to
a VM guest, the proper way to do this thin provisioning is to create one
md array and then create partitions on top.  Then pass a partition to a
guest.

This method eliminates many potential problems with your current setup,
such as elevator behavior causing excessive head seeks on the drives.
This is even more critical if some of your md arrays are parity (5/6).
You mentioned a single RAID 10 array.  If you're indeed running multiple
arrays of multiple RAID levels (parity and non parity) on the 5
partitions on each disk, and each VM is doing even medium to small
amount of IO concurrently, you'll be head thrashing pretty quickly.
Then, when you have a DDOS and lots of log writes/etc, you'll be
instantly seek bound, and likely start seeing SCSI timeouts, as the
drive head actuators simply can't move quickly enough to satisfy
requests before the timeout period.  This may be what caused your RAID
10 partitions to be kicked.  Not enough info to verify at this point.

The same situation can occur on a single OS bare metal host when the
storage system isn't designed to handle the IOPS load.  Consider a
maildir mailbox server with an average load of 2000 random R/W IOPS.
The _minimum_ you could get by with here would be 16x 15k disks in RAID
10.  8 * 300 seeks/s/drive = 2400 IOPS peak actuator performance.

If we were to put that workload on a RAID 10 array of only 4x 15k drives
we'd have 2 * 300 seeks/s/drive = 600 IOPS peak, less than 1/3rd the
actual load.  I've never tried this so I don't know if you'd have md
dropping drives due to SCSI timeouts, but you'd sure have serious
problems nonetheless.

-- 
Stan
