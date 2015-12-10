From: "P. Remek" <p.remek1@googlemail.com>
Subject: Re: start dm-multipath before mdadm raid
Date: Thu, 10 Dec 2015 23:44:01 +0100
Message-ID: <CABdHLQ4rh+Rtu6U+ZX6m0CWXu3sW4boEzHaPdxD03UBf82EJcQ@mail.gmail.com>
References: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
	<5669AE9C.7040904@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5669AE9C.7040904@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> Order of device discovery is not guaranteed, but base devices will
> almost always show up before multipath devices.  You have to filter out
> the base devices from mdadm consideration:
>
> Add a DEVICES statement to your mdadm.conf that only matches your
> multipath device names, not the base names.  Then update your initramfs
> so it applies to early boot as well.
>


This is something which I actually already tried. I specified in my
/etc/mdadm/mdadm.conf following:

DEVICE /dev/mapper/hgst-ssd*

In my /etc/multipath.conf I instruct dm-multipath to create
/dev/mapper/hgst-ssd1 /dev/mapper/hgst-ssd2 /dev/mapper/hgst-ssd3


But the only result is that after this config, the md raid is not
started at all. My conclusion was that when md raid was starting, the
multipath devices did not yet exist so it did not start up the array.
