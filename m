From: Chris Eddington <chrise@synplicity.com>
Subject: Re: Raid5 assemble after dual sata port failure
Date: Sun, 11 Nov 2007 09:41:13 -0800
Message-ID: <47373EB9.9050408@synplicity.com>
References: <47321FDF.8060207@synplicity.com> <4732E5F0.7080805@dgreaves.com> <4734CFE5.8070305@synplicity.com> <4734FB4A.4070401@synplicity.com> <473576F9.6040602@dgreaves.com> <4735FC7E.7030601@synplicity.com> <47373746.9090701@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47373746.9090701@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes, there is some kind of media error message in dmesg, below.  It is 
not random, it happens at exactly the same moments in each xfs_repair -n 
run. 

Nov 11 09:48:25 altair kernel: [37043.300691]          res 
51/40:00:01:00:00/00:00:00:00:00/e1 Emask 0x9 (media error)
Nov 11 09:48:25 altair kernel: [37043.304326] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:48:25 altair kernel: [37043.307672] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:48:25 altair kernel: [37043.307676] ata4.00: configured for 
UDMA/133
Nov 11 09:48:25 altair kernel: [37043.307684] ata4: EH complete
Nov 11 09:48:27 altair kernel: [37043.747838] SCSI device sdd: 976773168 
512-byte hdwr sectors (500108 MB)
Nov 11 09:48:27 altair kernel: [37043.747861] sdd: Write Protect is off
Nov 11 09:48:27 altair kernel: [37043.747878] SCSI device sdd: write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Nov 11 09:49:19 altair kernel: [37065.709216]          res 
51/40:00:0f:00:00/00:00:00:00:00/ef Emask 0x9 (media error)
Nov 11 09:49:19 altair kernel: [37065.720197] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:19 altair kernel: [37065.732188] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:19 altair kernel: [37065.732192] ata4.00: configured for 
UDMA/133
Nov 11 09:49:19 altair kernel: [37065.732199] ata4: EH complete
Nov 11 09:49:21 altair kernel: [37067.206243]          res 
51/40:00:0f:00:00/00:00:00:00:00/ef Emask 0x9 (media error)
Nov 11 09:49:21 altair kernel: [37067.210721] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:21 altair kernel: [37067.215727] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:21 altair kernel: [37067.215731] ata4.00: configured for 
UDMA/133
Nov 11 09:49:21 altair kernel: [37067.215738] ata4: EH complete
Nov 11 09:49:24 altair kernel: [37068.107825]          res 
51/40:00:0f:00:00/00:00:00:00:00/ef Emask 0x9 (media error)
Nov 11 09:49:24 altair kernel: [37068.112730] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:24 altair kernel: [37068.117732] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:24 altair kernel: [37068.117736] ata4.00: configured for 
UDMA/133
Nov 11 09:49:24 altair kernel: [37068.117740] ata4: EH complete
Nov 11 09:49:26 altair kernel: [37069.095665]          res 
51/40:00:0f:00:00/00:00:00:00:00/ef Emask 0x9 (media error)
Nov 11 09:49:26 altair kernel: [37069.100156] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:26 altair kernel: [37069.105148] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:26 altair kernel: [37069.105152] ata4.00: configured for 
UDMA/133
Nov 11 09:49:26 altair kernel: [37069.105159] ata4: EH complete
Nov 11 09:49:28 altair kernel: [37069.996842]          res 
51/40:00:0f:00:00/00:00:00:00:00/ef Emask 0x9 (media error)
Nov 11 09:49:28 altair kernel: [37070.000912] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:28 altair kernel: [37070.005916] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:28 altair kernel: [37070.005919] ata4.00: configured for 
UDMA/133
Nov 11 09:49:28 altair kernel: [37070.005924] ata4: EH complete
Nov 11 09:49:31 altair kernel: [37070.983850]          res 
51/40:00:0f:00:00/00:00:00:00:00/ef Emask 0x9 (media error)
Nov 11 09:49:31 altair kernel: [37070.987914] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:31 altair kernel: [37070.992917] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:31 altair kernel: [37070.992920] ata4.00: configured for 
UDMA/133
Nov 11 09:49:31 altair kernel: [37070.992935] ata4: EH complete
Nov 11 09:49:31 altair kernel: [37071.000639] SCSI device sdd: 976773168 
512-byte hdwr sectors (500108 MB)
Nov 11 09:49:31 altair kernel: [37071.000719] sdd: Write Protect is off
Nov 11 09:49:31 altair kernel: [37071.000745] SCSI device sdd: write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Nov 11 09:49:31 altair kernel: [37071.000762] SCSI device sdd: 976773168 
512-byte hdwr sectors (500108 MB)
Nov 11 09:49:31 altair kernel: [37071.000770] sdd: Write Protect is off
Nov 11 09:49:31 altair kernel: [37071.000788] SCSI device sdd: write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Nov 11 09:49:33 altair kernel: [37072.213749]          res 
51/40:00:0f:00:00/00:00:00:00:00/ef Emask 0x9 (media error)
Nov 11 09:49:33 altair kernel: [37072.218227] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:33 altair kernel: [37072.223231] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:33 altair kernel: [37072.223235] ata4.00: configured for 
UDMA/133
Nov 11 09:49:33 altair kernel: [37072.223242] ata4: EH complete
Nov 11 09:49:36 altair kernel: [37073.283239]          res 
51/40:00:0f:00:00/00:00:00:00:00/ef Emask 0x9 (media error)
Nov 11 09:49:36 altair kernel: [37073.286894] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:36 altair kernel: [37073.290220] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:36 altair kernel: [37073.290224] ata4.00: configured for 
UDMA/133
Nov 11 09:49:36 altair kernel: [37073.290231] ata4: EH complete
Nov 11 09:49:38 altair kernel: [37074.094417]          res 
51/40:00:0f:00:00/00:00:00:00:00/ef Emask 0x9 (media error)
Nov 11 09:49:38 altair kernel: [37074.097652] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:38 altair kernel: [37074.100988] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:38 altair kernel: [37074.100992] ata4.00: configured for 
UDMA/133
Nov 11 09:49:38 altair kernel: [37074.100997] ata4: EH complete
Nov 11 09:49:40 altair kernel: [37074.992267]          res 
51/40:00:0f:00:00/00:00:00:00:00/ef Emask 0x9 (media error)
Nov 11 09:49:40 altair kernel: [37074.996747] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:40 altair kernel: [37075.000074] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:40 altair kernel: [37075.000078] ata4.00: configured for 
UDMA/133
Nov 11 09:49:40 altair kernel: [37075.000083] ata4: EH complete
Nov 11 09:49:42 altair kernel: [37075.803457]          res 
51/40:00:0f:00:00/00:00:00:00:00/ef Emask 0x9 (media error)
Nov 11 09:49:42 altair kernel: [37075.807516] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:42 altair kernel: [37075.810842] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:42 altair kernel: [37075.810846] ata4.00: configured for 
UDMA/133
Nov 11 09:49:42 altair kernel: [37075.810853] ata4: EH complete
Nov 11 09:49:44 altair kernel: [37076.700452]          res 
51/40:00:0f:00:00/00:00:00:00:00/ef Emask 0x9 (media error)
Nov 11 09:49:44 altair kernel: [37076.704947] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:44 altair kernel: [37076.708272] ata4.00: ata_hpa_resize 1: 
sectors = 976773168, hpa_sectors = 976773168
Nov 11 09:49:44 altair kernel: [37076.708275] ata4.00: configured for 
UDMA/133
Nov 11 09:49:44 altair kernel: [37076.708290] ata4: EH complete
Nov 11 09:49:44 altair kernel: [37076.709550] SCSI device sdd: 976773168 
512-byte hdwr sectors (500108 MB)
Nov 11 09:49:44 altair kernel: [37076.709572] sdd: Write Protect is off
Nov 11 09:49:44 altair kernel: [37076.709594] SCSI device sdd: write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Nov 11 09:49:44 altair kernel: [37076.709611] SCSI device sdd: 976773168 
512-byte hdwr sectors (500108 MB)
Nov 11 09:49:44 altair kernel: [37076.709623] sdd: Write Protect is off
Nov 11 09:49:44 altair kernel: [37076.709705] SCSI device sdd: write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA


