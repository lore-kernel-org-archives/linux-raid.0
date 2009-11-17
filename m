From: Vincent Schut <schut@sarvision.nl>
Subject: Re: RAID 6 Failure follow up
Date: Tue, 17 Nov 2009 09:40:13 +0100
Message-ID: <4B02616D.8060405@sarvision.nl>
References: <4AF6D0A9.6000901@gmail.com> <4AF6D461.3050109@gmail.com> <4AF6D5FD.2010602@gmail.com> <4AF70791.9080007@sauce.co.nz> <4AF741A9.80701@gmail.com> <4AF74D39.3000304@sauce.co.nz> <7d86ddb90911081845j675818a2vec1a5bd26d542024@mail.gmail.com> <20091109080910.GE18545@boogie.lpds.sztaki.hu> <4AF7EA17.1030504@gmail.com> <20091109113454.GB4492@boogie.lpds.sztaki.hu> <4AF946B9.8040809@gmail.com> <4AF94FCA.6040303@sarvision.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF94FCA.6040303@sarvision.nl>
Sender: linux-raid-owner@vger.kernel.org
Cc: Andrew Dunn <andrew.g.dunn@gmail.com>, Gabor Gombas <gombasg@sztaki.hu>, Ryan Wagoner <rswagoner@gmail.com>, Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Vincent Schut wrote:
> Andrew Dunn wrote:
>> I am able to reproduce this smart error now. I have done it twice, so
>> maybe other things are causing this also.
>>
>> When I scanned the devices this morning with smartctl via webmin I lost
>> 8 of the 9 drives. They are howerver still in my /dev folder.
>>
>> Now I sent out my logs from the first failure last night, smartctl was
>> on the system... I dont know if ubuntu server's default smartd
>> configuration makes it do periodic scans because I didnt change anything.
>>
>> I would hate to move back to 9.10 and see this problem again.
>>
>> Should I just not install smartmontools? This seems like a bad solution
>> because now I wont be able to check the drives in advance for failures.
>>
>> Have you installed LSI's linux drivers? Some people say this solves
>> their issue.
>>
>> From the logs sent out last night do you think it could be something 
>> else?
>>
>> Thanks a ton,
> 
> FWIW, I encountered the same issue, and seem to have found a viable 
> workaround by accessing the SATA disks on that LSI backplane as scsi 
> devices, e.g. by adding '-d scsi' to my smartctl/smartd.conf lines. No 
> more errors in the logs, no more drives being kicked out.
> Though not as much info is available that way as when using de sata 
> driver ('-d sat', or automatically), like temperature is unavailable, it 
> does allow me to initiate the selftests and get their result, and to 
> monitor generic smart status of the drives. Quite enough for me.
> 
> YMMV, though.

Folks, I need to retract this. Thought I've had far less problems with 
'-d scsi' instead of '-d sat' when running the LSI SAS / smartmontools / 
mdadm combo, I got bitten again last night by a drive being kicked out 
for no apparent reason. For now my only possible advise is: don't use 
smartmontools on drives that are on this LSI SAS backplane.
I dearly hope this will improve soon; I hate it to have my drives go 
unmonitored for too long...

Vincent.

> 
> Vincent.
>>
>> Gabor Gombas wrote:
>>> On Mon, Nov 09, 2009 at 05:08:23AM -0500, Andrew Dunn wrote:
>>>
>>>  
>>>> does it momentarily offline the disks? like they re-appear in /dev
>>>> within moments? That would be similar behavior to what I am
>>>> experiencing, the disks drop from the array, but they are in /dev by 
>>>> the
>>>> time I get a chance to see them.
>>>>     
>>> No, either the disks need to be physically removed and re-inserted, or
>>> the machine needs to be rebooted.
>>>
>>> Gabor
>>>
>>>   
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

