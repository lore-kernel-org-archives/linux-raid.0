From: David Greaves <david@dgreaves.com>
Subject: Re: Adding a new mirror disk to RAID1 configuration
Date: Fri, 09 Jul 2004 09:11:36 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40EE5338.6080802@dgreaves.com>
References: <200407090509.i6959W316863@watkins-home.com> <40EE2994.1090402@neuro-tech.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40EE2994.1090402@neuro-tech.net>
To: Luke Reeves <luke@neuro-tech.net>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

no, no no :)

Install the second disk (hdc)
build it as md1 RAID1 with a 'missing' disk this time
copy the data over from md0
get rid of md0
add the first disk as the missing disk
it will sync

don't do it again

David


Luke Reeves wrote:

> I've looked into raidreconf, but apparently it can only do operations 
> on RAID levels 0 and 5.
>
>     Luke
>
> Guy wrote:
>
>> My guess is you configured the RAID1 array as having 1 disk.  Now if 
>> you add
>> more disks to it, they are spares.  You should have configured the 
>> array as
>> having 2 disks, with 1 missing.  Then when you add a disk, it will 
>> re-build
>> to it.
>>
>> Read about raidreconf.  Google it, if needed!  It may allow you to 
>> modify a
>> RAID1 array.  I know it allows you to add a disk to a RAID5 array, 
>> but don't
>> know about RAID1.  I have never used this tool.
>>
>> Guy
>>
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org
>> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Luke Reeves
>> Sent: Friday, July 09, 2004 12:55 AM
>> To: linux-raid@vger.kernel.org
>> Subject: Adding a new mirror disk to RAID1 configuration
>>
>> I have a system with two 40GB drives, and the first drive (hda) is 
>> setup   under an md device with RAID1 driving it.  I'm trying to now 
>> make the second disk, hdc, a mirror of the first.  When I try to add 
>> it using mdadm the second disk becomes a spare and no synchronization 
>> is done. Is there any way to add the second disk directly as a 
>> mirror?  Thanks.
>>
>>     Luke Reeves
>>     http://www.neuro-tech.net/
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

