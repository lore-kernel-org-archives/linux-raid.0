From: linas@austin.ibm.com
Subject: Re: Root Drive Mirroring and LVM.
Date: Wed, 4 Feb 2004 18:37:22 -0600
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Message-ID: <20040204183722.R27780@forte.austin.ibm.com>
References: <20040204122317.K27780@forte.austin.ibm.com> <Pine.LNX.4.44.0402041726350.20232-100000@coffee.psychology.mcmaster.ca> <20040204164946.P27780@forte.austin.ibm.com> <16417.31540.78193.699721@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <16417.31540.78193.699721@notabene.cse.unsw.edu.au>; from neilb@cse.unsw.edu.au on Thu, Feb 05, 2004 at 10:07:32AM +1100
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org, linuxppc64-dev@lists.linuxppc.org, linux-hotplug-devel@lists.sourceforge.net
List-Id: linux-raid.ids

On Thu, Feb 05, 2004 at 10:07:32AM +1100, Neil Brown wrote:
> On Wednesday February 4, linas@austin.ibm.com wrote:
> > On Wed, Feb 04, 2004 at 05:32:01PM -0500, Mark Hahn wrote:
> > > > So what's wrong with autodetect, again?
> > > 
> > > my guess is: in-kernel autodetect is the problem.  
> > > out-of-kernel detection can be much smarter, 
> > > and can be more easily tested/replaced.
> > 
> > Hm, yes, that makes sense.
> 
> 
> Good :-)
> 
> Just to flesh out my thoughts a bit more:
> 
>  If the root filesystem is on an MD array, then I see the process of
>  assembling that md array as quite similar to the process of finding
>  the device for the root filesystem.
> 
>  We don't expect the kernel, or anyone else, to scan all devices
>  looking for something that looks like a root filesystem, and loading
>  that.  Rather we tell the kernel or boot loader exactly where to find
>  the root filesystem.  And if the root filesystem moves, we get to
>  explicitly tell the boot loader where it is (root=/dev/hdc1 or
>  whatever).

Well, this is actually one of my more bitter complaints.  I'd much
much rather have some symbolic disk label, and have the kernel scan 
*all* devices for that.  I can defend this for both low-end and high-end 
machines.

On the low end i.e. PC's, PC servers: I've dealt (multiple times) with 
disk and/or controller failure.  If you have more than 3 disks, it can
get very confusing as to which cable is which.  Add to that that some
BIOS'es allow you to enable/disable controllers, which cause devices 
to be renumbered. E.g. I have a mobo with two 'plain vanilla' ide
connectors and two '100MHZ' 80-wire ide connectors.  Which one is 
/dev/hda and which is not depends on the BIOS settings.  Worse: 
if I plug in a 3rd party ide controller, then the numbering becomes 
insane:

/dev/hda: mobo 33MHz controller
/dev/hdc: mobo 33MHz controller
/dev/hde: pci card controller
/dev/hdg: pci card controller
/dev/hdi: mobo 100MHz controller
/dev/hdk: mobo 100MHz controller

But if I disable the 33MHz mobo connector in bios:

/dev/hda: mobo 100MHz controller
/dev/hdc: mobo 100MHz controller
/dev/hde: pci card controller
/dev/hdg: pci card controller

Since some types of disk failures will lock up the kernel during boot,
you spend a lot of time plugging and unplugging disks and rebooting.
It gets confusing after a while.

To add to the confusion: If you RAID-1 mirror the root partition, 
but then mount it as /dev/hdk (and not /dev/md0) during a rescue 
operation (because rescue disks often don't have RAID on them), 
and then edit /etc/fstab to try to match the new config...
you end up with two root partitions (each of the mirror pair) with
different /etc/fstab's, on different cables/controllers, ...
after fiddling with that, its a nightmare to figure out which 
is which, what's mounted how and where.

I also had a similar experience on a machine with 30-odd scsi disks.
We installed a new kernel on /dev/sdp, rebooted ... and what confusion,
since /dev/sdp was now /dev/sdg.  Worse, since the bootloader was 
unaware of this difference ... So then we made a change, and rebooted...
... again, much confusion till we worked it out.

As a cure-all, I started fiddling with ext2 disk labels.  However,
an ext2 disk label, when written on a RAID-1 device, will identify
*three* things: /dev/md0 (for example), and both mirror pairs: 
/dev/hda1 and /dev/hde1 all have the same label.

rieserfs doesn't have ext2 labels....

I wanted to fool with other partition table schemes (non-DOS partition 
tables) until I realized most PC rescue disks wouldn't be able to get 
you out of that jam. 

So then I thought about using LVM to label my disks (i.e. use LVM
for only one reason, and no other reason: to be able to assign logical
names, and not physical names).  But think about it... its scary, 
LVM is not widespread, somewhat buggy, and standard debian/redhat/suse 
rescue diskettes won't have it ... etc.


>  Assembling the root device should be handled the same way.  We tell
>  the boot loader/kernel where to expect it, but can over-ride that if
>  we need to:
>    md=0,/dev/hdc1,/dev/hde4
> 
>  All other md arrays can, and so should, be assembled by code running
>  out of the root filesystem.  

*If* you mounted the "right" root filesystem.  If you have multiple
copies around, and edit fstab on one but not the others, and then
recable and reboot ... 

>  This could be some program that
>  assembles anything it finds after scanning all devices, or something
>  a bit more focused, but it should be controllable by the sysadmin.
 
At least once I managed to mount /usr as /var because of the confusion,
and upon reboot the init.d scripts spewed /var/lock crud into my poor
/usr filesystem ... 

I want to know that /dev/mdwhatever is /var *before* I mount it,
not after.

>  It is true that in-kernel auto-detect can be controlled by fiddling
>  with partition types, but the problem is that it runs *before* the
>  root filesystem is mounted and so could conceivably confuse the
>  assembly of the root device (if e.g. you plugged in some other device
>  that also claimed to be part of /dev/md0, and it got scanned before
>  your real root device).

Well, yes, that too, I suppose.  But as you see, explicitly
specifying it at the boot prompt works only if you type in the
right thing ...

--linas


cc.ing ppc64 because although not an architecture issue, it is a 
sysadmin issue on enterprise-class machines.

cc.ing hot-plug because this is a cold-plug issue.

Note you get similar crud for multiple ethernet cards ... 


-------------------------------------------------------
The SF.Net email is sponsored by EclipseCon 2004
Premiere Conference on Open Tools Development and Integration
See the breadth of Eclipse activity. February 3-5 in Anaheim, CA.
http://www.eclipsecon.org/osdn
