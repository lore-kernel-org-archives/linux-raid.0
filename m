From: David Dodge <dododge@smart.net>
Subject: Re: ANNOUNCE: User-space System Device Enumation (uSDE)
Date: Thu, 30 Oct 2003 19:45:08 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310310045.TAA04280@smarty.smart.net>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Greg KH <greg@kroah.com>
Cc: "Guo, Min" <min.guo@intel.com>, Steven Dake <sdake@mvista.com>, Lars Marowsky-Bree <lmb@suse.de>, Mark Bellon <mbellon@mvista.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, cgl_discussion@osdl.org, "Ling, Xiaofeng" <xiaofeng.ling@intel.com>
List-Id: linux-raid.ids

Greg KH writes:
> On Wed, Oct 29, 2003 at 01:12:26PM +0800, Guo, Min wrote:
> > 2.For non-hotplug device
[...]
> >  uDEV:
> >          not deal with it
> 
> See Robert Love's very simple script to populate stuff from sysfs.  It
> can run from initscript just like SDE.  But in the end, udev will end up
> in initramfs and we will not need to do this.

So the intent is to have compiled-in drivers for already-attached
devices (framebuffer, system disks, loop, whatever) generate calls to
/sbin/hotplug within initramfs?

Mainly I'm asking because I did try putting a hotplug script into an
initramfs a few weeks ago (using -test7), and it didn't appear to be
invoked for e.g. the VESA framebuffer. So I want to make sure this is a
"future" capability and not something that should have worked :-)
