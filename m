From: "Gernot A. Weber" <gernot@tux-web.de>
Subject: Re: broken disk?
Date: Mon, 8 Apr 2002 23:23:29 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0204082321210.1436-100000@kopernikus.tux-web.de>
References: <xltsn65apm6.fsf@shookay.newview.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <xltsn65apm6.fsf@shookay.newview.com>
To: Mathieu Chouquet-Stringer <mathieu@newview.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Mathieu,
>
> I don't know for sure if the disk is broken but the device 08:25 is
> /dev/sdb9 (you can grep for the major:minor number in /dev or just take a
> look in linux/Documentation/devices.txt)
>
Mhm, I only have 7 partitions on sdb... and sometimes I get the same
message with 08:26 and 08:27...

> No, this one is ok: it means the drive is able to handle 64 tags at most
> (and you're scsi driver probably defaulted to a higher value).
>
That's right. The default is set to 253 (or was it 254?)...

Best wishes,

   Gernot


-- 
Gernot A. Weber
http://www.tux-web.de

Only wimps use tape backup: _real_ men just upload their important stuff
on ftp, and let the rest of the world mirror it.

                              Linus Torvalds, after a hard drive crash

