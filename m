From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Array over arrays - how to autoassemble correctly?
Date: Wed, 27 Jan 2010 21:51:53 +0100
Message-ID: <877hr3nudy.fsf@frosties.localdomain>
References: <73e903671001271032q1802c678i860744c72e2a92f3@mail.gmail.com>
	<20100127194139.GA18250@maude.comedia.it>
	<73e903671001271145p7b698661w3ca6562c2ced1018@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903671001271145p7b698661w3ca6562c2ced1018@mail.gmail.com>
	("Kristleifur Daoason"'s message of "Wed, 27 Jan 2010 19:45:13 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Kristleifur Da=F0ason <kristleifur@gmail.com> writes:

> On Wed, Jan 27, 2010 at 7:41 PM, Luca Berra <bluca@comedia.it> wrote:
>> On Wed, Jan 27, 2010 at 06:32:57PM +0000, Kristleifur Da=C4=91ason w=
rote:
>>>
>>> # mdadm.conf
>>> #
>>>
>>> # by default, scan all partitions (/proc/partitions) for MD superbl=
ocks.
>>> # alternatively, specify devices to scan, using wildcards if desire=
d.
>>> DEVICE partitions /dev/md/d0 /dev/md/d1
>>>
>>> # auto-create devices with Debian standard permissions
>>> # CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dmdp
>>>
>>> # automatically tag new arrays as belonging to the local system
>>> HOMEHOST <system>
>>>
>>> # definitions of existing MD arrays
>>>
>>> ARRAY /dev/md/d0 metadata=3D1.1 name=3Dmamma:d0
>>> UUID=3D7f98e926:206a8ebe:59fc8d7b:4644a883 level=3Draid6 num-device=
s=3D6 #
>>> container=3D6f98a7a8:d7b50181:587c27d1:59d6d137
>>>
>>> ARRAY /dev/md/d1 metadata=3D1.1 name=3Dmamma:d1
>>> UUID=3Dda547022:042a6f68:d5fe251e:5e89f263 level=3Draid6 num-device=
s=3D6 #
>>> container=3D6f98a7a8:d7b50181:587c27d1:59d6d137
>>>
>>> ARRAY /dev/md/tank metadata=3D1.1 name=3Dmamma:tank
>>> UUID=3D6f98a7a8:d7b50181:587c27d1:59d6d137 level=3Draid0 num-device=
s=3D2
>>> devices=3D/dev/md/d0,/dev/md/d1
>>>
>>
>> this kind of setup should be working without any issue on recent mda=
dm
>> try removing
>> DEVICE partitions /dev/md/d0 /dev/md/d1
>> and the "devices=3D/dev/md/d0,/dev/md/d1" from mdadm.conf
>> and let it discover things on boot by itself
>>
>> L.
>>
>
> Many thanks for the reply!
>
> However, that's how the mdadm.conf looked like until today - adding
> the DEVICE and devices stuff is something I put in to get things to
> autoassemble themselves fully, as I thought 'man mdadm.conf' indicate=
d
> it.
>
> Still, I'll certianly try - with and without - and double-checking
> that my initramfs is OK.
>
> Any further input most well appreciated.

Alternative add a scriplet into the initramfs config that calls the
mdadm assembling a second time.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
