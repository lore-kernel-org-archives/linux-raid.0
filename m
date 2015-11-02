From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Re: Advice requested
Date: Mon, 2 Nov 2015 17:49:23 -0600
Message-ID: <CAPpdf58En1ARr9YiFSgvPN5Ke_t7=EfxiaN9cZtGVtvR4NUdmA@mail.gmail.com>
References: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
	<56367C33.6060703@turmel.org>
	<CAPpdf5_PUpR7GhBHUaQfWb8Q+7FZenxXgFqbaN3f3r0r6NQNDA@mail.gmail.com>
	<5637842D.1070000@turmel.org>
	<CAPpdf59MFX1oVwLC-bmQBaQp9K_9-+h0v64OGMnV1-k=eCzO0w@mail.gmail.com>
	<5637BCE4.8000006@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5637BCE4.8000006@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Rund again

On Mon, Nov 2, 2015 at 1:43 PM, Phil Turmel <philip@turmel.org> wrote:
> Hi Dee,
>
> On 11/02/2015 01:21 PM, o1bigtenor wrote:
>> On Mon, Nov 2, 2015 at 9:41 AM, Phil Turmel <philip@turmel.org> wrote:
>
>>> That means you didn't tell it what device(s) to examine, so it did
>>> nothing.  Based on your data below, I expect you need to examine
>>> /dev/sdb1, /dev/sdc1, /dev/sde1, and /dev/sdf1.
>>
>> root@debianbase:/# mdadm -E /dev/sdb
>> /dev/sdb:
>>   MBR Magic : aa55
>> Partition[0] :   1953521664 sectors at         2048 (type fd)
>> root@debianbase:/# mdadm -E /dev/sdc
>> /dev/sdc:
>>   MBR Magic : aa55
>> Partition[0] :   1953525167 sectors at            1 (type ee)
>> root@debianbase:/# mdadm -E /dev/sde
>> /dev/sde:
>>   MBR Magic : aa55
>> Partition[0] :   1953521664 sectors at         2048 (type fd)
>> root@debianbase:/# mdadm -E /dev/sdf
>> /dev/sdf:
>>   MBR Magic : aa55
>> Partition[0] :   1953521664 sectors at         2048 (type fd)
>
> :-) You left off the partition numbers...  Please try again.

mdadm -E /dev/sdb1
/dev/sdb1:
         Magic : a92b4efc
       Version : 1.2
   Feature Map : 0x0
    Array UUID : 79baaa2f:0aa2b9fa:18e2ea6b:6e2846b3
          Name : debianbase:0  (local to host debianbase)
 Creation Time : Mon Mar  5 08:26:28 2012
    Raid Level : raid10
  Raid Devices : 4

Avail Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
    Array Size : 1953518592 (1863.02 GiB 2000.40 GB)
 Used Dev Size : 1953518592 (931.51 GiB 1000.20 GB)
   Data Offset : 2048 sectors
  Super Offset : 8 sectors
  Unused Space : before=1968 sectors, after=1024 sectors
         State : clean
   Device UUID : a80c76db:eaea61af:bcb9cbbb:ac99e467

   Update Time : Fri Aug 28 10:38:32 2015
      Checksum : 29a4fa98 - correct
        Events : 47341

        Layout : near=2
    Chunk Size : 512K

  Device Role : Active device 3
  Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
root@debianbase:/# mdadm -E /dev/sdc1
mdadm: No md superblock detected on /dev/sdc1.
root@debianbase:/# mdadm -E /dev/sdd1
mdadm: No md superblock detected on /dev/sdd1.
root@debianbase:/# mdadm -E /dev/sdf1
/dev/sdf1:
         Magic : a92b4efc
       Version : 1.2
   Feature Map : 0x0
    Array UUID : 79baaa2f:0aa2b9fa:18e2ea6b:6e2846b3
          Name : debianbase:0  (local to host debianbase)
 Creation Time : Mon Mar  5 08:26:28 2012
    Raid Level : raid10
  Raid Devices : 4

Avail Dev Size : 1953519616 (931.51 GiB 1000.20 GB)
    Array Size : 1953518592 (1863.02 GiB 2000.40 GB)
 Used Dev Size : 1953518592 (931.51 GiB 1000.20 GB)
   Data Offset : 2048 sectors
  Super Offset : 8 sectors
  Unused Space : before=1968 sectors, after=1024 sectors
         State : clean
   Device UUID : 9e749fa9:a0efe791:ea09d2e2:72b99f6c

   Update Time : Fri Aug 28 10:38:32 2015
      Checksum : 615d736 - correct
        Events : 47341

        Layout : near=2
    Chunk Size : 512K

  Device Role : Active device 1
  Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)



