From: "P. Remek" <p.remek1@googlemail.com>
Subject: Re: start dm-multipath before mdadm raid
Date: Fri, 11 Dec 2015 18:57:29 +0100
Message-ID: <CABdHLQ7d37RQ9FVYuAoVhHPW0+MiNr5suX6GGRG_8u_ykr9Hrg@mail.gmail.com>
References: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
	<5669AE9C.7040904@turmel.org>
	<CABdHLQ4rh+Rtu6U+ZX6m0CWXu3sW4boEzHaPdxD03UBf82EJcQ@mail.gmail.com>
	<566AD7EA.4070903@turmel.org>
	<CABdHLQ7Wdg1sUdC-Ryamdy+et6SNJRJnfdnRXSPOrWJYX9sT_g@mail.gmail.com>
	<566AF4E8.5030801@turmel.org>
	<CABdHLQ4++kTu22YGkdDW3r1UAxf_7E_+fcn9SfFnTSg6MgSm9w@mail.gmail.com>
	<566AFC2A.7040009@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <566AFC2A.7040009@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Not sure what to look for, the only relevant thing I see is:


>
> Next step would be to run udevadm trigger while running udevadm monitor
> in another session right after boot to see what events run and what
> rules are executed.  That should help narrow this down.  Also compare
> dmesg from boot with dmesg from udevadm trigger.
>
> I'm not familiar enough with ubuntu to be much more help.



UDEV  [5341.078565] change   /devices/virtual/block/dm-1 (block)
UDEV  [5341.079255] change   /devices/virtual/block/dm-2 (block)
UDEV  [5341.082457] change   /devices/virtual/block/dm-0 (block)
UDEV  [5341.085049] change   /devices/virtual/block/dm-6 (block)
UDEV  [5341.087382] change   /devices/virtual/block/dm-8 (block)
UDEV  [5341.088389] change   /devices/virtual/block/dm-7 (block)
UDEV  [5341.089766] change   /devices/virtual/block/dm-5 (block)
UDEV  [5341.090079] change   /devices/virtual/block/dm-4 (block)
UDEV  [5341.090105] change   /devices/virtual/block/dm-3 (block)
