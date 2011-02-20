From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Possible HDD error, how do I find which HDD it is?
Date: Sun, 20 Feb 2011 03:11:48 +0000
Message-ID: <4D608674.6090506@anonymous.org.uk>
References: <AANLkTimV8-mciW_9z_=U_-uYLvKp7Rbh0V1N0mr7rh8v@mail.gmail.com>	<4D5FE3D6.8070006@anonymous.org.uk>	<4D5FF386.6070003@turmel.org>	<AANLkTinw8hSks5kopU9ju1cNCQu11kUgPzRbC8L2h_ed@mail.gmail.com>	<4D60429E.1090501@turmel.org> <AANLkTi=k7BwKbkK+TL_CevezhcRyUszHpOBZY2Dt5TiQ@mail.gmail.com> <4D6046D5.4020005@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D6046D5.4020005@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>, Simon Mcnair <simonmcnair@gmail.com>
List-Id: linux-raid.ids

On 19/02/2011 22:40, Phil Turmel wrote:
> On 02/19/2011 05:30 PM, Mathias Bur=C3=A9n wrote:
[...]
>> This is the output of your latest script on my machine. The "0:0:0"
>> is supposed to be the LUN, which would be ata[1, 2, 3..], no?
>
> No.  You have to look in your dmesg to match the 'ata' initialization
> reports with the corresponding 'scsi' initialization reports.
>
> dmesg |grep 'ata[0-9]\|scsi[0-9]'
>
> Unless I missed something in sysfs that would make it easy to report
> it in the script?

I don't know about easy, but there is a suggestion in the page Simon
McNair linked to earlier in this thread:
http://www.linux-archive.org/centos/316405-how-map-ata-numbers-dev-sd-n=
umbers.html#post428370

I suspect that at the very least you'd have to check the proc_name to
see if it matched a driver which used libata before you could say the
unique_id matched the kernel's ata:N though, which is why I say it migh=
t=20
not be easy (well beyond me at any rate)...

Cheers,

John.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
