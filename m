From: linas@austin.ibm.com (linas)
Subject: Re: 2.6.15: mdrun, udev -- who creates nodes?
Date: Tue, 31 Jan 2006 13:26:43 -0600
Message-ID: <20060131192643.GU19465@austin.ibm.com>
References: <43DCA9CA.5020505@bl.com> <20060129123532.GA6158@wonderland.linux.it> <43DCD614.20705@pobox.com> <20060130204231.GP19465@austin.ibm.com> <20060130204743.GA13902@wonderland.linux.it> <dro3ue$ntb$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dro3ue$ntb$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jason Lunz <lunz@falooley.org>, neilb@suse.de
Cc: linux-hotplug-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 31, 2006 at 04:40:46PM +0000, Jason Lunz was heard to remark:
> md@Linux.IT said:
> >> -- kernel scans /dev/hda1, looking for md superblock
> >> -- kernel assembles devices according to info found in the superblocks
> >> -- udev creates /dev/md0, etc.=20
> > The problem is that some users and distributions build the drivers as
> > modules and/or disable in-kernel auto-assembly.
> 
> Not only that, the raid developers themselves consider autoassembly
> deprecated.
> 
> http://article.gmane.org/gmane.linux.kernel/373620

Hmm. My knee-jerk, didn't-stop-to-think-about-it reaction is that 
this is one of the finest features of linux raid, so why remove it?

Speaking as a real-life sysadmin, with actual servers and actual failed
disks, disk cables and disk controllers, this is a life-saving feature. 
Persistant naming of devices in Linux has long been a problem, and in
this case, it seemed to work.

<story>
I once had an ide controller fail on an x86 board. I bought a new 
controller at the local store, recabled the disks, and booted. 
I was alarmed to find that the system was trying to mount /home 
as /usr, and /usr as /lib, etc. Turned out that /dev/hdc had  
gotten renamed as /dev/hde, etc. and  had to go through a long,
painful, rocket-science (yes, I *do* have a PhD) boot-floppy rescue
to restore the system to working order.
 
I shudder to think what would have happened if RAID reconstruction 
had started based on faulty device names. Worse, as part of my rescue
ops, I had to make multle copies of /etc/fstab, which resided on
different disks (my root volume was raided), as well as the boot 
floppy, and each contained inconsistent info (needed to bootstrap 
my way back). Along the way, I made multiple errors in editing 
the /etc/fstab since I could not keep them straight; twiddling 
BIOS settings added to the confusion.  If this had been /etc/raid.conf 
instead, with reconstruction triggered off of it, this could have 
been an absolute disaster.
</story>

Based on the above, real-life experience, my gut reaction is 
raid assembly based on config files is a bad idea. I don't 
understand how innocent, "minor" errors made by the sysadmin 
won't result in catastrophic data loss.

--linas
