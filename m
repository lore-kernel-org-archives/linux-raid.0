From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: Suggestion needed for fixing RAID6
Date: Sat, 24 Apr 2010 21:36:17 +0200
Message-ID: <717901cae3e5$6a5fa730$0400a8c0@dcccs>
References: <626601cae203$dae35030$0400a8c0@dcccs> <20100423065143.GA17743@maude.comedia.it> <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "MRK" <mrk@shiftmail.org>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: "linux-raid" <linux-raid@vger.kernel.org>
Sent: Friday, April 23, 2010 2:34 PM
Subject: Re: Suggestion needed for fixing RAID6


> On 04/23/2010 10:47 AM, Janos Haar wrote:
>>
>> ----- Original Message ----- From: "Luca Berra" <bluca@comedia.it>
>> To: <linux-raid@vger.kernel.org>
>> Sent: Friday, April 23, 2010 8:51 AM
>> Subject: Re: Suggestion needed for fixing RAID6
>>
>>
>>> another option could be using the device mapper snapshot-merge target
>>> (writable snapshot), which iirc is a 2.6.33+ feature
>>> look at
>>> http://smorgasbord.gavagai.nl/2010/03/online-merging-of-cow-volumes-with-dm-snapshot/
>>> for hints.
>>> btw i have no clue how the scsi error will travel thru the dm layer.
>>> L.
>>
>> ...or cowloop! :-)
>> This is a good idea! :-)
>> Thank you.
>>
>> I have another one:
>> re-create the array (--assume-clean) with external bitmap, than drop the 
>> missing drive.
>> Than manually manipulate the bitmap file to re-sync only the last 10% 
>> wich is good enough for me...
>
>
> Cowloop is kinda deprecated in favour of DM, says wikipedia, and messing 
> with the bitmap looks complicated to me.

Hi,

I think i will like again this idea... :-D

> I think Luca's is a great suggestion. You can use 3 files with loop-device 
> so to store the COW devices for the 3 disks which are faulty. So that 
> writes go there and you can complete the resync.
> Then you would fail the cow devices one by one from mdadm and replicate to 
> spares.
>
> But this will work ONLY if read errors are still be reported across the 
> DM-snapshot thingo. Otherwise (if it e.g. returns a block of zeroes 
> without error) you are eventually going to get data corruption when 
> replacing drives.
>
> You can check if read errors are reported, by looking at the dmesg during 
> the resync. If you see many  "read error corrected..." it works, while if 
> it's silent it means it hasn't received read errors which means that it 
> doesn't work. If it doesn't work DO NOT go ahead replacing drives, or you 
> will get data corruption.
>
> So you need an initial test which just performs a resync but *without* 
> replicating to a spare. So I suggest you first remove all the spares from 
> the array, then create the COW snapshots, then assemble the array, perform 
> a resync, look at the dmesg. If it works: add the spares back, fail one 
> drive, etc.
>
> If this technique works this would be useful for everybody, so pls keep us 
> informed!!

Ok, i am doing it.

I think i have found some interesting, what is unexpected:
After 99.9% (and another 1800minute) the array is dropped the dm-snapshot 
structure!

ata5.00: exception Emask 0x0 SAct 0x7fa1 SErr 0x0 action 0x0
ata5.00: irq_stat 0x40000008
ata5.00: cmd 60/d8:38:1d:e7:90/00:00:ae:00:00/40 tag 7 ncq 110592 in
         res 41/40:7a:7b:e7:90/6c:00:ae:00:00/40 Emask 0x409 (media error) 
<F>
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/133
ata5: EH complete

...

