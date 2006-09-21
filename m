From: "Rob Bray" <raid@bymeinc.com>
Subject: Re: scrub was Re: RAID5 Problem - $1000 reward for help
Date: Thu, 21 Sep 2006 14:45:56 -0400 (EDT)
Message-ID: <54862.192.168.0.1.1158864356.squirrel@bymeinc.com>
References: <20060915090856.GD27597@boom.net>
    <B7838FAF-BD7D-4581-8E5C-8CB896AA3CC0@develooper.com>
    <5b170a7d0609170436w18fc6ff3r713284436c394fa7@mail.gmail.com>
    <200609171446.01130.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609171446.01130.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Am Sonntag, 17. September 2006 13:36 schrieben Sie:
>> On 9/17/06, Ask Bj=F8rn Hansen <ask@develooper.com> wrote:
>> > > It's recommended to use a script to scrub the raid device regula=
rly,
>> > > to detect sleeping bad blocks early.
>> >
>> > What's the best way to do that?  dd the full md device to /dev/nul=
l?
>>
>> echo check >/sys/block/md?/md/sync_action
>>
>> Distros may have cron scripts to do this "right".
>>
>> And you need a fairly recent kernel.
>
> Does this test stress the discs a lot, like a resync?
> How long does it take?
> Can I use it on a mounted array?
>

I'd like to add to this question -- does 'check' action on a RAID5 arra=
y
verify the accuracy of parity data, blindly read back all data, or only
verify readability of data blocks?

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
