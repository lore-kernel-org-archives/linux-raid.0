From: "Dave Dodge" <dododge@smart.net>
Subject: Re: ANNOUNCE: User-space System Device Enumation (uSDE)
Date: Thu, 30 Oct 2003 21:29:26 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310310229.VAA30940@smarty.smart.net>
References: <20031031005854.GC4906@kroah.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Greg KH <greg@kroah.com>
Cc: "Guo, Min" <min.guo@intel.com>, Steven Dake <sdake@mvista.com>, Lars Marowsky-Bree <lmb@suse.de>, Mark Bellon <mbellon@mvista.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, cgl_discussion@osdl.org, "Ling, Xiaofeng" <xiaofeng.ling@intel.com>
List-Id: linux-raid.ids

Greg KH writes: 
> On Thu, Oct 30, 2003 at 07:45:08PM -0500, David Dodge wrote:
[...]
> > Mainly I'm asking because I did try putting a hotplug script into an
> > initramfs a few weeks ago (using -test7), and it didn't appear to be
> > invoked for e.g. the VESA framebuffer. So I want to make sure this is a
> > "future" capability and not something that should have worked :-)
> 
> This is something that should have worked for you today, /sbin/hotplug
> does get called during early boot, before init is started up.

Okay, I'll keep working at it.  Unfortunately my main test system has
since had a major hardware failure and I haven't gotten a replacement
set up yet.

In the meantime, from a quick look at the kernel code I see this:

  - invocations of /sbin/hotplug normally go through call_usermodehelper.

  - kernel/kmod.c: call_usermodehelper does this prior to scheduling
    any work:

        if (!system_running)
                return -EBUSY;

  - init/main.c: system_running is not set non-zero until just
    prior to starting init. 

So it looks like calls to hotplug are dropped while compiled-in
drivers are initializing.  Or am I missing something obvious?  I
needed a one-line patch to be able to boot into initramfs; do I need
another to enable call_usermodehelper earlier?