sd 4:0:0:0: [sde] 2930277168 512-byte hardware sectors: (1.50 TB/1.36 TiB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
ata5.00: exception Emask 0x0 SAct 0x3ff SErr 0x0 action 0x0
ata5.00: irq_stat 0x40000008
ata5.00: cmd 60/d8:38:1d:e7:90/00:00:ae:00:00/40 tag 7 ncq 110592 in
         res 41/40:7a:7b:e7:90/6c:00:ae:00:00/40 Emask 0x409 (media error) 
<F>
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/133
sd 4:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 4:0:0:0: [sde] Sense Key : Medium Error [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
        ae 90 e7 7b
sd 4:0:0:0: [sde] Add. Sense: Unrecovered read error - auto reallocate 
failed
end_request: I/O error, dev sde, sector 2928732027
__ratelimit: 16 callbacks suppressed
raid5:md3: read error not correctable (sector 2923767936 on dm-0).
raid5: Disk failure on dm-0, disabling device.
raid5: Operation continuing on 9 devices.
md: md3: recovery done.
raid5:md3: read error not correctable (sector 2923767944 on dm-0).
raid5:md3: read error not correctable (sector 2923767952 on dm-0).
raid5:md3: read error not correctable (sector 2923767960 on dm-0).
raid5:md3: read error not correctable (sector 2923767968 on dm-0).
raid5:md3: read error not correctable (sector 2923767976 on dm-0).
raid5:md3: read error not correctable (sector 2923767984 on dm-0).
raid5:md3: read error not correctable (sector 2923767992 on dm-0).
raid5:md3: read error not correctable (sector 2923768000 on dm-0).
raid5:md3: read error not correctable (sector 2923768008 on dm-0).
ata5: EH complete
sd 4:0:0:0: [sde] 2930277168 512-byte hardware sectors: (1.50 TB/1.36 TiB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
ata5.00: exception Emask 0x0 SAct 0x1e1 SErr 0x0 action 0x0
ata5.00: irq_stat 0x40000008
ata5.00: cmd 60/00:28:f5:e8:90/01:00:ae:00:00/40 tag 5 ncq 131072 in
         res 41/40:27:ce:e9:90/6c:00:ae:00:00/40 Emask 0x409 (media error) 
<F>
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/133
ata5: EH complete
sd 4:0:0:0: [sde] 2930277168 512-byte hardware sectors: (1.50 TB/1.36 TiB)
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
RAID5 conf printout:
 --- rd:12 wd:9
 disk 0, o:1, dev:sda4
 disk 1, o:1, dev:sdb4
 disk 2, o:1, dev:sdc4
 disk 3, o:1, dev:sdd4
 disk 4, o:0, dev:dm-0
 disk 5, o:1, dev:sdf4
 disk 6, o:1, dev:sdg4
 disk 8, o:1, dev:sdi4
 disk 9, o:1, dev:sdj4
 disk 10, o:1, dev:sdk4
 disk 11, o:1, dev:sdl4
RAID5 conf printout:
 --- rd:12 wd:9
 disk 0, o:1, dev:sda4
 disk 1, o:1, dev:sdb4
 disk 2, o:1, dev:sdc4
 disk 4, o:0, dev:dm-0
 disk 5, o:1, dev:sdf4
 disk 6, o:1, dev:sdg4
 disk 8, o:1, dev:sdi4
 disk 9, o:1, dev:sdj4
 disk 10, o:1, dev:sdk4
 disk 11, o:1, dev:sdl4
RAID5 conf printout:
 --- rd:12 wd:9
 disk 0, o:1, dev:sda4
 disk 1, o:1, dev:sdb4
 disk 2, o:1, dev:sdc4
 disk 4, o:0, dev:dm-0
 disk 5, o:1, dev:sdf4
 disk 6, o:1, dev:sdg4
 disk 8, o:1, dev:sdi4
 disk 9, o:1, dev:sdj4
 disk 10, o:1, dev:sdk4
 disk 11, o:1, dev:sdl4
RAID5 conf printout:
 --- rd:12 wd:9
 disk 0, o:1, dev:sda4
 disk 1, o:1, dev:sdb4
 disk 2, o:1, dev:sdc4
 disk 5, o:1, dev:sdf4
 disk 6, o:1, dev:sdg4
 disk 8, o:1, dev:sdi4
 disk 9, o:1, dev:sdj4
 disk 10, o:1, dev:sdk4
 disk 11, o:1, dev:sdl4

So, the dm-0 is dropped only for _READ_ error!

kernel 2.6.28.10

Now i am trying to do a repair-resync solution before rebuild the missing 
drive...

Cheers,
Janos



> Thank you
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

