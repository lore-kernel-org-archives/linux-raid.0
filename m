From: "Kevin P. Fleming" <kpfleming@backtobasicsmgmt.com>
Subject: Re: Linux software RAID vs. udev
Date: Mon, 03 May 2004 20:06:44 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <409708C4.6070905@backtobasicsmgmt.com>
References: <4092FCA6.2020103@backtobasicsmgmt.com> <16534.64452.67783.81354@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16534.64452.67783.81354@cse.unsw.edu.au>
To: hotplug <linux-hotplug-devel@lists.sourceforge.net>
Cc: neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Neil Brown wrote:

> catch-22.  mdadm needed the device to pre-exist.  That is how the md
> driver works.
> 
> Maybe udev needs to be taught to be more open minded about these
> things.

OK, it appears that the root cause of this problem is that udev only 
creates device nodes for gendisks that have been created/registered, 
because that's the only way it can learn about their existence. After 
looking through the md driver, I don't even see how the first unit (md0) 
is getting registered by default, unless for some reason the block layer 
is calling md_probe for unit 0 without even being asked to.

Regardless, this is a big issue in the hotplug world, although it's in 
no way the md driver's fault :-) In the loop driver, it just allocates 
all its gendisks at init() time, which is fine when it only supports 8 
(or a smallish number) of devices. However, if the md driver did that it 
would allocate 512 gendisks and all the attendant md structures which 
would be extremely wasteful.

Hypothetically speaking, how would you feel about a solution where the 
md driver also exposed a single "control" device (character device 
presumably) where mdadm could do all its machinations? Something like 
the device-mapper control interface is what I'm envisioning here, 
although this starts to get into the dm/md overlap area...

I'll move this discussion to the linux-hotplug list; there has to be a 
solution to this problem somewhere :-)
