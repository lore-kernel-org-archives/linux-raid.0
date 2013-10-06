From: =?UTF-8?B?TWljaGHFgiBTYXdpY3o=?= <michal@sawicz.net>
Subject: Re: Help with data recovery - RAID6 with 2 failed drives and another
  with broken sectors
Date: Mon, 07 Oct 2013 00:56:25 +0200
Message-ID: <5251EA99.60208@sawicz.net>
References: <524A07DC.1040002@sawicz.net> <524B2158.2020900@sawicz.net> <5251D9AF.9030402@turmel.org> <5251DFF9.4050708@sawicz.net> <5251E0FA.2030206@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5251E0FA.2030206@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07.10.2013 00:15, Phil Turmel wrote:
> No, just fix the timeouts.  Otherwise, you'll be kicking drives out
> *way*  more often than you think.

Ah! Now I've actually read through some of the finds (and found dozens=20
of instances where you recommend the same - you *should* have a dime fo=
r=20
every time you mention that to people), I'm happy to report that just=20
one of my drives (at least from what they claim) does not support scter=
c=20
- the rest just had it disabled... This is fixed now, and a brand new=20
udev rule should take care of the timeout for the other drive. This=20
should make my array way more stable - thank you so much!

> Do check your smartctl reports for actual relocations, though.  In my
> experience, once you pass single digits, further failures are rapid.

Smartd is notifying me of all such - and since most of the drives are=20
still under warranty - I replace them as soon as possible when they=20
start to show up bad blocks.

Again, thank you Phil for your patience.
--=20
Micha=C5=82 (Saviq) Sawicz <michal@sawicz.net>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
