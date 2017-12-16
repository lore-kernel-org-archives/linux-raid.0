From: Wol's lists <antlists@youngman.org.uk>
Subject: Re: Wrong array assembly on boot?
Date: Sat, 16 Dec 2017 20:27:48 +0000
Message-ID: <9c2e2d2f-53bc-bae7-8b41-eab09944f109@youngman.org.uk>
References: <59739BDD.30307@yandex.ru> <597608BD.7080108@youngman.org.uk>
 <597611F6.20500@yandex.ru> <59764C40.4020503@youngman.org.uk>
 <59765183.1030508@yandex.ru> <5976569A.5040504@youngman.org.uk>
 <5A351458.1050303@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A351458.1050303@yandex.ru>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/12/17 12:40, Dark Penguin wrote:
> On 24/07/17 23:20, Wols Lists wrote:
>> On 24/07/17 20:58, Dark Penguin wrote:
>>> On 24/07/17 22:36, Wols Lists wrote:
>>>> On 24/07/17 16:27, Dark Penguin wrote:
>>>>> On 24/07/17 17:48, Wols Lists wrote:
>>>>>>> On 22/07/17 19:39, Dark Penguin wrote:
>>>>>>>>> Greetings!
>>>>>>>>>
>>>>>>>>> I have a mirror RAID with two devices (sdc1 and sde1). It's not a root
>>>>>>>>> partition, just a RAID with some data for services running on this
>>>>>>>>> server. (I'm running Debian Jessie x86_64 with a 4.1.18 kernel.) The
>>>>>>>>> RAID is listed in /etc/mdadm, and it has an external bitmap in /RAID .
>>>>>>>
>>>>>>> As an absolute minimum, can you please give us your version of mdadm.
>>>>> Oh, right, sorry. I thought the "absolute minimum" would be the kernel
>>>>> version and the distribution. :)
>>>>>
>>>>> mdadm - v3.3.2 - 21st August 2014
>>>>>
>>>>>
>>>> I was afraid it might be that ...
>>>>
>>>> You've hit a known bug in mdadm. It doesn't always successfully assemble
>>>> a mirror. I had exactly that problem - I created one mirror and when I
>>>> rebooted I had two ...
> 
> I think this is not the same problem (see below).
> 
> 
>>>> Can't offer any advice about how to fix your damaged mirror, but you
>>>> need to upgrade mdadm! That's two minor versions out of date - 3.4 and 4.0.
> 
> It's 3.4-4 in Ubuntu 17.10 and 3.4-4 in Debian Stretch, so I assume 4.0
> must be "not there yet"...
> 
https://raid.wiki.kernel.org/index.php/Linux_Raid#Help_wanted

mdadm 4.0 is nearly a year old ...
> 
>>> My mirror is not damaged anymore - it's quite healthy and cleanly
>>> missing some information I've overwritten. :) Of course, there's no way
>>> to help that now - that's what backups are for. I just wanted to learn
>>> how to avoid this situation in the future. And learn how is it really
>>> supposed to handle such things.
>>>
>>> Is this bug fixed in the newer mdadm? Or is it "known, but not fixed yet"?
>>>
>>>
>> Long fixed :-)
> 
> No, this is still not fixed in Ubuntu Artful (17.10) with mdadm v3.4-4 .
> 
> My problem is the following (tested just now on Ubuntu 17.10):
> 
> 
> - I create a RAID1 on two devices: /dev/sda1 and /dev/sdb1 (writemostly)
> - I use it
> - I pull /dev/sda1 out (bad cable, exactly the same situation as I had)
> - I continue using the degraded array:
> 
> $ sudo mdadm --detail /dev/md0
> /dev/md0:
> <...>
>      Number   Major   Minor   RaidDevice State
>         -       0        0        0      removed
>         1       8       17        1      active sync writemostly   /dev/sdb1
> 
> 
> - I shut down the machine and replace the cable, then boot it up again
> - I see the following:
> 
> mdadm: ignoring /dev/sdb1 as it reports /dev/sda1 as failed
> mdadm: /dev/md/0 has been started with 1 drive (out of 2).
> mdadm: Found some drive for an array that is already active: /dev/md/0
> mdadm: giving up.
> 
> $ sudo mdadm --detail /dev/md0
> /dev/md0:
> <...>
>      Number   Major   Minor   RaidDevice State
>         0       8        1        0      active sync   /dev/sda1
>         -       0        0        1      removed
> 
> 
> So, when assembling the arrays, mdadm sees two devices:
> - one that fell off and reports a clean array
> - one that knows that the first one fell off and reports it as faulty
> 
> And it decides to use the one that obviously fell off, which it knows
> about from the second device.

Except that it does NOT know about the second device !!! (At least, not 
to start with.)
> 
> Seriously? Is there a reason for this chosen behaviour, "ignoring the
> device that knows about problems"? It seems obviously wrong, but they
> know about it and even put the message to explain what's going on! There
> must be a reason that makes this "the lesser evil", but I can't imagine
> that situation.
> 
Read the mdadm manual, especially about booting and "mdadm --assemble 
--incremental".

udev detects sda, and passes it to mdadm, which starts building the array.

udev then detects sdb, and passes it to madam, WHICH HITS A BUG IN 3.4 
AND MESSES UP THE ASSEMBLY.

Standard advice for fixing any problems is always "upgrade to the latest 
version and see if you can reproduce the problem". I don't remember 
which version(s) of mdadm had this bug, but I know there were a LOT of 
fixes like this that went into v4.

Cheers,
Wol