>
>> (I had some other system issues about 5 weeks ago an damaged the
>> superblock from sdc.)
>
> Hmmm.  That makes me wonder if the correct superblock is available, but
> only if the partition is relocated back to sector 2048.  We may revisit
> this.
>
>>> { A look at the section on --examine in "man mdadm" would have helped
>>> here.  Please spend some time reviewing "man mdadm" and "man md". }
>
>> I have found that man pages are great resources when one does know or has
>> used the command, when you haven't - - - well there are most often NO examples,
>> either of what to do or what happens when something is wrong. They are most
>> often written by those intimately familiar with the area (never have a
>> problem with
>> anything) and so I don't bother looking at them - - - they just aren't useful.
>> (The whole RTFM thing is one of the biggest reasons that I find *nix very
>> frustrating - - - I have spent hours reading and re-reading a man page
>> and sometimes
>> four or five pages talking about it and its still not clear exactly
>> how to write the
>> command or even better if the result is not positive there is absolutely no idea
>> given as to how to troubleshoot things - - - sorry its a rant but you
>> did tell me to
>> read it and - - - - .)
>
> You may have to conquer this to succeed.  While man pages certainly
> aren't perfect, they are the most complete documentation available on
> any linux system.  Most people in your situation struggle with the
> 'synopsis' section, and how to decipher the brackets and braces and
> such.  Google 'reading man pages' and sample the results for a wide
> overview.  Save the deep dive on 'Backus-Naur' for last. :-)

Sounds like you like the present layout. If there were examples included I would
think that man pages are useful. As they are at present - - - well I
have an easier
time figuring out ancient Hebrew - - - at least there are tools that work.
Brackets and braces aren't the issue - - - good technical writing is. Others may
find that man pages are 'complete' - - - I would disagree. (I have worked
quite a few years in technical fields and find that computer documentation is
some of the most difficult to follow - - - I've even had to decipher
English written
in China - - - found that easier as they followed a standardized layout.)
>
>>> It seems /dev/sdd1 is missing, so I guess the device names have changed.
>>> Please supply the reports for all four array devices with their current
>>> names (as shown in the smartctl reports).
>>
>> sda is my current 'operating system' disc - - - or where I want my operating
>> system to reside. I wanted all my information to be on the raid array.
>>
>> sdd is a ssd drive that is presently not used and was used previously as
>> an 'operating system' disc.
>>
>> Therefore neither of these really has anything to do with the raid array.
>
> Well, your initial report referred to sdb1 and sdd1, so I clearly had to
> ask.

