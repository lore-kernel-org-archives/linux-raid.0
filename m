From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Linux mdadm superblock question.
Date: Sat, 13 Feb 2010 13:07:22 -0800
Message-ID: <4877c76c1002131307i61a3c985w8db8c10623a693c8@mail.gmail.com>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
	 <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
	 <4B77044B.1020609@zytor.com>
	 <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan>
	 <alpine.DEB.2.00.1002131248390.4721@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1002131248390.4721@asgard.lang.hm>
Sender: linux-raid-owner@vger.kernel.org
To: david@lang.hm
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Feb 13, 2010 at 12:49 PM,  <david@lang.hm> wrote:
> On Sat, 13 Feb 2010, Justin Piszcz wrote:
>
>> On Sat, 13 Feb 2010, H. Peter Anvin wrote:
>>
>>> On 02/11/2010 05:52 PM, Michael Evans wrote:
>>>>
>>>> On Thu, Feb 11, 2010 at 3:00 PM, Justin Piszcz <jpiszcz@lucidpixel=
s.com>
>>>> wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> I may be converting a host to ext4 and was curious, is 0.90 still=
 the
>>>>> only
>>>>> superblock version for mdadm/raid-1 that you can boot from withou=
t
>>>>> having to
>>>>> create an initrd/etc?
>>>>>
>>>>> Are there any benefits to using a superblock > 0.90 for a raid-1 =
boot
>>>>> volume
>>>>> < 2TB?
>>>>>
>>>>> Justin.
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-r=
aid"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>>>>>
>>>>
>>>> You need the superblock at the end of the partition: =A0If you rea=
d the
>>>> manual that is clearly either version 0.90 OR 1.0 (NOT 1.1 and als=
o
>>>> NOT 1.2; those use the same superblock layout but different
>>>> locations).
>>>
>>> 0.9 has the *serious* problem that it is hard to distinguish a
>>> whole-volume
>>>
>>> However, apparently mdadm recently switched to a 1.1 default. =A0I
>>> strongly urge Neil to change that to either 1.0 and 1.2, as I have
>>> started to get complaints from users that they have made RAID volum=
es
>>> with newer mdadm which apparently default to 1.1, and then want to =
boot
>>> from them (without playing MBR games like Grub does.) =A0I have to =
tell
>>> them that they have to regenerate their disks -- the superblock occ=
upies
>>> the boot sector and there is nothing I can do about it. =A0It's the=
 same
>>> pathology XFS has.
>>>
>>> =A0 =A0 =A0 =A0-hpa
>>>
>>
>> My original question was does the newer superblock do anything speci=
al or
>> offer new features *BESIDES* the quicker resync?
>
> the older superblocks have limits on the number of devices that can b=
e part
> of the raid set.
>
> David Lang
>

The 1.1 and 1.2 formats ALSO play more nicely with stacking partition
contents.  LVM, filesystems, and partition info all begin at the start
of a block device; putting the md labels there too makes it obvious
what order to unpack the structures in.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
