From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: nonzero mismatch_cnt with no earlier error
Date: Sun, 25 Feb 2007 20:58:15 +0100
Message-ID: <bb145bd20702251158o339093ecu223220d69d2031b3@mail.gmail.com>
References: <45DF859B.2050108@eyal.emu.id.au> <20070225183332.GA10098@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070225183332.GA10098@janus>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry to hijack the thread a little but I just noticed that the
mismatch_cnt for my mirror is at 256.

I'd always thought the monthly check done by the mdadm Debian package
does repair as well - apparently it doesn't.

So I guess I should run repair but I'm wondering ...
- is it safe / bugfree considering my oldish software? (mdadm 2.5.2 +
linux 2.6.17.4)
- is there any way to check which files (if any) have been corrupted?
- I have grub installed by hand on both mirror components, but that
shouldn't show up as mismatch, should it?

The box in question is in production so I'd rather not update mdadm
and/or kernel if possible.

Chris
