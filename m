From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: High IO Wait with RAID 1
Date: Fri, 13 Mar 2009 12:22:45 -0400
Message-ID: <49BA8855.1030904@tmr.com>
References: <7d86ddb90903121646q485ad12y90824a4c3fcc2dfd@mail.gmail.com>	 <20090313004802.GB29989@mint.phcomp.co.uk> <7d86ddb90903122021y5f4f0868na3f1944f87f77f4a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90903122021y5f4f0868na3f1944f87f77f4a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: Alain Williams <addw@phcomp.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ryan Wagoner wrote:
> I'm glad I'm not the only one experiencing the issue. Luckily the
> issues on both my systems aren't as bad. I don't have any errors
> showing in /var/log/messages on either system. I've been trying to
> track down this issue for about a year now. I just recently my the
> connection with RAID 1 and mdadm when copying data on the second
> system.
>
> Unfortunately it looks like the fix is to avoid software RAID 1. I
> prefer software RAID over hardware RAID on my home systems for the
> flexibility it offers, especially since I can easily move the disks
> between systems in the case of hardware failure.
>
> If I can find time to migrate the VMs, which run my web sites and
> email to another machine, I'll reinstall the one system utilizing RAID
> 1 on the LSI controller. It doesn't support RAID 5 so I'm hoping I can
> just pass the remaining disks through.
>
> You would think that software RAID 1 would be much simpler to
> implement than RAID 5 performance wise.
>
> Ryan
>
> On Thu, Mar 12, 2009 at 7:48 PM, Alain Williams <addw@phcomp.co.uk> wrote:
>   
>> On Thu, Mar 12, 2009 at 06:46:45PM -0500, Ryan Wagoner wrote:
>>     
>>> From what I can tell the issue here lies with mdadm and/or its
>>> interaction with CentOS 5.2. Let me first go over the configuration of
>>> both systems.
>>>
>>> System 1 - CentOS 5.2 x86_64
>>> 2x Seagate 7200.9 160GB in RAID 1
>>> 2x Seagate 7200.10 320GB in RAID 1
>>> 3x Hitachi Deskstar 7K1000 1TB in RAID 5
>>> All attached to Supermicro LSI 1068 PCI Express controller
>>>
>>> System 2 - CentOS 5.2 x86
>>> 1x Non Raid System Drive
>>> 2x Hitachi Deskstart 7K1000 1TB in RAID 1
>>> Attached to onboard ICH controller
>>>
>>> Both systems exhibit the same issues on the RAID 1 drives. That rules
>>> out the drive brand and controller card. During any IO intensive
>>> process the IO wait will raise and the system load will climb. I've
>>> had the IO wait as high as 70% and the load at 13+ while migrating a
>>> vmdk file with vmware-vdiskmanager. You can easily recreate the issue
>>> with bonnie++.
>>>       
>> I suspect that the answer is 'no', however I am seeing problems with raid 1
>> on CentOS 5.2 x86_64. The system worked nicely for some 2 months, then apparently
>> a disk died and it's mirror appeared to have problems before the first could be
>> replaced. The motherboard & both disks have now been replaced (data saved with a bit
>> of luck & juggling). I have been assuming hardware, but there seems little else
>> to change... and you report long I/O waits that I saw and still see
>> (even when I don't see the kernel error messages below).
>>
>> Disks have been Seagate & Samsung, but now both ST31000333AS (1TB) as raid 1.
>> Adaptec AIC7902 Ultra320 SCSI adapter
>> aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 101-133Mhz, 512 SCBs
>>
>> Executing 'w' or 'cat /proc/mdstat' can take several seconds,
>> failing sdb with mdadm and system performance becomes great again.
>>
>> I am seeing this sort of thing in /var/log/messages:
>> Mar 12 09:21:58 BFPS kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> Mar 12 09:21:58 BFPS kernel: ata2.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>> Mar 12 09:21:58 BFPS kernel:          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
>> Mar 12 09:21:58 BFPS kernel: ata2.00: status: { DRDY }
>> Mar 12 09:22:03 BFPS kernel: ata2: port is slow to respond, please be patient (Status 0xd0)
>> Mar 12 09:22:08 BFPS kernel: ata2: device not ready (errno=-16), forcing hardreset
>> Mar 12 09:22:08 BFPS kernel: ata2: hard resetting link
>> Mar 12 09:22:08 BFPS kernel: ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> Mar 12 09:22:39 BFPS kernel: ata2.00: qc timeout (cmd 0xec)
>> Mar 12 09:22:39 BFPS kernel: ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
>> Mar 12 09:22:39 BFPS kernel: ata2.00: revalidation failed (errno=-5)
>> Mar 12 09:22:39 BFPS kernel: ata2: failed to recover some devices, retrying in 5 secs
>> Mar 12 09:22:44 BFPS kernel: ata2: hard resetting link
>> Mar 12 09:24:02 BFPS kernel: ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> Mar 12 09:24:06 BFPS kernel: ata2.00: qc timeout (cmd 0xec)
>> Mar 12 09:24:06 BFPS kernel: ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
>> Mar 12 09:24:06 BFPS kernel: ata2.00: revalidation failed (errno=-5)
>> Mar 12 09:24:06 BFPS kernel: ata2: failed to recover some devices, retrying in 5 secs
>> Mar 12 09:24:06 BFPS kernel: ata2: hard resetting link
>> Mar 12 09:24:06 BFPS kernel: ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> Mar 12 09:24:06 BFPS kernel: ata2.00: qc timeout (cmd 0xec)
>> Mar 12 09:24:06 BFPS kernel: ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
>> Mar 12 09:24:06 BFPS kernel: ata2.00: revalidation failed (errno=-5)
>> Mar 12 09:24:06 BFPS kernel: ata2.00: disabled
>> Mar 12 09:24:06 BFPS kernel: ata2: port is slow to respond, please be patient (Status 0xff)
>> Mar 12 09:24:06 BFPS kernel: ata2: device not ready (errno=-16), forcing hardreset
>> Mar 12 09:24:06 BFPS kernel: ata2: hard resetting link
>> Mar 12 09:24:06 BFPS kernel: ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> Mar 12 09:24:06 BFPS kernel: ata2: EH complete
>> Mar 12 09:24:06 BFPS kernel: sd 1:0:0:0: SCSI error: return code = 0x00040000
>> Mar 12 09:24:06 BFPS kernel: end_request: I/O error, dev sdb, sector 1953519821
>> Mar 12 09:24:06 BFPS kernel: raid1: Disk failure on sdb2, disabling device.
>> Mar 12 09:24:06 BFPS kernel:    Operation continuing on 1 devices
>> Mar 12 09:24:06 BFPS kernel: sd 1:0:0:0: SCSI error: return code = 0x00040000
>> Mar 12 09:24:06 BFPS kernel: end_request: I/O error, dev sdb, sector 975018957
>> Mar 12 09:24:06 BFPS kernel: md: md3: sync done.
>> Mar 12 09:24:06 BFPS kernel: sd 1:0:0:0: SCSI error: return code = 0x00040000
>> Mar 12 09:24:06 BFPS kernel: end_request: I/O error, dev sdb, sector 975019981
>> Mar 12 09:24:06 BFPS kernel: sd 1:0:0:0: SCSI error: return code = 0x00040000
>> Mar 12 09:24:06 BFPS kernel: end_request: I/O error, dev sdb, sector 975021005
>> Mar 12 09:24:06 BFPS kernel: sd 1:0:0:0: SCSI error: return code = 0x00040000
>> Mar 12 09:24:06 BFPS kernel: end_request: I/O error, dev sdb, sector 975022029
>> Mar 12 09:24:06 BFPS kernel: sd 1:0:0:0: SCSI error: return code = 0x00040000
>> Mar 12 09:24:06 BFPS kernel: end_request: I/O error, dev sdb, sector 975022157
>> Mar 12 09:24:06 BFPS kernel: RAID1 conf printout:
>> Mar 12 09:24:06 BFPS kernel:  --- wd:1 rd:2
>> Mar 12 09:24:06 BFPS kernel:  disk 0, wo:0, o:1, dev:sda2
>> Mar 12 09:24:06 BFPS kernel:  disk 1, wo:1, o:0, dev:sdb2
>> Mar 12 09:24:06 BFPS kernel: RAID1 conf printout:
>> Mar 12 09:24:06 BFPS kernel:  --- wd:1 rd:2
>> Mar 12 09:24:06 BFPS kernel:  disk 0, wo:0, o:1, dev:sda2
>>
>> Mar 12 09:28:07 BFPS smartd[3183]: Device: /dev/sdb, not capable of SMART self-check
>> Mar 12 09:28:07 BFPS smartd[3183]: Sending warning via mail to root ...
>> Mar 12 09:28:07 BFPS smartd[3183]: Warning via mail to root: successful
>> Mar 12 09:28:07 BFPS smartd[3183]: Device: /dev/sdb, failed to read SMART Attribute Data
>> Mar 12 09:28:07 BFPS smartd[3183]: Sending warning via mail to root ...
>> Mar 12 09:28:07 BFPS smartd[3183]: Warning via mail to root: successful
>>     

Part of the issue with software RAID is that when you do two writes, be 
it mirrors or CRC, you actually have to push the data over the system 
bus to the controller. With hardware RAID you push it to the controller, 
freeing the bus.

"But wait, there's more" because the controller on a motherboard may not 
have enough cache to hold the i/o, may not optimize the access, etc, 
etc. And worst case it may write one drive then the other (serial 
access) instead of writing both at once. So performance may not be a bit 
better with the motherboard controller, and even an independent 
controller may not help much under load, since the limits here are the 
memory for cache (software has more) and the smartness of the write 
decisions (software is usually at least as good).

Going to hardware RAID buys only one thing in my experience, and that is 
it works at boot time, before the kernel gets into memory.

The other issue is that hardware RAID is per-disk, while software can 
allow selection of multiple RAID types by partition, allowing arrays to 
match use when that's appropriate.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


