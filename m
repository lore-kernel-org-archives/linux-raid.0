From: Neil Brown <neilb@suse.de>
Subject: Re: libata hotplug and md raid?
Date: Tue, 17 Oct 2006 11:58:03 +1000
Message-ID: <17716.14507.187306.941214@cse.unsw.edu.au>
References: <c384c5ea0609130311t4005e5aam153251fc6bbbdfb8@mail.gmail.com>
	<4507E2A9.7070306@emc.com>
	<4507E641.7090508@gmail.com>
	<c384c5ea0609140524ofed0dd8v6f1b89a6b4d67f75@mail.gmail.com>
	<45342287.407@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mark Lord on Monday October 16
Sender: linux-raid-owner@vger.kernel.org
To: Mark Lord <mlord@pobox.com>
Cc: linux-raid@vger.kernel.org, Leon Woestenberg <leon.woestenberg@gmail.com>, Tejun Heo <htejun@gmail.com>, Ric Wheeler <ric@emc.com>, Greg KH <gregkh@suse.de>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On Monday October 16, mlord@pobox.com wrote:
> > So the question remains: How will hotplug and md work together?
> > 
> > How does md and hotplug work together for current hotplug devices?
> 
> I have the same questions.
> 
> How does this work in a pure SCSI environment? (has it been tested?)
> If something should change, should those changes be in the MD layer?
> Or can this *really* all be done nicely from userspace?  How?

I would imagine that device removal would work like this:
 1/  you unplug the device
 2/ kernel notices and generates an unplug event to udev.
 3/ Udev does all the work to try to disconnect the device:
     force unmount (though that doesn't work for most filesystems)
     remove from dm
     remove from md (mdadm /dev/mdwhatever --fail /dev/dead --remove /dev/dead)
 4/ Udev removes the node from /dev.

udev can find out what needs to be done by looking at
/sys/block/whatever/holders. 

I don't know exactly how to get udev to do this, or whether there
would be 'issues' in getting it to work reliably.  However if anyone
wants to try I'm happy to help out where I can.

NeilBrown
