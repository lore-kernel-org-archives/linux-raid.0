From: "P. Remek" <p.remek1@googlemail.com>
Subject: Re: start dm-multipath before mdadm raid
Date: Fri, 11 Dec 2015 17:32:40 +0100
Message-ID: <CABdHLQ4++kTu22YGkdDW3r1UAxf_7E_+fcn9SfFnTSg6MgSm9w@mail.gmail.com>
References: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
	<5669AE9C.7040904@turmel.org>
	<CABdHLQ4rh+Rtu6U+ZX6m0CWXu3sW4boEzHaPdxD03UBf82EJcQ@mail.gmail.com>
	<566AD7EA.4070903@turmel.org>
	<CABdHLQ7Wdg1sUdC-Ryamdy+et6SNJRJnfdnRXSPOrWJYX9sT_g@mail.gmail.com>
	<566AF4E8.5030801@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <566AF4E8.5030801@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> It's likely that the udev rules that drive incremental assembly don't
> have the mapper aliases at the moment they run.  Try:
>
> DEVICE /dev/dm*
>

That crossed my mind too, but no, this doesn't help, the array still
doesn't show up
