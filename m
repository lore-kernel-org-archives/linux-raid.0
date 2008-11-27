From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm git pull] support for detecting platform raid capabilities
	and some fixes
Date: Fri, 28 Nov 2008 10:39:38 +1100
Message-ID: <18735.12218.461012.396198@notabene.brown>
References: <1227743100.31146.41.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Wednesday November 26
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids

On Wednesday November 26, dan.j.williams@intel.com wrote:
> Hi Neil,
> 
> This is hopefully the tail of the feature additions from me for
> mdadm-3.0-final.  It adds the capability for mdadm to detect platform
> raid capabilities, and honor them when creating new arrays.  For example
> here is the output of the new --detail-platform option on an imsm
> enabled platform:
> 
> # mdadm --detail-platform -e imsm
>        Platform : Intel(R) Matrix Storage Manager
>         Version : 7.6.0.1011
>     RAID Levels : raid0 raid1 raid10 raid5
>       Max Disks : 6
>     Max Volumes : 2
>  I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2
>           Port0 : /dev/sda (5RA4GKSS)
>           Port1 : /dev/sdb (5RA4GKNC)
>           Port2 : /dev/sdc (5RA4GKT8)
>           Port3 : /dev/sdd (5RA4GQWR)
>           Port5 : /dev/sde (5RA4GQYG)

No "Port4" - seems odd.

So what happens when you try to create an array on devices that aren't
attached to a detected platform?  Or create an array that crosses two
separate controllers?
Just a warning?  Require --force?  Do nothing ??

Sounds like a useful thing!

> 
> This implementation crawls through sysfs to put this information
> together, I believe it is crawling in a future proof fashion, but here
> are my assumptions:
> 1/ /sys/bus/pci/drivers/ahci/<x>/device will identify a pci ahci device
> with a bus id of 'x'.  This allows mdadm to detect which disks are
> attached to which controller.
> 2/ The 'scsi_host' objects in /sys/bus/pci/drivers/ahci/<x> are named
> 'host%d' and there is one host per physical ahci port.  This is not
> critical but allows the 'Port' information to be displayed.
> 

IMSM is only ever ahci?  Never SCSI etc?

And I notice that you hunt through all of the option-rom memory to
find the option from for the IMSM to read some details.
Once you have the I/O Controller, can you just look in the "resource"
file to get start/length info and read just that area ???

I wonder if libpci or libdiscover can do some of this for us.  It isn't
a lot of code, but I'm wondering if it is really a generic and
future-proof as it should be?

(reads code)

It looks like libpci can read 'resource' files etc, but it simply
reads everything - presumably to support 'lspci'.  It isn't clear that
you can ask it to just read the 'resource' for one device which is all
we really want.  That is a bit sad.

And libdiscover seems more complicated than we really want.

What would you think of using the 'resource' info, either via libpci
or more directly, possibly lifting the parser code from libpci?
I think I'd feel more comfortable about that.


> It relies on /sys/dev/block so requires at least 2.6.27.

Lots of the 'container' related stuff requires at least 2.6.27, so
that isn't a big cost.

> 
> Other notables:
> 1/ An attempt to cover the delay between mdadm creating an array and the
> friendly-named device node showing up in /dev/md/ by calling 'udevadm
> settle' before starting starting Incremental assembly.  This
> specifically fixes scripts that do:
> mdadm -A /dev/md/<container>
> mdadm -I /dev/md/<container>
> There is a good chance there is a better place to put this call, but
> putting it in create_mddev didn't work, and moving it up in main()
> resulted in a hang.  I didn't want to hold up the other patches for this
> debug.

I recently added "wait_for" to wait a little while for a device to
appear in /dev.  I don't seem to be calling it at the end of
--assemble.
Maybe putting that in place will be enough?

> 2/ --wait-clean now honors the --scan option to allow shutdown scripts
> to generically wait for any external metadata devices to finish
> lingering writes.

That looks good.

> 3/ Now that we can do checking against the platform there are cases
> where ->add_to_super should fail.

Makes sense.
I think in the case where it does fail we are getting an error message
from the ->add_to_super method, and then a generic "failed to add".

Maybe we should ensure that every error path does report the error,
then get rid of the generic error?

> 
> Please have a look.

I'll cherry-pick out the bits I definitely like and apply them.  Then
we can discuss the rest.

... In fact I have already done this.  I thought I had sent this Email
yesterday some time but it seems I didn't.

NeilBrown
