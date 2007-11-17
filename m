From: Chris Eddington <chrise@synplicity.com>
Subject: Re: Raid5 assemble after dual sata port failure
Date: Fri, 16 Nov 2007 22:31:30 -0800
Message-ID: <473E8AC2.9020701@synplicity.com>
References: <47321FDF.8060207@synplicity.com> <4732E5F0.7080805@dgreaves.com> <4734CFE5.8070305@synplicity.com> <4734FB4A.4070401@synplicity.com> <473576F9.6040602@dgreaves.com> <4735FC7E.7030601@synplicity.com> <47373746.9090701@dgreaves.com> <47373EB9.9050408@synplicity.com> <4737870D.5000906@dgreaves.com> <4737A5CC.8040105@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4737A5CC.8040105@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>, David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes, this is exactly the kind of symptoms I've experienced.  I was 
losing a drive here and there every couple of months (mostly the last 
two drives sdc and sdd) which I though were cable problems (shut down, 
re-plug the cables and restart and it would always work, with 
add/rebuild the 4th disk).  But now my guess is the motherboard chipset 
is overheating (or maybe the drives).  I have an MSI K9N platinum 
AMD/Nividia chipset that has 4 raid ports + 2 raid ports from a separate 
chip.  The mb chipset comes with a wimpy heatsink on it and it is very 
hot to the touch.  I had been planning to replace it but never got 
around to it.

I've been out of town this week so I had someone image all three disks.  
He used ghost disk image application.  He said the third disk reported 
media problems, and about 5% of the data was not fixable (sector 
errors).  Using these three copied drives, the array comes up and 
xfs_repair still reports a bunch of inode repairs as before, but it is a 
bit different, maybe even a reduction in losses.  But most important is 
the hpa_sector errors no longer occur.

Key questions:
- I assume ddrescue will do a much better job of correcting errors when 
imaging a disk?  My colleague used ghost which is just a copy tool.  I 
don't understand the capabilities of ddrescue on raid partitions that well.
- fdisk -l reports that all the drives are exactly the same size with 
exactly the same # sectors shown below.  I don't quite follow the 
hpa_resize issue, but it appears the drives don't have hidden HPA 
sectors - I guess?  Note that sdc is the original drive, where sda, sdb, 
and sdd are the imaged drives.

So what do you recommend to do first?  Should I try xfs_repair on the 
ghost copy, or just re-copy myself using ddrescue?  Are there special 
settings to ddrescue I should consider to verify/correct potential HPA 
changes?

Thks,
Chris

Disk /dev/sda: 500.1 GB, 500107862016 bytes
/dev/sda1               1       60801   488384001   fd  Linux raid 
autodetect
Disk /dev/sdb: 500.1 GB, 500107862016 bytes
/dev/sdb1               1       60801   488384001   fd  Linux raid 
autodetect
Disk /dev/sdc: 500.1 GB, 500107862016 bytes
/dev/sdc1               1       60801   488384001   fd  Linux raid 
autodetect
Disk /dev/sdd: 500.1 GB, 500107862016 bytes
/dev/sdd1               1       60801   488384001   fd  Linux raid 
autodetect

Bill Davidsen wrote:
> David Greaves wrote:
>> Chris Eddington wrote:
>>  
>>> Yes, there is some kind of media error message in dmesg, below.  It is
>>> not random, it happens at exactly the same moments in each 
>>> xfs_repair -n
>>> run.
>>> Nov 11 09:48:25 altair kernel: [37043.300691]          res
>>> 51/40:00:01:00:00/00:00:00:00:00/e1 Emask 0x9 (media error)
>>> Nov 11 09:48:25 altair kernel: [37043.304326] ata4.00: 
>>> ata_hpa_resize 1:
>>> sectors = 976773168, hpa_sectors = 976773168
>>> Nov 11 09:48:25 altair kernel: [37043.307672] ata4.00: 
>>> ata_hpa_resize 1:
>>> sectors = 976773168, hpa_sectors = 976773168
>>>     
>>
>> I'm not sure what an ata_hpa_resize error is...
>>   
>
> HPA = Hardware Protected Area.
>
> By any chance is this disk partitioned such that the partition size 
> includes the HPA? If it does, this sounds at least familiar, this 
> mailing list post may get you started: 
> http://osdir.com/ml/linux.ataraid/2005-09/msg00002.html
>
> In any case, run "fdisk -l" and look at the claimed total disk size 
> and the end point of the last partition. The HPA is not included in 
> the "disk size" so nothing should be trying to do so.
>> It probably explains the problems you've been having with the raid 
>> not 'just
>> recovering' though.
>>
>> I saw this:
>> http://www.linuxquestions.org/questions/linux-kernel-70/sata-issues-568894/ 
>>
>>   
>
> May be the same thing. Let us know what fdisk reports.
>>
>> What does smartctl say about your drive?
>>
>> IMO the spare drive is no longer useful for data recovery - you may 
>> want to use
>> ddrescue to try and copy this drive to the spare drive.
>>
>> David
>> PS Don't get the ddrescue parameters the wrong way round if you go 
>> that route...
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>   
>
>

