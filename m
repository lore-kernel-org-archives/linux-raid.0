From: Dmitrijs Ledkovs <xnox@debian.org>
Subject: Re: How does md(adm) work with fake-raid ?
Date: Fri, 19 Jul 2013 00:35:24 +0100
Message-ID: <CANBHLUi9+hJo8w4V6Bi_3kHDoph4yB7C=sCb5ZSGOB0K1WKGow@mail.gmail.com>
References: <CAC9WiBjU_A0jsB4KoX4B9ohT4TD3cYuDdioM6hSWfK13Otjs-Q@mail.gmail.com>
	<51E86646.8020107@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51E86646.8020107@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18 July 2013 23:03, Martin Wilck <mwilck@arcor.de> wrote:
> On 07/18/2013 10:37 PM, Francis Moreau wrote:
>> Hello,
>>
>> Sorry if the question is stupid but I'm a rookie in md things, but I'd
>> like to understand the big picture here.
>>
>> I've been told to use mdadm whenever possible even if my raid is
>> handled by the bios (fake raid) which use the ddf metadata format.
>> (unfortunately it seems that I can't desactive this fake raid in
>> favour of linux soft raid). It's RAID1 BTW.
>>
>> So my question is rather simple: in my understanding the bios is doing
>> the mirroring, but when setting up the md device, linux (kernel or
>> userspace, I don't really know) also handles the mirroring for RAID1
>> personnality. Is Linux clever enough to see that the mirroring is done
>> by the bios in my case ?
>>
>> Could anybody teach me the big picture ?
>
> Fake RAID uses a part of every disk to record information about the RAID
> arrays. This is called meta data, and your BIOS uses it for setting up
> the drives.
>
> Under Linux, first you need a low level SATA or SAS driver that detects
> your physical drives, e.g. the ahci driver.
>
> md can then detect the DDF meta data on your disk just like the BIOS,
> assemble the array(s), mirror the data, and do other RAID operations.
>
> Distributions can set this up automatically. Currently most distros
> don't do this for DDF (they do it only for fake RAID using the Intel
> Matrix (IMSM) format). For DDF, for historical reasons, most
> distributions will setup a mapping using dmraid (device mapper based
> mirroring). That will also basically work, but it isn't a
> fully-functional RAID implementation such as MD. The magic to set up
> either MD or dmraid automatically as disks are detected is hidden in the
> distro's udev rules, and possibly in the distro's installer logic.
>

There patches posted to debian bug tracker to enable using mdadm in
the installer to assemble/setup IMSM/DDF raid arrays, and thus using
mdadm.
I haven't integrated those, but am planning to work on merging them soon.

At the moment dmraid is used by default for both IMSM/DDF on Debian/Ubuntu.

My experience with these fakeraid arrays is very limitted, and I'd
want to enquire of proper migration strategies from dmraid to mdadm.
Whilst looking at the udev rules, at the moment, i have disable
IMSM/DDF from assembly in mdadm udev rules, because dmraid has a nice
property of "activating anything it finds".
I suppose having both mdadm & dmraid racing to activate those drives
wouldn't be nice.

How would one migrate from dmraid to mdadm? I was pondering about
drastic measures: patch out ISMS support out of dmraid, make dmraid
package depend on mdadm and make mdadm activate ISMS drives by
default.
But that sounds harsh, as I wouldn't want to cripple dmraid package
for those who still prefer to use it.

Are there distributions which switched to mdadm by default for ISMS? Suse?!

Regards,

Dmitrijs.
