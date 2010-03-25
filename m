From: Anshuman Aggarwal <anshuman@brillgene.com>
Subject: Re: 4 partition raid 5 with 2 disks active and 2 spare, how to force?
Date: Thu, 25 Mar 2010 19:39:38 +0530
Message-ID: <DFC0232A-8DCD-4815-AA08-DA7065F01221@brillgene.com>
References: <S1753093Ab0CYHZE/20100325072504Z+37@vger.kernel.org> <2E4545D6-8F4E-4779-9103-960C52983A72@brillgene.com> <4877c76c1003250437r346e18en8da0f6f804bef634@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003250437r346e18en8da0f6f804bef634@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Michael, I am clear about the problem of why the multiple failure would cause me to lose data. Which is why I wanted to consult this mailing list before proceeding. 

Could you tell me how to keep the array read-only?  and mark one or both of these spares as active forcibly? and Also, once I am able to use these spares as active and the data is not consistent in a particular stripe, how does the kernel resolve the inconsistency (as in what data does it use, the one based on the data stripes or the one based on the parity?) this one is just academic interest since it'll be difficult to figure out which is the right data anyways.

Thanks,
Anshuman

On 25-Mar-2010, at 5:07 PM, Michael Evans wrote:

> On Thu, Mar 25, 2010 at 2:30 AM, Anshuman Aggarwal
> <anshuman@brillgene.com> wrote:
>> All, thanks in advance...particularly Neil.
>> 
>> My raid5 setup has 4 partitions, 2 of which are showing up as spare and 2 as active. The mdadm --assemble --force gives me the following error:
>> 2 active devices and 2 spare cannot start device
>> 
>> it is a raid 5, with superblock 1.2, 4 devices in the order sda1, sdb5, sdc5, sdd5. I have lvm2 on top of this with other devices ...so as you all know data is irreplaceable blah blah.
>> 
>> I know that this device has not been written to for a while, so the data can be considered intact (hopefully all) if I can get the device to start up...but I'm not sure of the best way to coax the kernel to assemble it. Relevant information follows:
>> 
>> === This device is working fine ===
>> mdadm --examine  -e1.2 /dev/sdb5
>> /dev/sdb5:
>>          Magic : a92b4efc
>>        Version : 1.2
>>    Feature Map : 0x1
>>     Array UUID : 42c56ea0:2484f566:387adc6c:b3f6a014
>>           Name : GATEWAY:127  (local to host GATEWAY)
>>  Creation Time : Sat Aug 22 09:44:21 2009
>>     Raid Level : raid5
>>   Raid Devices : 4
>> 
>>  Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
>>     Array Size : 1758296832 (838.42 GiB 900.25 GB)
>>  Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
>>    Data Offset : 272 sectors
>>   Super Offset : 8 sectors
>>          State : clean
>>    Device UUID : f8ebb9f8:b447f894:d8b0b59f:ca8e98eb
>> 
>> Internal Bitmap : 2 sectors from superblock
>>    Update Time : Fri Mar 19 00:56:15 2010
>>       Checksum : 1005cfbc - correct
>>         Events : 3796145
>> 
>>         Layout : left-symmetric
>>     Chunk Size : 64K
>> 
>>   Device Role : Active device 2
>>   Array State : .AA. ('A' == active, '.' == missing)
>> 
>> === This device is marked spare, can be marked active (IMHO) ===
>> mdadm --examine  -e1.2 /dev/sdd5
>> /dev/sdd5:
>>          Magic : a92b4efc
>>        Version : 1.2
>>    Feature Map : 0x1
>>     Array UUID : 42c56ea0:2484f566:387adc6c:b3f6a014
>>           Name : GATEWAY:127  (local to host GATEWAY)
>>  Creation Time : Sat Aug 22 09:44:21 2009
>>     Raid Level : raid5
>>   Raid Devices : 4
>> 
>>  Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
>>     Array Size : 1758296832 (838.42 GiB 900.25 GB)
>>  Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
>>    Data Offset : 272 sectors
>>   Super Offset : 8 sectors
>>          State : clean
>>    Device UUID : 763a832f:1a9a7ea8:ce90d4a3:32e8ae54
>> 
>> Internal Bitmap : 2 sectors from superblock
>>    Update Time : Fri Mar 19 00:56:15 2010
>>       Checksum : c78aab46 - correct
>>         Events : 3796145
>> 
>>         Layout : left-symmetric
>>     Chunk Size : 64K
>> 
>>   Device Role : spare
>>   Array State : .AA. ('A' == active, '.' == missing)
>> 
>> 
>> === This is the completely failed device (needs replacement)    ===
>> mdadm --examine  -e1.2 /dev/sda1
>> [HANGS!!]
>> 
>> 
>> 
>> I already have the replacement drive available as sde5 but want to be able to reconstruct as much as possible)
>> 
>> Thanks again,
>> Anshuman Aggarwal--
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 
> You have a raid 5 array.
> 
> (drives then data+parity per drive as an example)
> 1234
> 
> 123P
> 45P6
> 7P89
> ...
> 
> You are missing two drives, meaning you lack parity and 1 data stripe
> and have NO parity to recover it with.
> 
> It's like seeing:
> 
> .23.
> .5P.
> .P8.
> 
> and expecting to somehow recover the missing data when it is no longer
> within the clean information.
> 
> Your only hope is to assemble the array in read only mode with the
> other devices, if they can still even be read.  In that case you might
> at least be able to recover nearly all of your data; hopefully any
> missing areas are in unimportant files or non-allocated space.
> 
> At this point you should be EXTREMELY CAREFUL, and DO NOTHING, without
> having a good solid plan in place.  Rushing /WILL/ cause you to loose
> data that might still potentially be recovered.

