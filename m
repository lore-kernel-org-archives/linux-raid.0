From: Chris <email.bug@arcor.de>
Subject: Re: Last working drive in RAID1
Date: Fri, 6 Mar 2015 10:21:24 +0100
Message-ID: <20150306102124.08e36c0d@smtp.arcor.de>
References: <54F7633F.3020503@gmail.com>
	<20150305084634.2d590fe4@notabene.brown>
	<54F78BD9.403@gmail.com>
	<20150305102622.016ec792@notabene.brown>
	<54F87C7C.8020501@youngman.org.uk>
	<54F8B5D2.8070304@turmel.org>
	<20150306085222.19dd30ce@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150306085222.19dd30ce@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Fri, 6 Mar 2015 08:52:22 +1100
schrieb NeilBrown <neilb@suse.de>:

> > Or, quite possibly, the device is plugged back in, at which point
> > the device name is there for it (as long as you use the same port,
> > of course).  In which case the filesystem may very well resume
> > successfully.
> 
> I was with you right up to this last point.
> When a device is unplugged and then plugged back in, it will always
> get a new name.

Right, that is what I see when "rotating" disks or connecting to a
docking station. And I did also see the last disk of an external
storage raid not going away (fail) when unplugged.

The times I had devices really break though, I don't think they
triggered an unplug event. They still seemed fully connected but had
motor-start, bus errors or something. In some occasions the failure was
only intermittent, and the device node continued to work again (within
the controller timeout or without a permanent error remaining after a
reset).


So if the last working drive could be marked as failed, when it
actually failed, that would also provide the proper information for
system failover on replicated hosts, in the many cases when a
controller/bus/drive fails without an unplug event. Cases that the udev
rule only idea does not seem to cover.

Regards,
Chris
