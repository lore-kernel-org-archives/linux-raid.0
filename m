From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Re: How to stress test an RAID 6 array?
Date: Mon, 03 Oct 2011 15:58:11 +0200
Message-ID: <4E89BF73.8020604@yazzy.org>
References: <4E89B81D.5000800@yazzy.org> <CADNH=7E9n-uj-xNPq-DuYgfJ+Js9b4bWn_QyeDJ8O+ka4GjLiQ@mail.gmail.com>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7E9n-uj-xNPq-DuYgfJ+Js9b4bWn_QyeDJ8O+ka4GjLiQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/3/11 3:39 PM, Mathias Bur=C3=A9n wrote:

> I would run badblocks on the md0 device. (increase number of blocks t=
o
> check at a time until you use all your available RAM)
> After that I'd run dd.

Any particular options you would give to dd ?

> I would also check the SMART data on all
> drives

What's strange SMART always says all the drives are healthy.
All of failures started with dmesg saying:
  exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
  ata9.00: failed command: FLUSH CACHE EXT
  ata9.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
  res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
  ata9.00: status: { DRDY }

That "exception Emask" part pointed me to misc threads where people=20
mentioned bugs in the Linux kernel.

A reboot would somehow reset the drives and they would always be workin=
g=20
fine again and I could always resync the array until the next time when=
=20
a drive would get kicked off.

> and the health of the controller.

How can I run a check on that within Linux?



--=20

Marcin M. Jessa
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
