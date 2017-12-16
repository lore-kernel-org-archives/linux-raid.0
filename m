From: Dark Penguin <darkpenguin@yandex.ru>
Subject: Re: Wrong array assembly on boot?
Date: Sat, 16 Dec 2017 15:40:56 +0300
Message-ID: <5A351458.1050303@yandex.ru>
References: <59739BDD.30307@yandex.ru> <597608BD.7080108@youngman.org.uk>
 <597611F6.20500@yandex.ru> <59764C40.4020503@youngman.org.uk>
 <59765183.1030508@yandex.ru> <5976569A.5040504@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5976569A.5040504@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/07/17 23:20, Wols Lists wrote:
> On 24/07/17 20:58, Dark Penguin wrote:
>> On 24/07/17 22:36, Wols Lists wrote:
>>> On 24/07/17 16:27, Dark Penguin wrote:
>>>> On 24/07/17 17:48, Wols Lists wrote:
>>>>>> On 22/07/17 19:39, Dark Penguin wrote:
>>>>>>>> Greetings!
>>>>>>>>
>>>>>>>> I have a mirror RAID with two devices (sdc1 and sde1). It's not a root
>>>>>>>> partition, just a RAID with some data for services running on this
>>>>>>>> server. (I'm running Debian Jessie x86_64 with a 4.1.18 kernel.) The
>>>>>>>> RAID is listed in /etc/mdadm, and it has an external bitmap in /RAID .
>>>>>>
>>>>>> As an absolute minimum, can you please give us your version of mdadm.
>>>> Oh, right, sorry. I thought the "absolute minimum" would be the kernel
>>>> version and the distribution. :)
>>>>
>>>> mdadm - v3.3.2 - 21st August 2014
>>>>
>>>>
>>> I was afraid it might be that ...
>>>
>>> You've hit a known bug in mdadm. It doesn't always successfully assemble
>>> a mirror. I had exactly that problem - I created one mirror and when I
>>> rebooted I had two ...

I think this is not the same problem (see below).


>>> Can't offer any advice about how to fix your damaged mirror, but you
>>> need to upgrade mdadm! That's two minor versions out of date - 3.4 and 4.0.

It's 3.4-4 in Ubuntu 17.10 and 3.4-4 in Debian Stretch, so I assume 4.0
must be "not there yet"...


>> My mirror is not damaged anymore - it's quite healthy and cleanly
>> missing some information I've overwritten. :) Of course, there's no way
>> to help that now - that's what backups are for. I just wanted to learn
>> how to avoid this situation in the future. And learn how is it really
>> supposed to handle such things.
>>
>> Is this bug fixed in the newer mdadm? Or is it "known, but not fixed yet"?
>>
>>
> Long fixed :-)

No, this is still not fixed in Ubuntu Artful (17.10) with mdadm v3.4-4 .

My problem is the following (tested just now on Ubuntu 17.10):


- I create a RAID1 on two devices: /dev/sda1 and /dev/sdb1 (writemostly)
- I use it
- I pull /dev/sda1 out (bad cable, exactly the same situation as I had)
- I continue using the degraded array:

$ sudo mdadm --detail /dev/md0
/dev/md0:
<...>
    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       17        1      active sync writemostly   /dev/sdb1


- I shut down the machine and replace the cable, then boot it up again
- I see the following:

mdadm: ignoring /dev/sdb1 as it reports /dev/sda1 as failed
mdadm: /dev/md/0 has been started with 1 drive (out of 2).
mdadm: Found some drive for an array that is already active: /dev/md/0
mdadm: giving up.

$ sudo mdadm --detail /dev/md0
/dev/md0:
<...>
    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       -       0        0        1      removed


So, when assembling the arrays, mdadm sees two devices:
- one that fell off and reports a clean array
- one that knows that the first one fell off and reports it as faulty

And it decides to use the one that obviously fell off, which it knows
about from the second device.

Seriously? Is there a reason for this chosen behaviour, "ignoring the
device that knows about problems"? It seems obviously wrong, but they
know about it and even put the message to explain what's going on! There
must be a reason that makes this "the lesser evil", but I can't imagine
that situation.


-- 
darkpenguin
