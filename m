From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Clarify /etc/mdadm.conf format and content?
Date: Mon, 9 Nov 2009 16:11:32 -0800
Message-ID: <4877c76c0911091611n73d3d4aalb4765cc674c0cdc3@mail.gmail.com>
References: <babafd2f0911042153y427d3194w520f2294f0ff7f53@mail.gmail.com>
	 <4877c76c0911042217r76d7e46cg4ceeb391e9098a6@mail.gmail.com>
	 <babafd2f0911042321k4dfda707he80f40596fba2a3b@mail.gmail.com>
	 <4877c76c0911042331i15f53768s382512200f02c398@mail.gmail.com>
	 <babafd2f0911050824u327c2ca3y43ab557b52f9356@mail.gmail.com>
	 <babafd2f0911050903y5a12f2c4r2a94dc9832ef944b@mail.gmail.com>
	 <19191.41266.193710.349961@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19191.41266.193710.349961@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Ben DJ <bendj095124367913213465@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You might be interested in a project I was working on.  Arch linux
already has something similar, I added it to Gentoo's sunrise overlay,
and the other major distros are too intimidating to submit it to
without better integration, which I've little inclination to work on
without a known path for inclusion.

It builds an initramfs and/or initrd using local binaries and is very
easy to customize since it builds the image within a subfolder.  You
can even chroot in to it and run informational only checks to make
sure you've included the things you'll want.  Plus you can work in a
subshell and then 'exit' to make a change like this or run an fsck
before early-userspace ends.

https://sourceforge.net/projects/aeuio

If it doesn't work please let me know so I can resolve the error.
