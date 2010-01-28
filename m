From: Carlos Williams <carloswill@gmail.com>
Subject: Re: How To Grow Using 'mdadm' Utility
Date: Thu, 28 Jan 2010 10:50:04 -0500
Message-ID: <d80f793f1001280750n68257e18n3e79ec0d68b5ac18@mail.gmail.com>
References: <d80f793f1001271056i1127fbcege5b4dd4a3927576@mail.gmail.com>
	 <1264634977.1928.13.camel@test.apertos.eu>
	 <d80f793f1001280658k487be15emc0a6d23c9d013957@mail.gmail.com>
	 <1264691314.1928.27.camel@test.apertos.eu>
	 <d80f793f1001280713j5b0ee689m1c4c455403c64928@mail.gmail.com>
	 <1264692194.1928.29.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264692194.1928.29.camel@test.apertos.eu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010/1/28 Micha=C5=82 Sawicz <michal@sawicz.net>:
> If you do - remount the filesystem read-only (mount -o remount,ro). B=
ut
> it would be best to use some LiveCD system, otherwise you will need t=
o
> resize on a live filesystem, it will take much more time and is more
> dangerous than resizing offline.
>
> If you can't take the fs offline - you can force resizing without fsc=
k
> first, but again - it would be best to fsck it and resize offline.

I can do "shutdown -r -F now" from my regular system. During this
reboot a fsck will be forced. Will that be enough?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
