From: Francesco Tomadin <inamaru94@gmail.com>
Subject: Re: WD nas broke can't accessmy files on RAID 1
Date: Sat, 21 Oct 2017 14:22:53 +0200
Message-ID: <CAKNaYNtK+-1JXmLQk0zcX1HrAiczVAoFCKTmJQuG5FexxwRGPg@mail.gmail.com>
References: <CAKNaYNuY8gNn+u4uMK8U+AnnYMmH8GNPDJGWTG1SNrQpDG4kjA@mail.gmail.com>
 <bfbf59c2-c750-f87b-5167-37c84086bb75@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bfbf59c2-c750-f87b-5167-37c84086bb75@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antmbox@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the reply!
First of all, I'll try to express myself in the best way I can :) (I'm
actually impressed that you realized my main language)

As you said, the nas won't boot up, it's stuck from yesterday. I'll
probably have to plug out the electricity since it doesn't work at
all. At the moment when I try to log in in the control panel it says
is performing file system consistency check. I'm not even sure if
unplugging right now will make the things even worse.

When you ask me to run those commands, to be honest I wouldn't even
know where to start, from what I tried to do in the last 2 days, I was
only able to see the disk partitions, and nothing more.


2017-10-21 13:25 GMT+02:00 Anthony Youngman <antmbox@youngman.org.uk>:
> On 21/10/17 11:46, Francesco Tomadin wrote:
>>
>> As title says, due to a bug in the WD nas, it started creating
>> infinite shares folder.
>> At the moment I can't access my NAS anymore, so I decided to try
>> ubuntu to recover my data.
>> I tried to follow some guides and to check stuff but seems like
>> (especially for my NAS) stuff like this doesn't exist.
>> I don't even wanna try to do stuff on my own since as you can clearly
>> see I'm not a linux user I don't even understand what's going on.
>>
>> PS: My nas had 4 slot, one of them was in JBOD format, and with ubuntu
>> I could easily access the data without problem.
>>
>> Tried to use some mdadm command but It gave me some "strange" errors
>> which I would ever try to "fix" on my own.
>> Tried to give a last chance to my nas yesterday but it's stuck at boot.
>> Please if someone could really help me task to task because I really
>> really don't know what to do anymore.
>
>
> Have you read the raid wiki? Is there any chance you could run the --detail
> and --examine commands? (Yes I get you may have problem finding the disks to
> be able to run the commands on them! :-)
>
> https://raid.wiki.kernel.org/index.php/Linux_Raid
>
> You might have to take the disks out of the NAS, or force the whole thing
> into JBOD mode, but again if it won't boot, that might not be possible ...
>>
>>
>> Sorry for my poor english It's not my first language.
>
>
> Better than my foreign languages! If you can't express yourself clearly in
> English, then post bi-lingual. I'm guessing your first language is Spanish
> or Italian, which I don't understand, but there are probably people who do.
> But you need to use as much English as possible to get the best help.
>
> Cheers,
> Wol
