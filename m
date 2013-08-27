From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Accesses to not yet running array
Date: Tue, 27 Aug 2013 10:11:03 +0200
Message-ID: <CAC9WiBhXxZ=i3NPjaqS25PYK5HkPBVbXOFCyfeRjEnrobuajXg@mail.gmail.com>
References: <CAC9WiBgjEQxe_uymD6WW3Oj5Bm6aYD-RBD-8m3G40c1y3HUb0Q@mail.gmail.com>
	<20130821090634.413491d8@notabene.brown>
	<CAC9WiBiYYOjCVaa5tKVC7Lnkz7fcB2wHM0v2wdQUi=1Ufku5gA@mail.gmail.com>
	<CAC9WiBjBGD0J5vSe+q7y+UVGp2+++Ac++zeQ_=LUz9eQ-kCffA@mail.gmail.com>
	<5217B364.1070704@arcor.de>
	<CAC9WiBg7iRDAj40TFUJVq-TXcktNarhT=3_mCJhOkXnitF8HDQ@mail.gmail.com>
	<CAC9WiBi=fDYmtLv6DPfskyMGfSHVk-J_=5fFsQkdWuigNcHGBw@mail.gmail.com>
	<5218FE4F.7000209@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5218FE4F.7000209@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Martin,

On Sat, Aug 24, 2013 at 8:41 PM, Martin Wilck <mwilck@arcor.de> wrote:
> On 08/24/2013 02:42 PM, Francis Moreau wrote:
>> On Sat, Aug 24, 2013 at 2:40 PM, Francis Moreau <francis.moro@gmail.com> wrote:
>>> Hello Martin,
>>>
>>> On Fri, Aug 23, 2013 at 9:09 PM, Martin Wilck <mwilck@arcor.de> wrote:
>>>> On 08/23/2013 12:00 PM, Francis Moreau wrote:
>>>>
>>>>> [ adding Martin in CC since it seems related to DDF... ]
>>>>
>>>> I reproduced it here. The problem is that mdmon isn't running. Simply
>>>> try running "mdmon /dev/md127", and the mount should proceed.
>>>>
>>>
>>> oh, ok, I should have noticed.
>>>
>>>> You'd avoid the problem by running "mdadm -IR /dev/sda" in the first place.
>>>
>>> Actually this is how arrays are assembled during boot on some
>>> distributions (Fedora for example).
>>
>> I meant the sequence:
>>
>> mdadm -I /dev/sda
>> mdadm -I /dev/sdb
>> mdadm -R /dev/mdxxx
>>
>> is used by distribution.
>
> CentOS 6 uses the following sequence:
>
> mdadm -I /dev/sda
> mdadm -I /dev/sdb
> mdadm -I /dev/mdXXX
>
> I don't see mdadm -R anywhere on CentOS.

After digging into the code of dracut, it seems that the bug (mdmon
not started by mdadm -R /dev/mdxxx on incomplete array) seems to be
known and a workaround exists.

Basically the script which starts MD arrays (slightly modified by me
to make it easier to read) does:

for md in /dev/md[0-9_]*; do

    ...

    [ $(cat $md/array_state) != inactive ] && continue

    mdadm --offroot -R $md

    [ $(cat $md/array_state) = inactive ] && continue

    # workaround for mdmon bug
    [ $(cat $md/degraded) -gt 0 ] && mdmon --offroot --takeover $md
done

In theory this should fix the bug but it doesn't (looks like I'm
really unlucky). Indeed at the time the script is run, the container
device doesn't exist in /dev. Therefore the workaround is only
executed on the MD array device. I can see the following message
during the boot: "mdmon: md126 is not a container - cannot monitor"

I tried to add "udevadm settle" before executing the workaround but
that doesn't help.

> You could change your udev rules to run "mdadm -IR /dev/mdXXX" instead.
> Have you tried that?

I tried and it works fine.

Thanks
-- 
Francis
