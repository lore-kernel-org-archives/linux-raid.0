From: "P. Remek" <p.remek1@googlemail.com>
Subject: Re: start dm-multipath before mdadm raid
Date: Sat, 12 Dec 2015 20:17:36 +0100
Message-ID: <CABdHLQ5jy1jNQ5uKF5AqJftHXw6CG3sEsrwguhgqP3mNr10aWA@mail.gmail.com>
References: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
	<5669AE9C.7040904@turmel.org>
	<CABdHLQ4rh+Rtu6U+ZX6m0CWXu3sW4boEzHaPdxD03UBf82EJcQ@mail.gmail.com>
	<566AD7EA.4070903@turmel.org>
	<CABdHLQ7Wdg1sUdC-Ryamdy+et6SNJRJnfdnRXSPOrWJYX9sT_g@mail.gmail.com>
	<566AF4E8.5030801@turmel.org>
	<CABdHLQ4++kTu22YGkdDW3r1UAxf_7E_+fcn9SfFnTSg6MgSm9w@mail.gmail.com>
	<22123.9272.750357.130814@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22123.9272.750357.130814@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> Do you have everything setup as a module or a mix?  That can certainly
> change things.  It might make sense to re-build the kernel so that the
> MDADM stuff is modules, but the rest is compiled in, or visa versa.

Here is all the information I collected: http://pastebin.com/VF4Sfrq5


Regarding the testing setup, we can safely consider whole system as a
test, we will rebuild the system once we figure final config anyway.
So we can play around with the current raid with no risk of data loss.
