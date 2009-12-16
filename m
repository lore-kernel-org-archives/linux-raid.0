From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: Re: [SOLVED] RAID-10 array won't auto-assemble @ boot of a Xen Guest;
	Works just fine 'manually' ... Any ideas?
Date: Wed, 16 Dec 2009 08:10:01 -0800
Message-ID: <babafd2f0912160810p34e43a6ao93dae8a576bfcb75@mail.gmail.com>
References: <babafd2f0912151558y513b589ay5e43080ef8e697d@mail.gmail.com>
	<babafd2f0912151705sbda2f50i84ca88433713888d@mail.gmail.com>
	<20091216091615.GB15689@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091216091615.GB15689@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc: robin@robinhill.me.uk
List-Id: linux-raid.ids

>> =A0 chkconfig -- list | grep -i boot
>> =A0 =A0 list: unknown service
>>
> What about if you leave out the space between the dashes and the list
> option?

Still not there.

> chkconfig --list | grep -i boot
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
