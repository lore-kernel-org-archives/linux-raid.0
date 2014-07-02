From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 02 Jul 2014 18:35:09 +0200
Message-ID: <53B434BD.30301@shiftmail.org>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt> <20140702204502.6b538fa8@notabene.brown> <20140702125434.Horde.abbwKfYRo99Ts-L6UvsCEIA@webmail.aeiou.pt> <20140702152429.742a3e8ea8bd100f5b3bae1f@bbaw.de> <20140702151406.Horde.HZoGSPYRo99TtBOu1q6B-GA@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702151406.Horde.HZoGSPYRo99TtBOu1q6B-GA@webmail.aeiou.pt>
Sender: linux-raid-owner@vger.kernel.org
To: Pedro Teixeira <finas@aeiou.pt>, =?UTF-8?B?TGFycyBUw6R1YmVy?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You have multiple bad-blocks list (an MD feature) which are already ful=
l=20
of sectors. Those are earlier disk errors which were stored on MD=20
headers (one list per drive).

MD will not try to read from such sectors anymore, and during reads MD=20
will return error to the upper layers immediately. This is if the strip=
e=20
does not have enough good components to read after excluding the bad=20
blocks, e.g. raid5 is able to tolerate up to 1 disk with badblocks in a=
=20
stripe, so with 2 badblocks in 2 different disks in the same stripes MD=
=20
will return a read error immediately and without trying.
That's why in dmesg you are seeing read errors from MD but not from the=
=20
component devices.

Now the question is how could so many badblocks be recorded on your arr=
ay.
It seems very unlikely that so many disks of your array are in such bad=
=20
shape .  This might indicate an MD bug in the badblocks code.
I am thinking some form of erroneous propagation of bad blocks, so that=
=20
e.g. writing to an area where an MD badblock exists, instead of clearin=
g=20
the bad block could have propagated the badblock to the other disks in=20
the same stripe. Something like that.

See if you can check that writing to a bad block clears it. It will be=20
difficult to compute the correct offset to write to, though. You might=20
want to do some trials-and-errors with dd together with blktrace. If yo=
u=20
can do that, you might want to check that it behaves correctly even whe=
n=20
writing something that does not align to 512b or 4k . Obviously this=20
test is desctructive wrt your data in that location.

Another easier test is if to try to read with dd from a component devic=
e=20
itself. If MD has recorded (even if happened long time in the past) a=20
bad block there, the direct read with dd should also hit it, return=20
error and stop, because badblocks in the surface of disks do not heal b=
y=20
themselves with time.

Another test is to read from md0 with dd from an area where you see tha=
t=20
only 1 disk has badblocks (probably requires some trial and error with=20
blktrace because the offsets of md0 are not equal to the offsets of the=
=20
component devices) . If MD works correctly, with such read it should=20
"heal" the badblock: compute from parity from the other disks, then=20
write over the badblock. The MD badblock should disappear.

The last 2 tests I described should not be destructive except in case o=
f=20
MD bugs.

EW


On 02/07/2014 16:14, Pedro Teixeira wrote:
> Hi Lars,
>
> the output of those commands:
>
> root@nas3:/# cat /sys/block/sdb/queue/physical_block_size
> 4096
> root@nas3:/# cat /sys/block/md0/queue/physical_block_size
> 4096
> root@nas3:/#
>
> The strange thing here is that dmesg is not poluted with sata errors=20
> like it is usual when a hard disk has bad sectors or some other=20
> hardware problem. the only thing in dmesg that hints to why reading=20
> the md volume fails are from dm itself.
>
> Cheers
> Pedro
>
>
> Citando Lars T=C3=A4uber
>> Hi Pedro,
>>
>> maybe an issue with the logical/physical blocksize?
>> What tell these commands:
>>
>> cat /sys/block/sdb/queue/physical_block_size
>> cat /sys/block/md0/queue/physical_block_size
>>
>> Seagate says there are 4096 bytes/sector on this devices.
>>
>> Lars
>
>
>
> _____________________________________________________________________=
___________=20
>
> Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
> http://www.aeiou.pt
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
