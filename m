From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Using mdadm --grow to resize a RAID1
Date: Mon, 2 Jan 2017 16:19:27 +0000
Message-ID: <586A7D8F.2060801@youngman.org.uk>
References: <4716208e-12a9-1ae8-46f4-a89ae15d9077@gmail.com>
 <586A454F.1010308@youngman.org.uk>
 <ca87be95-bfb1-10c6-18d4-9aca4a6e3558@gmail.com>
 <CA+res+RgdS92HZ7ZQEs_D8TrQntuhGW-UYEjjARoxeJHKEZhZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+res+RgdS92HZ7ZQEs_D8TrQntuhGW-UYEjjARoxeJHKEZhZw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <jack.wang.usish@gmail.com>, Benjammin2068 <benjammin2068@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/01/17 16:14, Jack Wang wrote:
> 2017-01-02 16:55 GMT+01:00 Benjammin2068 <benjammin2068@gmail.com>:
>>
>>
>> On 01/02/2017 06:19 AM, Wols Lists wrote:
>>> On 02/01/17 10:18, Benjammin2068 wrote:
>>>> I get stuck at the --size max.
>>>>
>>>> it seems the correct syntax is "--size=" but that "max" is not supported as an argument.
>>>>
>>>> little help?
>>> Off the top of my head - try with no argument. iirc it defaults to max,
>>> you don't need to tell it.
>>>
>>
>> Did that.
>>
>>
>>> [root@quantum ~]# mdadm --grow /dev/md1
>>> mdadm: no changes to --grow
>>
>>> [root@quantum ~]# mdadm --grow /dev/md1 --size
>>> mdadm: option '--size' requires an argument
>>> Usage: mdadm --help
>>>   for help
>>
>>> [root@quantum ~]# mdadm --grow /dev/md1 --size max
>>> mdadm: component size of /dev/md1 unchanged at 239490048K
>>
>>> [root@quantum ~]# mdadm --grow /dev/md1 --size=max
>>> mdadm: component size of /dev/md1 unchanged at 239490048K
> 
> So we need someone who has edit permission to update the the wiki page
> in https://raid.wiki.kernel.org/index.php/Growing
> 
I've just checked the wiki page - it's not one of the ones I've yet
updated. I will be only too happy to do so, as soon as we can work out
(or someone tells us) the correct syntax to do so.

I must admit, using "man mdadm", it looks like Benjammin is doing the
right thing, so something's not quite right here ...

Cheers,
Wol
