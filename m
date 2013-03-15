From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Putting grub back on new mirror disk
Date: Thu, 14 Mar 2013 17:48:30 -0700
Message-ID: <51426FDE.4090406@vorgon.com>
References: <5141361F.7010505@vorgon.com> <CAD4F9C5-6A55-421A-BFAD-B23D72662054@colorremedies.com> <51423AAA.1070404@vorgon.com> <E1690A73-C20E-4EB9-97E9-ACDC22AE9904@colorremedies.com> <51423CB4.6010803@vorgon.com> <947D0B46-E42D-41A6-A408-99CB4AAA374C@colorremedies.com> <514241A2.6020301@vorgon.com> <608C7548-918F-4F11-A874-3399D8691538@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <608C7548-918F-4F11-A874-3399D8691538@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hd0 would have changed because it's a new drive. But all the numbers 
match the device list at /dev/disk/by-id


On 3/14/2013 2:39 PM, Chris Murphy wrote:
>
> On Mar 14, 2013, at 3:31 PM, Timothy D. Lenz <tlenz@vorgon.com> wrote:
>
>> This message said no errors. does that mean grub is now back on sda correctly?
>
> That should be the case yes.
>
>>
>> Here is the current device.map:
>> (fd0)	/dev/fd0
>> (hd0)	/dev/disk/by-id/ata-ST3500413AS_Z3T69GCE
>> (hd1)	/dev/disk/by-id/ata-ST3500418AS_5VMJ49P1
>> (hd2)	/dev/disk/by-id/ata-ST3500320AS_9QM35MY5
>> (hd3)	/dev/disk/by-id/ata-ST3500820AS_9QM6V6JF
>>
>>
>> Hmm, wonder if that didn't update correctly as the replacement drive would have a different number.
>
> ? All four entries are different.
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
