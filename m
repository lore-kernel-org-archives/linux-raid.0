From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: disable raid autodetect at boot
Date: Mon, 23 May 2011 15:50:20 +0300
Message-ID: <BANLkTi=zLb7j_MvkTyQa=ifMAS+kDCkbvg@mail.gmail.com>
References: <BANLkTim=K8b_3jD5RAdMT6+0TYQXNAHBtg@mail.gmail.com>
	<4DDA388C.2020000@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDA388C.2020000@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael,
can you pls explain what do I need to look at to disable this.

Alex.


On Mon, May 23, 2011 at 1:35 PM, Michael Tokarev <mjt@tls.msk.ru> wrote=
:
> 23.05.2011 13:36, Alexander Lyakas wrote:
>> Hello,
>>
>> I have a simple raid1 created on top of /dev/sda and /dev/sdb. After=
 I
>> reboot, I would like to always manually assemble the raid. However,
>> every time the machine reboots, it looks like md tries to
>> automatically reassemble the raid, but usually binds only one of the
>> source devices:
>>
>> 16936 May 23 11:47:36 vc kernel: [ =A0 =A03.472926] md: linear perso=
nality
>> registered for level -1
> ..
>> 16971 May 23 11:47:36 vc kernel: [ =A0 =A06.059194] md: bind<sdb>
>
> This is not kernel autodetection, this is your initramfs/initrd
> and mdadm. =A0Or maybe mdadm in the regular root filesystem.
>
> /mjt
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
