From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Unable to convert raid1 to raid5
Date: Sun, 7 Aug 2016 02:00:05 +0100
Message-ID: <57A68815.40601@youngman.org.uk>
References: <57A4F436.9080402@youngman.org.uk>
 <57A679C9.3060204@youngman.org.uk>
 <CAN7jt2060xqsQB+nAnWO4LmqdUySkU_AWpq=UdFte=Ht0zuoPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAN7jt2060xqsQB+nAnWO4LmqdUySkU_AWpq=UdFte=Ht0zuoPw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Glenn Enright <glenn.enright@gmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/08/16 01:32, Glenn Enright wrote:
> On 7/08/2016 12:01 pm, "Wols Lists" <antlists@youngman.org.uk
> <mailto:antlists@youngman.org.uk>> wrote:
>>
>> On 05/08/16 21:16, Wols Lists wrote:
>> > In my testing of xosview, I've been mucking about with a vm and raid.
>> > xosview is looking quite promising (I've got a few comments about it,
>> > but never mind).
>> >
>> > BUT. In mucking about with raid 1, I increased my raid devices to three.
>> > I now just can NOT convert the array to raid 5! I've been mucking around
>> > with all sorts of things trying to get it to work, but finally two error
>> > messages make things clear.
>> >
>> Following up to myself - suddenly thought "I know what's wrong". So I
>> stopped the array, and of course couldn't access it, it was no longer
>> there. So I assembled but didn't run it, and it worked fine.
>>
>> Simples, once you realise what's wrong - you can ADD devices to a
>> running array, but you can't REMOVE them.
>>
>> Cheers,
>> Wol
>>

> 
> You can remove em if you mark em as failed first. Eg
> 
> Mdadm /dev/mdx --fail /dev/sdc1 --remove /dev/sdc1
> 
> Best, Glenn
> 
Except - if you read my original post - I was trying to TOTALLY remove
the device!

mdadm --grow -raid-devices=2

THAT was the problem - I had a 3-device mirror, and you can't convert
that to raid5! Even if you've --fail --remove'd the third device!

In other words, "--grow --raid-devices=more" will work on a running
device, "--grow --raid-devices=less" will only work on an array that is
built but not running.

I now have the problem that my "--grow --level=5" has fallen foul of the
"reshape stuck at zero" problem, and I can now neither run the array,
nor get the reshape working ... :-(

At least it's a test vm, specifically for mucking about with raid, so if
I trash it all and start again it's no loss, but it's worrying if a
reshape threatens to lose all your data for you! Especially as I intend
to do it live at some point!

Cheers,
Wol


