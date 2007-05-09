From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: removed disk && md-device
Date: Thu, 10 May 2007 01:41:35 +0400
Message-ID: <4642400F.3040907@msgid.tls.msk.ru>
References: <200705091417.09033.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200705091417.09033.bs@q-leap.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net
List-Id: linux-raid.ids

Bernd Schubert wrote:
> Hi,
> 
> we are presently running into a hotplug/linux-raid problem.
> 
> Lets assume a hard disk entirely fails or a stupid human being pulls it out of 
> the system. Several partitions of the very same hardisk are also part of 
> linux-software raid. Also, /dev is managed by udev.
> 
> Problem-1) When the disk fails, udev will remove it from /dev. Unfortunately 
> this will make it impossible to remove the disk or its partitions 
> from /dev/mdX device, since mdadm tries to read the device fail and will 
> abort if this file is not there.

What do you mean by "fails" here?

All the device information is still here, look at /sys/block/mdX/md/rdY/block .
Even if, say, sda (which was a part of md0) disappeared, there will still be
/sys/block/sda directory, because md subsystem keeps it open.  Yes the device
node may be removed by udev (oh how i dislike udev!), but all the info is still
here.  Also, all the info is in the array information available using ioctl.

mdadm can work it out from here, but it's a bit ugly.

> Problem-2) Even though the kernel detected the device to not exist anymore, it 
> didn't inform its md-layer about this event. The md-layer will first detect 
> non-existent disk, if a read or write attempt to one of its raid-partitions 
> fails. Unfortunately, if you are unluckily, it might never detect that, e.g. 
> for raid1 devices.

This is backwards.

"If you're unlucky" should be the opposite -- "You're lucky".  Well ok, it really
depends on other things.  Because if md-layer does not detect failed disk, it
means that disk hasn't been needed so far (because any attempt to do I/O on it
will fail, and the disk will be kicked off the array).  And since there was no
need in that disk, that means no changes has been made to the array (because
in case of any change, all disks will be written to).  Which, in turn, means
either of:

 a) disk will reappear (there are several failure modes, sometimes just bus
   rescan or powercycle will do the trick), and noone will even notice, and
   everything will be ok.

 b) disk is dead.  And I think this is where you say "unlucky" - because for
  quite some (unknown amount) of time, the array will be running in degraded
  mode, instead of enabling/resyncing hot spare etc.

Again: it depends on the failure scenario.  What to do here is questionable,
because a) contradicts with b).  So far, I haven't seen disks dying (well,
maybe 2 or 3 times), but I've seen disks "disappearing" randomly for no
apparent reason, and bus reset or powercycle brings them back just fine.
So for me, this is "lucky" behaviour.. ;)

Also, with all the modern hotpluggable drives (usb, sata, hotpluggable scsi,
and esp. networked storage, where network may add its own failure modes),
it's much more easier to make a device disappear - by touching cables for
example - this is the case a).

> I think there should be several solutions to these problems.
> 
> 1) Before udev removes a device file, it should run a pre-remove script, which 
> should check if the device is listed in /proc/mdstat and if it is listed 
> there, it should run mdadm to remove this device from the.
> Does udev presently support to run pre-remove scripts?
> 
> 2.) As soon as the kernel detects a failed device, it should also inform the 
> md layer.

See above: it depends.

> 3.) Does mdadm really need the device?

No it doesn't.  In order to fail or remove a component device from
an array, only major:minor number is needed.  Device nodes aren't needed
even to assemble array, but only if doing it the dumb way - during
assembly, mdadm examines the devices and tries to add some intelligency
to the process, and for that, device nodes are really necessary.  But
not for hotremovals.

/mjt
