From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 02 Jul 2014 23:34:53 +0200
Message-ID: <53B47AFD.6000802@shiftmail.org>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt> <20140702204502.6b538fa8@notabene.brown> <20140702125434.Horde.abbwKfYRo99Ts-L6UvsCEIA@webmail.aeiou.pt> <20140702152429.742a3e8ea8bd100f5b3bae1f@bbaw.de> <20140702151406.Horde.HZoGSPYRo99TtBOu1q6B-GA@webmail.aeiou.pt> <53B434BD.30301@shiftmail.org> <20140702192825.Horde.18y4TPYRo99TtE9JC9kSzUA@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702192825.Horde.18y4TPYRo99TtE9JC9kSzUA@webmail.aeiou.pt>
Sender: linux-raid-owner@vger.kernel.org
To: Pedro Teixeira <finas@aeiou.pt>
Cc: =?UTF-8?B?TGFycyBUw6R1YmVy?= <taeuber@bbaw.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/07/2014 20:28, Pedro Teixeira wrote:
>
> Hi Ethan,
>
> The thing here is that some of the bad blocks ( if not all ) that are 
> giving read errors are not on the bad blocks list.
>

Are you sure? Please note that the offset is a complex topic because an 
offset given by fsck will be a sector offset in the md0 sense, while the 
device badblock list contains offset in the device sense, which means 
that to convert one onto the other you have to divide, or multiply, by 
the number of data disks, approximately, and handle the remainder 
manually also considering the problem of the rotating parity. Not 
simple. Is this the computation that you did?

> Specifically, the ones that show up when doing a fsck are not on any 
> drive. For these sectors fsck tries to re-write then and md still 
> throws an error but they are not added to the list.
>

Not "added" but "removed". Writing to a bad block should create valid 
content so they should be removed from the list. If they don't then 
indeed there is probably a bug in the MD code, see my previous post.

> I replaced sdm with a new disk. this was one that had a bunch or bad 
> blocks reported by md, and after finishing the rebuild ( with no 
> errors at all ) the --examine-badblocks still gives me the exact same 
> list of errors. I would expect that replacing the disk by a new one 
> would clear the errors.
>

This is the correct behaviour by design.
Source disks did not have valid content in those positions, so good data 
cannot be created from nothing. Badblocks will be replicated onto the 
new disk.
"Bad" here is more a synonym of "containing invalid data", not really 
"unreadable surface".

> as I know the disks are good, is there any way of reseting the bad 
> blocks list without destroying the filesystem?
>

This one I don't know but doing that would probably not help to find the 
bug.

Regads
EW

