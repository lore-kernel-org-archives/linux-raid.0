From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
 by user
Date: Wed, 2 Nov 2011 16:29:13 +0100
Message-ID: <20111102152913.GG5119@tango.0pointer.de>
References: <20110208172822.GC21847@tango.0pointer.de>
 <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
 <20111031110613.GA1402@tango.0pointer.de>
 <20111102114416.7879b77f@notabene.brown>
 <20111102011615.GA5289@tango.0pointer.de>
 <20111102130334.09c3ab51@notabene.brown>
 <20111102133223.GC5119@tango.0pointer.de>
 <CAPXgP12RsaFeGK+dQ2hwFjQawhN+QDn1+K8t6jkJ-XSRyautJw@mail.gmail.com>
 <20111102151749.GE5119@tango.0pointer.de>
 <CAPXgP13XEsGSdrftU77-ee3k0gE=O=Odrb4YNkADUFCJ352ZBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPXgP13XEsGSdrftU77-ee3k0gE=O=Odrb4YNkADUFCJ352ZBg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Andrey Borzenkov <arvidjaar@mail.ru>, systemd-devel@lists.freedesktop.org
List-Id: linux-raid.ids

On Wed, 02.11.11 16:21, Kay Sievers (kay.sievers@vrfy.org) wrote:

> 
> On Wed, Nov 2, 2011 at 16:17, Lennart Poettering <lennart@poettering.net> wrote:
> > Kernel threads we detect by checking whether /proc/$PID/cmdline is
> > empty, hence I'd suggest we use the first char of argv[0][0] here, to
> > detect whether something is a process to avoid killing. Question is
> > which char to choose for that. I am tempted to use '@'.
> 
> Maybe introduce a 'initramfs' cgroup and move the pids there?

Well, in which hierarchy? I am a bit concerned about having other
subsystems muck with the systemd cgroup hierarchy, before systemd has
set it up.

I can see some elegance in having all code from the initrd that remains
running during boot in a cgroup of its own, but that's probably
orthogonal to finding a way to recognize processes not to kill at
shutdown. Why? Because there's stuff like Plymouth which also stays
around from the initramfs, but actually is something we *do* want to
kill on shutdown.


Lennart

-- 
Lennart Poettering - Red Hat, Inc.
