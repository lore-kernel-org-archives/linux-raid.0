From: Dark Penguin <darkpenguin@yandex.ru>
Subject: Re: Wrong array assembly on boot?
Date: Mon, 24 Jul 2017 22:58:59 +0300
Message-ID: <59765183.1030508@yandex.ru>
References: <59739BDD.30307@yandex.ru> <597608BD.7080108@youngman.org.uk>
 <597611F6.20500@yandex.ru> <59764C40.4020503@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59764C40.4020503@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/07/17 22:36, Wols Lists wrote:
> On 24/07/17 16:27, Dark Penguin wrote:
>> On 24/07/17 17:48, Wols Lists wrote:
>>>> On 22/07/17 19:39, Dark Penguin wrote:
>>>>>> Greetings!
>>>>>>
>>>>>> I have a mirror RAID with two devices (sdc1 and sde1). It's not a root
>>>>>> partition, just a RAID with some data for services running on this
>>>>>> server. (I'm running Debian Jessie x86_64 with a 4.1.18 kernel.) The
>>>>>> RAID is listed in /etc/mdadm, and it has an external bitmap in /RAID .
>>>>
>>>> As an absolute minimum, can you please give us your version of mdadm.
>> Oh, right, sorry. I thought the "absolute minimum" would be the kernel
>> version and the distribution. :)
>>
>> mdadm - v3.3.2 - 21st August 2014
>>
>>
> I was afraid it might be that ...
> 
> You've hit a known bug in mdadm. It doesn't always successfully assemble
> a mirror. I had exactly that problem - I created one mirror and when I
> rebooted I had two ...
> 
> Can't offer any advice about how to fix your damaged mirror, but you
> need to upgrade mdadm! That's two minor versions out of date - 3.4 and 4.0.
> 
> Cheers,
> Wol

My mirror is not damaged anymore - it's quite healthy and cleanly
missing some information I've overwritten. :) Of course, there's no way
to help that now - that's what backups are for. I just wanted to learn
how to avoid this situation in the future. And learn how is it really
supposed to handle such things.

Is this bug fixed in the newer mdadm? Or is it "known, but not fixed yet"?


-- 
darkpenguin
