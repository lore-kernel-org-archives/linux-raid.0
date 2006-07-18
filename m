From: Neil Brown <neilb@suse.de>
Subject: Re: Test feedback 2.6.17.4+libata-tj-stable (EH, hotplug)
Date: Tue, 18 Jul 2006 11:21:19 +1000
Message-ID: <17596.14223.843247.572486@cse.unsw.edu.au>
References: <bb145bd20607101439n475b1771g1c754af31911288@mail.gmail.com>
	<44B31260.5030409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: message from Tejun Heo on Tuesday July 11
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Christian Pernegger <pernegger@gmail.com>, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 11, htejun@gmail.com wrote:
> Christian Pernegger wrote:
> > The fact that the disk had changed minor numbers after it was plugged
> > back in bugs me a bit. (was sdc before, sde after). Additionally udev
> > removed the sdc device file, so I had to manually recreate it to be
> > able to remove the 'faulty' disk from its md array.
> 
> That's because md is stilling holding onto sdc in failed mode.  A 
> hotplug script which checks whether a removed device is in md array and 
> if so removes it from the array will solve the problem.  Not sure 
> whether that would be the correct approach though.

Checking whether the to-be-removed device is in an md array or in use
in any other way first definitely sounds like the right approach to
me.

Exactly what to do if the device is in use is somewhat less obvious.
If the array is completely quiescent then you don't necessarily want
to fail/remove the device from the array....

I think the best approach would be to have plug-ins that are called if
an unplugged device is in use, and if it is still in use after those
calls, then don't delete the device.  Maybe it would also be good if
hotplug was told when a device was no longer in use so it could remove
the /dev entry then....

NeilBrown
