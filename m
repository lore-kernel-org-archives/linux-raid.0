From: Soeren Grunewald <soeren.grunewald@desy.de>
Subject: Re: Assembly of RAID6 with 48 disk fails
Date: Fri, 1 Jul 2016 09:24:13 +0200
Message-ID: <c12fbf50-7a19-9f52-1dcb-fe000481ebb8@desy.de>
References: <1407524886.20708095.1467300814680.JavaMail.zimbra@desy.de>
 <70dae6c2-0137-8436-0625-7a056ddf2779@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70dae6c2-0137-8436-0625-7a056ddf2779@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Phil,

Thanks for your advice, that actually helped. I just build git head, 
used '--assemble --force' and it was working. All filesystems on the 
array are still valid, no data loss :) But this is the end for this 
machine, since it was clearly a controller fault.

So thank you very very much, also from the users.
-- 
Cheers,
Soeren

On 06/30/2016 11:06 PM, Phil Turmel wrote:
> On 06/30/2016 11:33 AM, Grunewald, Soeren wrote:
>> Hi All,
>>
>> After a crash, probably caused by some raid issue, the array can't be
>> assembled again. It looks like 8 disk were disappearing form the raid at
>> the same time, which then lead to the system crash. Now I'm unable to
>> get the array back to live again. Because the whole system was on the
>> failing array, I can't access any additional information to check what
>> happened. The system is a 8 year old SUN Fire X4540 system running under
>> Ubuntu 12.04.5 (kernel-3.13.0-91 and mdadm-3.2.5-1ubuntu0.3), which is
>> mainly used for data conversion (converting very large files from one
>> format into another). The boot partition is placed on a 2GB ssd and the
>> rest is running on the 48disk raid6 array. I have booted the system from
>> a usb stick with clonezilla (kernel 4.4.x + mdadm 3.3) and started
>> digging...
>>
>> Since this is the first time, that a I face such a large array and such
>> an issue, I better follow the advice from the Linux-Raid-Wiki and
>> request for help.
>>
>> As one can see in the attached log, the 'Events' count of 40 drives is
>> 4391 and 4385 for the 8 others. We have the same picture for the
>> 'State', 40 drives state 'clean' and 8 drives 'active'. So I tried
>> 'mdadm --assemble --force ...'.  This fixed the event count and faulty
>> flag on 4 of the 8 disks. But still the array can't be created.
>>
>> Except one smart error (1 Currently unreadable (pending) sectors) do all
>> other drives pass the extended smart test. I know, this does not mean
>> that the drives are not damaged or broken.
>>
>> Anyway, how should I process to get the array working again?
>>
> You're the second person in the last month to run into this...  There
> was a bug in mdadm that makes it fail with --assemble --force when there
> are several out-of-date devices.
>
> The fix was to clone the mdadm git tree, compile the latest, and run
> that stand-alone binary to perform the forced assembly.  I haven't tried
> to determine which released version has the fix.
>
> Phil
>
