From: =?UTF-8?B?S2Fyc3RlbiBSw7Zta2U=?= <k.roemke@gmx.de>
Subject: Re: misunderstanding of spare and raid devices? - and one question
 more
Date: Thu, 30 Jun 2011 14:52:38 +0200
Message-ID: <4E0C7196.1070307@gmx.de>
References: <4E0C5539.4030000@gmx.de> <4E0C5E47.5090604@anonymous.org.uk> <4E0C6CC4.3030506@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E0C6CC4.3030506@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,
your explanations are well for me.
Am 30.06.2011 14:32, schrieb Phil Turmel:
> Hi Karsten,
>
> Just to clarify for you, as your comment below suggests some confusion as to the role of a spare:
>
> When the resync finished on this, if you had let it, you would have had three drives' capacity, with parity interspersed, on four drives.  The fifth drive would have been idle, but ready to replace any of the other four without intervention from you.
Yes, I understand in exact that way - but I was wondering why I see 2 Spares
>
>>> 1 spare - but why - I expect 4 active disks and 1 spare
>>>
>>> kspace9:~ # mdadm --create /dev/md0 --level=5 --raid-devices=5 /dev/sda3
>>> /dev/sdb2 /dev/sdc5 /dev/sdd5 /dev/sde5
>>> leads to
>>> md0 : active (auto-read-only) raid5 sde5[5](S) sdd5[3] sdc5[2] sdb2[1]
>>> sda3[0]
>>> 18345728 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]
>
> This will end up with four drives' capacity, with parity interspersed, on five drives.  No spare.
>
>>> That's what I want, but I reached it more or less by random.
>>> Where is my "think-error" (in german).
No - that's not what I want, but it seems first to be the right way.
After my posting before put the raid back to lvm I do mdadm --detail
and see, that the capacity cant't match, I have around 16 GB, I expected
12 GB - so I decided to stop my experiments - until I get a hint, which
comes very fast.
>
> I hope this helps you decide which layout is the one you really want.
If you think you want the first layout, you should also consider raid6 (dual redundancy).
There's a performance penalty, but your data would be significantly safer.
I have to say, I haved looked at  raid 6 only at a glance.
Are there any experiences in which percentage the performance penalty is to expect?
Thanks
      Karsten

>
> Phil
>

