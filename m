From: Thomas Baker <tjb@unh.edu>
Subject: Re: Any hope for a 27 disk RAID6+1HS array with four disks reporting "No md superblock detected"?
Date: Thu, 5 Feb 2009 19:08:09 -0500
Message-ID: <81341EE6-D13D-4174-8937-ADEFD02D2DB0@unh.edu>
References: <1233775657.10151.5.camel@localhost.localdomain>	 <4989FF7B.6030503@scalableinformatics.com>	 <1233781437.696.2.camel@localhost.localdomain>  <498B34AA.5020606@tmr.com> <1233860358.1780.21.camel@localhost.localdomain> <498B7CDA.2090209@tmr.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <498B7CDA.2090209@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Feb 5, 2009, at 6:57 PM, Bill Davidsen wrote:

> Thomas J. Baker wrote:
>> On Thu, 2009-02-05 at 13:49 -0500, Bill Davidsen wrote:
>>
>>> Thomas J. Baker wrote:
>>>
>>>> The array was made probably two years ago and had been working fine
>>>> until recently. In reading the documentation for mdadm, it did  
>>>> seem like
>>>> it should have required me to use the higher version but it never
>>>> complained when I made it and worked fine.
>>>>
>>> What have you changed lately? Are the drives all on a single  
>>> controller? Are you using PARTITIONS in mdadm.conf and letting  
>>> mdadm find things for itself?
>>>
>>>
>>
>> The array is made up of two Dell PowerVault 220s in split bus
>> configuration with two Adaptec 39160 Dual Channel SCSI controllers.  
>> Each
>> half of each PowerVault (7 disks) is connected to one of the  
>> channels on
>> the Adaptecs. Four channels in all.
>>
>> As far as changing things, what do you mean? The cause of the  
>> failure is
>> likely heat as we've had some AC issues recently.
>>
>>
> Well that's change, but if you can read the drives at all it doesn't  
> sound like the typical "fall down dead" heat issues, I would expect  
> tons of hardware errors at a lower level from the device controller.  
> Did you check the partition tables with fdisk or similar?  Are the  
> drives all in the same physical box? IBM split their boxes, running  
> four drives off one power and four (or three+CD) off the other. They  
> are likely to have something in common, if you can find it you might  
> fix it.
>
>> I didn't use mdadm.conf at all. All disks are partitioned with one
>> 'Linux raid autodetect' partition.  mdadm had always found the array
>> automatically at boot.
>>
>
> No kernel update or utilities update lately?
>
> Given the choice of identify in hopes of a fixable problem or  
> reinstall, config, recover from backup, I'm trying to see if you can  
> do the former in preference to the latter.
>


Fdisk reports all drives look OK as far as partition table and  
partition type. I'm in the process of running a media verify from the  
Adaptec BIOS on each of the four to make sure nothing is really wrong  
with them. The PowerVaults house 14 drives so we have two boxes. A  
PowerVault is just a box for disks, essentially an external SCSI  
enclosure. As far as I can tell, the hardware seems fine now that the  
AC is fixed.

I did do a software update after the failure in hopes of it helping,  
which likely updated the kernel since it had been a month or two on  
that machine. CentOS5 so nothing major should have changed in terms of  
versions, etc.

The research group that uses the array is hoping for a fixable problem  
too as opposed to the longer remake/restore route. The only hope to me  
seems to be if mdadm can somehow recover/remake the md superblock on  
the four troublesome disks.

Thanks,

tjb
--
=======================================================================
| Thomas Baker                                  email: tjb@unh.edu    |
| Systems Programmer                                                  |
| Research Computing Center                     voice: (603) 862-4490 |
| University of New Hampshire                     fax: (603) 862-1761 |
| 332 Morse Hall                                                      |
| Durham, NH 03824 USA              http://wintermute.sr.unh.edu/~tjb |
=======================================================================