With two drives removed from access then sdb1 and sdd1 were the useful drives.
Now with all drives plugged in we are still looking at sdb1 and sdd1 as being
the most likely accessible drives.
>
>>> Looking for this is one of the reasons I asked for these reports --
>>> non-raid rated drives producing timeout mismatch failures is a common
>>> problem seen on this list.  I also wanted to know if your drives are
>>> generally healthy -- they are -- and how that might have impacted your
>>> situation.  { I had some of the same Seagate .12 drives -- they didn't
>>> start failing until they had nearly 40k hours. }
>>
>> When these drives were bought, late January 2012 there was no differentiation
>> between drives based upon intended usage. That happened some time in
>> about 2013 IIRC.
>
> Drive manufacturers have always pitched their enterprise drives for raid
> duty, but only started sabotaging raid support in desktop drives in the
> 2011 time frame (as shown in the email archives I referenced).
>
> But even before they started cutting ERC support, you had to activate it
> manually to be safe in a raid array.  So no, desktop drives have never
> been safe to use in MD raid "out of the box".  And still are not.
>
>>> Another reason I asked for this is that drive names can change on power
>>> cycles and unplug/replug cycles.  Knowing what device is what (versus
>>> drive serial number) is important.  Please verify drive serial number
>>> versus device name after any power cycle or replug event and let us know
>>> any changes.
>>
>> There have been no real changes in quite a long time.
>> The only UUID change was between before Aug 28th of this and after when the
>> UUID of the array was changed. It was not finding the array upon a reboot (used
>> to improve web speeds changed by Firefox's software) that informed me that I
>> had an issue.
>
> The device you originally referred to as /dev/sdd is now apparently
> something else.  So yes, you are subject to device name changes.

Yes something changed from this morning to now. The way it is now makes more
sense but I didn't change anything.
>
> A UUID change only happens when an array is re-created.  If you've lost
> the original superblocks, recovery may not be possible.  Losing access
> at boot time is often a problem with updates to an initramfs, not to any
> actual problem with an array.
>
>>> This ^^^ isn't really an error.
>> If it isn't an error this was the only place where there were any
>> listed changes to the array and/or its discs.
>>
>> Subsequently I was unable to mount the array nor did it mount automatically as
>> it had for the previous time (at least 4 months).
>>>
>>>> Aug 28 10:39:28 debiantestingbase kernel: [    4.125325] random: nonblocking pool is initialized
>>>> Aug 28 10:39:28 debiantestingbase kernel: [    4.125530] md: bind<sde1>
>>>> Aug 28 10:39:28 debiantestingbase kernel: [    4.142140] md: bind<sdf1>
>>>> Aug 28 10:39:28 debiantestingbase kernel: [    4.144984] md: raid10 personality registered for level 10
>>>> Aug 28 10:39:28 debiantestingbase kernel: [    4.145397] md/raid10:md0: active with 4 out of 4 devices
>>>
>>> If it was, you wouldn't get this ^^^ success.
>> May have been a success but the UUID was changed and I could find no way
>> to access the array (still can't for that matter!).
>
> Which suggests that the new UUID array is not pointing at the data you
> need.  If the other two drives still have the old superblocks, it might
> still be possible.
>
>>> This section of your syslog is too far back in time -- before the failure.
>> This section is AT the time of failure.
>> Md0 has not been accessible subsequently!
>
> Then all four drives have new superblocks due to some form of array
> creation that has blown away the others.  Since the array won't mount,
> you had either incorrect array creation parameters and/or some operation
> stomping on the contents.
>
>>>
>>> [trim /]
>>>
>>>> Was following directions from one person on linux-raid and when he stopped
>>>> responding turned to someone who is somewhat connected with redhat and
>>>> hard drive stuff. There seemed to be a consensus that I needed to use low
>>>> level tools in an attempt to recover files, if I could. As there are about 200k
>>>> I wasn't looking forward to repairing things ;-(  !
>>>
>>> A link to the linux-raid archive of the prior discussion might help.
>>> And you might still need low level tools -- we are still trying to get
>>> your array started.  Then we can look at the next layer on top of that.
>>>  Based on your prior mails, /dev/md0 was formatted as ext4, yes?
>>
>> Yes.
>
> Based on your comments below, NO.
>
>> o1bigtenor <o1bigtenor@gmail.com>
>> Sep 3
>> Reply
>> to linux-raid
>> Greetings
>>
>> Had updated a system to Debian 8 which also had a Raid 10 array that
>> has been in use for about 3 1/2 years. (Setup raid under Debian 6 then
>> ran it mostly under Debian 7 mounting the array each time after
>> booting using the command
>>
>> #mount /dev/dm-o /home/myspace/RAID
>
> This indicates that you had a device mapper layer on top of the raid
> array, with the filesystem in that layer.
>
> I trimmed the rest of this mail in favor of the archive link:
> http://marc.info/?l=linux-raid&m=144131963804698&w=2
>
snip
>> # mdadm -D
>> mdadm: No devices given.
>>
>>
>>
>>> member
>>> details (mdadm -E)
>>
>> # mdadm -E
>> mdadm: No devices to examine
>>
>>
>>> and a summary of what happened.
>>> Include any excerpts from your dmesg and/or syslogs that look like they
>>> might be relevant.
>>
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.025162] scsi 3:0:0:0:
>> Direct-Access     ATA      ST31000524AS     JC4B PQ: 0 ANSI: 5
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.025768] sd 3:0:0:0:
>> [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.026296] sd 3:0:0:0:
>> [sdb] Write Protect is off
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.026304] sd 3:0:0:0:
>> [sdb] Mode Sense: 00 3a 00 00
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.026484] sd 3:0:0:0:
>> [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO
>> or FUA
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.028273]  sdb: sdb1
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.028698] sd 3:0:0:0:
>> [sdb] Attached SCSI disk
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.086532] Switched to
>> clocksource tsc
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.168919] md: bind<sdb1>
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.342285] ata5: SATA
>> link up 3.0 Gbps (SStatus 123 SControl 300)
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.343153] ata5.00:
>> ATA-9: ST1000DM003-1ER162, CC45, max UDMA/133
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.343158] ata5.00:
>> 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.344067] ata5.00:
>> configured for UDMA/133
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.344255] scsi 4:0:0:0:
>> Direct-Access     ATA      ST1000DM003-1ER1 CC45 PQ: 0 ANSI: 5
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.344627] sd 4:0:0:0:
>> [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.344631] sd 4:0:0:0:
>> [sdc] 4096-byte physical blocks
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.344823] sd 4:0:0:0:
>> [sdc] Write Protect is off
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.344831] sd 4:0:0:0:
>> [sdc] Mode Sense: 00 3a 00 00
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.344946] sd 4:0:0:0:
>> [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO
>> or FUA
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.411364]  sdc: sdc1
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.412317] sd 4:0:0:0:
>> [sdc] Attached SCSI disk
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.501080] md: bind<sdc1>
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.662509] ata6: SATA
>> link up 3.0 Gbps (SStatus 123 SControl 300)
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.674767] ata6.00:
>> ATA-8: Corsair Force 3 SSD, 1.3.3, max UDMA/133
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.674772] ata6.00:
>> 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.684647] ata6.00:
>> configured for UDMA/133
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.684933] scsi 5:0:0:0:
>> Direct-Access     ATA      Corsair Force 3  3    PQ: 0 ANSI: 5
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.685504] sd 5:0:0:0:
>> [sdd] 468862128 512-byte logical blocks: (240 GB/223 GiB)
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.685975] sd 5:0:0:0:
>> [sdd] Write Protect is off
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.685983] sd 5:0:0:0:
>> [sdd] Mode Sense: 00 3a 00 00
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.686186] sd 5:0:0:0:
>> [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO
>> or FUA
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.688051]  sdd: sdd1
>> sdd4 < sdd5 sdd6 sdd7 sdd8 sdd9 sdd10 >
>> Aug 28 10:39:28 debiantestingbase kernel: [    3.689305] sd 5:0:0:0:
>> [sdd] Attached SCSI disk
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.002712] ata8: SATA
>> link down (SStatus 0 SControl 300)
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.003107] scsi 8:0:0:0:
>> Direct-Access     ATA      ST31000524AS     JC4B PQ: 0 ANSI: 5
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.003597] sd 8:0:0:0:
>> [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.003843] scsi 9:0:0:0:
>> Direct-Access     ATA      ST31000524AS     JC4B PQ: 0 ANSI: 5
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.003975] sd 8:0:0:0:
>> [sde] Write Protect is off
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.003980] sd 8:0:0:0:
>> [sde] Mode Sense: 00 3a 00 00
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.004090] sd 8:0:0:0:
>> [sde] Write cache: enabled, read cache: enabled, doesn't support DPO
>> or FUA
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.004478] sd 9:0:0:0:
>> [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.004645] sd 9:0:0:0:
>> [sdf] Write Protect is off
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.004650] sd 9:0:0:0:
>> [sdf] Mode Sense: 00 3a 00 00
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.004737] sd 9:0:0:0:
>> [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO
>> or FUA
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.004778] scsi
>> 15:0:0:0: Processor         Marvell  91xx Config      1.01 PQ: 0 ANSI:
>> 5
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.006375]  sdf: sdf1
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.006967] sd 9:0:0:0:
>> [sdf] Attached SCSI disk
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.008855]  sde: sde1
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.009704] sd 8:0:0:0:
>> [sde] Attached SCSI disk
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.018710] ata16.00:
>> exception Emask 0x1 SAct 0x0 SErr 0x0 action 0x0
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.018753] ata16.00:
>> irq_stat 0x40000001
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.018783] ata16.00: cmd
>> a0/01:00:00:00:01/00:00:00:00:00/a0 tag 1 dma 16640 in
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.018783]
>> Inquiry 12 01 00 00 ff 00res 50/00:00:af:6d:70/00:00:74:00:00/e0 Emask
>> 0x1 (device error)
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.018868] ata16.00:
>> status: { DRDY }
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.125325] random:
>> nonblocking pool is initialized
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.125530] md: bind<sde1>
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.142140] md: bind<sdf1>
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.144984] md: raid10
>> personality registered for level 10
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.145397]
>> md/raid10:md0: active with 4 out of 4 devices
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.145440] md0: detected
>> capacity change from 0 to 2000403038208
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.208978]  md0:
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.479305]
>> device-mapper: uevent: version 1.0.3
>> Aug 28 10:39:28 debiantestingbase kernel: [    4.479536]
>> device-mapper: ioctl: 4.30.0-ioctl (2014-12-22) initialised:
>> dm-devel@redhat.com
snip
>>
>
> Lots of useful information, but no-one tried to drill deeper in /dev/dm0.
>
> Everything points to there being another missing layer between the raid
> device (md0) and your ext4 filesystem, that previously available as
> /dev/dm-0.  We need to decipher the initial contents of /dev/md0 to find
> a lost signature.
>
> Please supply the updated mdadm -E reports as I asked.  Trim all of the
> old mails from your reply, too.  Makes for very difficult reading.

Sorry - - - you did ask for all of what had gone on.
>
> When we get your array assembled, we'll use hexdump to poke around.

Over to you

Dee
