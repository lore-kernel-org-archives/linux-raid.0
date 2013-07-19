From: Martin Wilck <mwilck@arcor.de>
Subject: Re: How does md(adm) work with fake-raid ?
Date: Fri, 19 Jul 2013 20:52:31 +0200
Message-ID: <51E98AEF.5060206@arcor.de>
References: <CAC9WiBjU_A0jsB4KoX4B9ohT4TD3cYuDdioM6hSWfK13Otjs-Q@mail.gmail.com>	<51E86613.9050505@arcor.de> <CAC9WiBiup8RfusZo51DjAsTOLyr1F-LxgGGCWRCakYURskz7rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBiup8RfusZo51DjAsTOLyr1F-LxgGGCWRCakYURskz7rA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Yes, but my question is about how md cooperate with the BIOS in this case ?

Not sure what you mean. When Linux runs, with or without MD, no BIOS
code is ever executed.

The only way of communication between BIOS and MD is the meta data. When
you create an array in your BIOS setup tool, The BIOS will write the
meta data. MD will read it, and when it's done, it will re-write it
(usually unchanged, unless a disk failure occurs, but there are some
fields such as sequential numbers and time stamps that change every time
the meta data is written). The BIOS will read this back the next time
your system boots.

> Are there any procedures described out there that I could follow to
> test MD DFF ?

Not really. Play around, test various RAID levels etc, whatever your
fake RAID supports. If you have a Linux or Windows driver for your fake
raid, check if it correctly detects your setup after MD had control.

Note that RAID arrays *created* by MD (with mdadm -C) will most probably
not be accepted by the BIOS (it will consider them "foreign
configurations" and not import them).

Martin
