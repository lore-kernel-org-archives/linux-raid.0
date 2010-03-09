From: Mark Knecht <markknecht@gmail.com>
Subject: Re: 3 disk RAID1?
Date: Mon, 8 Mar 2010 17:19:09 -0800
Message-ID: <5bdc1c8b1003081719h37f02cb9rbdc4bb6064e4c3d7@mail.gmail.com>
References: <5bdc1c8b1003081239l32c5653fs8347179e23c0a287@mail.gmail.com>
	 <20100308205803.GA31731@cthulhu.home.robinhill.me.uk>
	 <5bdc1c8b1003081304n7a59e99ej1f66078090980f06@mail.gmail.com>
	 <4877c76c1003081411p3c729c89q3d908d07f19b0857@mail.gmail.com>
	 <73e903671003081418g13861e21pa412f46995ad9781@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903671003081418g13861e21pa412f46995ad9781@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Kristleifur_Da=C3=B0ason?= <kristleifur@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 8, 2010 at 2:18 PM, Kristleifur Da=C3=B0ason
<kristleifur@gmail.com> wrote:
<SNIP>
>>
>> When in doubt, read the manual two or three more times.
>>
>> This might also help you: http://wiki.tldp.org/LVM-on-RAID =C2=A0I w=
rote
>> some background comparison sections when I made that...
>
> Good advice.
>
> The contents of the manual didn't really stick for me until I'd
> actually *done* the tasks I was trying to figure out. The beautiful
> and classic Catch-22 of learning new things. So I somewhat
> empathically suggest you obtain a virtual machine program and start u=
p
> a few disposable virtual machines. (VirtualBox is pretty good and als=
o
> free.) Try creating some RAID's on VM's and getting them to boot, try
> failing a device and readding it, etc.
>
> And keep the manual in a window next to the virtual machine's window =
:)
>
> -- Kristleifur
>

Exactly what I'm working on this afternoon. I've not created many VM's
from scratch so there's a learning curve there, but potentially making
the hard drives virtual in the new VM setup and then applying RAID to
them seems like a good way to practice.

Additionally I'm going to purchase maybe 3 or 4 drives and then see
about using the other SATA ports on my desktop motherboard to create
additional storage that I can get some real performance numbers on.

Thanks!

- Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
