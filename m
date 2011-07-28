From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID 1 using SSD and 2 HDD
Date: Thu, 28 Jul 2011 14:31:10 -0400
Message-ID: <4E31AAEE.30601@redhat.com>
References: <4E25C9BA.1060401@dodtsair.com> <20110720003235.51b3a657@natsu> <4E25D775.1080406@dodtsair.com> <24EACA6AC4B506428C92FE7C172FEF4E02084CF0@MX16A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24EACA6AC4B506428C92FE7C172FEF4E02084CF0@MX16A.corp.emc.com>
Sender: linux-raid-owner@vger.kernel.org
To: brian.foster@emc.com
Cc: mpower@dodtsair.com, rm@romanrm.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/20/2011 08:59 AM, brian.foster@emc.com wrote:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Mike Power
>> Sent: Tuesday, July 19, 2011 3:14 PM
>> To: Roman Mamedov
>> Cc: linux-raid@vger.kernel.org
>> Subject: Re: RAID 1 using SSD and 2 HDD
>>
>> Thanks for the link.  That is the kind of thing I am looking for.
>>
>> On 07/19/2011 11:32 AM, Roman Mamedov wrote:
>>> On Tue, 19 Jul 2011 11:15:22 -0700
>>> Mike Power<mpower@dodtsair.com>   wrote:
>>>
>>>> Is it possible to implement a RAID 1 array using two equal size HDD
>>>> and one smaller and faster SSD.  The idea being that the resulting
>>>> RAID would have the same size of the HDD while picking up the speed
>>>> benefits of the SSD.
>>> See http://bcache.evilpiepirate.org/
>>>
>
> Also, Roberto referred to the facebook flashcache implementation. It is based on device-mapper and last I tried bcache, probably a bit more production-worthy at the moment (though bcache looks intriguing long term, so I'd suggest to try both and draw your own conclusion):
>
> https://github.com/facebook/flashcache

Having not looked at those two, I can say that an md raid1 with two hard 
drives and one SSD works *very* well.  It's blazing fast.  Here's how I 
set mine up:

SSD: three partitions, one for boot, one for /, and one for ~/repos 
(which is where all my git/cvs/etc. checkouts reside)
hard disks: four partitions, one for boot, one for /, one for /home, one 
for ~/repos

Then I created four raid1 arrays like so:

mdadm -C /dev/md/boot -l1 -n3 -e1.0 --bitmap=internal --name=boot 
/dev/sda1 --write-mostly --write-behind=128 /dev/sdb1 /dev/sdc1
mdadm -C /dev/md/root -l1 -n3 -e1.2 --bitmap=internal --name=root 
/dev/sda2 --write-mostly --write-behind=1024 /dev/sdb2 /dev/sdc2
mdadm -C /dev/md/home -l1 -n2 -e1.2 --bitmap=internal --name=home 
/dev/sdb3 /dev/sdc3
mdadm -C /dev/md/repos -l1 -n3 -e1.2 --bitmap=internal --name=repos 
/dev/sda4 --write-mostly --write-behind=1024 /dev/sdb4 /dev/sdc4

Works for me with stellar performance.  Treats the SSD as the only 
device that matters on the three arrays it participates in with the hard 
drives there merely as a backing store for safety in case the SSD blows 
chunks some day.  Obviously, if you need some other aspect of your home 
directory to have the SSD benefit then modify to your tastes, but all my 
scratch builds happen under ~/repos and the thing flies when compiling 
stuff compared to how it used to be.

