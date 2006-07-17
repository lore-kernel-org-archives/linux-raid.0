From: Sevrin Robstad <quack@online.no>
Subject: Re: trying to "brute-force" my RAID 5...
Date: Mon, 17 Jul 2006 23:23:22 +0200
Message-ID: <44BBFFCA.5030309@online.no>
References: <44BAB76D.9070809@start.no>
 <62b0912f0607170413x465b363eh92c811da67cc363@mail.gmail.com>
 <44BBFF5A.7010702@start.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <44BBFF5A.7010702@start.no>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Molle Bestefich wrote:

>> Sevrin Robstad wrote:
>>
>>> I got a friend of mine to make a list of all the 6^6 combinations of 
>>> dev
>>> 1 2 3 4 5 missing,
>>>
>>> shouldn't this work ???
>>
>>
>> Only if you get the layout and chunk size right.
>>
>> And make sure that you know whether you were using partitions (eg.
>> sda1) or whole drives (eg. sda - bad idea).
>>
> Thanks for replying.. I guess I'm pretty sure that ONE of the 66 
> combination should be the right one?? And chunk size - 64kbyte is 
> default, yes ? I created the RAID when I installed Fedora Core 3 some 
> time ago, didn't do anything special so the chunks should be 64kbyte 
> and parity should be left-symmetric ?
>  I'm also sure that I created it on partitions, and all disks has a 
> "Linux Raid" partition on it.
>
> But still, when I grep the log of my script I get no partition out of 
> any combination...
>
> Any Idea ?
>
>
> Sevrin

