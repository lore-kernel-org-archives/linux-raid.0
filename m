From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: disable raid autodetect at boot
Date: Wed, 25 May 2011 18:15:49 +0300
Message-ID: <BANLkTik=qRE_c5XWs6kjbT90otnmdGdaog@mail.gmail.com>
References: <BANLkTim=K8b_3jD5RAdMT6+0TYQXNAHBtg@mail.gmail.com>
	<4DDA388C.2020000@msgid.tls.msk.ru>
	<BANLkTi=zLb7j_MvkTyQa=ifMAS+kDCkbvg@mail.gmail.com>
	<4DDA5F51.3090501@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDA5F51.3090501@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael,
thank you for your advice.

The only place where I saw mdadm is being called on boot is via
/etc/init.d/mdadm, which starts mdadm with --monitor --scan options.
Still I disabled the daemon start (in /etc/default/mdadm), but
inactive raid keeps reappearing on boot.

How can I find out who else might be calling mdadm on boot?

Thanks,
   Alex.


On Mon, May 23, 2011 at 4:21 PM, Michael Tokarev <mjt@tls.msk.ru> wrote=
:
> 23.05.2011 16:50, Alexander Lyakas wrote:
>> Michael,
>> can you pls explain what do I need to look at to disable this.
>
>> On Mon, May 23, 2011 at 1:35 PM, Michael Tokarev <mjt@tls.msk.ru> wr=
ote:
>
>>> This is not kernel autodetection, this is your initramfs/initrd
>>> and mdadm. =A0Or maybe mdadm in the regular root filesystem.
>
> You need to find out where and how mdadm is called
> on your system during bootup, and fix that place.
>
> /mjt
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
