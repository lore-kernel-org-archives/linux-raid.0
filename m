From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] Failed reads from RAID-0 array (from newbie
                         who has read the FAQ)
Date: Mon, 19 Mar 2007 11:31:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0703191112400.14222-100000@iolanthe.rowland.org>
References: <4641.72.21.237.163.1174316051.squirrel@www.multitool.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4641.72.21.237.163.1174316051.squirrel@www.multitool.net>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Schwarz <mschwarz@multitool.net>
Cc: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-usb-users@lists.sourceforge.net
List-Id: linux-raid.ids

On Mon, 19 Mar 2007, Michael Schwarz wrote:

> I'm going to hang on to the hardware. This is a pilot/demo that may lead
> to development of a new device, and, if so, I'll be getting back into
> device driver writing. Working this problem would be great practice for
> that. So I will do it. The only problem is I don't know when!
> 
> I believe I can replicate the problem, so I'll find time (perhaps next
> weekend) to capture the data of interest.

Michael, you don't seem to appreciate the basic principles for tracking 
down problems.

	First: Simplify.  Get rid of everything that isn't relevant
	to the problem and could serve to distract you.  In particular,
	don't run X.  That will eliminate around half of your running
	processes and shrink the stack dump down so that it might fit
	in the kernel buffer without overflowing.

	Second: Simplify.  Don't run kernels that have been modified by
	Fedora or anybody else.  Use a plain vanilla kernel from
	kernel.org.

	Third: Simplify.  Try not to collect the same data over and over
	again (take a look at the starts of all those dmesg files you
	compressed and emailed).  You can clear the kernel's log buffer
	after dumping it by doing "dmesg -c >/dev/null".

	Fourth: Be prepared to make changes.  This means making changes
	to the kernel configuration or source code, another reason for 
	using a stock kernel.

To get some really useful data, you need to build a kernel with 
CONFIG_USB_DEBUG turned on.  Without that setting there won't be any 
helpful debugging information in the log.

Then you should run a minimal system.  Single-user mode would be best, 
but that can be _too_ bare-bones.  No GUI will suffice.

Then you should clear the kernel log before before starting the big file 
copy.  Basically nothing that happens before then is important, because 
nothing has gone wrong.

Then after the hang occurs, see what shows up in the dmesg log.  And get a 
stack dump.

> Mr. Stern: Where might I go for low level programming information on USB
> devices? I'm interested in registers/DMA/packet formats, etc.

Are you interested in USB devices (i.e., flash drives, webcams, and so on
-- the things you plug in to a USB connection) or USB controllers (the 
hardware in your computer that manages the USB bus)?

> I've found info on the USB protocol itself, but I haven't found info on
> devices. Obviously I can dig through kernel source, but documents would be
> nice! Again, if this is an unreasonable request for you to "do my
> homework," just say so! I won't be offended. I'm sure I can find it myself
> given time, but if you happen to have some URLs handy, they'd be
> appreciated.

There are three types of USB controllers used in personal computers: UHCI, 
OHCI, and EHCI.  Links to their specifications are available here:

	http://www.usb.org/developers/resources/

Specifications for various classes of USB devices are available here:

	http://www.usb.org/developers/devclass_docs

Alan Stern

