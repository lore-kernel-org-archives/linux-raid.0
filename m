From: Greg KH <greg@kroah.com>
Subject: Re: ANNOUNCE: User-space System Device Enumation
	(uSDE)
Date: Thu, 30 Oct 2003 16:58:54 -0800
Sender: cgl_discussion-bounces@lists.osdl.org
Message-ID: <20031031005854.GC4906@kroah.com>
References: <200310310045.TAA04280@smarty.smart.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgl_discussion-bounces@lists.osdl.org>
Content-Disposition: inline
In-Reply-To: <200310310045.TAA04280@smarty.smart.net>
List-Unsubscribe: <http://lists.osdl.org/mailman/listinfo/cgl_discussion>,
	<mailto:cgl_discussion-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/cgl_discussion>
List-Post: <mailto:cgl_discussion@lists.osdl.org>
List-Help: <mailto:cgl_discussion-request@lists.osdl.org?subject=help>
List-Subscribe: <http://lists.osdl.org/mailman/listinfo/cgl_discussion>,
	<mailto:cgl_discussion-request@lists.osdl.org?subject=subscribe>
Errors-To: cgl_discussion-bounces@lists.osdl.org
To: David Dodge <dododge@smart.net>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, Lars Marowsky-Bree <lmb@suse.de>, "Ling,
	Xiaofeng" <xiaofeng.ling@intel.com>, "Guo,
	Min" <min.guo@intel.com>, Mark Bellon <mbellon@mvista.com>, linux-kernel@vger.kernel.org, cgl_discussion@osdl.org, Steven Dake <sdake@mvista.com>
List-Id: linux-raid.ids

On Thu, Oct 30, 2003 at 07:45:08PM -0500, David Dodge wrote:
> Greg KH writes:
> > On Wed, Oct 29, 2003 at 01:12:26PM +0800, Guo, Min wrote:
> > > 2.For non-hotplug device
> [...]
> > >  uDEV:
> > >          not deal with it
> > 
> > See Robert Love's very simple script to populate stuff from sysfs.  It
> > can run from initscript just like SDE.  But in the end, udev will end up
> > in initramfs and we will not need to do this.
> 
> So the intent is to have compiled-in drivers for already-attached
> devices (framebuffer, system disks, loop, whatever) generate calls to
> /sbin/hotplug within initramfs?
> 
> Mainly I'm asking because I did try putting a hotplug script into an
> initramfs a few weeks ago (using -test7), and it didn't appear to be
> invoked for e.g. the VESA framebuffer. So I want to make sure this is a
> "future" capability and not something that should have worked :-)

This is something that should have worked for you today, /sbin/hotplug
does get called during early boot, before init is started up.

thanks,

greg k-h