David Greaves wrote:
> Chris Eddington wrote:
>   
>> Hi,
>>
>> Thanks for the pointer on xfs_repair -n , it actually tells me something
>> (some listed below) but I'm not sure what it means but there seems to be
>> a lot of data loss.  One complication is I see an error message in ata6,
>> so I moved the disks around thinking it was a flaky sata port, but I see
>> the error again on ata4 so it seems to follow the disk.  But it happens
>> exactly at the same time during xfs_repair sequence, so I don't think it
>> is a flaky disk.
>>     
> Does dmesg have any info/sata errors?
>
> xfs_repair will have problems if the disk is bad. You may want to image the disk
> (possibly onto the 'spare'?) if it is bad.
>
>   
>>  I'll go to the xfs mailing list on this.
>>     
> Very good idea :)
>
>   
>> Is there a way to be sure the disk order is right? 
>>     
> The order looks right to me.
> xfs_repair wouldn't recognise it as well as it does if the order was wrong.
>
>   
>> not way out of wack since I'm seeing so much from xfs_repair.  Also
>> since I've been moving the disks around, I want to be sure I have the
>> right order.
>>     
>
> Bear in mind that -n stops the repair fixing a problem. Then as the 'repair'
> proceeds it becomes very confused by problems that should have been fixed.
>
> This is evident in the superblock issue (which also probably explains the failed
> mount).
>
>
>   
>> Is there a way to try restoring using the other disk?
>>     
> No the event count was very out of date.
>
>
>
>   

