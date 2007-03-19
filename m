From: "Michael Schwarz" <mschwarz@multitool.net>
Subject: Re: [Linux-usb-users] Failed reads from RAID-0 array (from newbie  
                             who has read the FAQ)
Date: Mon, 19 Mar 2007 10:58:50 -0600 (CST)
Message-ID: <24685.64.122.229.18.1174323530.squirrel@www.multitool.net>
References: <4641.72.21.237.163.1174316051.squirrel@www.multitool.net>
    <Pine.LNX.4.44L0.0703191112400.14222-100000@iolanthe.rowland.org>
Reply-To: mschwarz@multitool.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0703191112400.14222-100000@iolanthe.rowland.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-usb-users@lists.sourceforge.net
List-Id: linux-raid.ids

Comments below.

-- 
Michael Schwarz

> On Mon, 19 Mar 2007, Michael Schwarz wrote:
>
>> I'm going to hang on to the hardware. This is a pilot/demo that may lead
>> to development of a new device, and, if so, I'll be getting back into
>> device driver writing. Working this problem would be great practice for
>> that. So I will do it. The only problem is I don't know when!
>>
>> I believe I can replicate the problem, so I'll find time (perhaps next
>> weekend) to capture the data of interest.
>
> Michael, you don't seem to appreciate the basic principles for tracking
> down problems.

I want to bristle at this. I've been a professional software developer for
nearly 20 years. But I can't because all of your points below are, of
course, dead on for tracking down a device-level problem.

>
> 	First: Simplify.  Get rid of everything that isn't relevant
> 	to the problem and could serve to distract you.  In particular,
> 	don't run X.  That will eliminate around half of your running
> 	processes and shrink the stack dump down so that it might fit
> 	in the kernel buffer without overflowing.

Right on. And I know this; I should have had two boxes where I was
working; one where I could do browsy-emaily things separate from the
problem I was working.

>
> 	Second: Simplify.  Don't run kernels that have been modified by
> 	Fedora or anybody else.  Use a plain vanilla kernel from
> 	kernel.org.

Yeah; But here was where I lacked confidence. I used to know every inch of
my kernel and my hardware, but, as previously stated, that was back in the
2.2.x days. I wasn't confident that I could run my hardware with a
plain-vanilla kernel or that I could successfully roll my own working
2.6.x kernel in a timely manner. But, of course, I understand why this is
a good idea.

>
> 	Third: Simplify.  Try not to collect the same data over and over
> 	again (take a look at the starts of all those dmesg files you
> 	compressed and emailed).  You can clear the kernel's log buffer
> 	after dumping it by doing "dmesg -c >/dev/null".

Thanks, I actually didn't know that flag. Makes me feel pretty stupid...

>
> 	Fourth: Be prepared to make changes.  This means making changes
> 	to the kernel configuration or source code, another reason for
> 	using a stock kernel.

I agree -- I just lacked confidence doing so with newer kernels. I used to
ALWAYS build my own kernel right up through the 2.2.x series, building the
kernel to exactly match my hardware. I just haven't kept up. And if you
compare the 2.2.x kernel's configuration parameter list to the 2.6.x,
well, you can maybe understand why I was reluctant to launch on that when
under time pressure. But you point (I gather) is that if I had, it might
well have taken less time than it did...

>
> To get some really useful data, you need to build a kernel with
> CONFIG_USB_DEBUG turned on.  Without that setting there won't be any
> helpful debugging information in the log.

Before I send any more info on this problem, I will do this and all of the
above.

>
> Then you should run a minimal system.  Single-user mode would be best,
> but that can be _too_ bare-bones.  No GUI will suffice.

Will do.

>
> Then you should clear the kernel log before before starting the big file
> copy.  Basically nothing that happens before then is important, because
> nothing has gone wrong.
>
> Then after the hang occurs, see what shows up in the dmesg log.  And get a
> stack dump.
>
>> Mr. Stern: Where might I go for low level programming information on USB
>> devices? I'm interested in registers/DMA/packet formats, etc.
>
> Are you interested in USB devices (i.e., flash drives, webcams, and so on
> -- the things you plug in to a USB connection) or USB controllers (the
> hardware in your computer that manages the USB bus)?

Firstly the controllers, then specific devices.

>
>> I've found info on the USB protocol itself, but I haven't found info on
>> devices. Obviously I can dig through kernel source, but documents would
>> be
>> nice! Again, if this is an unreasonable request for you to "do my
>> homework," just say so! I won't be offended. I'm sure I can find it
>> myself
>> given time, but if you happen to have some URLs handy, they'd be
>> appreciated.
>
> There are three types of USB controllers used in personal computers: UHCI,
> OHCI, and EHCI.  Links to their specifications are available here:
>
> 	http://www.usb.org/developers/resources/

Thanks. This is just what I wanted.

>
> Specifications for various classes of USB devices are available here:
>
> 	http://www.usb.org/developers/devclass_docs

And this. Thank you much. I won't post on this issue again until I've
"cleared the decks" of the items you mention above. Thanks again.

>
> Alan Stern
>
>

